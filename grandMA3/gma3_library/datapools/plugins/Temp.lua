local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)

function CreateInputDialog(displayHandle)
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

    -- Get the overlay.
    local display = GetDisplayByIndex(displayIndex)
    local screenOverlay = display.ScreenOverlay

    -- Delete any UI elements currently displayed on the overlay.
    screenOverlay:ClearUIChildren()

    -- Create the dialog base.
    local dialogWidth = 800
    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = "LC_Main_Box"
    baseInput.H = "0"
    baseInput.W = dialogWidth
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
    baseInput.MinSize = string.format("%s,0", dialogWidth - 100)
    baseInput.Columns = 1
    baseInput.Rows = 2
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "150"
    baseInput[1][2].SizePolicy = "Stretch"
    baseInput.AutoClose = "No"
    baseInput.CloseOnEscape = "Yes"

    -- Create the title bar.
    local titleBar = baseInput:Append("TitleBar")
    titleBar.Columns = 2
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "200"
    titleBar.Texture = "corner2"

    local titleBarIcon = titleBar:Append("TitleButton")
    titleBarIcon.Text = "Layout_Color_By_RIRI"
    titleBarIcon.Texture = "corner1"
    titleBarIcon.Anchors = "0,0"
    titleBarIcon.Icon = "448"

    local titleBarCancelButton = titleBar:Append("CancelButton")
    titleBarCancelButton.Anchors = "1,0"
    titleBarCancelButton.Texture = "corner2"

    -- Create the dialog's main frame.
    local dlgFrame = baseInput:Append("DialogFrame")
    dlgFrame.H = "100%"
    dlgFrame.W = "100%"
    dlgFrame.Columns = 1
    dlgFrame.Rows = 3
    dlgFrame.Anchors = {
        left = 0,
        right = 0,
        top = 1,
        bottom = 1
    }
    dlgFrame[1][1].SizePolicy = "Fixed"
    -- dlgFrame[1][1].Size = "60"
    dlgFrame[1][1].Size = "500"
    dlgFrame[1][2].SizePolicy = "Fixed"
    dlgFrame[1][2].Size = "500"
    dlgFrame[1][3].SizePolicy = "Fixed"
    dlgFrame[1][3].Size = "500"
    -- dlgFrame[1][4].SizePolicy = "Fixed"
    -- dlgFrame[1][4].Size = "500"
    -- dlgFrame[1][5].SizePolicy = "Fixed"
    -- dlgFrame[1][5].Size = "500"
    -- dlgFrame[1][6].SizePolicy = "Fixed"
    -- dlgFrame[1][6].Size = "500"
    -- dlgFrame[1][7].SizePolicy = "Fixed"
    -- dlgFrame[1][7].Size = "500"
    -- dlgFrame[1][8].SizePolicy = "Fixed"
    -- dlgFrame[1][8].Size = "500"

    -- Create the sub title.
    -- This is row 1 of the dlgFrame.
    local subTitle = dlgFrame:Append("UIObject")
    subTitle.Text = "Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
    subTitle.ContentDriven = "Yes"
    subTitle.ContentWidth = "No"
    subTitle.TextAutoAdjust = "No"
    subTitle.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
    subTitle.Padding = {
        left = 20,
        right = 20,
        top = 15,
        bottom = 15
    }
    subTitle.Font = "Medium20"
    subTitle.HasHover = "No"
    subTitle.BackColor = colorTransparent

    -- Create the inputs grid.
    -- This is row 2 of the dlgFrame.
    local inputsGrid = dlgFrame:Append("UILayoutGrid")
    inputsGrid.Columns = 10
    inputsGrid.Rows = 3
    inputsGrid.Anchors = {
        left = 0,
        right = 0,
        top = 1,
        bottom = 1
    }
    inputsGrid.Margin = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 5
    }

    -- Create the UI elements for the first input.
    local input1Icon = inputsGrid:Append("Button")
    input1Icon.Text = ""
    input1Icon.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
    -- input1Icon.Icon = "time"
    input1Icon.Icon = "469"
    input1Icon.Margin = {
        left = 0,
        right = 2,
        top = 0,
        bottom = 2
    }
    input1Icon.HasHover = "No";

    local input1Label = inputsGrid:Append("UIObject")
    input1Label.Text = "Input 1 - Integer"
    input1Label.TextalignmentH = "Left"
    input1Label.Anchors = {
        left = 1,
        right = 5,
        top = 0,
        bottom = 0
    }
    input1Label.Padding = "5,5"
    input1Label.Margin = {
        left = 2,
        right = 2,
        top = 0,
        bottom = 2
    }
    input1Label.HasHover = "No";

    local input1LineEdit = inputsGrid:Append("LineEdit")
    input1LineEdit.Margin = {
        left = 2,
        right = 0,
        top = 0,
        bottom = 2
    }
    input1LineEdit.Prompt = "Value 1: "
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.Anchors = {
        left = 6,
        right = 9,
        top = 0,
        bottom = 0
    }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Filter = "0123456789"
    input1LineEdit.VkPluginName = "TextInputNumOnly"
    input1LineEdit.Content = ""
    input1LineEdit.MaxTextLength = 6
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"

    -- Create the UI elements for the second input.
    local input2Icon = inputsGrid:Append("Button")
    input2Icon.Text = ""
    input2Icon.Anchors = {
        left = 0,
        right = 0,
        top = 1,
        bottom = 1
    }
    input2Icon.Icon = "tools"
    input2Icon.Margin = {
        left = 0,
        right = 2,
        top = 2,
        bottom = 2
    }
    input2Icon.HasHover = "No";
    input2Icon.BackColor = colorPartlySelected

    local input2Label = inputsGrid:Append("UIObject")
    input2Label.Text = "Input 2 - Decimal"
    input2Label.TextalignmentH = "Left"
    input2Label.Anchors = {
        left = 1,
        right = 5,
        top = 1,
        bottom = 1
    }
    input2Label.Padding = "5,5"
    input2Label.Margin = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2
    }
    input2Label.HasHover = "No";
    input2Label.BackColor = colorPartlySelected

    local input2LineEdit = inputsGrid:Append("LineEdit")
    input2LineEdit.Margin = {
        left = 2,
        right = 0,
        top = 2,
        bottom = 2
    }
    input2LineEdit.Prompt = "Value 2: "
    input2LineEdit.TextAutoAdjust = "Yes"
    input2LineEdit.Anchors = {
        left = 6,
        right = 9,
        top = 1,
        bottom = 1
    }
    input2LineEdit.Padding = "5,5"
    input2LineEdit.Filter = "0123456789."
    input2LineEdit.VkPluginName = "TextInputNumOnly"
    input2LineEdit.Content = ""
    input2LineEdit.MaxTextLength = 8
    input2LineEdit.HideFocusFrame = "Yes"
    input2LineEdit.PluginComponent = myHandle
    input2LineEdit.TextChanged = "OnInput2TextChanged"

    -- Create the UI elements for the third input.
    local input3Icon = inputsGrid:Append("Button")
    input3Icon.Text = ""
    input3Icon.Anchors = {
        left = 0,
        right = 0,
        top = 2,
        bottom = 2
    }
    input3Icon.Icon = "object_sequence"
    input3Icon.Margin = {
        left = 0,
        right = 2,
        top = 2,
        bottom = 2
    }
    input3Icon.HasHover = "No";
    input3Icon.BackColor = colorMacro

    local input3Label = inputsGrid:Append("UIObject")
    input3Label.Text = "Input 3 - Text"
    input3Label.TextalignmentH = "Left"
    input3Label.Anchors = {
        left = 1,
        right = 5,
        top = 2,
        bottom = 2
    }
    input3Label.Padding = "5,5"
    input3Label.Margin = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2
    }
    input3Label.HasHover = "No";
    input3Label.BackColor = colorMacro

    local input3LineEdit = inputsGrid:Append("LineEdit")
    input3LineEdit.Margin = {
        left = 2,
        right = 0,
        top = 2,
        bottom = 2
    }
    input3LineEdit.Prompt = "Value 3: "
    input3LineEdit.TextAutoAdjust = "Yes"
    input3LineEdit.Anchors = {
        left = 6,
        right = 9,
        top = 2,
        bottom = 2
    }
    input3LineEdit.Padding = "5,5"
    input3LineEdit.VkPluginName = "TextInput"
    input3LineEdit.Content = ""
    input3LineEdit.MaxTextLength = 10
    input3LineEdit.HideFocusFrame = "Yes"
    input3LineEdit.PluginComponent = myHandle
    input3LineEdit.TextChanged = "OnInput3TextChanged"

     -- Create the UI elements for the 4 input.
     local input4Icon = inputsGrid:Append("Button")
     input4Icon.Text = ""
     input4Icon.Anchors = {
         left = 0,
         right = 0,
         top = 0,
         bottom = 0
     }
     -- input4Icon.Icon = "time"
     input4Icon.Icon = "469"
     input4Icon.Margin = {
         left = 0,
         right = 2,
         top = 0,
         bottom = 2
     }
     input4Icon.HasHover = "No";
 
     local input4Label = inputsGrid:Append("UIObject")
     input4Label.Text = "Input 4 - Integer"
     input4Label.TextalignmentH = "Left"
     input4Label.Anchors = {
         left = 1,
         right = 5,
         top = 0,
         bottom = 0
     }
     input4Label.Padding = "5,5"
     input4Label.Margin = {
         left = 2,
         right = 2,
         top = 0,
         bottom = 2
     }
     input4Label.HasHover = "No";
 
     local input4LineEdit = inputsGrid:Append("LineEdit")
     input4LineEdit.Margin = {
         left = 2,
         right = 0,
         top = 0,
         bottom = 2
     }
     input4LineEdit.Prompt = "Value 1: "
     input4LineEdit.TextAutoAdjust = "Yes"
     input4LineEdit.Anchors = {
         left = 6,
         right = 9,
         top = 0,
         bottom = 0
     }
     input4LineEdit.Padding = "5,5"
     input4LineEdit.Filter = "0123456789"
     input4LineEdit.VkPluginName = "TextInputNumOnly"
     input4LineEdit.Content = ""
     input4LineEdit.MaxTextLength = 6
     input4LineEdit.HideFocusFrame = "Yes"
     input4LineEdit.PluginComponent = myHandle
     input4LineEdit.TextChanged = "OnInput4TextChanged"

    -- Create the button grid.
    -- This is row 3 of the dlgFrame.
    local buttonGrid = dlgFrame:Append("UILayoutGrid")
    buttonGrid.Columns = 2
    buttonGrid.Rows = 1
    buttonGrid.Anchors = {
        left = 0,
        right = 0,
        top = 2,
        bottom = 2
    }

    local applyButton = buttonGrid:Append("Button");
    applyButton.Anchors = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
    applyButton.Textshadow = 1;
    applyButton.HasHover = "Yes";
    applyButton.Text = "Apply";
    applyButton.Font = "Medium20";
    applyButton.TextalignmentH = "Centre";
    applyButton.PluginComponent = myHandle
    applyButton.Clicked = "ApplyButtonClicked"

    local cancelButton = buttonGrid:Append("Button");
    cancelButton.Anchors = {
        left = 1,
        right = 1,
        top = 0,
        bottom = 0
    }
    cancelButton.Textshadow = 1;
    cancelButton.HasHover = "Yes";
    cancelButton.Text = "Cancel";
    cancelButton.Font = "Medium20";
    cancelButton.TextalignmentH = "Centre";
    cancelButton.PluginComponent = myHandle
    cancelButton.Clicked = "CancelButtonClicked"
    cancelButton.Visible = "Yes"

    -- Handlers.
    signalTable.CancelButtonClicked = function(caller)
        Echo("Cancel button clicked.")
        Obj.Delete(screenOverlay, Obj.Index(baseInput))
    end

    signalTable.ApplyButtonClicked = function(caller)
        Echo("Apply button clicked.")

        if (applyButton.BackColor == colorBackground) then
            applyButton.BackColor = colorBackgroundPlease
        else
            applyButton.BackColor = colorBackground
        end
    end

    signalTable.OnInput1TextChanged = function(caller)
        Echo("Input1 changed: '" .. caller.Content .. "'")
    input1Icon.Icon = tonumber(caller.Content)
    end

    signalTable.OnInput2TextChanged = function(caller)
        Echo("Input2 changed: '" .. caller.Content .. "'")
    end

    signalTable.OnInput3TextChanged = function(caller)
        Echo("Input3 changed: '" .. caller.Content .. "'")
    end
end

-- Run the plugin.
return CreateInputDialog
