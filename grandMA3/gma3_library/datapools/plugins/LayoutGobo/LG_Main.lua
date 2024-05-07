--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", May 2024.
--]]

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

local function Main(displayHandle)
    Echo(
        '**********************************************************************************************************************************************************************')
    Cmd('Set CurrentUserProfile Property KeyboardShortcutsActive 0')
    local list = false
    local FixtureGroups = DataPool().Groups:Children()
    local SelectedGrp = {}
    local SelectedGrpNo = {}
    local SelGrp
    local Nr_SelectedGrp
    local check_grp = false
    local TLay = DataPool().Layouts:Children()
    local TLayNr
    local TLayNrRef
    local NaLay = "Phaser_Color"
    local SeqNr = DataPool().Sequences:Children()
    local SeqNrStart
    local SeqNrRange
    local App = ShowData().Appearances:Children()
    local AppNr
    local AppNrRange
    local Preset_5_Nr = DataPool().PresetPools[25]:Children()
    local Preset_5_NrStart
    local Preset_5_NrRange
    local Preset_5_Current
    local MaxGobLgn = 16
    local Nr_Gobo = 0
    local Selected_Grp_Wheel = {}

    local TopInc = 0

    local popuplists = {
        Grp_Select    = {},
        Name_Select   = { 'Layout Gobo Select', 'LGS', 'L_GOBO', 'L_G' },
        Lay_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Seq_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Appear_Select = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Preset_Select = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 }
    }
    if list == false then
        for k in ipairs(FixtureGroups) do
            table.insert(popuplists.Grp_Select, "'" .. FixtureGroups[k].name .. "'")
        end
        for k in ipairs(TLay) do
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
        for k in ipairs(Preset_5_Nr) do
            for i in ipairs(popuplists.Preset_Select) do
                if popuplists.Preset_Select[i] == Preset_5_Nr[k].NO then
                    table.remove(popuplists.Preset_Select, i)
                end
            end
            Preset_5_NrStart = Preset_5_Nr[k].NO + 1
        end
        if Preset_5_NrStart == nil then
            Preset_5_NrStart = 1
        end
        Preset_5_Current = Preset_5_NrStart
        list = true
    end

    -- Get the index of the display on which to create the dialog.
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then
        displayIndex = 1
    end

    -- Get the colors.
    local colorTransparent = Root().ColorTheme.ColorGroups.Global.Transparent
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

    -- Get the overlay.
    local display = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Delete any UI elements currently displayed on the overlay.
    screenOverlay:ClearUIChildren()

    -- Create the dialog base.
    local dialogWidth = 800
    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = "LG_Main_Box"
    baseInput.H = "0"
    baseInput.W = dialogWidth
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
    baseInput.MinSize = string.format("%s,0", dialogWidth - 100)
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
    titleBarIcon.Text = "                       Layout Gobo By RIRI"
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
    dlgFrame[1][2].Size = "700"
    dlgFrame[1][3].SizePolicy = "Fixed"
    dlgFrame[1][3].Size = "50"

    -- Create the sub title.
    -- This is row 1 of the dlgFrame.
    local subTitle = dlgFrame:Append("UIObject")
    subTitle.Text =
    "Set Number begin Layout, Sequence, Appearance & Preset \nAdd FixtureGroup\nSelected Group(s) are:\n"
    subTitle.TextalignmentH = "Left"
    subTitle.TextalignmentV = "Top"
    subTitle.ContentDriven = "Yes"
    subTitle.ContentWidth = "Yes"
    subTitle.TextAutoAdjust = "Yes"
    subTitle.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    subTitle.Padding = { left = 0, right = 0, top = 5, bottom = 5 }
    subTitle.Font = "2"
    subTitle.HasHover = "No"
    subTitle.BackColor = colorTransparent

    -- Create the inputs grid.
    -- This is row 2 of the dlgFrame.
    local inputsGrid = dlgFrame:Append("UILayoutGrid")
    inputsGrid.Columns = 10
    inputsGrid.Rows = 7
    inputsGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    inputsGrid.Margin = { left = 0, right = 0, top = 0, bottom = 5 }

    -- Create the UI elements for the 1 input.
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
    input1LineEdit.Content = "L_Gobo"
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
    input2Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 } -- top = 2
    input2Icon.HasHover = "No";
    input2Icon.BackColor = colorLayouts

    local input2Label = inputsGrid:Append("UIObject")
    input2Label.Text = "Layout Nr"
    input2Label.TextalignmentH = "Left"
    input2Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input2Label.Padding = "5,5"
    input2Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 } -- top = 2
    input2Label.HasHover = "No";
    input2Label.BackColor = colorLayouts
    input2Label.Font = "2"

    local input2LineEdit = inputsGrid:Append("LineEdit")
    input2LineEdit.Prompt = "Nr: "
    input2LineEdit.TextAutoAdjust = "Yes"
    input2LineEdit.Anchors = { left = 4, right = 7, top = TopInc, bottom = TopInc }
    input2LineEdit.Padding = "5,5"
    input2LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 } -- top = 2
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
    input2Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 } -- top = 2
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
    input5Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 } -- top = 2
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
    input6Label.Text = "Preset 3 Nr"
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
    input6LineEdit.Content = Preset_5_NrStart
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
    input6Sujestion.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 } -- top = 2
    input6Sujestion.Icon = "zoom"
    input6Sujestion.Name = 'Preset_Select'
    input6Sujestion.PluginComponent = thiscomponent
    input6Sujestion.Clicked = 'mypopup'
    input6Sujestion.HasHover = "yes"
    input6Sujestion.backColor = colorPresets
    input6Sujestion.Visible = "No"

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
    input8Label.Text = "Nb Gobo / line"
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
    input8LineEdit.Content = MaxGobLgn
    input8LineEdit.MaxTextLength = 6
    input8LineEdit.HideFocusFrame = "Yes"
    input8LineEdit.PluginComponent = myHandle
    input8LineEdit.TextChanged = "OnInput8TextChanged"
    input8LineEdit.Font = "2"
    input8LineEdit.BackColor = colorPartlySelected
    input8LineEdit.Visible = "No"

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

    local input10Button = inputsGrid:Append('Button')
    input10Button.Anchors = { left = 1, right = 9, top = TopInc, bottom = TopInc }
    input10Button.Padding = "5,5"
    input10Button.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input10Button.Name = 'Grp_Select'
    input10Button.Text = 'Please add Group'
    input10Button.PluginComponent = thiscomponent
    input10Button.Clicked = 'mypopup'
    input10Button.BackColor = colorGroups
    input10Button.Font = "2"
    input10Button.Visible = "Yes"

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
        Construct_Gobo_Layout(displayHandle, TLay, SeqNrStart, TLayNr, AppNr,
            Preset_5_Current, Preset_5_NrStart, SelectedGrp, SelectedGrpNo, TLayNrRef, NaLay, MaxGobLgn)
    end

    signalTable.OnInput1TextChanged = function(caller)
        NaLay = caller.Content:gsub("'", "")
    end

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
            if check_grp == true then
                OkButton.Visible = "Yes"
            end
        end
    end

    signalTable.OnInput3TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input3LineEdit.TextColor = colorAlertText
            checks = true
        end
        SeqNrStart = caller.Content:gsub("'", "")
        SeqNrStart = tonumber(SeqNrStart)
        SeqNrRange = SeqNrStart + tonumber(Nr_Gobo)
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
            if check_grp == true and check_gel == true then
                OkButton.Visible = "Yes"
            end
        end
    end


    signalTable.OnInput5TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input5LineEdit.TextColor = colorAlertText
            checks = true
        end
        AppNr = caller.Content:gsub("'", "")
        AppNr = tonumber(AppNr)
        AppNrRange = AppNr + 75 + (Nr_Gobo * 2)
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
            if check_grp == true and check_gel == true then
                OkButton.Visible = "Yes"
            end
        end
    end

    signalTable.OnInput6TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input6LineEdit.TextColor = colorAlertText
            checks = true
        end
        Preset_5_NrStart = caller.Content:gsub("'", "")
        Preset_5_NrStart = tonumber(Preset_5_NrStart)
        Preset_5_Current = Preset_5_NrStart
        Preset_5_NrRange = Preset_5_NrStart + Nr_Gobo
        for k in ipairs(Preset_5_Nr) do
            if Preset_5_NrStart <= tonumber(Preset_5_Nr[k].NO) then
                if Preset_5_NrRange >= tonumber(Preset_5_Nr[k].NO) then
                    OkButton.Visible = "No"
                    input6LineEdit.TextColor = colorAlertText
                    checks = true
                    for i in ipairs(popuplists.Preset_Select) do
                        if Preset_5_NrStart <= tonumber(popuplists.Preset_Select[i]) then
                            if Preset_5_NrRange >= tonumber(popuplists.Preset_Select[i]) then
                                table.remove(popuplists.Preset_Select, i)
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input6LineEdit.TextColor = colorText
            if check_grp == true then
                OkButton.Visible = "Yes"
            end
        end
    end

    signalTable.OnInput8TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            checks = true
        end
        MaxGobLgn = caller.Content:gsub("'", "")
        MaxGobLgn = tonumber(MaxGobLgn)

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

    function signalTable.mypopup(caller)
        local itemlist = popuplists[caller.Name]
        local _, choice = PopupInput { title = caller.Name, caller = caller:GetDisplay(), items = itemlist, selectedValue = caller.Text }

        if caller.Name == "Grp_Select" then
            for k in ipairs(popuplists.Grp_Select) do
                if popuplists.Grp_Select[k] == choice then
                    table.remove(popuplists.Grp_Select, k)
                end
            end
            choice = choice:gsub("'", "")
            for k in ipairs(FixtureGroups) do
                if choice == FixtureGroups[k].name then
                    SelGrp = k
                end
            end
            table.insert(SelectedGrp, "'" .. FixtureGroups[SelGrp].name .. "'")
            table.insert(SelectedGrpNo, "'" .. FixtureGroups[SelGrp].NO .. "'")
            for k in ipairs(SelectedGrp) do
                Nr_SelectedGrp = k
            end
            Selected_Grp_Wheel[Nr_SelectedGrp] = {}
            subTitle.Text = subTitle.Text .. Nr_SelectedGrp .. "." .. FixtureGroups[SelGrp].name .. " "
            OkButton.Visible = "Yes"
            input1LineEdit.Visible = "Yes"
            input2LineEdit.Visible = "Yes"
            input3LineEdit.Visible = "Yes"
            input5LineEdit.Visible = "Yes"
            input6LineEdit.Visible = "Yes"
            input8LineEdit.Visible = "Yes"
            input1Sujestion.Visible = "Yes"
            input2Sujestion.Visible = "Yes"
            input3Sujestion.Visible = "Yes"
            input5Sujestion.Visible = "Yes"
            input6Sujestion.Visible = "Yes"
            Nr_Gobo = Check_Nr_Gobo(FixtureGroups[SelGrp].NO, Nr_Gobo)
        elseif caller.Name == "Name_Select" then
            input1LineEdit.Content = choice
        elseif caller.Name == "Lay_Select" then
            input2LineEdit.Content = choice
        elseif caller.Name == "Seq_Select" then
            input3LineEdit.Content = choice
        elseif caller.Name == "Appear_Select" then
            input5LineEdit.Content = choice
        elseif caller.Name == "Preset_Select" then
            input6LineEdit.Content = choice
        end
    end

    -- local function Dec24_To_Dec8(dec24)
    --     return math.floor(dec24 * 255 / 16777215)
    -- end

    function Check_Gobo(att, fixtureID, Nr_Gobo_)
        local _fixtureID_ = 'Fixture ' .. fixtureID
       
        CmdIndirectWait("clearall; Fixture " .. fixtureID)
        local handlefixture = ObjectList(_fixtureID_)[1]
        local mode = handlefixture.MODEDIRECT.name
        local ft = handlefixture.FIXTURETYPE.name

        CmdIndirectWait("cd root")
        CmdIndirectWait("cd FixtureType '" .. ft .. "'")
        CmdIndirectWait("cd DMXModes.'*" .. mode .. "*'.DMXChannels")

        local GoboAttNum = 1
        while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
            -- this loop is to find where attribute gobo is in the dmxchannels
            GoboAttNum = GoboAttNum + 1
        end
        if GoboAttNum == #CmdObj().Destination:Children() then
            Printf("Returning")
            return
        end
        -- this is to terminate the function if there is no gobo
        local DefaultP = Dec24_To_Dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
        CmdIndirectWait("cd '*" .. att .. "'")
        CmdIndirectWait("cd '*" .. att .. "'")
        if CmdObj().Destination:Children()[1].DMXTO ~= nil then
            local i = 1
            while DefaultP > Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXTO) or DefaultP < Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXFROM) do
                -- this is to find where is the static attributes of the gobo wheel
                i = i + 1
            end
            local MaxDmxForLoop = Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXTO)
            Cmd("cd " .. i)                                    -- changing destination to the not shaking, or revolving gobos
            i = 1
            while i <= #CmdObj().Destination:Children() do     -- iterating over the gobos
                Nr_Gobo_ = Nr_Gobo_ + 1
                i = i + 1
            end

            return Nr_Gobo_
        else
            Printf("No " .. att .. " here")
        end
    end

    function Check_Nr_Gobo(FGNr_, Nr_Gobo_)
        local FixtureID_
        CmdIndirectWait('Clearall')
        CmdIndirectWait('SelectFixtures Group ' .. FGNr_)
        local myFixtureIndex = SelectionFirst(true)
        local mySubFixture = GetSubfixture(myFixtureIndex)
        if mySubFixture ~= nil then
            FixtureID_ = mySubFixture.fid
            Printf(FixtureID_)
        end

        Cmd("clearall; fixture " .. FixtureID_)
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if fixture has gobo1
            Nr_Gobo_ = Check_Gobo("Gobo1", FixtureID_, Nr_Gobo_)
        end
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then -- check if fixture has gobo2
            Nr_Gobo_ = Check_Gobo("Gobo2", FixtureID_, Nr_Gobo_)
        end
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then -- check if fixture has gobo3
            Nr_Gobo_ = Check_Gobo("Gobo3", FixtureID_, Nr_Gobo_)
        end
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if fixture has EFFECTWHEEL
            Nr_Gobo_ = Check_Gobo("EFFECTWHEEL", FixtureID_, Nr_Gobo_)
        end
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then -- check if fixture has Prism1
            Nr_Gobo_ = Check_Gobo("Prism1", FixtureID_, Nr_Gobo_)
        end
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then -- check if fixture has Prism2
            Nr_Gobo_ = Check_Gobo("Prism2", FixtureID_, Nr_Gobo_)
        end
        Echo(Nr_Gobo_)
        return Nr_Gobo_
    end
end
-- Run the plugin.
return Main

--end LG_Main.lua
