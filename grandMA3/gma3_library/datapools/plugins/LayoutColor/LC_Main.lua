--[[
Releases:
* 2.3.2.0

Version:
* 2.1.2.0

Created by Richard Fontaine "RIRI", June 2024. Update may 2026
--]]

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

local function LC_list_input(popuplists, TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr,
                             MacroNrStart, All_5_Nr, All_5_NrStart, All_5_Current, MatrickNr,
                             MatrickNrStart)
    for k in ipairs(TLay) do
        Echo('Tlay ' .. k)
        for i in ipairs(popuplists.Lay_Select) do
            if popuplists.Lay_Select[i] == TLay[k].NO then
                table.remove(popuplists.Lay_Select, i)
            end
        end
        TLayNr = TLay[k].NO + 1
        TLayNrRef = k
    end
    if TLayNr == nil then
        TLayNr = 1
    end
    for k in ipairs(SeqNr) do
        for i in ipairs(popuplists.Seq_Select) do
            if popuplists.Seq_Select[i] == SeqNr[k].NO then
                table.remove(popuplists.Seq_Select, i)
            end
        end
        SeqNrStart = SeqNr[k].NO + 1
    end
    if SeqNrStart == nil then
        SeqNrStart = 1
    end

    local m
    for k in ipairs(MacroNr) do
        for i in ipairs(popuplists.Macro_Select) do
            if popuplists.Macro_Select[i] == MacroNr[k].NO then
                table.remove(popuplists.Macro_Select, i)
            end
        end
        MacroNrStart = MacroNr[k].NO + 1
        m = k
    end

    if m == nil then
        MacroNrStart = 1
    end

    local kk
    for k in ipairs(All_5_Nr) do
        for i in ipairs(popuplists.Preset_Select) do
            if popuplists.Preset_Select[i] == All_5_Nr[k].NO then
                table.remove(popuplists.Preset_Select, i)
            end
        end
        kk = k
        All_5_NrStart = All_5_Nr[k].NO + 1
        -- Printf("All_5_NrStart inside: %d", All_5_NrStart)
    end
    if kk == nil then
        All_5_NrStart = 1
    end
    All_5_Current = All_5_NrStart

    local kkk
    for k in ipairs(MatrickNr) do
        for i in ipairs(popuplists.Matrick_Select) do
            if popuplists.Matrick_Select[i] == MatrickNr[k].NO then
                table.remove(popuplists.Matrick_Select, i)
            end
        end
        MatrickNrStart = MatrickNr[k].NO + 1
        kkk = k
    end
    if kkk == nil then
        MatrickNrStart = 1
    end
    -- MatrickNr = MatrickNrStart

    Printf("TLayNr: %d", TLayNr)
    Printf("SeqNrStart: %d", SeqNrStart)
    Printf("MacroNrStart: %d", MacroNrStart)
    Printf("All_5_NrStart: %d", All_5_NrStart)
    Printf("MatrickNrStart: %d", MatrickNrStart)
    Printf("All_5_Current: %d", All_5_Current)

    return TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_5_Nr,
        All_5_NrStart, All_5_Current, MatrickNr, MatrickNrStart
end

local function LC_CH_Pool(popuplists)
    local Pool_check = Root().ShowData.DataPools:Children()
    popuplists.DataPool_Select = {}
    popuplists.list_pool = {}
    for k in ipairs(Pool_check) do
        table.insert(popuplists.list_pool, "'" .. Pool_check[k].name .. "'")
        table.insert(popuplists.DataPool_Select, "'" .. Pool_check[k].name .. "'")
    end
    table.insert(popuplists.list_pool, "'New'")
    table.insert(popuplists.DataPool_Select, "'New'")
    return Pool_check
end

local function Main(displayHandle)
    Cmd('Set UserProfile *.15 Property "keyboardshortcutsactive" false')




    local list = false
    local FixtureGroups = DataPool().Groups:Children()
    -- local SelectedGrp = {}
    -- local SelectedGrpNo = {}
    local SelGrp
    -- local Nr_SelectedGrp
    local check_grp = false
    local check_pool = false
    local check_gel = false
    local check_DataPool = false
    local ColPath = Root().ShowData.GelPools
    local ColGels = ColPath:Children()
    local SelectedGelNr
    local NGel
    local MaxColLgn = 50
    local TLay = DataPool().Layouts:Children()
    local TLayNr
    local TLayNrRef
    local NaLay = "Colors"
    local SeqNr = DataPool().Sequences:Children()
    local SeqNrStart
    local SeqNrRange
    local MacroNr = DataPool().Macros:Children()
    local MacroNrStart
    local MacroNrRange
    local App = Root().ShowData.Appearances:Children()
    local AppearObject = Root().ShowData.Appearances
    local AppNr
    local AppNrRange
    local All_5_Nr = DataPool().PresetPools[25]:Children()
    local All_5_NrStart
    local All_5_NrRange
    local All_5_Current
    local MatrickNr = DataPool().MAtricks:Children()
    local MatrickNrStart
    local MatrickNrRange
    local Favourite_Nr = 16
    local TopInc = 0
    local Pool_check
    local NaPool = "LC_COLOR"
    local PoolObject = Root().ShowData.DataPools
    local old_NAPOOL
    local NbGroup


    local popuplists = {
        DataPool_Select  = {},
        list_pool        = {},
        -- Grp_Select       = {},
        Gel_Select       = {},
        Name_Select      = { 'LC_COLOR', 'Layout Color', 'Layout Kolor', 'L Co', 'L Ko', 'Color', 'Kolor' },
        Name_Pool_Select = { 'LC_COLOR', 'Layout Color', 'Layout Kolor', 'L Co', 'L Ko', 'Color', 'Kolor' },
        Lay_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Seq_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Macro_Select     = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Appear_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Preset_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Matrick_Select   = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Favorite_Select  = { 10, 16, 20, 30, 32, 40, 50, 60, 64, 70, 80, 90, 100, 110, 120, 124 }
    }

    Pool_check = LC_CH_Pool(popuplists)
    local Groups_Pool = 1
    local Construct_Pool = 1
    local New = false

    if list == false then
        -- for k in ipairs(FixtureGroups) do
        --     table.insert(popuplists.Grp_Select, "'" .. FixtureGroups[k].name .. "'")
        -- end
        for k in ipairs(ColGels) do
            table.insert(popuplists.Gel_Select, "'" .. ColGels[k].name .. "'")
        end
        for k in ipairs(App) do
            for i in ipairs(popuplists.Appear_Select) do
                if popuplists.Appear_Select[i] == App[k].NO then
                    table.remove(popuplists.Appear_Select, i)
                end
            end

            AppNr = App[k].NO + 1
        end
        if AppNr == nil then
            AppNr = 1
        end
        TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_5_Nr,
        All_5_NrStart, All_5_Current, MatrickNr, MatrickNrStart = LC_list_input(popuplists,
            TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_5_Nr,
            All_5_NrStart, All_5_Current, MatrickNr, MatrickNrStart)

        list = true
    end

    -- Get the index of the display on which to create the dialog.
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then
        displayIndex = 1
    end

    -- Get the colors.
    local colorTransparent = Root().ColorTheme.ColorGroups.Global.Transparent
    local colorTransparent50 = Root().ColorTheme.ColorGroups.Global.Transparent50
    local colorBackground = Root().ColorTheme.ColorGroups.Button.Background
    local colorBackgroundPlease = Root().ColorTheme.ColorGroups.Button.BackgroundPlease
    local colorPartlySelected = Root().ColorTheme.ColorGroups.Global.PartlySelected
    local colorPartlySelectedPreset = Root().ColorTheme.ColorGroups.Global.PartlySelectedPreset

    local colorLayouts = Root().ColorTheme.ColorGroups.PoolWindow.Layouts
    local colorSequences = Root().ColorTheme.ColorGroups.PoolWindow.Sequences
    local colorMacro = Root().ColorTheme.ColorGroups.PoolWindow.Macros
    local colorAppearances = Root().ColorTheme.ColorGroups.PoolWindow.Appearances
    local colorPresets = Root().ColorTheme.ColorGroups.PoolWindow.Presets
    local colorMatricks = Root().ColorTheme.ColorGroups.PoolWindow.Matricks
    local colorPlugins = Root().ColorTheme.ColorGroups.PoolWindow.Plugins
    local colorGroups = Root().ColorTheme.ColorGroups.PoolWindow.Groups
    local colorText = Root().ColorTheme.colorGroups.Global.Text
    local colorAlertText = Root().ColorTheme.colorGroups.Global.AlertText
    local colorFavorite = Root().ColorTheme.colorGroups.Global.Collected
    local colorDataPools = Root().ColorTheme.ColorGroups.PoolWindow.DataPools
    local colorGelPools = Root().ColorTheme.ColorGroups.PoolWindow.Gels

    -- Get the overlay.
    local display = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Delete any UI elements currently displayed on the overlay.
    screenOverlay:ClearUIChildren()

    -- Create the dialog base.
    local dialogWidth = 1024
    local baseInput = screenOverlay:Append("BaseInput")
    local myicon = baseInput:Append("AppearancePreview")
    -- myicon.Appearance = GetObject('Layout_Color')
    myicon.Appearance = AppearObject[955]
    myicon.BackColor, myicon.W = colorTransparent, 1000
    myicon.X, myicon.Y = 0, 0
    myicon.Interactive = 'No'
    baseInput.Name = "LC_Main_Box"
    baseInput.H = "0"
    baseInput.W = dialogWidth
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.55, display.H)
    baseInput.MinSize = string.format("%s,0", dialogWidth)
    baseInput.Columns = 1
    baseInput.Rows = 2
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "60"
    baseInput[1][2].SizePolicy = "Stretch"
    baseInput.AutoClose = "No"
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
    titleBarIcon.Text = "               Layout Color By RIRI"
    titleBarIcon.Texture = "corner1"
    titleBarIcon.Anchors = "0,0"
    titleBarIcon.Icon = "object_plugin1"
    titleBarIcon.Font = "2"
    titleBarIcon.backColor = colorPlugins

    local titleBarCloseButton = titleBar:Append("CloseButton")
    titleBarCloseButton.Anchors = "1,0"
    titleBarCloseButton.Texture = "corner2"
    titleBarCloseButton.backColor = colorPlugins

    -- Create the dialog's main frame.
    local dlgFrame = baseInput:Append("DialogFrame")
    dlgFrame.H = "100%"
    dlgFrame.W = "100%"
    dlgFrame.Columns = 1
    dlgFrame.Rows = 3
    dlgFrame.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    dlgFrame[1][1].SizePolicy = "Fixed"
    dlgFrame[1][1].Size = "150"
    dlgFrame[1][2].SizePolicy = "Fixed"
    dlgFrame[1][2].Size = "800"
    dlgFrame[1][3].SizePolicy = "Fixed"
    dlgFrame[1][3].Size = "50"

    -- Create the sub title.
    -- This is row 1 of the dlgFrame.
    local subTitle = dlgFrame:Append("UIObject")
    subTitle.Text = ""
    -- "Set Number begin Layout, Sequence, Macro, Appearance & Preset & Matrick\nAdd ColorGel & FixtureGroup\nSelected Group(s) are:\n"
    subTitle.TextalignmentH = "Left"
    subTitle.TextalignmentV = "Top"
    subTitle.ContentDriven = "Yes"
    subTitle.ContentWidth = "Yes"
    subTitle.TextAutoAdjust = "Yes"
    subTitle.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    subTitle.Padding = { left = 0, right = 0, top = 5, bottom = 5 }
    subTitle.Font = "2"
    subTitle.HasHover = "No"
    subTitle.BackColor = colorTransparent50

    -- Create the inputs grid.
    -- This is row 2 of the dlgFrame.
    local inputsGrid = dlgFrame:Append("UILayoutGrid")
    inputsGrid.Columns = 10
    inputsGrid.Rows = 13
    inputsGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    inputsGrid.Margin = { left = 0, right = 0, top = 0, bottom = 5 }

    -- Create the UI elements for the 9 input button.
    local input9Icon = inputsGrid:Append("Button")
    input9Icon.Text = ""
    input9Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input9Icon.Icon = "object_gels"
    input9Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input9Icon.HasHover = "No";
    input9Icon.BackColor = colorGelPools
    input9Icon.Font = "2"

    local input9Label = inputsGrid:Append("UIObject")
    input9Label.Text = "Gel  "
    input9Label.TextalignmentH = "Left"
    input9Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input9Label.Padding = "5,5"
    input9Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input9Label.HasHover = "No";
    input9Label.Font = "2"
    input9Label.BackColor = colorGelPools

    local input9Button = inputsGrid:Append('Button')
    input9Button.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    input9Button.Padding = "5,5"
    input9Button.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input9Button.Name = 'Gel_Select'
    input9Button.Text = "Please select Gel"
    input9Button.PluginComponent = thiscomponent
    input9Button.Clicked = 'mypopup'
    input9Button.BackColor = colorGelPools
    input9Button.Font = "2"
    input9Button.Visible = "Yes"

    TopInc = TopInc + 1

    -- Create the UI elements for the 10 input button.
    local input10Icon = inputsGrid:Append("Button")
    input10Icon.Text = ""
    input10Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input10Icon.Icon = "object_group2"
    input10Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input10Icon.HasHover = "No";
    input10Icon.BackColor = colorGroups
    input10Icon.Font = "2"

    local input10Label = inputsGrid:Append("UIObject")
    input10Label.Text = "Nb Group  "
    input10Label.TextalignmentH = "Left"
    input10Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input10Label.Padding = "5,5"
    input10Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input10Label.HasHover = "No";
    input10Label.Font = "2"
    input10Label.BackColor = colorGroups

    local input10LineEdit = inputsGrid:Append("LineEdit")
    input10LineEdit.Prompt = "Nb: "
    input10LineEdit.TextAutoAdjust = "Yes"
    input10LineEdit.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    input10LineEdit.Padding = "5,5"
    input10LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input10LineEdit.Filter = "0123456789"
    input10LineEdit.VkPluginName = "TextInputNumOnly"
    input10LineEdit.Content = NbGroup
    input10LineEdit.MaxTextLength = 6
    input10LineEdit.HideFocusFrame = "Yes"
    input10LineEdit.PluginComponent = myHandle
    input10LineEdit.TextChanged = "OnInput10TextChanged"
    input10LineEdit.Font = "2"
    input10LineEdit.BackColor = colorGroups
    input10LineEdit.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 1 input.
    local input20Icon = inputsGrid:Append("Button")
    input20Icon.Text = ""
    input20Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input20Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input20Icon.Icon = "object_datapool"
    input20Icon.HasHover = "No";
    input20Icon.BackColor = colorDataPools

    local input20Label = inputsGrid:Append("UIObject")
    input20Label.Text = "DataPool Destination"
    input20Label.TextalignmentH = "Left"
    input20Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input20Label.Padding = "5,5"
    input20Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input20Label.HasHover = "No"
    input20Label.BackColor = colorDataPools
    input20Label.Font = "3"

    local input20Button = inputsGrid:Append('Button')
    input20Button.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input20Button.Padding = "5,5"
    input20Button.Margin = { left = 4, right = 0, top = TopInc, bottom = 2 }
    input20Button.Name = 'DataPool_Select'
    input20Button.Text = "Please select DataPool"
    input20Button.PluginComponent = thiscomponent
    input20Button.Clicked = 'mypopup'
    input20Button.BackColor = colorDataPools
    input20Button.Font = "2"
    input20Button.Visible = "No"

    local input20number = inputsGrid:Append('Button')
    input20number.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input20number.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input20number.Text = ""
    input20number.BackColor = colorDataPools
    input20number.Font = "3"
    input20number.HasHover = "No"
    input20number.Visible = "No"

    TopInc = TopInc + 1

    local input21Icon = inputsGrid:Append("Button")
    input21Icon.Text = ""
    input21Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input21Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input21Icon.Icon = "object_datapool"
    input21Icon.HasHover = "No";
    input21Icon.BackColor = colorDataPools

    local input21Label = inputsGrid:Append("UIObject")
    input21Label.Text = "DataPool Name"
    input21Label.TextalignmentH = "Left"
    input21Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input21Label.Padding = "5,5"
    input21Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input21Label.HasHover = "No"
    input21Label.BackColor = colorDataPools
    input21Label.Font = "2"

    local input21LineEdit = inputsGrid:Append("LineEdit")
    input21LineEdit.Prompt = "Name: "
    input21LineEdit.TextAutoAdjust = "Yes"
    input21LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input21LineEdit.Padding = "5,5"
    input21LineEdit.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input21LineEdit.VkPluginName = "TextInput"
    input21LineEdit.Content = ""
    input21LineEdit.MaxTextLength = 16
    input21LineEdit.HideFocusFrame = "Yes"
    input21LineEdit.PluginComponent = myHandle
    input21LineEdit.TextChanged = "OnInput21TextChanged"
    input21LineEdit.BackColor = colorDataPools
    input21LineEdit.Font = "2"
    input21LineEdit.Visible = "No"

    local input21Sujestion = inputsGrid:Append("Button")
    input21Sujestion.Text = ""
    input21Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input21Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input21Sujestion.Icon = "zoom"
    input21Sujestion.Name = 'Name_Pool_Select'
    input21Sujestion.PluginComponent = thiscomponent
    input21Sujestion.Clicked = 'mypopup'
    input21Sujestion.HasHover = "yes"
    input21Sujestion.backColor = colorDataPools
    input21Sujestion.Visible = "No"

    TopInc = TopInc + 1



    local input1Icon = inputsGrid:Append("Button")
    input1Icon.Text = ""
    input1Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input1Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input1Icon.Icon = "object_layout"
    input1Icon.HasHover = "No";
    input1Icon.BackColor = colorLayouts

    local input1Label = inputsGrid:Append("UIObject")
    input1Label.Text = "Layout Name"
    input1Label.TextalignmentH = "Left"
    input1Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input1Label.Padding = "5,5"
    input1Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input1Label.HasHover = "No"
    input1Label.BackColor = colorLayouts
    input1Label.Font = "2"

    local input1LineEdit = inputsGrid:Append("LineEdit")
    input1LineEdit.Prompt = "Name: "
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input1LineEdit.VkPluginName = "TextInput"
    input1LineEdit.Content = "Colors"
    input1LineEdit.MaxTextLength = 16
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"
    input1LineEdit.BackColor = colorLayouts
    input1LineEdit.Font = "2"
    input1LineEdit.Visible = "No"

    local input1Sujestion = inputsGrid:Append("Button")
    input1Sujestion.Text = ""
    input1Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input1Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input1Sujestion.Icon = "zoom"
    input1Sujestion.Name = 'Name_Select'
    input1Sujestion.PluginComponent = thiscomponent
    input1Sujestion.Clicked = 'mypopup'
    input1Sujestion.HasHover = "yes"
    input1Sujestion.backColor = colorLayouts
    input1Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 2 input.
    local input2Icon = inputsGrid:Append("Button")
    input2Icon.Text = ""
    input2Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input2Icon.Icon = "object_layout"
    input2Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input2Icon.HasHover = "No";
    input2Icon.BackColor = colorLayouts

    local input2Label = inputsGrid:Append("UIObject")
    input2Label.Text = "Layout Nr"
    input2Label.TextalignmentH = "Left"
    input2Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input2Label.Padding = "5,5"
    input2Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input2Label.HasHover = "No";
    input2Label.BackColor = colorLayouts
    input2Label.Font = "2"

    local input2LineEdit = inputsGrid:Append("LineEdit")
    input2LineEdit.Prompt = "Nr: "
    input2LineEdit.TextAutoAdjust = "Yes"
    input2LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input2LineEdit.Padding = "5,5"
    input2LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input2LineEdit.Filter = "0123456789."
    input2LineEdit.VkPluginName = "TextInputNumOnly"
    input2LineEdit.Content = TLayNr
    input2LineEdit.MaxTextLength = 8
    input2LineEdit.HideFocusFrame = "Yes"
    input2LineEdit.PluginComponent = myHandle
    input2LineEdit.TextChanged = "OnInput2TextChanged"
    input2LineEdit.BackColor = colorLayouts
    input2LineEdit.Font = "2"
    input2LineEdit.Visible = "No"

    local input2Sujestion = inputsGrid:Append("Button")
    input2Sujestion.Text = ""
    input2Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input2Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input2Sujestion.Icon = "zoom"
    input2Sujestion.Name = 'Lay_Select'
    input2Sujestion.PluginComponent = thiscomponent
    input2Sujestion.Clicked = 'mypopup'
    input2Sujestion.HasHover = "yes"
    input2Sujestion.backColor = colorLayouts
    input2Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 3 input.
    local input3Icon = inputsGrid:Append("Button")
    input3Icon.Text = ""
    input3Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input3Icon.Icon = "object_sequence"
    input3Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input3Icon.HasHover = "No";
    input3Icon.BackColor = colorSequences

    local input3Label = inputsGrid:Append("UIObject")
    input3Label.Text = "Sequence Nr"
    input3Label.TextalignmentH = "Left"
    input3Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input3Label.Padding = "5,5"
    input3Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input3Label.HasHover = "No";
    input3Label.BackColor = colorPartlySelectedPreset
    input3Label.Font = "2"
    input3Label.BackColor = colorSequences

    local input3LineEdit = inputsGrid:Append("LineEdit")
    input3LineEdit.Prompt = "Nr: "
    input3LineEdit.TextAutoAdjust = "Yes"
    input3LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input3LineEdit.Padding = "5,5"
    input3LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input3LineEdit.VkPluginName = "TextInputNumOnly"
    input3LineEdit.Content = SeqNrStart
    input3LineEdit.MaxTextLength = 10
    input3LineEdit.HideFocusFrame = "Yes"
    input3LineEdit.Filter = "0123456789."
    input3LineEdit.PluginComponent = myHandle
    input3LineEdit.TextChanged = "OnInput3TextChanged"
    input3LineEdit.Font = "2"
    input3LineEdit.BackColor = colorSequences
    input3LineEdit.Visible = "No"

    local input3Sujestion = inputsGrid:Append("Button")
    input3Sujestion.Text = ""
    input3Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input3Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input3Sujestion.Icon = "zoom"
    input3Sujestion.Name = 'Seq_Select'
    input3Sujestion.PluginComponent = thiscomponent
    input3Sujestion.Clicked = 'mypopup'
    input3Sujestion.HasHover = "yes"
    input3Sujestion.backColor = colorSequences
    input3Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 4 input.
    local input4Icon = inputsGrid:Append("Button")
    input4Icon.Text = ""
    input4Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input4Icon.Icon = "object_macro"
    input4Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input4Icon.HasHover = "No";
    input4Icon.BackColor = colorMacro

    local input4Label = inputsGrid:Append("UIObject")
    input4Label.Text = "Macro Nr"
    input4Label.TextalignmentH = "Left"
    input4Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input4Label.Padding = "5,5"
    input4Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input4Label.HasHover = "No";
    input4Label.Font = "2"
    input4Label.BackColor = colorMacro

    local input4LineEdit = inputsGrid:Append("LineEdit")
    input4LineEdit.Prompt = "Nr: "
    input4LineEdit.TextAutoAdjust = "Yes"
    input4LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input4LineEdit.Padding = "5,5"
    input4LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input4LineEdit.Filter = "0123456789"
    input4LineEdit.VkPluginName = "TextInputNumOnly"
    input4LineEdit.Content = MacroNrStart
    input4LineEdit.MaxTextLength = 6
    input4LineEdit.HideFocusFrame = "Yes"
    input4LineEdit.PluginComponent = myHandle
    input4LineEdit.TextChanged = "OnInput4TextChanged"
    input4LineEdit.Font = "2"
    input4LineEdit.BackColor = colorMacro
    input4LineEdit.Visible = "No"

    local input4Sujestion = inputsGrid:Append("Button")
    input4Sujestion.Text = ""
    input4Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input4Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input4Sujestion.Icon = "zoom"
    input4Sujestion.Name = 'Macro_Select'
    input4Sujestion.PluginComponent = thiscomponent
    input4Sujestion.Clicked = 'mypopup'
    input4Sujestion.HasHover = "yes"
    input4Sujestion.backColor = colorMacro
    input4Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 5 input.
    local input5Icon = inputsGrid:Append("Button")
    input5Icon.Text = ""
    input5Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input5Icon.Icon = "object_appear."
    input5Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input5Icon.HasHover = "No";
    input5Icon.BackColor = colorAppearances

    local input5Label = inputsGrid:Append("UIObject")
    input5Label.Text = "Appear. Nr"
    input5Label.TextalignmentH = "Left"
    input5Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input5Label.Padding = "5,5"
    input5Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input5Label.HasHover = "No";
    input5Label.Font = "2"
    input5Label.BackColor = colorAppearances

    local input5LineEdit = inputsGrid:Append("LineEdit")
    input5LineEdit.Prompt = "Nr: "
    input5LineEdit.TextAutoAdjust = "Yes"
    input5LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input5LineEdit.Padding = "5,5"
    input5LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input5LineEdit.Filter = "0123456789"
    input5LineEdit.VkPluginName = "TextInputNumOnly"
    input5LineEdit.Content = AppNr
    input5LineEdit.MaxTextLength = 6
    input5LineEdit.HideFocusFrame = "Yes"
    input5LineEdit.PluginComponent = myHandle
    input5LineEdit.TextChanged = "OnInput5TextChanged"
    input5LineEdit.Font = "2"
    input5LineEdit.BackColor = colorAppearances
    input5LineEdit.Visible = "No"

    local input5Sujestion = inputsGrid:Append("Button")
    input5Sujestion.Text = ""
    input5Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input5Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input5Sujestion.Icon = "zoom"
    input5Sujestion.Name = 'Appear_Select'
    input5Sujestion.PluginComponent = thiscomponent
    input5Sujestion.Clicked = 'mypopup'
    input5Sujestion.HasHover = "yes"
    input5Sujestion.backColor = colorAppearances
    input5Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 6 input.
    local input6Icon = inputsGrid:Append("Button")
    input6Icon.Text = ""
    input6Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input6Icon.Icon = "object_preset"
    input6Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input6Icon.HasHover = "No";
    input6Icon.BackColor = colorPresets

    local input6Label = inputsGrid:Append("UIObject")
    input6Label.Text = "Preset All 5 Nr"
    input6Label.TextalignmentH = "Left"
    input6Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input6Label.Padding = "5,5"
    input6Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input6Label.HasHover = "No";
    input6Label.Font = "2"
    input6Label.BackColor = colorPresets

    local input6LineEdit = inputsGrid:Append("LineEdit")
    input6LineEdit.Prompt = "Nr: "
    input6LineEdit.TextAutoAdjust = "Yes"
    input6LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input6LineEdit.Padding = "5,5"
    input6LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input6LineEdit.Filter = "0123456789"
    input6LineEdit.VkPluginName = "TextInputNumOnly"
    input6LineEdit.Content = All_5_NrStart
    input6LineEdit.MaxTextLength = 6
    input6LineEdit.HideFocusFrame = "Yes"
    input6LineEdit.PluginComponent = myHandle
    input6LineEdit.TextChanged = "OnInput6TextChanged"
    input6LineEdit.Font = "2"
    input6LineEdit.BackColor = colorPresets
    input6LineEdit.Visible = "No"

    local input6Sujestion = inputsGrid:Append("Button")
    input6Sujestion.Text = ""
    input6Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input6Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input6Sujestion.Icon = "zoom"
    input6Sujestion.Name = 'Preset_Select'
    input6Sujestion.PluginComponent = thiscomponent
    input6Sujestion.Clicked = 'mypopup'
    input6Sujestion.HasHover = "yes"
    input6Sujestion.backColor = colorPresets
    input6Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 7 input.
    local input7Icon = inputsGrid:Append("Button")
    input7Icon.Text = ""
    input7Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input7Icon.Icon = "object_matricks"
    input7Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input7Icon.HasHover = "No";
    input7Icon.BackColor = colorMatricks

    local input7Label = inputsGrid:Append("UIObject")
    input7Label.Text = "Matrick Nr"
    input7Label.TextalignmentH = "Left"
    input7Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input7Label.Padding = "5,5"
    input7Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input7Label.HasHover = "No";
    input7Label.Font = "2"
    input7Label.BackColor = colorMatricks

    local input7LineEdit = inputsGrid:Append("LineEdit")
    input7LineEdit.Prompt = "Nr: "
    input7LineEdit.TextAutoAdjust = "Yes"
    input7LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input7LineEdit.Padding = "5,5"
    input7LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input7LineEdit.Filter = "0123456789"
    input7LineEdit.VkPluginName = "TextInputNumOnly"
    input7LineEdit.Content = MatrickNrStart
    input7LineEdit.MaxTextLength = 6
    input7LineEdit.HideFocusFrame = "Yes"
    input7LineEdit.PluginComponent = myHandle
    input7LineEdit.TextChanged = "OnInput7TextChanged"
    input7LineEdit.Font = "2"
    input7LineEdit.BackColor = colorMatricks
    input7LineEdit.Visible = "No"

    local input7Sujestion = inputsGrid:Append("Button")
    input7Sujestion.Text = ""
    input7Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input7Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input7Sujestion.Icon = "zoom"
    input7Sujestion.Name = 'Matrick_Select'
    input7Sujestion.PluginComponent = thiscomponent
    input7Sujestion.Clicked = 'mypopup'
    input7Sujestion.HasHover = "yes"
    input7Sujestion.backColor = colorMatricks
    input7Sujestion.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 8 input.
    local input8Icon = inputsGrid:Append("Button")
    input8Icon.Text = ""
    input8Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input8Icon.Icon = "settings"
    input8Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input8Icon.HasHover = "No";
    input8Icon.BackColor = colorPartlySelected

    local input8Label = inputsGrid:Append("UIObject")
    input8Label.Text = "Nb color / line"
    input8Label.TextalignmentH = "Left"
    input8Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input8Label.Padding = "5,5"
    input8Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input8Label.HasHover = "No";
    input8Label.Font = "2"
    input8Label.BackColor = colorPartlySelected

    local input8LineEdit = inputsGrid:Append("LineEdit")
    input8LineEdit.Prompt = "Nb: "
    input8LineEdit.TextAutoAdjust = "Yes"
    input8LineEdit.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    input8LineEdit.Padding = "5,5"
    input8LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input8LineEdit.Filter = "0123456789"
    input8LineEdit.VkPluginName = "TextInputNumOnly"
    input8LineEdit.Content = MaxColLgn
    input8LineEdit.MaxTextLength = 6
    input8LineEdit.HideFocusFrame = "Yes"
    input8LineEdit.PluginComponent = myHandle
    input8LineEdit.TextChanged = "OnInput8TextChanged"
    input8LineEdit.Font = "2"
    input8LineEdit.BackColor = colorPartlySelected
    input8LineEdit.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 11 input.
    local input11Icon = inputsGrid:Append("Button")
    input11Icon.Text = ""
    input11Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input11Icon.Icon = "star"
    input11Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input11Icon.HasHover = "No";
    input11Icon.BackColor = colorFavorite

    local input11Label = inputsGrid:Append("UIObject")
    input11Label.Text = "Nb Favorites"
    input11Label.TextalignmentH = "Left"
    input11Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input11Label.Padding = "5,5"
    input11Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input11Label.HasHover = "No";
    input11Label.Font = "2"
    input11Label.BackColor = colorFavorite

    local input11LineEdit = inputsGrid:Append("LineEdit")
    input11LineEdit.Prompt = "Nb: "
    input11LineEdit.TextAutoAdjust = "Yes"
    input11LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input11LineEdit.Padding = "5,5"
    input11LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input11LineEdit.Filter = "0123456789"
    input11LineEdit.VkPluginName = "TextInputNumOnly"
    input11LineEdit.Content = Favourite_Nr
    input11LineEdit.MaxTextLength = 6
    input11LineEdit.HideFocusFrame = "Yes"
    input11LineEdit.PluginComponent = myHandle
    input11LineEdit.TextChanged = "OnInput11TextChanged"
    input11LineEdit.Font = "2"
    input11LineEdit.BackColor = colorFavorite
    input11LineEdit.Visible = "No"

    local input11Sujestion = inputsGrid:Append("Button")
    input11Sujestion.Text = ""
    input11Sujestion.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input11Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input11Sujestion.Icon = "zoom"
    input11Sujestion.Name = 'Favorite_Select'
    input11Sujestion.PluginComponent = thiscomponent
    input11Sujestion.Clicked = 'mypopup'
    input11Sujestion.HasHover = "yes"
    input11Sujestion.backColor = colorFavorite
    input11Sujestion.Visible = "No"





    -- local input10Button = inputsGrid:Append('Button')
    -- input10Button.Text = 'Please add Group'
    -- input10Button.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    -- input10Button.Padding = "5,5"
    -- input10Button.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    -- input10Button.Name = 'Grp_Select'
    -- input10Button.HasHover = "yes"
    -- input10Button.PluginComponent = thiscomponent
    -- input10Button.Clicked = 'mypopup'
    -- input10Button.BackColor = colorGroups
    -- input10Button.Font = "2"
    -- input10Button.Visible = "No"

    -- local input10Sujestion = inputsGrid:Append("Button")
    -- input10Sujestion.Text = "Select Pool"
    -- input10Sujestion.Anchors = { left = 2, right = 3, top = TopInc, bottom = TopInc }
    -- input10Sujestion.Margin = { left = 0, right = 0, top = TopInc, bottom = 2 }
    -- input10Sujestion.Name = 'list_pool'
    -- input10Sujestion.PluginComponent = thiscomponent
    -- input10Sujestion.Clicked = 'mypopup'
    -- input10Sujestion.HasHover = "yes"
    -- input10Sujestion.backColor = colorGroups
    -- input10Sujestion.Font = "2"
    -- input10Sujestion.Visible = "No"

    -- TopInc = TopInc + 1

    -- local input12Icon = inputsGrid:Append("Button")
    -- input12Icon.Anchors = { left = 1, right = 1, top = TopInc, bottom = TopInc }
    -- input12Icon.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    -- input12Icon.Icon = 'object_datapool'
    -- input12Icon.backColor = colorGroups
    -- input12Icon.HasHover = "No"


    -- Create the button grid.
    -- This is row 3 of the dlgFrame.
    local buttonGrid = dlgFrame:Append("UILayoutGrid")
    buttonGrid.Columns = 2
    buttonGrid.Rows = 1
    buttonGrid.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }

    local OkButton = buttonGrid:Append("Button");
    OkButton.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    OkButton.Textshadow = 1
    OkButton.HasHover = "Yes"
    OkButton.Text = "OK Let's GO"
    OkButton.Font = "2"
    OkButton.TextalignmentH = "Centre"
    OkButton.PluginComponent = myHandle
    OkButton.Clicked = "OkButtonClicked"
    OkButton.Visible = "No"

    local cancelButton = buttonGrid:Append("Button");
    cancelButton.Anchors = { left = 1, right = 1, top = 0, bottom = 0 }
    cancelButton.Textshadow = 1
    cancelButton.HasHover = "Yes"
    cancelButton.Text = "Cancel"
    cancelButton.Font = "2"
    cancelButton.TextalignmentH = "Centre"
    cancelButton.PluginComponent = myHandle
    cancelButton.Clicked = "CancelButtonClicked"
    cancelButton.Visible = "Yes"

    -- Handlers.
    signalTable.CancelButtonClicked = function(caller)
        Cmd("ClearAll /nu")
        Obj.Delete(screenOverlay, Obj.Index(baseInput))
    end

    signalTable.OkButtonClicked = function(caller)
        if (OkButton.BackColor == colorBackground) then
            OkButton.BackColor = colorBackgroundPlease
        else
            OkButton.BackColor = colorBackground
        end
        Obj.Delete(screenOverlay, Obj.Index(baseInput))
        LC_Construct_Layout(TLay, SeqNrStart, MacroNrStart, MatrickNrStart, MatrickNr, TLayNr,
            AppNr, All_5_Current, All_5_NrStart, ColPath, SelectedGelNr, NbGroup,
            TLayNrRef, NaLay, MaxColLgn, Favourite_Nr, Construct_Pool,
            Groups_Pool)
    end

    -- Layout Name
    signalTable.OnInput1TextChanged = function(caller)
        NaLay = caller.Content:gsub("'", "")
    end
    -- Pool Name
    signalTable.OnInput21TextChanged = function(caller)
        NaPool = caller.Content:gsub("'", "")
        input20Button.Text = NaPool
        PoolObject[Construct_Pool]:Set('Name', NaPool)
        Pool_check = LC_CH_Pool(popuplists)
        NaPool = PoolObject[Construct_Pool]:Get('Name')
        input20Button.Text = NaPool
        if old_NAPOOL ~= NaPool then
            input21LineEdit.Content = NaPool
            old_NAPOOL = NaPool
        end
    end
    -- Layout Nr
    signalTable.OnInput2TextChanged = function(caller)
        local check = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input2LineEdit.TextColor = colorAlertText
            check = true
        end
        TLayNr = caller.Content:gsub("'", "")
        TLayNr = tonumber(TLayNr)
        for k in ipairs(TLay) do
            if TLayNr == tonumber(TLay[k].NO) then
                OkButton.Visible = "No"
                input2LineEdit.TextColor = colorAlertText
                check = true
            end
        end
        if check == false then
            input2LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- seq Nr
    signalTable.OnInput3TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input3LineEdit.TextColor = colorAlertText
            checks = true
        end
        SeqNrStart = caller.Content:gsub("'", "")
        SeqNrStart = tonumber(SeqNrStart)
        SeqNrRange = SeqNrStart + tonumber((NbGroup * (NGel + 2)) + NGel + 100)
        for k in ipairs(SeqNr) do
            if SeqNrStart <= tonumber(SeqNr[k].NO) then
                if SeqNrRange >= tonumber(SeqNr[k].NO) then
                    OkButton.Visible = "No"
                    input3LineEdit.TextColor = colorAlertText
                    checks = true
                    for i in ipairs(popuplists.Seq_Select) do
                        if SeqNrStart <= tonumber(popuplists.Seq_Select[i]) then
                            if SeqNrRange >= tonumber(popuplists.Seq_Select[i]) then
                                table.remove(popuplists.Seq_Select, i)
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input3LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Macro Nr
    signalTable.OnInput4TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input4LineEdit.TextColor = colorAlertText
            checks = true
        end
        MacroNrStart = caller.Content:gsub("'", "")
        MacroNrStart = tonumber(MacroNrStart)
        MacroNrRange = MacroNrStart + 42 + Favourite_Nr + NbGroup
        Printf("MacroNrStart " .. MacroNrStart)
        for k in ipairs(MacroNr) do
            if MacroNrStart <= tonumber(MacroNr[k].NO) then
                if MacroNrRange >= tonumber(MacroNr[k].NO) then
                    OkButton.Visible = "No"
                    input4LineEdit.TextColor = colorAlertText
                    checks = true
                end
            end
        end
        if checks == false then
            input4LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Appear Nr
    signalTable.OnInput5TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input5LineEdit.TextColor = colorAlertText
            checks = true
        end
        AppNr = caller.Content:gsub("'", "")
        AppNr = tonumber(AppNr)
        AppNrRange = AppNr + 75 + (NGel * 2)
        for k in ipairs(App) do
            if AppNr <= tonumber(App[k].NO) then
                if AppNrRange >= tonumber(App[k].NO) then
                    OkButton.Visible = "No"
                    input5LineEdit.TextColor = colorAlertText
                    checks = true
                    for i in ipairs(popuplists.Appear_Select) do
                        if AppNr <= tonumber(popuplists.Appear_Select[i]) then
                            if AppNrRange >= tonumber(popuplists.Appear_Select[i]) then
                                table.remove(popuplists.Appear_Select, i)
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input5LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Preset all5
    signalTable.OnInput6TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input6LineEdit.TextColor = colorAlertText
            checks = true
        end
        All_5_NrStart = caller.Content:gsub("'", "")
        All_5_NrStart = tonumber(All_5_NrStart)
        All_5_Current = All_5_NrStart
        All_5_NrRange = All_5_NrStart + NGel
        for k in ipairs(All_5_Nr) do
            if All_5_NrStart <= tonumber(All_5_Nr[k].NO) then
                if All_5_NrRange >= tonumber(All_5_Nr[k].NO) then
                    OkButton.Visible = "No"
                    input6LineEdit.TextColor = colorAlertText
                    checks = true
                    for i in ipairs(popuplists.Preset_Select) do
                        if All_5_NrStart <= tonumber(popuplists.Preset_Select[i]) then
                            if All_5_NrRange >= tonumber(popuplists.Preset_Select[i]) then
                                table.remove(popuplists.Preset_Select, i)
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input6LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Matrick Nr
    signalTable.OnInput7TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input7LineEdit.TextColor = colorAlertText
            checks = true
        end
        MatrickNrStart = caller.Content:gsub("'", "")
        MatrickNrStart = tonumber(MatrickNrStart)
        MatrickNrRange = MatrickNrStart + NbGroup + 1
        for k in ipairs(MatrickNr) do
            if MatrickNrStart <= tonumber(MatrickNr[k].NO) then
                if MatrickNrRange >= tonumber(MatrickNr[k].NO) then
                    OkButton.Visible = "No"
                    input7LineEdit.TextColor = colorAlertText
                    checks = true
                    for i in ipairs(popuplists.Matrick_Select) do
                        if MatrickNrStart <= tonumber(popuplists.Matrick_Select[i]) then
                            if MatrickNrRange >= tonumber(popuplists.Matrick_Select[i]) then
                                table.remove(popuplists.Matrick_Select, i)
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input7LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Nb color line
    signalTable.OnInput8TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            checks = true
        end
        MaxColLgn = caller.Content:gsub("'", "")
        MaxColLgn = tonumber(MaxColLgn)

        if checks == true then
            OkButton.Visible = "No"
            input8LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input8LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Nb Favorite
    signalTable.OnInput11TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input11LineEdit.TextColor = colorAlertText
            checks = true
        end
        Favourite_Nr = caller.Content:gsub("'", "")
        Favourite_Nr = tonumber(Favourite_Nr)
        if Favourite_Nr == nil then
            Favourite_Nr = 1
        end
        MacroNrRange = MacroNrStart + 42 + Favourite_Nr + NbGroup
        for k in ipairs(MacroNr) do
            if MacroNrStart <= tonumber(MacroNr[k].NO) then
                if MacroNrRange >= tonumber(MacroNr[k].NO) then
                    OkButton.Visible = "No"
                    input4LineEdit.TextColor = colorAlertText
                    input11LineEdit.TextColor = colorAlertText
                    checks = true
                end
            end
        end

        if checks == true then
            OkButton.Visible = "No"
            input4LineEdit.TextColor = colorAlertText
            input11LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input4LineEdit.TextColor = colorText
            input11LineEdit.TextColor = colorText
            if check_grp == true and check_gel == true and check_pool == true and check_DataPool == true then
                OkButton.Visible = "Yes"
            end
        end
    end
    -- Nb Group
    signalTable.OnInput10TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input10LineEdit.TextColor = colorAlertText
            checks = true
        else
            OkButton.Visible = "Yes"
            input10LineEdit.TextColor = colorText
        end
        NbGroup = caller.Content:gsub("'", "")
        NbGroup = tonumber(NbGroup)
        if NbGroup == nil then
            NbGroup = 1
        end
        check_grp = true
        input20number.Visible = "Yes"
        input20Button.Visible = "Yes"
    end

    function signalTable.mypopup(caller)
        local itemlist = popuplists[caller.Name]
        local _, choice = PopupInput { title = caller.Name, caller = caller:GetDisplay(), items = itemlist, selectedValue = caller.Text }

        local Check_Pool = false
        if caller.Name == "DataPool_Select" then
            Echo('datapool_select')
            Pool_check = LC_CH_Pool(popuplists)
            caller.Text = choice or caller.Text
            for k in ipairs(Pool_check) do
                Echo('k pool_check' .. k)
                Echo(' Name ' .. Pool_check[k].name)
                if Pool_check[k].name == caller.Text:gsub("'", "") then
                    Echo('Construct_Pool ' .. k)
                    Construct_Pool = tonumber(k)
                    Check_Pool = true
                    New = false
                end
            end
            if Check_Pool == false then
                Echo('check_pool false')
                local C_Pool = PoolObject:Acquire()
                Construct_Pool = C_Pool.No
                coroutine.yield(0.1)
                PoolObject:Create(Construct_Pool)
                Pool_check = LC_CH_Pool(popuplists)
                FixtureGroups = Root().ShowData.DataPools[Construct_Pool].Groups:Children()
                New = true
                OkButton.Visible = "Yes"
                input21LineEdit.Content = "LC_COlOR"
                Check_Pool = true
            end
            if Check_Pool == true then
                Echo('New')
                Pool_check = LC_CH_Pool(popuplists)
                input21LineEdit.Content = PoolObject[Construct_Pool]:Get('Name')
                PoolObject = Root().ShowData.DataPools
                TLay = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
                SeqNr = Root().ShowData.DataPools[Construct_Pool].Sequences:Children()
                MacroNr = Root().ShowData.DataPools[Construct_Pool].Macros:Children()
                All_5_Nr = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]:Children()
                FixtureGroups = Root().ShowData.DataPools[Construct_Pool].Groups:Children()
                MatrickNr = Root().ShowData.DataPools[Construct_Pool].MAtricks:Children()
                MatrickNrStart = 1
                popuplists = {
                    DataPool_Select  = {},
                    list_pool        = {},
                    -- Grp_Select       = {},
                    -- Gel_Select       = {},
                    Name_Select      = { 'LC_COLOR', 'Layout Color', 'Layout Kolor', 'L Co', 'L Ko', 'Color', 'Kolor' },
                    Name_Pool_Select = { 'LC_COLOR', 'Layout Color', 'Layout Kolor', 'L Co', 'L Ko', 'Color', 'Kolor' },
                    Lay_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Seq_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Macro_Select     = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Appear_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Preset_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Matrick_Select   = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
                    Favorite_Select  = { 10, 16, 20, 30, 32, 40, 50, 60, 64, 70, 80, 90, 100, 110, 120, 124 }
                }
                TLayNr, SeqNrStart, MacroNrStart, All_5_NrStart = nil, nil, nil, nil
                TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_5_Nr,
                All_5_NrStart, All_5_Current, MatrickNr, MatrickNrStart = LC_list_input(popuplists,
                    TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_5_Nr,
                    All_5_NrStart, All_5_Current, MatrickNr, MatrickNrStart)
                coroutine.yield(0.1)
            else
                Echo('Else')
                TLayNr = 1
                SeqNrStart = 1
                MacroNrStart = 1
                All_5_NrStart = 1
            end

            input1LineEdit.Content = "LC_COLOR"
            input2LineEdit.Content = TLayNr
            input3LineEdit.Content = SeqNrStart
            input4LineEdit.Content = MacroNrStart
            input5LineEdit.Content = AppNr
            input6LineEdit.Content = All_5_NrStart
            input7LineEdit.Content = MatrickNrStart
            input8LineEdit.Content = MaxColLgn
            input11LineEdit.Content = Favourite_Nr
            input20number.Text = Construct_Pool

            OkButton.Visible = "Yes"
            input1LineEdit.Visible = "Yes"
            input2LineEdit.Visible = "Yes"
            input3LineEdit.Visible = "Yes"
            input4LineEdit.Visible = "Yes"
            input5LineEdit.Visible = "Yes"

            input6LineEdit.Visible = "Yes"
            input7LineEdit.Visible = "Yes"
            input8LineEdit.Visible = "Yes"
            input11LineEdit.Visible = "Yes"

            input1Sujestion.Visible = "Yes"
            input21Sujestion.Visible = "Yes"
            input2Sujestion.Visible = "Yes"
            input3Sujestion.Visible = "Yes"
            input4Sujestion.Visible = "Yes"
            input5Sujestion.Visible = "Yes"

            input6Sujestion.Visible = "Yes"
            input7Sujestion.Visible = "Yes"
            -- input10Sujestion.Visible = "Yes"
            input11Sujestion.Visible = "Yes"

            input21LineEdit.Visible = "Yes"

            input9Button.Visible = "Yes"
        elseif caller.Name == "Gel_Select" then
            caller.Text = choice or caller.Text
            for k in ipairs(ColGels) do
                if ColGels[k].name == caller.Text:gsub("'", "") then
                    SelectedGelNr = k
                end
            end
            local TCol = ColPath:Children()[SelectedGelNr]
            for k in ipairs(TCol) do
                NGel = k
            end
            check_gel = true
            -- input10Button.Visible = "Yes"
            input10LineEdit.Visible = "Yes"

            -- input10Sujestion.Visible = "Yes"
            -- elseif caller.Name == "list_pool" then
            --     caller.Text = choice or caller.Text
            --     for k in ipairs(Pool_check) do
            --         if Pool_check[k].name == caller.Text:gsub("'", "") then
            --             Groups_Pool = tonumber(k)
            --             Printf("Pool selected: " .. Groups_Pool)
            --         end
            --     end
            --     -- local lo
            --     -- for k in ipairs(popuplists.Grp_Select) do
            --     --     lo = tonumber(k)
            --     -- end
            --     -- Printf("lo : " .. lo)
            --     -- for k = lo, 0, -1 do
            --     --     table.remove(popuplists.Grp_Select, k)
            --     -- end
            --     -- for k in ipairs(FixtureGroups) do
            --     --     Printf("NEW Adding Group to list: " .. FixtureGroups[k].name)
            --     --     table.insert(popuplists.Grp_Select, "'" .. FixtureGroups[k].name .. "'")
            --     -- end
            --     check_pool = true
            --     input10Button.Visible = "Yes"
            -- elseif caller.Name == "Grp_Select" then
            --     for k in ipairs(popuplists.Grp_Select) do
            --         if popuplists.Grp_Select[k] == choice then
            --             table.remove(popuplists.Grp_Select, k)
            --         end
            --     end
            --     choice = choice:gsub("'", "")
            --     for k in ipairs(FixtureGroups) do
            --         if choice == FixtureGroups[k].name then
            --             SelGrp = k
            --         end
            --     end
            --     table.insert(SelectedGrp, "'" .. FixtureGroups[SelGrp].name .. "'")
            --     table.insert(SelectedGrpNo, "'" .. FixtureGroups[SelGrp].NO .. "'")
            --     for k in ipairs(SelectedGrp) do
            --         Nr_SelectedGrp = k
            --     end
            --     subTitle.Text = subTitle.Text .. Nr_SelectedGrp .. "." .. FixtureGroups[SelGrp].name .. " "
        elseif caller.Name == "Name_Select" then
            input1LineEdit.Content = choice
        elseif caller.Name == "Lay_Select" then
            input2LineEdit.Content = choice
        elseif caller.Name == "Seq_Select" then
            input3LineEdit.Content = choice
        elseif caller.Name == "Macro_Select" then
            input4LineEdit.Content = choice
        elseif caller.Name == "Appear_Select" then
            input5LineEdit.Content = choice
        elseif caller.Name == "Preset_Select" then
            input6LineEdit.Content = choice
        elseif caller.Name == "Matrick_Select" then
            input7LineEdit.Content = choice
        elseif caller.Name == "Favorite_Select" then
            input11LineEdit.Content = choice
        elseif caller.Name == "Name_Pool_Select" then
            input21LineEdit.Content = choice
        end
    end
end
-- Run the plugin.
return Main

--end LC_Main.lua
