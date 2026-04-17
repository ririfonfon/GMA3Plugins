--[[
Releases:
* 2.3.2.0

Created by Richard Fontaine "RIRI", April 2026.
--]]

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

local function SOUND_Check_DMX(myDMXUniverse, myDMXAddress, myCount, myBreakIndex)
    Cmd('Fixture Thru')

    -- Set the DMX universe - range 1-1024.
    -- local myDMXUniverse = 1
    -- Set the DMX address in the universe - range 1-512.
    -- local myDMXAddress = 1
    -- Set the optional count for the number of fixtures (break_index channel amount) to check.
    -- local myCount = 1
    -- Set the optional break_index number for fixtures with multiple breaks.
    -- Default value is 0 to indicate the first break.
    -- local myBreakIndex = 0

    -- Creates the string used for the DMX address.
    local startOfRange = string.format("%d.%03d", myDMXUniverse, myDMXAddress)

    -- Check if there is a selection and exit if there isn't.
    if SelectionFirst() == nil then
        Printf("Please make a selection and try again.")
        Cmd('Clear')
        return
    end
    -- This gets the handle for the first fixture a patched generic Dimmers 8-bit mode.
    local myDmxMode = GetSubfixture(SelectionFirst()).ModeDirect

    if myDmxMode == nil then
        -- Exit the function if the DMX mode returns nil.
    else
        -- Do the actual collision check and provide useful feedback.
        if CheckDMXCollision(myDmxMode, startOfRange, myCount, myBreakIndex) then
            Printf("The DMX address " .. startOfRange .. " is available.")
            Cmd('Clear')
            return false
        else
            ErrEcho("The DMX address " .. startOfRange .. " cannot be used as a start address for this patch.")
            Cmd('Clear')
            return true
        end
    end
end

local function SOUND_Check_ID(myFID, myCount)
    -- Create a variable with the FID you want to check.
    -- local myFID = 2001
    -- Create a variable with the number of subsequent ID's to also check.
    -- local myCount = 10
    -- Create a variable with the IDType you want to check.
    -- Default value is 0. This is the "Fixture" type.
    -- Valid integers are:
    --- 0 = Fixture
    --- 1 = Channel
    --- 2 = Universal
    --- 3 = Houseligths (default name)
    --- 4 = NonDim (default name)
    --- 5 = Media (default name)
    --- 6 = Fog (default name)
    --- 7 = Effect (default name)
    --- 8 = Pyro (default name)
    --- 9 = MArker
    --- 10 = Multipatch
    local myType = 0

    -- Check if the count is more than one.
    if myCount > 1 then
        -- Check if there is a collision and print valid feedback.
        if CheckFIDCollision(myFID, myCount, myType) then
            Printf("The FID " .. myFID .. " to " .. (myFID + myCount) .. " is available.")
            return false
        else
            ErrEcho("The FID " .. myFID .. " to " .. (myFID + myCount) .. " gives an FID collision.")
            return true
        end
    else
        if CheckFIDCollision(myFID, nil, myType) then
            Printf("The FID " .. myFID .. " is available.")
            return false
        else
            ErrEcho("The FID " .. myFID .. " gives an FID collision.")
            return true
        end
    end
end

local function SOUND_list_input(popuplists, TLay, TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr,
                          MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current)
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
    for k in ipairs(All_4_Nr) do
        for i in ipairs(popuplists.Preset_Select) do
            if popuplists.Preset_Select[i] == All_4_Nr[k].NO then
                table.remove(popuplists.Preset_Select, i)
            end
        end
        kk = k
        All_4_NrStart = All_4_Nr[k].NO + 1
    end
    if kk == nil then
        All_4_NrStart = 1
    end
    All_4_Current = All_4_NrStart
    return TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current
end

local function SOUND_CH_Pool(popuplists)
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
    local Select = UserVars()
    local Call = false
    if GetVar(Select, "S_Fonction") then
        Sound_Retour_Recepie()
        Call = true
    end

    if Call == true then
        return
    end

    Cmd('Set UserProfile *.15 Property "keyboardshortcutsactive" false')

    local list = false
    local TLay = DataPool().Layouts:Children()
    local FixtureGroups = DataPool().Groups:Children()
    local TLayNr
    local TLayNrRef
    local NaLay = "Sound"
    local NaPool = "Sound"
    local SeqNr = DataPool().Sequences:Children()
    local SeqNrStart
    local SeqNrRange
    local MacroNr = DataPool().Macros:Children()
    local MacroNrStart
    local MacroNrRange
    local App = Root().ShowData.Appearances:Children()
    local All_4_Nr = DataPool().PresetPools[25]:Children()
    local All_4_NrStart
    local All_4_NrRange
    local All_4_Current
    local TopInc = 0
    local PoolObject = Root().ShowData.DataPools
    local Pool_check
    local old_NAPOOL
    local Univers = 210
    local Address = 1
    local Fid = 901
    local Grp_Start

    local popuplists = {
        DataPool_Select  = {},
        list_pool        = {},
        Name_Select      = { 'Sound', 'Audio', 'Sound In', 'Sound Mod' },
        Name_Pool_Select = { 'Sound', 'Audio', 'Sound In', 'Sound Mod' },
        Lay_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Seq_Select       = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Macro_Select     = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
        Preset_Select    = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 }
    }

    Pool_check = SOUND_CH_Pool(popuplists)
    local Construct_Pool = 1
    local New = false

    if list == false then
        TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr,
        MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current = SOUND_list_input(popuplists, TLay,
            TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr,
            MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current)

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
    local colorPresets = Root().ColorTheme.ColorGroups.PoolWindow.Presets
    local colorPlugins = Root().ColorTheme.ColorGroups.PoolWindow.Plugins
    local colorGroups = Root().ColorTheme.ColorGroups.PoolWindow.Groups
    local colorText = Root().ColorTheme.colorGroups.Global.Text
    local colorAlertText = Root().ColorTheme.colorGroups.Global.AlertText
    local colorDataPools = Root().ColorTheme.ColorGroups.PoolWindow.DataPools

    -- Get the overlay.
    local display = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Delete any UI elements currently displayed on the overlay.
    screenOverlay:ClearUIChildren()

    -- Create the dialog base.
    local dialogWidth = 1024
    local baseInput = screenOverlay:Append("BaseInput")
    local myicon = baseInput:Append("AppearancePreview")

    for k in ipairs(App) do
        if App[k].Name == "[[Sound_png]]" then
            myicon.Appearance = App[k]
        end
    end

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
    titleBarIcon.Text = "               Sound By RIRI"
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
    " Select DataPool \n \n Set Layout, Sequence, Macro & Preset All 4 \n \n Univers , Address & Fixture Id \n \n FixtureGroups"
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
    inputsGrid.Rows = 12
    inputsGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    inputsGrid.Margin = { left = 0, right = 0, top = 0, bottom = 5 }

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
    input20Button.Visible = "Yes"

    local input20number = inputsGrid:Append('Button')
    input20number.Anchors = { left = 8, right = 9, top = TopInc, bottom = TopInc }
    input20number.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input20number.Text = ""
    input20number.BackColor = colorDataPools
    input20number.Font = "3"
    input20number.HasHover = "No"

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
    input1Icon.HasHover = "No"
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
    input1LineEdit.Content = ""
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



    -- Create the UI elements for the 6 input.
    local input6Icon = inputsGrid:Append("Button")
    input6Icon.Text = ""
    input6Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input6Icon.Icon = "object_preset"
    input6Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input6Icon.HasHover = "No";
    input6Icon.BackColor = colorPresets

    local input6Label = inputsGrid:Append("UIObject")
    input6Label.Text = "Preset All 4 Nr"
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
    input6LineEdit.Content = All_4_NrStart
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
    input7Icon.Icon = "settings"
    input7Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input7Icon.HasHover = "No";
    input7Icon.BackColor = colorPartlySelected

    local input7Label = inputsGrid:Append("UIObject")
    input7Label.Text = "Univers"
    input7Label.TextalignmentH = "Left"
    input7Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input7Label.Padding = "5,5"
    input7Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input7Label.HasHover = "No";
    input7Label.Font = "2"
    input7Label.BackColor = colorPartlySelected

    local input7LineEdit = inputsGrid:Append("LineEdit")
    input7LineEdit.Prompt = "Nb: "
    input7LineEdit.TextAutoAdjust = "Yes"
    input7LineEdit.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    input7LineEdit.Padding = "5,5"
    input7LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input7LineEdit.Filter = "0123456789"
    input7LineEdit.VkPluginName = "TextInputNumOnly"
    input7LineEdit.Content = ""
    input7LineEdit.MaxTextLength = 6
    input7LineEdit.HideFocusFrame = "Yes"
    input7LineEdit.PluginComponent = myHandle
    input7LineEdit.TextChanged = "OnInput7TextChanged"
    input7LineEdit.Font = "2"
    input7LineEdit.BackColor = colorPartlySelected
    input7LineEdit.Visible = "No"

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
    input8Label.Text = "Address"
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
    input8LineEdit.Content = ""
    input8LineEdit.MaxTextLength = 6
    input8LineEdit.HideFocusFrame = "Yes"
    input8LineEdit.PluginComponent = myHandle
    input8LineEdit.TextChanged = "OnInput8TextChanged"
    input8LineEdit.Font = "2"
    input8LineEdit.BackColor = colorPartlySelected
    input8LineEdit.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 8 input.
    local input9Icon = inputsGrid:Append("Button")
    input9Icon.Text = ""
    input9Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input9Icon.Icon = "settings"
    input9Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input9Icon.HasHover = "No";
    input9Icon.BackColor = colorPartlySelected

    local input9Label = inputsGrid:Append("UIObject")
    input9Label.Text = "Fixture ID"
    input9Label.TextalignmentH = "Left"
    input9Label.Anchors = { left = 1, right = 3, top = TopInc, bottom = TopInc }
    input9Label.Padding = "5,5"
    input9Label.Margin = { left = 2, right = 2, top = TopInc, bottom = 2 }
    input9Label.HasHover = "No";
    input9Label.Font = "2"
    input9Label.BackColor = colorPartlySelected

    local input9LineEdit = inputsGrid:Append("LineEdit")
    input9LineEdit.Prompt = "Nb: "
    input9LineEdit.TextAutoAdjust = "Yes"
    input9LineEdit.Anchors = { left = 4, right = 9, top = TopInc, bottom = TopInc }
    input9LineEdit.Padding = "5,5"
    input9LineEdit.Margin = { left = 2, right = 0, top = TopInc, bottom = 2 }
    input9LineEdit.Filter = "0123456789"
    input9LineEdit.VkPluginName = "TextInputNumOnly"
    input9LineEdit.Content = ""
    input9LineEdit.MaxTextLength = 6
    input9LineEdit.HideFocusFrame = "Yes"
    input9LineEdit.PluginComponent = myHandle
    input9LineEdit.TextChanged = "OnInput9TextChanged"
    input9LineEdit.Font = "2"
    input9LineEdit.BackColor = colorPartlySelected
    input9LineEdit.Visible = "No"

    TopInc = TopInc + 1

    -- Create the UI elements for the 8 input.
    local input10Icon = inputsGrid:Append("Button")
    input10Icon.Text = ""
    input10Icon.Anchors = { left = 0, right = 0, top = TopInc, bottom = TopInc }
    input10Icon.Icon = "object_group2"
    input10Icon.Margin = { left = 0, right = 2, top = TopInc, bottom = 2 }
    input10Icon.HasHover = "No";
    input10Icon.BackColor = colorGroups

    local input10Label = inputsGrid:Append("UIObject")
    input10Label.Text = "Group ID"
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
    input10LineEdit.Content = ""
    input10LineEdit.MaxTextLength = 6
    input10LineEdit.HideFocusFrame = "Yes"
    input10LineEdit.PluginComponent = myHandle
    input10LineEdit.TextChanged = "OnInput10TextChanged"
    input10LineEdit.Font = "2"
    input10LineEdit.BackColor = colorGroups
    input10LineEdit.Visible = "No"

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

        Cmd('ClearAll')
        -- Cmd('Store DataPool ' .. Construct_Pool .. ' Sequence ' .. SeqNrStart .. ' /Overwrite /NoConfirmation')
        -- Cmd('Store DataPool ' .. Construct_Pool .. ' Macro ' .. MacroNrStart .. ' /Overwrite /NoConfirmation')
        Cmd('Store DataPool ' .. Construct_Pool .. ' Group ' .. Grp_Start .. ' /Overwrite /NoConfirmation')
        Cmd('Store DataPool ' .. Construct_Pool .. ' Preset 24.' .. All_4_NrStart .. ' /Overwrite /NoConfirmation')
        -- Cmd('Store DataPool ' .. Construct_Pool .. ' Layout ' .. TLayNr .. ' /Overwrite /NoConfirmation')

        SOUND_Patch(Univers, Address, Fid)
        local Seq_On_Off = SOUND_Build_Seq(Construct_Pool, SeqNrStart, All_4_NrStart, Grp_Start)
        SOUND_Build_Macro(Construct_Pool, MacroNrStart)
        SOUND_Remote_Dmx(Construct_Pool, SeqNrStart, Univers, Address)
        SOUND_Build_Layout(Construct_Pool, NaLay, TLayNr, MacroNrStart, Seq_On_Off)

        return
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
        Pool_check = SOUND_CH_Pool(popuplists)
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
        if New == false then
            for k in ipairs(TLay) do
                if TLayNr == tonumber(TLay[k].NO) then
                    OkButton.Visible = "No"
                    input2LineEdit.TextColor = colorAlertText
                    check = true
                end
            end
        end
        if check == false then
            input2LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Sequence
    signalTable.OnInput3TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input3LineEdit.TextColor = colorAlertText
            checks = true
        end
        SeqNrStart = caller.Content:gsub("'", "")
        SeqNrStart = tonumber(SeqNrStart)
        SeqNrRange = SeqNrStart
        if New == false then
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
        end
        if checks == false then
            input3LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Macro
    signalTable.OnInput4TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input4LineEdit.TextColor = colorAlertText
            checks = true
        end
        MacroNrStart = caller.Content:gsub("'", "")
        MacroNrStart = tonumber(MacroNrStart)
        MacroNrRange = MacroNrStart + 42
        -- Printf("**MacroNrStart " .. MacroNrStart)
        if New == false then
            for k in ipairs(MacroNr) do
                if MacroNrStart <= tonumber(MacroNr[k].NO) then
                    if MacroNrRange >= tonumber(MacroNr[k].NO) then
                        OkButton.Visible = "No"
                        input4LineEdit.TextColor = colorAlertText
                        checks = true
                    end
                end
            end
        end
        if checks == false then
            input4LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- All 4
    signalTable.OnInput6TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input6LineEdit.TextColor = colorAlertText
            checks = true
        end
        All_4_NrStart = caller.Content:gsub("'", "")
        All_4_NrStart = tonumber(All_4_NrStart)
        All_4_Current = All_4_NrStart
        All_4_NrRange = All_4_NrStart + 9
        if New == false then
            for k in ipairs(All_4_Nr) do
                if All_4_NrStart <= tonumber(All_4_Nr[k].NO) then
                    if All_4_NrRange >= tonumber(All_4_Nr[k].NO) then
                        OkButton.Visible = "No"
                        input6LineEdit.TextColor = colorAlertText
                        checks = true
                        for i in ipairs(popuplists.Preset_Select) do
                            if All_4_NrStart <= tonumber(popuplists.Preset_Select[i]) then
                                if All_4_NrRange >= tonumber(popuplists.Preset_Select[i]) then
                                    table.remove(popuplists.Preset_Select, i)
                                end
                            end
                        end
                    end
                end
            end
        end
        if checks == false then
            input6LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Univers
    signalTable.OnInput7TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            OkButton.Visible = "No"
            input7LineEdit.TextColor = colorAlertText
            checks = true
        end
        Univers = caller.Content:gsub("'", "")
        Univers = tonumber(Univers)

        checks = SOUND_Check_DMX(Univers, Address, 1, 0)

        if checks == true then
            OkButton.Visible = "No"
            input7LineEdit.TextColor = colorAlertText
            input8LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input7LineEdit.TextColor = colorText
            input8LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Address
    signalTable.OnInput8TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            checks = true
        end
        Address = caller.Content:gsub("'", "")
        Address = tonumber(Address)

        checks = SOUND_Check_DMX(Univers, Address, 1, 0)

        if checks == true then
            OkButton.Visible = "No"
            input7LineEdit.TextColor = colorAlertText
            input8LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input7LineEdit.TextColor = colorText
            input8LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Fid
    signalTable.OnInput9TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            checks = true
        end
        Fid = caller.Content:gsub("'", "")
        Fid = tonumber(Fid)

        checks = SOUND_Check_ID(Fid, 11)

        if checks == true then
            OkButton.Visible = "No"
            input9LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input9LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end
    -- Grp
    signalTable.OnInput10TextChanged = function(caller)
        local checks = false
        if caller.Content == "" or caller.Content == "0" then
            checks = true
        end
        Grp_Start = caller.Content:gsub("'", "")
        Grp_Start = tonumber(Grp_Start)

        for k in ipairs(FixtureGroups) do
            if FixtureGroups[k].No == Grp_Start then
                checks = true
            end
        end

        if checks == true then
            OkButton.Visible = "No"
            input10LineEdit.TextColor = colorAlertText
        end
        if checks == false then
            input10LineEdit.TextColor = colorText
            OkButton.Visible = "Yes"
        end
    end


    function signalTable.mypopup(caller)
        local itemlist = popuplists[caller.Name]
        local _, choice = PopupInput { title = caller.Name, caller = caller:GetDisplay(), items = itemlist, selectedValue = caller.Text }

        local Check_Pool = false
        if caller.Name == "DataPool_Select" then
            caller.Text = choice or caller.Text
            for k in ipairs(Pool_check) do
                if Pool_check[k].name == caller.Text:gsub("'", "") then
                    Construct_Pool = tonumber(k)
                    Check_Pool = true
                    New = false
                end
            end
            if Check_Pool == false then
                local C_Pool = PoolObject:Acquire()
                Construct_Pool = C_Pool.No
                coroutine.yield(0.1)
                PoolObject:Create(Construct_Pool)
                Pool_check = SOUND_CH_Pool(popuplists)
                New = true
                OkButton.Visible = "Yes"
                input21LineEdit.Content = "Sound"
            end
            if Check_Pool == true then
                Pool_check = SOUND_CH_Pool(popuplists)
                input21LineEdit.Content = PoolObject[Construct_Pool]:Get('Name')
                PoolObject = Root().ShowData.DataPools
                TLay = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
                SeqNr = Root().ShowData.DataPools[Construct_Pool].Sequences:Children()
                MacroNr = Root().ShowData.DataPools[Construct_Pool].Macros:Children()
                All_4_Nr = Root().ShowData.DataPools[Construct_Pool].PresetPools[24]:Children()
                FixtureGroups = Root().ShowData.DataPools[Construct_Pool].Groups:Children()
                TLayNr, SeqNrStart, MacroNrStart, All_4_NrStart = nil, nil, nil, nil
                TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr,
                MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current = SOUND_list_input(popuplists, TLay,
                    TLayNr, TLayNrRef, SeqNr, SeqNrStart, MacroNr, MacroNrStart, All_4_Nr, All_4_NrStart, All_4_Current)
            else
                TLayNr = 1
                SeqNrStart = 1
                MacroNrStart = 1
                All_4_NrStart = 1
            end

            input1LineEdit.Content = "Sound"
            input2LineEdit.Content = TLayNr
            input3LineEdit.Content = SeqNrStart
            input4LineEdit.Content = MacroNrStart
            input6LineEdit.Content = All_4_NrStart
            input7LineEdit.Content = Univers
            input8LineEdit.Content = Address
            input9LineEdit.Content = Fid
            input10LineEdit.Content = 1
            input20number.Text = Construct_Pool



            OkButton.Visible = "Yes"
            input1LineEdit.Visible = "Yes"
            input21LineEdit.Visible = "Yes"
            input2LineEdit.Visible = "Yes"
            input3LineEdit.Visible = "Yes"
            input4LineEdit.Visible = "Yes"

            input6LineEdit.Visible = "Yes"
            input7LineEdit.Visible = "Yes"
            input8LineEdit.Visible = "Yes"
            input9LineEdit.Visible = "Yes"
            input10LineEdit.Visible = "Yes"

            input1Sujestion.Visible = "Yes"
            input21Sujestion.Visible = "Yes"
            input2Sujestion.Visible = "Yes"
            input3Sujestion.Visible = "Yes"
            input4Sujestion.Visible = "Yes"

            input6Sujestion.Visible = "Yes"
        elseif caller.Name == "Name_Select" then
            input1LineEdit.Content = choice
        elseif caller.Name == "Lay_Select" then
            input2LineEdit.Content = choice
        elseif caller.Name == "Seq_Select" then
            input3LineEdit.Content = choice
        elseif caller.Name == "Macro_Select" then
            input4LineEdit.Content = choice
        elseif caller.Name == "Preset_Select" then
            input6LineEdit.Content = choice
        elseif caller.Name == "Name_Pool_Select" then
            input21LineEdit.Content = choice
        end
    end
end
-- Run the plugin.
return Main

--end LC_Main.lua
