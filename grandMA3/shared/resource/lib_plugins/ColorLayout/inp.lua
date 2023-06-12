local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...); 
local my_handle     = select(4,...);

local function UpdateRecipeTarget(ctx)
	local mainGrid = ctx.Frame.SequenceGrid;
	signalTable.OnRowSelected(mainGrid, nil, mainGrid.SelectedRow);
end

local function OnSettingsChanged(obj, change, ctx)
	local titleButtons = ctx.TitleBar.TitleButtons;
	local stepControl = nil;
	local cueOnlyControl = nil;
	--local valueReadoutControl = nil;
	local selectionOnly = nil;
	if (titleButtons) then
		stepControl = titleButtons.StepControl;
		--valueReadoutControl = titleButtons.ValueReadoutControl;
		selectionOnly = titleButtons.SelectionOnly;
		cueOnlyControl = titleButtons.CueOnlyBtn;
	end

	local vis = obj.TrackSheet;
	local layerToolbarVis = obj.ShowLayerToolbar;

	if (stepControl) then stepControl.Visible = vis; end;
	--if (valueReadoutControl) then valueReadoutControl.Visible = vis; end;
	if (selectionOnly) then selectionOnly.Visible = vis; end;
	if (cueOnlyControl) then cueOnlyControl.Visible = vis; end;

	if (obj.ShowRecipes) then
		UpdateRecipeTarget(ctx);
	end

	local Frame=ctx.Frame;
	Frame.RecipeFrame.Visible=obj.ShowRecipes;
	Frame.NotesFrame.Visible=obj.ShowNotes;
	Frame.Toolbars.LayerToolbar.Visible = obj.ShowLayerToolbar;
	Frame.FilterSettings.Visible=obj.ShowFilterToolbar;
	SetFilterSettingsTarget(obj.Filter, Frame.FilterSettings:GetUIChild(1));
end

local function OnFilterSettingsChanged(obj, change, ctx)
	OnSettingsChanged(obj:Parent():Parent(), change, ctx);
end


signalTable.SequenceSheetWindowLoaded = function(caller,status,creator)
	local settings = caller.WindowSettings;
	if (settings) then
		caller.TitleBar.Title.Settings = settings;
		Root().Menus.FilterSettings:CommandCall(caller);
		HookObjectChange(OnSettingsChanged, settings, my_handle:Parent(), caller);
		HookObjectChange(OnFilterSettingsChanged, settings:Ptr(1):Ptr(1), my_handle:Parent(), caller);
		OnSettingsChanged(settings, nil, caller);

		--[[
		local btns = caller.TitleBar.TitleButtons;
		local bit0 = btns.BitBtn0;
		local bit1 = btns.BitBtn1;
		local bit2 = btns.BitBtn2;
		local recipSettings = settings.RecipeSheetSettings;
		local bitFilter = recipSettings:Ptr(1):Ptr(1);
		Echo("bit filter: "..bitFilter.Name);

		bit0.Target = bitFilter;
		bit1.Target = bitFilter;
		bit2.Target = bitFilter;
]]
	end
end

signalTable.SetSettingsAsTarget = function(caller,status,creator)
	local wnd = caller:FindParent("Window");
	local settings = wnd.WindowSettings;
	caller.Target = settings;
end

signalTable.SetTargetSettings = function(caller,status,creator)
	local wnd = caller:FindParent("Window");
	local settings = wnd.WindowSettings;
	caller.Target = settings;
	SetFilterSettingsTarget(settings.Filter, wnd.Frame.FilterSettings:GetUIChild(1));
end

signalTable.SetRecipeSettings = function(caller,status,creator)
	local wnd = caller:FindParent("Window");
	local settings=wnd.WindowSettings.RecipeSheetSettings;
	caller.RecipeFilter:SetChildren("Target", settings:Ptr(1):Ptr(1));
	caller.RecipeGrid.ExternalSettings = settings;
end

signalTable.OnSequenceTargetChanged = function(caller,status,new_target)
    --Echo("Sequence target changed to "..tostring(new_target));
	local wnd = caller:FindParent("Window");
	UpdateRecipeTarget(wnd);
end

signalTable.OnRowSelected = function(caller,status,row_id)
	local ui_parent=caller:Parent();
	local selColumn = tonumber(caller.SelectedColumn);
	if selColumn ~= nil and selColumn >= 4294967296 then
		--this is track sheet data actually
		row_id = caller:GridGetParentRowId(row_id);
	end

	local object = IntToHandle(row_id);
	local notesHeader = ui_parent.NotesFrame.NotesHeader;
	if (IsObjectValid(object)) then
		local cueObj = nil;
		local partObj = nil;
		local hasMoreParts = false;
		if (object:IsClass("Part") ) then
			cueObj = object:Parent();
			partObj = object;
		elseif (object:IsClass("Cue")) then
			cueObj = object;
			partObj = object:Ptr(1);
			object=object:Ptr(1);
			hasMoreParts = cueObj:Count() > 1;
		end

		if (cueObj and partObj) then
			-- Naming scheme "Cue 1 : Part 1" or with custom labels "Cue 1 'MyCue' : Part 1 'MyPart'"
			local cueNameFromObject = cueObj.Name;
			local partNameFromObject = partObj.Name;
			local cueNameFromIndex = "Cue " .. cueObj.index;
			local partNameFromIndex = "Part " .. partObj.index;

			if (cueNameFromObject == "CueZero" or cueNameFromObject == "OffCue") then
				notesHeader.Text = "Note for " .. cueNameFromObject;
			elseif (partObj.Part == 0) then -- Selection is cue
				if (cueNameFromObject == cueNameFromIndex and hasMoreParts) then
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " : " .. partNameFromIndex;
				elseif (hasMoreParts) then
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " '" .. cueNameFromObject .. "' : " .. partNameFromIndex .. "'";
				elseif (cueNameFromObject == cueNameFromIndex) then
					notesHeader.Text = "Note for " .. cueNameFromIndex;
				else
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " '" .. cueNameFromObject .. "'";
				end
			else
				if (cueNameFromObject == cueNameFromIndex and partNameFromObject == partNameFromIndex) then
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " : " .. partNameFromIndex;
				elseif (cueNameFromObject == cueNameFromIndex and partNameFromObject ~= partNameFromIndex) then
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " : " .. partNameFromIndex .. " '" .. partNameFromObject .. "'";
				elseif (cueNameFromObject ~= cueNameFromIndex and partNameFromObject == partNameFromIndex) then
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " '" .. cueNameFromObject .. "' : " .. partNameFromIndex;
				else
					notesHeader.Text = "Note for " .. cueNameFromIndex .. " '" .. cueNameFromObject .. "' : " .. partNameFromIndex .. " '" .. partNameFromObject .. "'";
				end
			end
		end
	end

	local recipe_grid=ui_parent.RecipeFrame.RecipeGrid;
	if recipe_grid:IsVisible() == true then
		recipe_grid:Set("TargetObject", object, Enums.ChangeLevel.None)

		local settings=recipe_grid:GridGetSettings();
		local columnFilter = settings:Ptr(1):Ptr(1)
		if columnFilter.Preset ~= object then
			columnFilter.Preset = object;
		end
	end

  	caller:SelectionChanged(row_id);
	--[[
	local wnd = caller:FindParent("Window");
	local settings=wnd.WindowSettings.RecipeSheetSettings;
	recipe_grid.ExternalSettings = settings
	local columnFilter = settings:Ptr(1):Ptr(1)
	columnFilter.Preset = object;
	]]
end

signalTable.OnCharInput = function(caller, signal)
    local seqSheet = caller:FindParent("SequenceWindow").Frame.SequenceGrid;
    seqSheet:OnNoteCharInput(signal);
end
