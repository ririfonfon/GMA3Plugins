-- Cue Picker v1.1 
-- by Max Woelk <max@mwoelk.de>
--
-- License: 
-- Feel free to use, modify and distribute this script as you wish but keep it free to use for everyone.
--
-- This script creates a dialog that allows the user to goto a cue from a sequence.
-- In contrast to the built-in cue picker, this script places cues in a grid layout featuring large appearances.
-- 
-- Usage:
-- Call the plugin with the sequence number as argument.
-- Example: > Plugin 1 "2" 
-- Triggers the cue picker for sequence 2.
---
-- Optionally, you can provide a second argument to assign the selected cue's appearance to a macro.
-- Example: > Plugin 1 "2,3" to trigger the cue picker for sequence 2 and assign the selected cue's appearance to macro 3.
-- This is especially useful when using macros in a layout to trigger this plugin
---
--- Additionally you can provide a third argument to specify the command to be executed.
--- Example: > Plugin 1 "2,3,Load" to trigger the cue picker for sequence 2, assign the selected cue's appearance to macro 3 and execute the "Load" command.
--- The default command is "Go". 
--- You can also skip the macro number and provide the command directly as second argument.
--- Example: > Plugin 1 "2,Load" to trigger the cue picker for sequence 2 and execute the "Load" command.
---

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)

-- change the following lines if you want larger / smaller buttons
local buttonWidth = 150
local buttonHeight = 100

local function renderCueButton(cue, grid, row, col)
    local subgrid = grid:Append("UILayoutGrid")
    subgrid.Columns = 1
    subgrid.Rows = 4
    subgrid.Anchors = {
        left = col,
        right = col,
        top = row,
        bottom = row
    }

    local appearance = cue:Get(1).Appearance
    if appearance == nil then
        local button = subgrid:Append("Button")
        button.Text = cue:Get(1).Name
        button.Font = "Medium20"
        button.TextalignmentH = "Centre"
        button.TextalignmentV = "Centre"
        button.PluginComponent = myHandle
        button.Clicked = "CueButtonClicked"
        button.Anchors = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 3
        }
        button.HasHover = "Yes"
        return
    end

    local preview = subgrid:Append("AppearancePreview")
    preview.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 2
    }
    preview.PluginComponent = myHandle
    preview.Appearance = cue:Get(1).Appearance
    preview.HasHover = "Yes"
    preview.Clicked = "CueButtonClicked"
    preview.HideFocusFrame = "No"

    local button = subgrid:Append("Button")
    button.Text = cue:Get(1).Name
    button.Font = "Medium20"
    button.TextalignmentH = "Centre"
    button.TextalignmentV = "Centre"
    button.PluginComponent = myHandle
    button.Clicked = "CueButtonClicked"
    button.Anchors = {
        left = 0,
        right = 0,
        top = 3,
        bottom = 3
    }
    button.HasHover = "Yes"
end

local function main(displayHandle, argument)
    if argument == nil then
        Echo("No argument provided.")
        return
    end

    local arglist = {}
    for arg in argument:gmatch("([^,]+)") do
        table.insert(arglist, arg)
    end

    if #arglist < 1 then
        Echo("Not enough arguments provided.")
        return
    end

    local seqNo = tonumber(arglist[1])
    local macroNo = nil
    local cmdStr = "Go"

    if #arglist > 1 then
        macroNo = tonumber(arglist[2])
        if macroNo == nil and #arglist == 2 then
            cmdStr = arglist[2]
        end
        if macroNo == nil and #arglist > 2 then
            Echo("Invalid macro number provided.")
            return
        end
    end
    if #arglist > 2 then
        cmdStr = arglist[3]
    end

    -- Get the index of the display on which to create the dialog.
    local displayIndex = Obj.Index(GetFocusDisplay())

    -- Get the overlay.
    local display = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Get the sequence, macro  and cues
    local seq = DataPool().Sequences:Get(seqNo)
    if seq == nil then
        Echo("Sequence not found.")
        return
    end

    local macro = nil
    if macroNo ~= nil then
        macro = DataPool().Macros:Get(macroNo)
        if macro == nil then
            Echo("Macro not found.")
            return
        end
    end

    -- Get cues
    local cues = seq:Children()
    local cueCount = #cues - 2

    -- Define sizes
    local maxDialogWidth = display.W * 0.8
    local maxDialogHeight = display.H * 0.8
    if displayIndex > 5 then
        -- Allow larger size on the small displays.
        maxDialogWidth = display.W
        maxDialogHeight = display.H
    end

    local minRowHeight = buttonHeight
    local minItemWidth = buttonWidth

    -- Calculate number of columns and rows.
    local maxCols = math.floor(maxDialogWidth / minItemWidth)

    -- We want to have a square grid to keep it as compact as possible.
    -- Replace with "local preferredCols = maxCols" if it should be as wide as possible.
    local preferredCols = math.min(maxCols, math.ceil(math.sqrt(cueCount)))

    -- in case preferred Cols would be higher than the display we use maxCols instead
    local colCount = math.min(preferredCols, cueCount)
    local rowCount = math.ceil(cueCount / colCount)

    if colCount < maxCols and rowCount * minRowHeight > maxDialogHeight then
        -- try with full width to prevent scrolling too much
        colCount = math.min(maxCols, cueCount)
        rowCount = math.ceil(cueCount / colCount)
    end

    -- Delete any UI elements currently displayed on the overlay.
    screenOverlay:ClearUIChildren()
    
    -- Create the dialog base.
    -- We try to keep the dialog as small as possible and to show all items at once
    local dialogWidth = minItemWidth * colCount
    local dialogHeight = minRowHeight * rowCount + 75

    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = "SinguPickerWindow"
    baseInput.H = dialogHeight
    baseInput.W = dialogWidth
    baseInput.MaxSize = string.format("%s,%s", maxDialogWidth, maxDialogHeight)
    baseInput.Columns = 1  
    baseInput.Rows = 2
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "60"
    baseInput[1][2].SizePolicy = "Stretch"
    baseInput.AutoClose = "Yes"
    baseInput.CloseOnEscape = "Yes"

    -- Create the title bar.
    local titleBar = baseInput:Append("TitleBar")
    titleBar.Columns = 2  
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "50"
    titleBar.Texture = "corner2"
    
    local titleBarIcon = titleBar:Append("TitleButton")
    titleBarIcon.Text = seq.Name
    titleBarIcon.Texture = "corner1"
    titleBarIcon.Anchors = "0,0"
    titleBarIcon.Icon = "star"
    
    local titleBarCloseButton = titleBar:Append("CloseButton")
    titleBarCloseButton.Anchors = "1,0"
    titleBarCloseButton.Texture = "corner2"

    -- Create the dialog's main frame.
    local dlgFrame = baseInput:Append("DialogFrame")
    dlgFrame.Anchors = {
        left = 0,
        right = 0,
        top = 1,
        bottom = 1
    }
    dlgFrame[1][1].SizePolicy = "Stretch"

    -- Create a scroll container
    local scrollContainer = dlgFrame:Append("ScrollContainer")
    scrollContainer.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
    
    local scrollBox = scrollContainer:Append("ScrollBox")

    -- Create the inputs grid.
    -- This is row 1 of the dlgFrame.
    local inputsGrid = scrollBox:Append("UILayoutGrid")
    inputsGrid.Columns = colCount
    inputsGrid.Rows =  rowCount
    inputsGrid.W = "100%"
    inputsGrid.H = rowCount * minRowHeight
    inputsGrid.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }

    for i, cue in ipairs(cues) do
        -- Skip the first two cues (Zero and Off Cue)
        -- We don't want to show them in the picker.
        if i > 2 then
            local gridIdx = i - 2
            renderCueButton(cue, inputsGrid, math.floor((gridIdx - 1) / inputsGrid.Columns), (gridIdx - 1) % inputsGrid.Columns)
        end
    end
    

    -- Handlers.
    -- Cancel button clicked.
    signalTable.CancelButtonClicked = function(caller)
        Obj.Delete(screenOverlay, Obj.Index(baseInput))
    end  

    -- Cue button clicked.
    signalTable.CueButtonClicked = function(caller)
        -- get index of caller in the grid
        local i = caller:Parent():Index() - 2
        local cue = seq:Children()[i + 2]
        local cuePart = cue:Get(1)

        Cmd(string.format("%s Sequence %d Cue %d",cmdStr, seq.No, cue.No/1000))

        -- if we have a macro as well, we assign the cue appearance to it
        if macro ~= nil and cuePart ~= nil then
            macro.Appearance = cuePart.Appearance
        end

        Obj.Delete(screenOverlay, Obj.Index(baseInput))
    end
end

return main