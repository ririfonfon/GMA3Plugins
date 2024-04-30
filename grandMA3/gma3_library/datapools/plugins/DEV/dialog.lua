--[[
Releases:
* 1.1.8.0

Created by Richard Fontaine "RIRI", January 2024.
--]]

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

function CreateInputDialog(displayHandle)
  local list = false
  local FixtureGroups = Root().ShowData.DataPools.Default.Groups:Children()
  local SelectedGrp = {}
  local SelectedGrpNo = {}
  local SelGrp
  local Nr_SelectedGrp
  local check_grp = false
  local ColPath = Root().ShowData.GelPools
  local ColGels = ColPath:Children()
  local SelectedGelNr
  local NGel
  local MaxColLgn
  local check_gel = false
  local TLay = Root().ShowData.DataPools.Default.Layouts:Children()
  local TLayNr
  local Nalay
  local SeqNr = Root().ShowData.DataPools.Default.Sequences:Children()
  local SeqNrStart
  local SeqNrRange
  local MacroNr = Root().ShowData.DataPools.Default.Macros:Children()
  local MacroNrStart
  local MacroNrRange
  local App = Root().ShowData.Appearances:Children()
  local AppNr
  local AppNrRange
  local All_5_Nr = Root().ShowData.DataPools.Default.PresetPools[25]:Children()
  local All_5_NrStart
  local All_5_NrRange
  local MatrickNr = Root().ShowData.DataPools.Default.MAtricks:Children()
  local MatrickNrStart
  local MatrickNrRange

  local popuplists = {
    Grp_Select     = {},
    Gel_Select     = {},
    Name_Select    = { 'Layout Color', 'Layout Kolor', 'L Co', 'L Ko', 'Color', 'Kolor' },
    Lay_Select     = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
    Seq_Select     = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
    Macro_Select   = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
    Appear_Select  = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
    Preset_Select  = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 },
    Matrick_Select = { 1, 11, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 2001 }
  }

  if list == false then
    Echo("list")
    for k in ipairs(FixtureGroups) do
      table.insert(popuplists.Grp_Select, "'" .. FixtureGroups[k].name .. "'")
    end
    for k in ipairs(ColGels) do
      table.insert(popuplists.Gel_Select, "'" .. ColGels[k].name .. "'")
    end
    for k in ipairs(TLay) do
      for i in ipairs(popuplists.Lay_Select) do
        if popuplists.Lay_Select[i] == TLay[k].NO then
          table.remove(popuplists.Lay_Select, i)
        end
      end
      TLayNr = TLay[k].NO + 1
    end
    for k in ipairs(SeqNr) do
      for i in ipairs(popuplists.Seq_Select) do
        if popuplists.Seq_Select[i] == SeqNr[k].NO then
          table.remove(popuplists.Seq_Select, i)
        end
      end
      SeqNrStart = SeqNr[k].NO + 1
    end
    for k in ipairs(MacroNr) do
      for i in ipairs(popuplists.Macro_Select) do
        if popuplists.Macro_Select[i] == MacroNr[k].NO then
          table.remove(popuplists.Macro_Select, i)
        end
      end
      MacroNrStart = MacroNr[k].NO + 1
    end
    for k in ipairs(App) do
      for i in ipairs(popuplists.Appear_Select) do
        if popuplists.Appear_Select[i] == App[k].NO then
          table.remove(popuplists.Appear_Select, i)
        end
      end
      AppNr = App[k].NO + 1
    end
    for k in ipairs(All_5_Nr) do
      for i in ipairs(popuplists.Preset_Select) do
        if popuplists.Preset_Select[i] == All_5_Nr[k].NO then
          table.remove(popuplists.Preset_Select, i)
        end
      end
      All_5_NrStart = All_5_Nr[k].NO + 1
    end
    if All_5_NrStart == nil then
      All_5_NrStart = 1
    end
    for k in ipairs(MatrickNr) do
      for i in ipairs(popuplists.Matrick_Select) do
        if popuplists.Matrick_Select[i] == MatrickNr[k].NO then
          table.remove(popuplists.Matrick_Select, i)
        end
      end
      MatrickNrStart = MatrickNr[k].NO + 1
    end
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
  baseInput.Name = "LC_Main_Box"
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
  titleBarIcon.Text = "                       Layout Color By RIRI"
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
  --   dlgFrame[1][1].Size = "60"
  dlgFrame[1][2].SizePolicy = "Fixed"
  dlgFrame[1][2].Size = "700"
  -- dlgFrame[1][2].Size = "Stretch"
  dlgFrame[1][3].SizePolicy = "Fixed"
  dlgFrame[1][3].Size = "50"
  --   dlgFrame[1][3].Size = "80"

  -- Create the sub title.
  -- This is row 1 of the dlgFrame.
  local subTitle = dlgFrame:Append("UIObject")
  subTitle.Text =
  "Set Number begin Layout, Sequence, Macro, Appearance & Preset & Matrick\nAdd ColorGel & FixtureGroup\nSelected Group(s) are:\n"
  subTitle.TextalignmentH = "Left"
  subTitle.TextalignmentV = "Top"
  subTitle.ContentDriven = "Yes"
  subTitle.ContentWidth = "Yes"
  subTitle.TextAutoAdjust = "Yes"
  subTitle.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
  subTitle.Padding = { left = 0, right = 0, top = 5, bottom = 5 }
  subTitle.Font = "2"
  -- subTitle.Font = "Medium20"
  subTitle.HasHover = "No"
  subTitle.BackColor = colorTransparent

  -- Create the inputs grid.
  -- This is row 2 of the dlgFrame.
  local inputsGrid = dlgFrame:Append("UILayoutGrid")
  inputsGrid.Columns = 10
  inputsGrid.Rows = 10
  inputsGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
  inputsGrid.Margin = { left = 0, right = 0, top = 0, bottom = 5 }

  -- Create the UI elements for the 1 input.
  local input1Icon = inputsGrid:Append("Button")
  input1Icon.Text = ""
  input1Icon.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
  input1Icon.Margin = { left = 0, right = 2, top = 0, bottom = 2 }
  input1Icon.Icon = "object_layout"
  input1Icon.HasHover = "No";
  input1Icon.BackColor = colorLayouts

  local input1Label = inputsGrid:Append("UIObject")
  input1Label.Text = "Layout Name"
  input1Label.TextalignmentH = "Left"
  input1Label.Anchors = { left = 1, right = 3, top = 0, bottom = 0 }
  input1Label.Padding = "5,5"
  input1Label.Margin = { left = 2, right = 2, top = 0, bottom = 2 }
  input1Label.HasHover = "No"
  input1Label.BackColor = colorLayouts
  input1Label.Font = "2"

  local input1LineEdit = inputsGrid:Append("LineEdit")
  input1LineEdit.Prompt = "Name: "
  input1LineEdit.TextAutoAdjust = "Yes"
  input1LineEdit.Anchors = { left = 4, right = 7, top = 0, bottom = 0 }
  input1LineEdit.Padding = "5,5"
  input1LineEdit.Margin = { left = 2, right = 2, top = 0, bottom = 2 }
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
  input1Sujestion.Anchors = { left = 8, right = 9, top = 0, bottom = 0 }
  input1Sujestion.Margin = { left = 2, right = 0, top = 0, bottom = 2 }
  input1Sujestion.Icon = "zoom"
  input1Sujestion.Name = 'Name_Select'
  input1Sujestion.PluginComponent = thiscomponent
  input1Sujestion.Clicked = 'mypopup'
  input1Sujestion.HasHover = "yes"
  input1Sujestion.backColor = colorLayouts
  input1Sujestion.Visible = "No"

  -- Create the UI elements for the 2 input.
  local input2Icon = inputsGrid:Append("Button")
  input2Icon.Text = ""
  input2Icon.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
  input2Icon.Icon = "object_layout"
  input2Icon.Margin = { left = 0, right = 2, top = 2, bottom = 2 }
  input2Icon.HasHover = "No";
  input2Icon.BackColor = colorLayouts

  local input2Label = inputsGrid:Append("UIObject")
  input2Label.Text = "Layout Nr"
  input2Label.TextalignmentH = "Left"
  input2Label.Anchors = { left = 1, right = 3, top = 1, bottom = 1 }
  input2Label.Padding = "5,5"
  input2Label.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
  input2Label.HasHover = "No";
  input2Label.BackColor = colorLayouts
  input2Label.Font = "2"

  local input2LineEdit = inputsGrid:Append("LineEdit")
  input2LineEdit.Prompt = "Nr: "
  input2LineEdit.TextAutoAdjust = "Yes"
  input2LineEdit.Anchors = { left = 4, right = 7, top = 1, bottom = 1 }
  input2LineEdit.Padding = "5,5"
  input2LineEdit.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
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
  input2Sujestion.Anchors = { left = 8, right = 9, top = 1, bottom = 1 }
  input2Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input2Sujestion.Icon = "zoom"
  input2Sujestion.Name = 'Lay_Select'
  input2Sujestion.PluginComponent = thiscomponent
  input2Sujestion.Clicked = 'mypopup'
  input2Sujestion.HasHover = "yes"
  input2Sujestion.backColor = colorLayouts
  input2Sujestion.Visible = "No"

  -- Create the UI elements for the 3 input.
  local input3Icon = inputsGrid:Append("Button")
  input3Icon.Text = ""
  input3Icon.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }
  input3Icon.Icon = "object_sequence"
  input3Icon.Margin = { left = 0, right = 2, top = 2, bottom = 2 }
  input3Icon.HasHover = "No";
  input3Icon.BackColor = colorSequences

  local input3Label = inputsGrid:Append("UIObject")
  input3Label.Text = "Sequence Nr"
  input3Label.TextalignmentH = "Left"
  input3Label.Anchors = { left = 1, right = 3, top = 2, bottom = 2 }
  input3Label.Padding = "5,5"
  input3Label.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
  input3Label.HasHover = "No";
  input3Label.BackColor = colorPartlySelectedPreset
  input3Label.Font = "2"
  input3Label.BackColor = colorSequences

  local input3LineEdit = inputsGrid:Append("LineEdit")
  input3LineEdit.Prompt = "Nr: "
  input3LineEdit.TextAutoAdjust = "Yes"
  input3LineEdit.Anchors = { left = 4, right = 7, top = 2, bottom = 2 }
  input3LineEdit.Padding = "5,5"
  input3LineEdit.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
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
  input3Sujestion.Anchors = { left = 8, right = 9, top = 2, bottom = 2 }
  input3Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input3Sujestion.Icon = "zoom"
  input3Sujestion.Name = 'Seq_Select'
  input3Sujestion.PluginComponent = thiscomponent
  input3Sujestion.Clicked = 'mypopup'
  input3Sujestion.HasHover = "yes"
  input3Sujestion.backColor = colorSequences
  input3Sujestion.Visible = "No"

  -- Create the UI elements for the 4 input.
  local input4Icon = inputsGrid:Append("Button")
  input4Icon.Text = ""
  input4Icon.Anchors = { left = 0, right = 0, top = 3, bottom = 3 }
  input4Icon.Icon = "object_macro"
  input4Icon.Margin = { left = 0, right = 2, top = 3, bottom = 2 }
  input4Icon.HasHover = "No";
  input4Icon.BackColor = colorMacro

  local input4Label = inputsGrid:Append("UIObject")
  input4Label.Text = "Macro Nr"
  input4Label.TextalignmentH = "Left"
  input4Label.Anchors = { left = 1, right = 3, top = 3, bottom = 3 }
  input4Label.Padding = "5,5"
  input4Label.Margin = { left = 2, right = 2, top = 3, bottom = 2 }
  input4Label.HasHover = "No";
  input4Label.Font = "2"
  input4Label.BackColor = colorMacro

  local input4LineEdit = inputsGrid:Append("LineEdit")
  input4LineEdit.Prompt = "Nr: "
  input4LineEdit.TextAutoAdjust = "Yes"
  input4LineEdit.Anchors = { left = 4, right = 7, top = 3, bottom = 3 }
  input4LineEdit.Padding = "5,5"
  input4LineEdit.Margin = { left = 2, right = 0, top = 3, bottom = 2 }
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
  input4Sujestion.Anchors = { left = 8, right = 9, top = 3, bottom = 3 }
  input4Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input4Sujestion.Icon = "zoom"
  input4Sujestion.Name = 'Macro_Select'
  input4Sujestion.PluginComponent = thiscomponent
  input4Sujestion.Clicked = 'mypopup'
  input4Sujestion.HasHover = "yes"
  input4Sujestion.backColor = colorMacro
  input4Sujestion.Visible = "No"

  -- Create the UI elements for the 5 input.
  local input5Icon = inputsGrid:Append("Button")
  input5Icon.Text = ""
  input5Icon.Anchors = { left = 0, right = 0, top = 4, bottom = 4 }
  input5Icon.Icon = "object_appear."
  input5Icon.Margin = { left = 0, right = 2, top = 4, bottom = 2 }
  input5Icon.HasHover = "No";
  input5Icon.BackColor = colorAppearances

  local input5Label = inputsGrid:Append("UIObject")
  input5Label.Text = "Appear. Nr"
  input5Label.TextalignmentH = "Left"
  input5Label.Anchors = { left = 1, right = 3, top = 4, bottom = 4 }
  input5Label.Padding = "5,5"
  input5Label.Margin = { left = 2, right = 2, top = 4, bottom = 2 }
  input5Label.HasHover = "No";
  input5Label.Font = "2"
  input5Label.BackColor = colorAppearances

  local input5LineEdit = inputsGrid:Append("LineEdit")
  input5LineEdit.Prompt = "Nr: "
  input5LineEdit.TextAutoAdjust = "Yes"
  input5LineEdit.Anchors = { left = 4, right = 7, top = 4, bottom = 4 }
  input5LineEdit.Padding = "5,5"
  input5LineEdit.Margin = { left = 2, right = 0, top = 4, bottom = 2 }
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
  input5Sujestion.Anchors = { left = 8, right = 9, top = 4, bottom = 4 }
  input5Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input5Sujestion.Icon = "zoom"
  input5Sujestion.Name = 'Appear_Select'
  input5Sujestion.PluginComponent = thiscomponent
  input5Sujestion.Clicked = 'mypopup'
  input5Sujestion.HasHover = "yes"
  input5Sujestion.backColor = colorAppearances
  input5Sujestion.Visible = "No"

  -- Create the UI elements for the 6 input.
  local input6Icon = inputsGrid:Append("Button")
  input6Icon.Text = ""
  input6Icon.Anchors = { left = 0, right = 0, top = 5, bottom = 5 }
  input6Icon.Icon = "object_preset"
  input6Icon.Margin = { left = 0, right = 2, top = 5, bottom = 2 }
  input6Icon.HasHover = "No";
  input6Icon.BackColor = colorPresets

  local input6Label = inputsGrid:Append("UIObject")
  input6Label.Text = "Preset All 5 Nr"
  input6Label.TextalignmentH = "Left"
  input6Label.Anchors = { left = 1, right = 3, top = 5, bottom = 5 }
  input6Label.Padding = "5,5"
  input6Label.Margin = { left = 2, right = 2, top = 5, bottom = 2 }
  input6Label.HasHover = "No";
  input6Label.Font = "2"
  input6Label.BackColor = colorPresets

  local input6LineEdit = inputsGrid:Append("LineEdit")
  input6LineEdit.Prompt = "Nr: "
  input6LineEdit.TextAutoAdjust = "Yes"
  input6LineEdit.Anchors = { left = 4, right = 7, top = 5, bottom = 5 }
  input6LineEdit.Padding = "5,5"
  input6LineEdit.Margin = { left = 2, right = 0, top = 5, bottom = 2 }
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
  input6Sujestion.Anchors = { left = 8, right = 9, top = 5, bottom = 5 }
  input6Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input6Sujestion.Icon = "zoom"
  input6Sujestion.Name = 'Preset_Select'
  input6Sujestion.PluginComponent = thiscomponent
  input6Sujestion.Clicked = 'mypopup'
  input6Sujestion.HasHover = "yes"
  input6Sujestion.backColor = colorPresets
  input6Sujestion.Visible = "No"

  -- Create the UI elements for the 7 input.
  local input7Icon = inputsGrid:Append("Button")
  input7Icon.Text = ""
  input7Icon.Anchors = { left = 0, right = 0, top = 6, bottom = 6 }
  input7Icon.Icon = "object_matricks"
  input7Icon.Margin = { left = 0, right = 2, top = 6, bottom = 2 }
  input7Icon.HasHover = "No";
  input7Icon.BackColor = colorMatricks

  local input7Label = inputsGrid:Append("UIObject")
  input7Label.Text = "Matrick Nr"
  input7Label.TextalignmentH = "Left"
  input7Label.Anchors = { left = 1, right = 3, top = 6, bottom = 6 }
  input7Label.Padding = "5,5"
  input7Label.Margin = { left = 2, right = 2, top = 6, bottom = 2 }
  input7Label.HasHover = "No";
  input7Label.Font = "2"
  input7Label.BackColor = colorMatricks

  local input7LineEdit = inputsGrid:Append("LineEdit")
  input7LineEdit.Prompt = "Nr: "
  input7LineEdit.TextAutoAdjust = "Yes"
  input7LineEdit.Anchors = { left = 4, right = 7, top = 6, bottom = 6 }
  input7LineEdit.Padding = "5,5"
  input7LineEdit.Margin = { left = 2, right = 0, top = 6, bottom = 2 }
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
  input7Sujestion.Anchors = { left = 8, right = 9, top = 6, bottom = 6 }
  input7Sujestion.Margin = { left = 2, right = 0, top = 2, bottom = 2 }
  input7Sujestion.Icon = "zoom"
  input7Sujestion.Name = 'Matrick_Select'
  input7Sujestion.PluginComponent = thiscomponent
  input7Sujestion.Clicked = 'mypopup'
  input7Sujestion.HasHover = "yes"
  input7Sujestion.backColor = colorMatricks
  input7Sujestion.Visible = "No"

  -- Create the UI elements for the 8 input.
  local input8Icon = inputsGrid:Append("Button")
  input8Icon.Text = ""
  input8Icon.Anchors = { left = 0, right = 0, top = 7, bottom = 7 }
  input8Icon.Icon = "settings"
  input8Icon.Margin = { left = 0, right = 2, top = 7, bottom = 2 }
  input8Icon.HasHover = "No";
  input8Icon.BackColor = colorPartlySelected

  local input8Label = inputsGrid:Append("UIObject")
  input8Label.Text = "Nb color / line"
  input8Label.TextalignmentH = "Left"
  input8Label.Anchors = { left = 1, right = 3, top = 7, bottom = 7 }
  input8Label.Padding = "5,5"
  input8Label.Margin = { left = 2, right = 2, top = 7, bottom = 2 }
  input8Label.HasHover = "No";
  input8Label.Font = "2"
  input8Label.BackColor = colorPartlySelected

  local input8LineEdit = inputsGrid:Append("LineEdit")
  input8LineEdit.Prompt = "Nb: "
  input8LineEdit.TextAutoAdjust = "Yes"
  input8LineEdit.Anchors = { left = 4, right = 9, top = 7, bottom = 7 }
  input8LineEdit.Padding = "5,5"
  input8LineEdit.Margin = { left = 2, right = 0, top = 7, bottom = 2 }
  input8LineEdit.Filter = "0123456789"
  input8LineEdit.VkPluginName = "TextInputNumOnly"
  input8LineEdit.Content = "40"
  input8LineEdit.MaxTextLength = 6
  input8LineEdit.HideFocusFrame = "Yes"
  input8LineEdit.PluginComponent = myHandle
  input8LineEdit.TextChanged = "OnInput8TextChanged"
  input8LineEdit.Font = "2"
  input8LineEdit.BackColor = colorPartlySelected
  input8LineEdit.Visible = "No"

  -- Create the UI elements for the 9 input button.
  local input9Icon = inputsGrid:Append("Button")
  input9Icon.Text = ""
  input9Icon.Anchors = { left = 0, right = 0, top = 8, bottom = 8 }
  input9Icon.Icon = "object_gels"
  input9Icon.Margin = { left = 0, right = 2, top = 8, bottom = 2 }
  input9Icon.HasHover = "No";
  input9Icon.BackColor = colorPartlySelectedPreset
  input9Icon.Font = "2"

  local input9Label = inputsGrid:Append("UIObject")
  input9Label.Text = "Gel  "
  input9Label.TextalignmentH = "Left"
  input9Label.Anchors = { left = 1, right = 3, top = 8, bottom = 8 }
  input9Label.Padding = "5,5"
  input9Label.Margin = { left = 2, right = 2, top = 8, bottom = 2 }
  input9Label.HasHover = "No";
  input9Label.Font = "2"
  input9Label.BackColor = colorPartlySelectedPreset

  local input9Button = inputsGrid:Append('Button')
  input9Button.Anchors = { left = 4, right = 9, top = 8, bottom = 8 }
  input9Button.Padding = "5,5"
  input9Button.Margin = { left = 2, right = 0, top = 8, bottom = 2 }
  input9Button.Name = 'Gel_Select'
  input9Button.Text = "Please select Gel"
  -- input9Button.Text = "'Custom'"
  input9Button.PluginComponent = thiscomponent
  input9Button.Clicked = 'mypopup'
  input9Button.BackColor = colorPartlySelectedPreset
  input9Button.Font = "2"

  -- Create the UI elements for the 10 input button.
  local input10Icon = inputsGrid:Append("Button")
  input10Icon.Text = ""
  input10Icon.Anchors = { left = 0, right = 0, top = 9, bottom = 9 }
  input10Icon.Icon = "object_group2"
  input10Icon.Margin = { left = 0, right = 2, top = 9, bottom = 2 }
  input10Icon.HasHover = "No";
  input10Icon.BackColor = colorGroups
  input10Icon.Font = "2"

  local input10Button = inputsGrid:Append('Button')
  input10Button.Anchors = { left = 1, right = 9, top = 9, bottom = 9 }
  input10Button.Padding = "5,5"
  input10Button.Margin = { left = 2, right = 0, top = 9, bottom = 2 }
  input10Button.Name = 'Grp_Select'
  input10Button.Text = 'Please add Group'
  input10Button.PluginComponent = thiscomponent
  input10Button.Clicked = 'mypopup'
  input10Button.BackColor = colorGroups
  input10Button.Font = "2"
  input10Button.Visible = "No"

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
    Echo("Cancel button clicked.")
    Obj.Delete(screenOverlay, Obj.Index(baseInput))
  end

  signalTable.OkButtonClicked = function(caller)
    Echo("OK button clicked.")

    if (OkButton.BackColor == colorBackground) then
      OkButton.BackColor = colorBackgroundPlease
    else
      OkButton.BackColor = colorBackground
    end
  end

  signalTable.OnInput1TextChanged = function(caller)
    Echo("Input1 changed: '" .. caller.Content .. "'")
    Nalay = caller.Content:gsub("'", "")
  end

  signalTable.OnInput2TextChanged = function(caller)
    Echo("Input2 changed: '" .. caller.Content .. "'")
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
      if check_grp == true and check_gel == true then
        OkButton.Visible = "Yes"
      end
    end
  end

  signalTable.OnInput3TextChanged = function(caller)
    Echo("Input3 changed: '" .. caller.Content .. "'")
    local checks = false
    if caller.Content == "" or caller.Content == "0" then
      OkButton.Visible = "No"
      input3LineEdit.TextColor = colorAlertText
      checks = true
    end
    SeqNrStart = caller.Content:gsub("'", "")
    SeqNrStart = tonumber(SeqNrStart)
    SeqNrRange = SeqNrStart + tonumber((Nr_SelectedGrp * (NGel + 2)) + NGel + 100)
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

  signalTable.OnInput4TextChanged = function(caller)
    Echo("Input4 changed: '" .. caller.Content .. "'")
    local checks = false
    if caller.Content == "" or caller.Content == "0" then
      OkButton.Visible = "No"
      input4LineEdit.TextColor = colorAlertText
      checks = true
    end
    MacroNrStart = caller.Content:gsub("'", "")
    MacroNrStart = tonumber(MacroNrStart)
    MacroNrRange = MacroNrStart + 45
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
      if check_grp == true and check_gel == true then
        OkButton.Visible = "Yes"
      end
    end
  end

  signalTable.OnInput5TextChanged = function(caller)
    Echo("Input5 changed: '" .. caller.Content .. "'")
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
      if check_grp == true and check_gel == true then
        OkButton.Visible = "Yes"
      end
    end
  end

  signalTable.OnInput6TextChanged = function(caller)
    Echo("Input6 changed: '" .. caller.Content .. "'")
    local checks = false
    if caller.Content == "" or caller.Content == "0" then
      OkButton.Visible = "No"
      input6LineEdit.TextColor = colorAlertText
      checks = true
    end
    All_5_NrStart = caller.Content:gsub("'", "")
    All_5_NrStart = tonumber(All_5_NrStart)
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
      if check_grp == true and check_gel == true then
        OkButton.Visible = "Yes"
      end
    end
  end

  signalTable.OnInput7TextChanged = function(caller)
    Echo("Input7 changed: '" .. caller.Content .. "'")
    local checks = false
    if caller.Content == "" or caller.Content == "0" then
      OkButton.Visible = "No"
      input7LineEdit.TextColor = colorAlertText
      checks = true
    end
    MatrickNrStart = caller.Content:gsub("'", "")
    MatrickNrStart = tonumber(MatrickNrStart)
    MatrickNrRange = MatrickNrStart + Nr_SelectedGrp + 1
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
      if check_grp == true and check_gel == true then
        OkButton.Visible = "Yes"
      end
    end
  end

  signalTable.OnInput8TextChanged = function(caller)
    Echo("Input8 changed: '" .. caller.Content .. "'")
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

  function signalTable.mypopup(caller)
    local itemlist = popuplists[caller.Name]
    local _, choice = PopupInput { title = caller.Name, caller = caller:GetDisplay(), items = itemlist, selectedValue = caller.Text }

    if caller.Name == "Gel_Select" then
      caller.Text = choice or caller.Text
      Echo("Gelchanged: " .. caller.Text .. "'")
      for k in ipairs(ColGels) do
        if ColGels[k].name == caller.Text:gsub("'", "") then
          SelectedGelNr = k
        end
      end
      local TCol = ColPath:Children()[SelectedGelNr]
      for k in ipairs(TCol) do
        NGel = k
      end
      Echo(NGel)
      check_gel = true
      input10Button.Visible = "Yes"

    elseif caller.Name == "Grp_Select" then
      for k in ipairs(popuplists.Grp_Select) do
        Echo(popuplists.Grp_Select[k])
        if popuplists.Grp_Select[k] == choice then
          table.remove(popuplists.Grp_Select, k)
        end
      end
      choice = choice:gsub("'", "")
      Echo("Grp add : " .. choice)
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
      subTitle.Text = subTitle.Text .. Nr_SelectedGrp .. "." .. FixtureGroups[SelGrp].name .. " "
      Echo("Select Group " .. FixtureGroups[SelGrp].name)
      check_grp = true
      if check_gel == true then
        OkButton.Visible = "Yes"
        input1LineEdit.Visible = "Yes"
        input2LineEdit.Visible = "Yes"
        input3LineEdit.Visible = "Yes"
        input4LineEdit.Visible = "Yes"
        input5LineEdit.Visible = "Yes"
        input6LineEdit.Visible = "Yes"
        input7LineEdit.Visible = "Yes"
        input8LineEdit.Visible = "Yes"
        input1Sujestion.Visible = "Yes"
        input2Sujestion.Visible = "Yes"
        input3Sujestion.Visible = "Yes"
        input4Sujestion.Visible = "Yes"
        input5Sujestion.Visible = "Yes"
        input6Sujestion.Visible = "Yes"
        input7Sujestion.Visible = "Yes"
      end

    elseif caller.Name == "Name_Select" then
      input1LineEdit.Content = choice
    elseif caller.Name == "Lay_Select" then
      Echo(("lay call"))
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
    end
  end
end

-- Run the plugin.
return CreateInputDialog
