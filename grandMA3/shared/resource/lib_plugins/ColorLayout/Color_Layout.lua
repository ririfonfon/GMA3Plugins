--[[
Releases:
* 1.1.4.2

Created by Richard Fontaine "RIRI", April 2020.
--]]

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local function Main(display_Handle)

    local root = Root();

    -- Store all Groups in a Table
    local FixtureGroups = root.ShowData.DataPools.Default.Groups:Children()

    -- Store all ColorGel in a Table
    local ColPath = root.ShowData.GelPools
    local ColGels = ColPath:Children()

    -- Store all Used CustomImage in a Table to find the last free number, and define the Symbols
    local Img = root.ShowData.MediaPools.Symbols:Children()
    local ImgNr

    for k in pairs(Img) do
        ImgNr = Maf(Img[k].NO)
    end

    if ImgNr == nil then
        ImgNr = 0
    end

    local ImgImp = {
        {Name =     "\"on\"",               FileName = "\"on.png\"",            Filepath = "", }, 
        {Name =     "\"off\"",              FileName = "\"off.png\"",           Filepath = "", }, 
        {Name =     "\"exec_time_on\"",     FileName = "\"exec_time_on.png\"",  Filepath = "", }, 
        {Name =     "\"exec_time_off\"",    FileName = "\"exec_time_off.png\"", Filepath = "", }, 
        {Name =     "\"calcul_on\"",        FileName = "\"calcul_on.png\"",     Filepath = "", }, 
        {Name =     "\"calcul_off\"",       FileName = "\"calcul_off.png\"",    Filepath = "", }
    }    
    
    -- Store all Used Appearances in a Table to find the last free number
    local App = root.ShowData.Appearances:Children()
    local AppNr
    
    for k in pairs(App) do
        AppNr = Maf(App[k].NO)
    end
    AppNr = AppNr + 1
    
    local NrAppear
    local NrNeed
    local AppCrea = 0
    local StAppNameOn
    local StAppNameOff
    local StAppOn =         '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff =        '\"Showdata.MediaPools.Symbols.off\"'
    local StAppExecOn =     '\"Showdata.MediaPools.Symbols.exec_time_on\"'
    local StAppExecOff =    '\"Showdata.MediaPools.Symbols.exec_time_off\"'
    local StAppCalculOn =   '\"Showdata.MediaPools.Symbols.calcul_on\"'
    local StAppCalculOff =  '\"Showdata.MediaPools.Symbols.calcul_off\"'
    local StApp0On =        '\"Showdata.MediaPools.Symbols.[number_0_black_png]\"'
    local StApp0Off =       '\"Showdata.MediaPools.Symbols.[number_0_white_png]\"'
    local StApp1On =        '\"Showdata.MediaPools.Symbols.[number_1_black_png]\"'
    local StApp1Off =       '\"Showdata.MediaPools.Symbols.[number_1_white_png]\"'
    local StApp2On =        '\"Showdata.MediaPools.Symbols.[number_2_black_png]\"'
    local StApp2Off =       '\"Showdata.MediaPools.Symbols.[number_2_white_png]\"'
    local StApp3On =        '\"Showdata.MediaPools.Symbols.[number_3_black_png]\"'
    local StApp3Off =       '\"Showdata.MediaPools.Symbols.[number_3_white_png]\"'
    local StApp4On =        '\"Showdata.MediaPools.Symbols.[number_4_black_png]\"'
    local StApp4Off =       '\"Showdata.MediaPools.Symbols.[number_4_white_png]\"'
    local StApp6On =        '\"Showdata.MediaPools.Symbols.[number_6_black_png]\"'
    local StApp6Off =       '\"Showdata.MediaPools.Symbols.[number_6_white_png]\"'
    local StAppSkullOn =    '\"Showdata.MediaPools.Symbols.[skull_black_png]\"'
    local StAppSkullOff =   '\"Showdata.MediaPools.Symbols.[skull_white_png]\"'
    local StAppTricksOn =   '\"Showdata.MediaPools.Symbols.[arrow_right_black_png]\"'
    local StAppTricksOff =  '\"Showdata.MediaPools.Symbols.[home_white_png]\"'
    local StAppMacroTricks ='\"Showdata.MediaPools.Symbols.[gear_white_png]\"'
    local FadeRef =         ' color=\'0,0.8,0,1\''
    local DelayRef =        ' color=\'0.8,0.8,0,1\'' 
    local DelayToRef =      ' color=\'0.8,0.3,0,1\''
    local XgrpRef =         ' color=\'0,0.8,0.8,1\''
    local XblockRef =       ' color=\'0.8,0,0.8,1\''
    local XwingsRef =       ' color=\'0.8,0,0.3,1\''
    local PhaseRef =        ' color=\'0.3,0,0.8,1\''
    local SkullRef =        ' color=\'0.6,0,0,1\''
    local NoRef =            ' color=\'1,1,1,1\''
    local NrAppTricks = 1
    
    local AppTricks = {
        {Name ='\'tricks_on\'',             StApp = StAppTricksOn,      Nr ='', RGBref = NoRef},
        {Name ='\'tricks_off\'',            StApp = StAppTricksOff,     Nr ='', RGBref = NoRef},
        {Name ='\'macrotricks_off\'',       StApp = StAppMacroTricks,   Nr ='', RGBref = NoRef}
    }  

    local AppImp = {
        {Name ='\'exectime_on\'',           StApp = StAppExecOn,        Nr ='', RGBref = FadeRef},
        {Name ='\'exectime_off\'',          StApp = StAppExecOff,       Nr ='', RGBref = FadeRef},
        {Name ='\'fade0_on\'',              StApp = StApp0On,           Nr ='', RGBref = FadeRef},
        {Name ='\'fade0_off\'',             StApp = StApp0Off,          Nr ='', RGBref = FadeRef},
        {Name ='\'fade1_on\'',              StApp = StApp1On,           Nr ='', RGBref = FadeRef},
        {Name ='\'fade1_off\'',             StApp = StApp1Off,          Nr ='', RGBref = FadeRef},
        {Name ='\'fade2_on\'',              StApp = StApp2On,           Nr ='', RGBref = FadeRef},
        {Name ='\'fade2_off\'',             StApp = StApp2Off,          Nr ='', RGBref = FadeRef},
        {Name ='\'fade4_on\'',              StApp = StApp4On,           Nr ='', RGBref = FadeRef},
        {Name ='\'fade4_off\'',             StApp = StApp4Off,          Nr ='', RGBref = FadeRef},
        {Name ='\'input_fade_on\'',         StApp = StAppCalculOn,      Nr ='', RGBref = FadeRef},
        {Name ='\'input_fade_off\'',        StApp = StAppCalculOff,     Nr ='', RGBref = FadeRef},
        {Name ='\'delay0_on\'',             StApp = StApp0On,           Nr ='', RGBref = DelayRef},
        {Name ='\'delay0_off\'',            StApp = StApp0Off,          Nr ='', RGBref = DelayRef},
        {Name ='\'delay1_on\'',             StApp = StApp1On,           Nr ='', RGBref = DelayRef},
        {Name ='\'delay1_off\'',            StApp = StApp1Off,          Nr ='', RGBref = DelayRef},
        {Name ='\'delay2_on\'',             StApp = StApp2On,           Nr ='', RGBref = DelayRef},
        {Name ='\'delay2_off\'',            StApp = StApp2Off,          Nr ='', RGBref = DelayRef},
        {Name ='\'delay4_on\'',             StApp = StApp4On,           Nr ='', RGBref = DelayRef},
        {Name ='\'delay4_off\'',            StApp = StApp4Off,          Nr ='', RGBref = DelayRef},
        {Name ='\'input_delay_on\'',        StApp = StAppCalculOn,      Nr ='', RGBref = DelayRef},
        {Name ='\'input_delay_off\'',       StApp = StAppCalculOff,     Nr ='', RGBref = DelayRef},
        {Name ='\'delayto0_on\'',           StApp = StApp0On,           Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto0_off\'',          StApp = StApp0Off,          Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto1_on\'',           StApp = StApp1On,           Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto1_off\'',          StApp = StApp1Off,          Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto2_on\'',           StApp = StApp2On,           Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto2_off\'',          StApp = StApp2Off,          Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto4_on\'',           StApp = StApp4On,           Nr ='', RGBref = DelayToRef},
        {Name ='\'delayto4_off\'',          StApp = StApp4Off,          Nr ='', RGBref = DelayToRef},
        {Name ='\'input_delayto_on\'',      StApp = StAppCalculOn,      Nr ='', RGBref = DelayToRef},
        {Name ='\'input_delayto_off\'',     StApp = StAppCalculOff,     Nr ='', RGBref = DelayToRef},
        {Name ='\'xgroup0_on\'',            StApp = StApp0On,           Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup0_off\'',           StApp = StApp0Off,          Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup2_on\'',            StApp = StApp2On,           Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup2_off\'',           StApp = StApp2Off,          Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup3_on\'',            StApp = StApp3On,           Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup3_off\'',           StApp = StApp3Off,          Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup4_on\'',            StApp = StApp4On,           Nr ='', RGBref = XgrpRef},
        {Name ='\'xgroup4_off\'',           StApp = StApp4Off,          Nr ='', RGBref = XgrpRef},
        {Name ='\'input_xgroup_on\'',       StApp = StAppCalculOn,      Nr ='', RGBref = XgrpRef},
        {Name ='\'input_xgroup_off\'',      StApp = StAppCalculOff,     Nr ='', RGBref = XgrpRef},
        {Name ='\'xblock0_on\'',            StApp = StApp0On,           Nr ='', RGBref = XblockRef},
        {Name ='\'xblock0_off\'',           StApp = StApp0Off,          Nr ='', RGBref = XblockRef},
        {Name ='\'xblock2_on\'',            StApp = StApp2On,           Nr ='', RGBref = XblockRef},
        {Name ='\'xblock2_off\'',           StApp = StApp2Off,          Nr ='', RGBref = XblockRef},
        {Name ='\'xblock3_on\'',            StApp = StApp3On,           Nr ='', RGBref = XblockRef},
        {Name ='\'xblock3_off\'',           StApp = StApp3Off,          Nr ='', RGBref = XblockRef},
        {Name ='\'xblock4_on\'',            StApp = StApp4On,           Nr ='', RGBref = XblockRef},
        {Name ='\'xblock4_off\'',           StApp = StApp4Off,          Nr ='', RGBref = XblockRef},
        {Name ='\'input_xblock_on\'',       StApp = StAppCalculOn,      Nr ='', RGBref = XblockRef},
        {Name ='\'input_xblock_off\'',      StApp = StAppCalculOff,     Nr ='', RGBref = XblockRef},
        {Name ='\'xwings0_on\'',            StApp = StApp0On,           Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings0_off\'',           StApp = StApp0Off,          Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings2_on\'',            StApp = StApp2On,           Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings2_off\'',           StApp = StApp2Off,          Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings3_on\'',            StApp = StApp3On,           Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings3_off\'',           StApp = StApp3Off,          Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings4_on\'',            StApp = StApp4On,           Nr ='', RGBref = XwingsRef},
        {Name ='\'xwings4_off\'',           StApp = StApp4Off,          Nr ='', RGBref = XwingsRef},
        {Name ='\'input_xwings_on\'',       StApp = StAppCalculOn,      Nr ='', RGBref = XwingsRef},
        {Name ='\'input_xwings_off\'',      StApp = StAppCalculOff,     Nr ='', RGBref = XwingsRef},
        {Name ='\'input_phase_on\'',        StApp = StAppCalculOn,      Nr ='', RGBref = PhaseRef},
        {Name ='\'input_phase_off\'',       StApp = StAppCalculOff,     Nr ='', RGBref = PhaseRef},
        {Name ='\'skull_on\'',              StApp = StAppSkullOn,       Nr ='', RGBref = SkullRef},
        {Name ='\'skull_off\'',             StApp = StAppSkullOff,      Nr ='', RGBref = SkullRef}
    }   
    
    local Argument_Fade = {
        {name = 'ExecTime',    UseExTime = 1,     Time = 0},
        {name = 'Time 0',      UseExTime = 0,     Time = 0},
        {name = 'Time 1',      UseExTime = 0,     Time = 1},
        {name = 'Time 2',      UseExTime = 0,     Time = 2},
        {name = 'Time 4',      UseExTime = 0,     Time = 4},
        {name = 'Time Input',  UseExTime = 0,     Time = 0}
    }

    local Argument_Delay = {
        {name = 'Delay From 0',     Time = 0},
        {name = 'Delay From 1',     Time = 1},
        {name = 'Delay From 2',     Time = 2},
        {name = 'Delay From 4',     Time = 4},
        {name = 'Delay From Input', Time = 0},
    }

    local Argument_DelayTo = {
        {name = 'Delay To 0',     Time = 0},
        {name = 'Delay To 1',     Time = 1},
        {name = 'Delay To 2',     Time = 2},
        {name = 'Delay To 4',     Time = 4},
        {name = 'Delay To Input', Time = 0},
    }

    local Argument_Xgrp = {
        {name = 'XGroup To 0',     Time = 0},
        {name = 'XGroup To 2',     Time = 2},
        {name = 'XGroup To 3',     Time = 3},
        {name = 'XGroup To 4',     Time = 4},
        {name = 'XGroup To Input', Time = 0},
    }

    local Argument_Xblock = {
        {name = 'XBlock To 0',     Time = 0},
        {name = 'XBlock To 2',     Time = 2},
        {name = 'XBlock To 3',     Time = 3},
        {name = 'XBlock To 4',     Time = 4},
        {name = 'XBlock To Input', Time = 0},
    }

    local Argument_Xwings = {
        {name = 'XWings To 0',     Time = 0},
        {name = 'XWings To 2',     Time = 2},
        {name = 'XWings To 3',     Time = 3},
        {name = 'XWings To 4',     Time = 4},
        {name = 'XWings To Input', Time = 0},
    }

    
    local appcheck = {}
    for k in pairs(AppImp) do
        appcheck[k] = setmetatable({value = ''}, {ref = ''})
    end
    
    -- Store all Use Layout in a Table to find the last free number
    local TLay = root.ShowData.DataPools.Default.Layouts:Children()
    local TLayNr
    local TLayNrRef
    
    for k in pairs(TLay) do
        TLayNr = Maf(tonumber(TLay[k].NO))
        TLayNrRef = k
    end
    
    -- Store all Used Sequence in a Table to find the last free number
    local SeqNr = root.ShowData.DataPools.Default.Sequences:Children()
    local SeqNrStart
    local SeqNrEnd
    local prefix_index = 1
    local old_prefix_index
    local prefix = 'LC'..tostring(prefix_index)..'_'
    local exit = false

    repeat
        old_prefix_index = prefix_index
        for k in pairs(SeqNr) do
            if string.match(SeqNr[k].name,prefix) then
                E("LC found %s", tostring(SeqNr[k].name))
                prefix_index = prefix_index + 1  
            end
            SeqNrStart = Maf(SeqNr[k].NO)
        end
        prefix = 'LC'..tostring(prefix_index)..'_'
        if old_prefix_index == prefix_index then
            exit = true
        end

    until exit == true
    
    if SeqNrStart == nil then
        SeqNrStart = 0
    end

    -- Store all Used Macro in a Table to find the last free number
    local Macro_Pool = root.ShowData.DataPools.Default.Macros
    local MacroNr = root.ShowData.DataPools.Default.Macros:Children()
    local MacroNrStart

    for k in pairs(MacroNr) do
        MacroNrStart = Maf(MacroNr[k].NO)
    end

    if MacroNrStart == nil then
        MacroNrStart = 0
    end

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do
        TIconNr = Maf(TIcon[k].NO)
    end

    -- Store all Used MAtricks in a Table to find the last free number
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
    local MatrickNrStart
    for k in pairs(MatrickNr) do
        MatrickNrStart = Maf(MatrickNr[k].NO)
    end
    if MatrickNrStart == nil then
        MatrickNrStart = 0
    end

    MatrickNrStart = Maf(MatrickNrStart + 1)
    local MatrickNr = MatrickNrStart
    
    -- variables
    local LayX
    local RefX = Maf(0 - TLay[TLayNrRef].DimensionW / 2)
    local LayY = TLay[TLayNrRef].DimensionH / 2
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local TCol
    local StColName
    local StringColName
    local StColCode
    local ColNr = 0
    local SelGrp
    local TGrpChoise
    local ChoGel = {}
    local SelColGel
    local SelectedGrp = {}
    local SelectedGrpName = {}
    local SelectedGrpNo = {}
    local GrpNo
    local SelectedGelNr
    local col_count
    local Message ="Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local MacroNrText = "Macro_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 12
    local count = 0
    local check = {}
    local NaLay = "Colors"
    local PopTableGrp = {}
    local PopTableGel = {}
    local FirstSeqTime
    local LastSeqTime
    local FirstSeqTimeFrom
    local LastSeqTimeFrom
    local FirstSeqTimeTo
    local LastSeqTimeTo
    local FirstSeqDelay
    local LastSeqDelay 
    local FirstSeqDelayFrom
    local LastSeqDelayFrom
    local FirstSeqDelayTo
    local LastSeqDelayTo
    local FirstSeqXgrp
    local LastSeqXgrp
    local FirstSeqXblock
    local LastSeqXblock
    local FirstSeqXwings
    local LastSeqXwings
    local FirstSeqColor
    local LastSeqColor
    local CurrentSeqNr
    local CurrentMacroNr
    local UsedW
    local UsedH
    local MaxColLgn = 40
    local long_imgimp
    local add_check = 0

    local condition_string
    
    
    TLayNr = Maf(TLayNr + 1)
    SeqNrStart = SeqNrStart + 1
    MacroNrStart = MacroNrStart + 1

    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end

    local Swipe_Color = {
        {name ="____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____", selectedValue=11, 
            values={
                ["'" .. ColGels[1].name .. "'"]=1,["'" .. ColGels[2].name .. "'"]=2,["'" .. ColGels[3].name .. "'"]=3,["'" .. ColGels[4].name .. "'"]=4,["'" .. ColGels[5].name .. "'"]=5,
                ["'" .. ColGels[6].name .. "'"]=6,["'" .. ColGels[7].name .. "'"]=7,["'" .. ColGels[8].name .. "'"]=8,["'" .. ColGels[9].name .. "'"]=9,["'" .. ColGels[10].name .. "'"]=10,
                ["'" .. ColGels[11].name .. "'"]=11
            },type=0
        }
    }

    -- Main Box
    ::MainBox::
    local box = MessageBox({
        title = 'Color_Layout_By_RIRI',
        display = display_Handle,
        backColor = "1.7",
        message = Message,
        commands = {{
            name = 'Add Group',
            value = 11
        }, {
            name = OkBtn,
            value = ValOkBtn
        }, {
            name = 'Cancel',
            value = 0
        }},
        inputs = {{
            name = 'Layout_Nr',
            value = TLayNr,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Layout_Name',
            value = NaLay,
            maxTextLength = 16,
            vkPlugin = "TextInput"
        }, {
            name = 'Sequence_Start_Nr',
            blackFilter = "*",
            value = SeqNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Macro_Start_Nr',
            blackFilter = "*",
            value = MacroNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Appearance_Start_Nr',
            blackFilter = "*",
            value = AppNr,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Max_Color_By_Line',
            value = MaxColLgn,
            maxTextLength = 2,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Matrick_Start_Nr',
            value = MatrickNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }},
        selectors = Swipe_Color

    })

    if (box.result == 11 or box.result == 100 or box.result == 10) then

        if (count == 0 or ValOkBtn == 100) then
            ValOkBtn = Maf(ValOkBtn / 10)
            if (ValOkBtn < 10) then
                ValOkBtn = 1
            end
        end

        if (ValOkBtn == 1) then
            OkBtn = "OK Let's GO :)"

        end

        for k in pairs(FixtureGroups) do
            count = count + 1
        end

        if (count == 0) then
            E("all Groups are added")
            Co("all Groups are added")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors.____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto MainBox
        else
            E("add Group")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors.____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto addGroup
        end

    elseif (box.result == 1) then
       
        if next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors.____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto addGroup
        else
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors.____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            E("now i do some Magic stuff...")
            goto doMagicStuff
        end

    elseif (box.result == 0) then
        E("User Canceled")
        goto canceled
    end

    -- End Main Box  

    -- Choise Fixture Group  
    -- Create a Choise for each Group in Table
    ::addGroup::

    TGrpChoise = {}
    for k in ipairs(FixtureGroups) do
        table.insert(TGrpChoise, "'" .. FixtureGroups[k].name .. "'")
        E(FixtureGroups[k].name)
    end

    -- Setup the Messagebox
    PopTableGrp = {
        title = "Fixture Group",
        caller = display_Handle,
        items = TGrpChoise,
        selectedValue = "",
        add_args = {
            FilterSupport = "Yes"
        }
    }
    SelGrp = PopupInput(PopTableGrp)

    table.insert(SelectedGrp, "'" .. FixtureGroups[SelGrp + 1].name .. "'")
    table.insert(SelectedGrpNo, "'" .. FixtureGroups[SelGrp + 1].NO .. "'")
    E("A")
    Message = Message .. FixtureGroups[SelGrp + 1].name .. "\n"
    E("Select Group " .. FixtureGroups[SelGrp + 1].name)
    table.remove(FixtureGroups, SelGrp + 1)
    goto MainBox
    -- End Choise Fixture Group	        
    
    -- Choise ColorGel  
    -- Create a Choise for each Group in Table

    -- Magic Stuff
    ::doMagicStuff::

    --fix name SelectedGrp 
    for g in pairs(SelectedGrp) do
    SelectedGrpName[g] = SelectedGrp[g]:gsub(' ','_')
    end

    --fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart

    --check Symbols
    for k in pairs(Img) do
        for q in pairs(ImgImp) do
            if ('"' .. Img[k].name .. '"' == ImgImp[q].Name) then
                check[q] =  1
                add_check = Maf(add_check + 1)
            end
            long_imgimp = q
        end
    end
    
    if (long_imgimp == add_check) then    
        E("file exist")
    else
        E("file NOT exist")
        -- Select a disk
        local drives = Root().Temp.DriveCollect
        local selectedDrive -- users selected drive
        local options = {} -- popup options
        local PopTableDisk = {} -- 
        -- grab a list of connected drives
        for i = 1, drives.count, 1 do
            table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
        end
        -- present a popup for the user choose (Internal may not work)
        PopTableDisk = {
            title = "Select a disk to import on & off symbols",
            caller = display_Handle,
            items = options,
            selectedValue = "",
            add_args = {
                FilterSupport = "Yes"
            }
        }
        selectedDrive = PopupInput(PopTableDisk)
        selectedDrive = selectedDrive + 1

        -- if the user cancled then exit the plugin
        if selectedDrive == nil then
            return
        end
            
        -- grab the export path for the selected drive and append the file name
        E("selectedDrive = %s", tostring(selectedDrive))
        Cmd("select Drive " .. selectedDrive .. "")
            
        -- Import Symbols      
        for k in pairs(ImgImp) do
            
            if(check[k] == nil) then
                ImgNr = Maf(ImgNr + 1);
                E(ImgNr)
                E(k)
                Cmd("Store Image 2." .. ImgNr .. " " .. ImgImp[k].Name .. " Filename=" .. ImgImp[k].FileName .. " filepath=" .. ImgImp[k].Filepath .. "")
            end
        end
    end
    -- End check Images  


        
    -- Create MAtricks
    Cmd('Store MAtricks ' .. MatrickNrStart .. ' /nu')
    Cmd('Set Matricks ' .. MatrickNrStart .. ' name = ' .. prefix .. NaLay .. ' /nu')
    MatrickNr = Maf(MatrickNrStart + 1) 

    for g in pairs(SelectedGrp) do
     Cmd('Store MAtricks ' .. MatrickNr .. ' /nu')
     Cmd('Set Matricks ' .. MatrickNr .. ' name = ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') .. ' /nu')
     MatrickNr = Maf(MatrickNr + 1)
    end

    -- Create Appearances/Sequences
        
    -- Create new Layout View
    Cmd("Store Layout "  .. TLayNr .. " \"" .. prefix .. NaLay .. "")
    -- end
        
    SelectedGelNr = tonumber(SelectedGelNr)
    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    E('Create Appear. Tricks Ref')
    for q in pairs(AppTricks) do
        AppTricks[q].Nr = Maf(AppNr)
        Cmd( 'Store App ' .. AppTricks[q].Nr .. ' "' .. prefix .. AppTricks[q].Name .. '" "Appearance"=' .. AppTricks[q].StApp .. '' .. AppTricks[q].RGBref ..'')
        AppNr = Maf(AppNr + 1)
    end
        
    for g in ipairs(SelectedGrp) do
            
        LayX = RefX
        col_count = 0
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!
        
        if (AppCrea == 0) then
            AppNr = Maf(AppNr);
            Cmd('Store App ' .. AppNr .. ' \'' .. prefix ..' Label\' Appearance=' .. StAppOn .. ' color=\'0,0,0,1\'')
        end 
        
        NrAppear = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)
        
        Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
        Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " Action=0 Appearance=" .. AppNr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilitySelectionRelevance=1")
        
        LayNr = Maf(LayNr + 1)
        LayX = Maf(LayX + LayW + 20)

        FirstSeqColor = CurrentSeqNr
        for col in ipairs(TCol) do
            col_count = col_count + 1
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            StColName = TCol[col].name
            StringColName = string.gsub( StColName," ","_" )
            ColNr = SelectedGelNr .. "." .. TCol[col].no
            
            -- Create Appearances only 1 times
            if (AppCrea == 0) then
                StAppNameOn = "\"" .. prefix .. StringColName .. " on\""
                StAppNameOff = "\"" .. prefix .. StringColName .. " off\""
                Cmd("Store App " .. NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
                NrAppear = Maf(NrAppear + 1);
                Cmd("Store App " .. NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
                NrAppear = Maf(NrAppear + 1);
            end
            -- end Appearances
            
            -- Create Sequences
            GrpNo = SelectedGrpNo[g]
            GrpNo = string.gsub( GrpNo,"'","" )
         Cmd("ClearAll /nu")
         Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .. "")
         Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. prefix .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
         Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
         Cmd("Assign Group " .. GrpNo .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
         Cmd('Assign MAtricks ' .. MatrickNrStart .. ' At Sequence ' .. CurrentSeqNr .. ' Cue 1 Part 0.1 /nu')
         -- Add Cmd to Squence
         Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed .. "\"")
         Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
         Command_Ext_Suite(CurrentSeqNr)
         -- end Sequences
         
         -- Add Squences to Layout
         Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
         Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
         
         NrNeed = Maf(NrNeed + 2); -- Set App Nr to next color

         if (col_count ~= MaxColLgn) then
             LayX = Maf(LayX + LayW + 20)
         else
             LayX = RefX
             LayX = Maf(LayX + LayW + 20)
             LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
             LayY = Maf(LayY - LayH)
             col_count = 0
         end

         LayNr = Maf(LayNr + 1)
         LastSeqColor = CurrentSeqNr
         CurrentSeqNr = Maf(CurrentSeqNr + 1)
        end
        -- end COLOR SEQ
    
     -- add matrick group
     Cmd('ClearAll /nu')
     Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', '') )
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', '') .. '\' Property Command=\'Assign MaTricks ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') .. ' At Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor .. ' cue 1 part 0.1 ;  Assign Sequence ' .. CurrentSeqNr + 1 .. ' At Layout ' .. TLayNr .. '.' .. LayNr )
     Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[2].Nr )
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     Cmd('ClearAll /nu')
     Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') .. '\'')
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') .. '\' Property Command=\'Assign MaTricks ' .. MatrickNrStart ..  ' At Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor .. ' cue 1 part 0.1 ; Assign Sequence ' .. CurrentSeqNr - 1 .. ' At Layout ' .. TLayNr .. '.' .. LayNr )
     Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[1].Nr )  
     LayNr = Maf(LayNr + 1)
     LayX = Maf(LayX + LayW + 20)
     Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g]:gsub('\'', '') )
     Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
     Cmd('Insert')
     Cmd('set 1 Command=\'Edit Matrick ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') )
     Cmd('ChangeDestination Root')
     Cmd('Assign Macro ' .. CurrentMacroNr .. " at layout " .. TLayNr)
     Cmd('set Macro ' .. CurrentMacroNr .. ' Property Appearance='.. AppTricks[3].Nr )
     Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname= 0 VisibilityBar=0 VisibilityIndicatorBar=0')
     
     CurrentMacroNr = Maf(CurrentMacroNr + 1)        
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     FirstSeqColor = CurrentSeqNr   
     AppCrea = 1
     LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
    end
    -- end Appearances/Sequences 

    -- check Appear. time .... TODO trouver procedure 
    -- E("check Appear.")
    -- add_check = 0
    -- for k in pairs(App) do
    --     for q in pairs(AppImp) do
    --         if ('"' .. App[k].name .. '"' == AppImp[q].Name) then 
    --             add_check = Maf(add_check + 1)
    --             appcheck[q].value = 1   
    --             appcheck[q].ref = k     
    --             -- table.insert(appcheck.value, q, 1)
    --             -- table.insert(appcheck.ref, q, k)
    --             E(appcheck[q].value)
    --             E(appcheck[q].ref)         
    --         end
    --         long_imgimp = q
    --     end
    -- end"clearall /nu"
    
    -- if (long_imgimp == add_check) then
        --     E("Appear. exist")
        -- else
            --     E("Appear. NOT exist")
    E('Create Appear. Time Ref')
    for q in pairs(AppImp) do
        AppImp[q].Nr = Maf(NrNeed)
        Cmd( 'Store App ' .. AppImp[q].Nr .. ' "' .. prefix .. AppImp[q].Name .. '" "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref ..'')
        NrNeed = Maf(NrNeed + 1)
    end
    
    SeqNrEnd = CurrentSeqNr - 1
    
    

    
    
    -- Add offset for Layout Element distance
    LayY = Maf(LayY - 150) 
    LayX = RefX
    LayX = Maf(LayX + LayW - 100)
    
    
    -- add Sequence FADE
    
    --Setup Fade seq
    FirstSeqTime = CurrentSeqNr
    LastSeqTime = Maf(CurrentSeqNr + 5)
    -- Create Macro Time Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Time Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    Cmd('Insert')    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" ')
    Cmd("Insert")    
    Cmd('set 3 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeTox" ')
    Cmd('ChangeDestination Root')

    for i = 1,6 do
        local ia= tonumber(i * 2 - 1)
        local ib= tonumber(i * 2)
        -- Create Sequences 
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[i].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
        if i == 1 then
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[i].name .. '\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime='.. Argument_Fade[i].UseExTime .. '')
        elseif i == 6 then        
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[i].name .. '\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime='.. Argument_Fade[i].UseExTime .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" '.. Argument_Fade[i].Time ..' ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" '.. Argument_Fade[i].Time ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ib].Nr .. '\'')
        Command_Ext_Suite(CurrentSeqNr)

        -- end Sequences

        -- Add Squences to Layout
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[ib].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        if i == 1 then
            LayNr = Maf(LayNr + 1)
            Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'FADE')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'24')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 700 PositionH 140')
            LayNr = Maf(LayNr + 1)
            Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'Ex.Time')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'24')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 120 PositionH 140')
        end
        LayX = Maf(LayX + LayW + 20)
        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
        -- end Sequences

    end
    -- end Sequences FADE

    
    
    
    
    -- Setup DelayFrom seq
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    FirstSeqDelayFrom = CurrentSeqNr
    LastSeqDelayFrom = Maf(CurrentSeqNr + 4)
    -- Create Macro DelayFrom Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'DelayFrom Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. LastSeqDelayFrom .. '')
    Cmd("Insert")    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" ')
    Cmd('ChangeDestination Root')

    -- Create Sequences Delayfrom 
    for i = 1,5 do 
        local ia= tonumber(i * 2 + 11)
        local ib= tonumber(i * 2 + 12)    
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Delay[i].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
        if i == 5 then
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Delay[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Delay[i].name .. '\' Property Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" '.. Argument_Delay[i].Time ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' ..AppImp[ib].Nr .. '\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0')
        Command_Ext_Suite(CurrentSeqNr)

        -- end Sequences
        
        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[ib].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        if i == 1 then
            LayNr = Maf(LayNr + 1)
            Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'DELAY FROM')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 580 PositionH 140')
        end
        LayX = Maf(LayX + LayW + 20)
        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
        -- end Sequences delayfrom 0
    end
    -- end Sequences DelayFrom 
    
    
    -- Setup DelayTo seq
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    FirstSeqDelayTo = CurrentSeqNr
    LastSeqDelayTo = Maf(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'DelayTo Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. LastSeqDelayTo .. '')
    Cmd('Insert')    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayTox" ')
    Cmd('ChangeDestination Root')
    
    -- Create Sequences DelayTo 
    for i = 1,5 do 
    local ia= tonumber(i * 2 + 21)
    local ib= tonumber(i * 2 + 22)
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_DelayTo[i].name .. '\'')
    -- Add Cmd to Squence
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
    if i == 5 then
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_DelayTo[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
    else
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_DelayTo[i].name .. '\' Property Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayTox" '.. Argument_DelayTo[i].Time ..'')
    end
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' ..AppImp[ib].Nr .. '\'')
    Command_Ext_Suite(CurrentSeqNr)

    -- end Sequences

    -- Add Squences to Layout
    Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[ib].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
    if i == 1 then
        LayNr = Maf(LayNr + 1)
        Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'DELAY TO')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 580 PositionH 140')
    end    
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    end
    -- end Sequences DelayTo



    -- Add offset for Layout Element distance
    LayY = Maf(LayY - 150) 
    LayX = RefX
    LayX = Maf(LayX + LayW - 100)


    -- Create Macro Phase Input
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Phase Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')    
    Cmd('set 1 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "PhaseFromx" ')
    Cmd("Insert")    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "PhaseTox" ')
    Cmd('ChangeDestination Root')
 
    -- Create Sequences 
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'Phase Input\'')

    -- Add Cmd to Squence
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[63].Nr .. '\'')      
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix ..'Phase Input\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[64].Nr .. '\'')
    Command_Ext_Suite(CurrentSeqNr)

    -- end Sequences

    -- Add Squences to Layout
    Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[64].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        LayNr = Maf(LayNr + 1)
        Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'PHASE')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 120 PositionH 140')
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences Phase
    
    -- Setup XGroup seq
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    FirstSeqXgrp = CurrentSeqNr
    LastSeqXgrp = Maf(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'XGroup Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqXgrp .. ' thru ' .. LastSeqXgrp .. ' - ' .. LastSeqXgrp .. '')
    Cmd('Insert')    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "XGroup" ')
    Cmd('ChangeDestination Root')
    

    -- Create Sequences XGroup
    for i = 1,5 do 
        local ia= tonumber(i * 2 + 31)
        local ib= tonumber(i * 2 + 32)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Xgrp[i].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
        if i == 5 then
         Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xgrp[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xgrp[i].name .. '\' Property Command=\'off seq ' .. FirstSeqXgrp .. ' thru ' .. LastSeqXgrp .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "XGroup" '.. Argument_Xgrp[i].Time ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' ..AppImp[ib].Nr .. '\'')
        Command_Ext_Suite(CurrentSeqNr)

        -- end Sequences
    
        -- Add Squences to Layout
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[ib].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        if i == 1 then
            LayNr = Maf(LayNr + 1)
            Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'X GROUP')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 580 PositionH 140')
        end    
        LayX = Maf(LayX + LayW + 20)
        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
    end
    -- end Sequences XGroup





    -- Setup XBlock seq
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    FirstSeqXblock = CurrentSeqNr
    LastSeqXblock = Maf(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'XBlock Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqXblock .. ' thru ' .. LastSeqXblock .. ' - ' .. LastSeqXblock .. '')
    Cmd('Insert')    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "XBlock" ')
    Cmd('ChangeDestination Root')
    

    -- Create Sequences XBlock
    for i = 1,5 do 
        local ia= tonumber(i * 2 + 41)
        local ib= tonumber(i * 2 + 42)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Xblock[i].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
        if i == 5 then
         Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xblock[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xblock[i].name .. '\' Property Command=\'off seq ' .. FirstSeqXblock .. ' thru ' .. LastSeqXblock .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "XBlock" '.. Argument_Xblock[i].Time ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' ..AppImp[ib].Nr .. '\'')
        Command_Ext_Suite(CurrentSeqNr)

        -- end Sequences
    
        -- Add Squences to Layout
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[ib].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        if i == 1 then
            LayNr = Maf(LayNr + 1)
            Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'XBLOCK')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
            Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 580 PositionH 140')
        end    
        LayX = Maf(LayX + LayW + 20)
        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
    end
    -- end Sequences XBlock







    -- Setup XWings seq
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    FirstSeqXwings = CurrentSeqNr
    LastSeqXwings = Maf(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'XWings Input\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeqXwings .. ' thru ' .. LastSeqXwings .. ' - ' .. LastSeqXwings .. '')
    Cmd('Insert')    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "XWings" ')
    Cmd('ChangeDestination Root')
    

    -- Create Sequences XWings
    for i = 1,5 do 
        local ia= tonumber(i * 2 + 51)
        local ib= tonumber(i * 2 + 52)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Xwings[i].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'CueZero\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. AppImp[ia].Nr .. '\'')
        if i == 5 then
         Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xwings[i].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Xwings[i].name .. '\' Property Command=\'off seq ' .. FirstSeqXwings .. ' thru ' .. LastSeqXwings .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "XWings" '.. Argument_Xwings[i].Time ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'OffCue\' Property Command=\'Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' ..AppImp[ib].Nr .. '\'')
        Command_Ext_Suite(CurrentSeqNr)
       
        -- end Sequences
    
        -- Add Squences to Layout
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' appearance=' .. AppImp[ib].Nr .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        if i == 1 then
           LayNr = Maf(LayNr + 1)
           Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\'XWINGS')
           Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'32')
           Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
           Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
           Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW 580 PositionH 140')
       end    
       LayX = Maf(LayX + LayW + 20)
       LayNr = Maf(LayNr + 1)
       CurrentSeqNr = Maf(CurrentSeqNr + 1)
    end
    -- end Sequences XWings

    -- add Kill all LCx_
    LayY = TLay[TLayNrRef].DimensionH / 2
    LayY = Maf(LayY + 20) -- Add offset for Layout Element distance
    LayX = RefX
    -- Create Sequences
    Cmd("ClearAll /nu")
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'KILL_ALL\'')
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. prefix .. "'skull_on'\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. prefix .. 'KILL_ALL\' Property Command=\'Off Sequence \'' .. prefix .. '*')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. prefix .. "'skull_off'\"")
    Command_Ext_Suite(CurrentSeqNr)

    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. prefix .. "'skull_off'" .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
    --end Kill al LCx_


    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
     
    -- add All Color
    LayX = Maf(LayX + LayW + 20)
    NrNeed = Maf(AppNr + 1)
    col_count = 0

    for col in ipairs(TCol) do
        col_count = col_count + 1
        StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        StColName = TCol[col].name
        StringColName = string.gsub( StColName," ","_" )
        ColNr = SelectedGelNr .. "." .. TCol[col].no

        -- Create Sequences
        Cmd("ClearAll /nu")
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        -- Add Cmd to Squence
        Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. prefix .. 'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\'Go+ Sequence \'' .. prefix .. StringColName ..  '*')
        Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Command_Ext_Suite(CurrentSeqNr)
        
        -- end Sequences

        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        NrNeed = Maf(NrNeed + 2); -- Set App Nr to next color

        if (col_count ~= MaxColLgn) then
            LayX = Maf(LayX + LayW + 20)
        else
            LayX = RefX
            LayX = Maf(LayX + LayW + 20)
            LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
            LayY = Maf(LayY - LayH)
            col_count = 0
        end

        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
    end

    -- Macro Del LC prefix
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    condition_string = "Lua 'if Confirm(\"Delete Layout Color LC".. prefix:gsub('%D*','') .."?\") then; Cmd(\"Go macro ".. CurrentMacroNr .."\"); else Cmd(\"Off macro ".. CurrentMacroNr .."\"); end'"..' /nu'
    
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \''  .. 'ERASE\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1,7 do 
    Cmd('Insert')
    end
    Cmd('ChangeDestination Root')

    Macro_Pool[CurrentMacroNr]:Set('name','Erase ['..prefix:gsub('_','').. ']')
    Macro_Pool[CurrentMacroNr][1]:Set('Command',condition_string)
    Macro_Pool[CurrentMacroNr][1]:Set('Wait','Go')
    Macro_Pool[CurrentMacroNr][2]:Set('Command','Delete Sequence ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][3]:Set('Command','Delete Layout ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][4]:Set('Command','Delete Matricks ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][5]:Set('Command','Delete Appearance ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][6]:Set('Command','Delete  Macro ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][7]:Set('Command','Delete  Macro ' .. CurrentMacroNr .. ' /nc')


    -- end All Color

    for k in pairs(root.ShowData.DataPools.Default.Layouts:Children()) do
        if (Maf(TLayNr) == Maf(tonumber(root.ShowData.DataPools.Default.Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    UsedW = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout "  .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)
    Cmd('Select Layout ' .. TLayNr)

    ::canceled::
    Cmd("ClearAll /nu")
end
return Main