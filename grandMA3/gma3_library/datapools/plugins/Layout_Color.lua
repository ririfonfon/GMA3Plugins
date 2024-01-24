--[[
Releases:
* 1.1.8.0

Created by Richard Fontaine "RIRI", January 2024.
--]]

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

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
        ImgNr = math.floor(Img[k].NO)
    end

    if ImgNr == nil then
        ImgNr = 0
    end

    local ImgImp = {
        { Name = "\"on\"",            FileName = "\"on.png\"",            Filepath = "" },
        { Name = "\"off\"",           FileName = "\"off.png\"",           Filepath = "" },
        { Name = "\"exec_time_on\"",  FileName = "\"exec_time_on.png\"",  Filepath = "" },
        { Name = "\"exec_time_off\"", FileName = "\"exec_time_off.png\"", Filepath = "" },
        { Name = "\"calcul_on\"",     FileName = "\"calcul_on.png\"",     Filepath = "" },
        { Name = "\"calcul_off\"",    FileName = "\"calcul_off.png\"",    Filepath = "" },
        { Name = "\"x_on\"",          FileName = "\"x_on.png\"",          Filepath = "" },
        { Name = "\"x_off\"",         FileName = "\"x_off.png\"",         Filepath = "" },
        { Name = "\"y_on\"",          FileName = "\"y_on.png\"",          Filepath = "" },
        { Name = "\"y_off\"",         FileName = "\"y_off.png\"",         Filepath = "" },
        { Name = "\"z_on\"",          FileName = "\"z_on.png\"",          Filepath = "" },
        { Name = "\"z_off\"",         FileName = "\"z_off.png\"",         Filepath = "" }
    }

    -- Store all Used Appearances in a Table to find the last free number
    local App = root.ShowData.Appearances:Children()
    local AppNr

    for k in pairs(App) do
        AppNr = math.floor(App[k].NO)
    end
    if AppNr == nil then
        AppNr = 0
    end
    AppNr = AppNr + 1

    local NrAppear
    local NrNeed
    local AppCrea = 0
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    local StAppExecOn = '\"Showdata.MediaPools.Symbols.exec_time_on\"'
    local StAppExecOff = '\"Showdata.MediaPools.Symbols.exec_time_off\"'
    local StAppCalculOn = '\"Showdata.MediaPools.Symbols.calcul_on\"'
    local StAppCalculOff = '\"Showdata.MediaPools.Symbols.calcul_off\"'
    local StApp0On = '\"Showdata.MediaPools.Symbols.[number_0_black_png]\"'
    local StApp0Off = '\"Showdata.MediaPools.Symbols.[number_0_white_png]\"'
    local StApp1On = '\"Showdata.MediaPools.Symbols.[number_1_black_png]\"'
    local StApp1Off = '\"Showdata.MediaPools.Symbols.[number_1_white_png]\"'
    local StApp2On = '\"Showdata.MediaPools.Symbols.[number_2_black_png]\"'
    local StApp2Off = '\"Showdata.MediaPools.Symbols.[number_2_white_png]\"'
    local StApp3On = '\"Showdata.MediaPools.Symbols.[number_3_black_png]\"'
    local StApp3Off = '\"Showdata.MediaPools.Symbols.[number_3_white_png]\"'
    local StApp4On = '\"Showdata.MediaPools.Symbols.[number_4_black_png]\"'
    local StApp4Off = '\"Showdata.MediaPools.Symbols.[number_4_white_png]\"'
    local StAppSkullOn = '\"Showdata.MediaPools.Symbols.[skull_black_png]\"'
    local StAppSkullOff = '\"Showdata.MediaPools.Symbols.[skull_white_png]\"'
    local StAppTricksOn = '\"Showdata.MediaPools.Symbols.[arrow_right_black_png]\"'
    local StAppTricksOff = '\"Showdata.MediaPools.Symbols.[home_white_png]\"'
    local StAppMacroTricks = '\"Showdata.MediaPools.Symbols.[gear_white_png]\"'
    local StAppXOn = '\"Showdata.MediaPools.Symbols.x_on\"'
    local StAppXOff = '\"Showdata.MediaPools.Symbols.x_off\"'
    local StAppYOn = '\"Showdata.MediaPools.Symbols.y_on\"'
    local StAppYOff = '\"Showdata.MediaPools.Symbols.y_off\"'
    local StAppZOn = '\"Showdata.MediaPools.Symbols.z_on\"'
    local StAppZOff = '\"Showdata.MediaPools.Symbols.z_off\"'
    local surfix = { 'x', 'y', 'z' }
    local FadeRef = ' color=\'0,0.8,0,1\''
    local DelayRef = ' color=\'0.8,0.8,0,1\''
    local DelayToRef = ' color=\'0.8,0.3,0,1\''
    local XgrpRef = ' color=\'0,0.8,0.8,1\''
    local XblockRef = ' color=\'0.8,0,0.8,1\''
    local XwingsRef = ' color=\'0.8,0,0.3,1\''
    local PhaseRef = ' color=\'0.3,0,0.8,1\''
    local SkullRef = ' color=\'0.6,0,0,1\''
    local NoRef = ' color=\'1,1,1,1\''

    local AppTricks = {
        { Name = '\'tricks_on\'',       StApp = StAppTricksOn,    Nr = '', RGBref = NoRef },
        { Name = '\'tricks_off\'',      StApp = StAppTricksOff,   Nr = '', RGBref = NoRef },
        { Name = '\'macrotricks_off\'', StApp = StAppMacroTricks, Nr = '', RGBref = NoRef }
    }

    local AppImp = {
        { Name = '\'exectime_on\'',       StApp = StAppExecOn,    Nr = '', RGBref = FadeRef },
        { Name = '\'exectime_off\'',      StApp = StAppExecOff,   Nr = '', RGBref = FadeRef },
        { Name = '\'fade0_on\'',          StApp = StApp0On,       Nr = '', RGBref = FadeRef },
        { Name = '\'fade0_off\'',         StApp = StApp0Off,      Nr = '', RGBref = FadeRef },
        { Name = '\'fade1_on\'',          StApp = StApp1On,       Nr = '', RGBref = FadeRef },
        { Name = '\'fade1_off\'',         StApp = StApp1Off,      Nr = '', RGBref = FadeRef },
        { Name = '\'fade2_on\'',          StApp = StApp2On,       Nr = '', RGBref = FadeRef },
        { Name = '\'fade2_off\'',         StApp = StApp2Off,      Nr = '', RGBref = FadeRef },
        { Name = '\'fade4_on\'',          StApp = StApp4On,       Nr = '', RGBref = FadeRef },
        { Name = '\'fade4_off\'',         StApp = StApp4Off,      Nr = '', RGBref = FadeRef },
        { Name = '\'input_fade_on\'',     StApp = StAppCalculOn,  Nr = '', RGBref = FadeRef },
        { Name = '\'input_fade_off\'',    StApp = StAppCalculOff, Nr = '', RGBref = FadeRef },
        { Name = '\'delay0_on\'',         StApp = StApp0On,       Nr = '', RGBref = DelayRef },
        { Name = '\'delay0_off\'',        StApp = StApp0Off,      Nr = '', RGBref = DelayRef },
        { Name = '\'delay1_on\'',         StApp = StApp1On,       Nr = '', RGBref = DelayRef },
        { Name = '\'delay1_off\'',        StApp = StApp1Off,      Nr = '', RGBref = DelayRef },
        { Name = '\'delay2_on\'',         StApp = StApp2On,       Nr = '', RGBref = DelayRef },
        { Name = '\'delay2_off\'',        StApp = StApp2Off,      Nr = '', RGBref = DelayRef },
        { Name = '\'delay4_on\'',         StApp = StApp4On,       Nr = '', RGBref = DelayRef },
        { Name = '\'delay4_off\'',        StApp = StApp4Off,      Nr = '', RGBref = DelayRef },
        { Name = '\'input_delay_on\'',    StApp = StAppCalculOn,  Nr = '', RGBref = DelayRef },
        { Name = '\'input_delay_off\'',   StApp = StAppCalculOff, Nr = '', RGBref = DelayRef },
        { Name = '\'delayto0_on\'',       StApp = StApp0On,       Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto0_off\'',      StApp = StApp0Off,      Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto1_on\'',       StApp = StApp1On,       Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto1_off\'',      StApp = StApp1Off,      Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto2_on\'',       StApp = StApp2On,       Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto2_off\'',      StApp = StApp2Off,      Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto4_on\'',       StApp = StApp4On,       Nr = '', RGBref = DelayToRef },
        { Name = '\'delayto4_off\'',      StApp = StApp4Off,      Nr = '', RGBref = DelayToRef },
        { Name = '\'input_delayto_on\'',  StApp = StAppCalculOn,  Nr = '', RGBref = DelayToRef },
        { Name = '\'input_delayto_off\'', StApp = StAppCalculOff, Nr = '', RGBref = DelayToRef },
        { Name = '\'xgroup0_on\'',        StApp = StApp0On,       Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup0_off\'',       StApp = StApp0Off,      Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup2_on\'',        StApp = StApp2On,       Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup2_off\'',       StApp = StApp2Off,      Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup3_on\'',        StApp = StApp3On,       Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup3_off\'',       StApp = StApp3Off,      Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup4_on\'',        StApp = StApp4On,       Nr = '', RGBref = XgrpRef },
        { Name = '\'xgroup4_off\'',       StApp = StApp4Off,      Nr = '', RGBref = XgrpRef },
        { Name = '\'input_xgroup_on\'',   StApp = StAppCalculOn,  Nr = '', RGBref = XgrpRef },
        { Name = '\'input_xgroup_off\'',  StApp = StAppCalculOff, Nr = '', RGBref = XgrpRef },
        { Name = '\'xblock0_on\'',        StApp = StApp0On,       Nr = '', RGBref = XblockRef },
        { Name = '\'xblock0_off\'',       StApp = StApp0Off,      Nr = '', RGBref = XblockRef },
        { Name = '\'xblock2_on\'',        StApp = StApp2On,       Nr = '', RGBref = XblockRef },
        { Name = '\'xblock2_off\'',       StApp = StApp2Off,      Nr = '', RGBref = XblockRef },
        { Name = '\'xblock3_on\'',        StApp = StApp3On,       Nr = '', RGBref = XblockRef },
        { Name = '\'xblock3_off\'',       StApp = StApp3Off,      Nr = '', RGBref = XblockRef },
        { Name = '\'xblock4_on\'',        StApp = StApp4On,       Nr = '', RGBref = XblockRef },
        { Name = '\'xblock4_off\'',       StApp = StApp4Off,      Nr = '', RGBref = XblockRef },
        { Name = '\'input_xblock_on\'',   StApp = StAppCalculOn,  Nr = '', RGBref = XblockRef },
        { Name = '\'input_xblock_off\'',  StApp = StAppCalculOff, Nr = '', RGBref = XblockRef },
        { Name = '\'xwings0_on\'',        StApp = StApp0On,       Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings0_off\'',       StApp = StApp0Off,      Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings2_on\'',        StApp = StApp2On,       Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings2_off\'',       StApp = StApp2Off,      Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings3_on\'',        StApp = StApp3On,       Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings3_off\'',       StApp = StApp3Off,      Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings4_on\'',        StApp = StApp4On,       Nr = '', RGBref = XwingsRef },
        { Name = '\'xwings4_off\'',       StApp = StApp4Off,      Nr = '', RGBref = XwingsRef },
        { Name = '\'input_xwings_on\'',   StApp = StAppCalculOn,  Nr = '', RGBref = XwingsRef },
        { Name = '\'input_xwings_off\'',  StApp = StAppCalculOff, Nr = '', RGBref = XwingsRef },
        { Name = '\'input_phase_on\'',    StApp = StAppCalculOn,  Nr = '', RGBref = PhaseRef },
        { Name = '\'input_phase_off\'',   StApp = StAppCalculOff, Nr = '', RGBref = PhaseRef },
        { Name = '\'skull_on\'',          StApp = StAppSkullOn,   Nr = '', RGBref = SkullRef },
        { Name = '\'skull_off\'',         StApp = StAppSkullOff,  Nr = '', RGBref = SkullRef },
        { Name = '\'x_on\'',              StApp = StAppXOn,       Nr = '', RGBref = NoRef },
        { Name = '\'x_off\'',             StApp = StAppXOff,      Nr = '', RGBref = NoRef },
        { Name = '\'y_on\'',              StApp = StAppYOn,       Nr = '', RGBref = NoRef },
        { Name = '\'y_off\'',             StApp = StAppYOff,      Nr = '', RGBref = NoRef },
        { Name = '\'z_on\'',              StApp = StAppZOn,       Nr = '', RGBref = NoRef },
        { Name = '\'z_off\'',             StApp = StAppZOff,      Nr = '', RGBref = NoRef }
    }


    local Argument_Fade = {
        { name = 'ExecTime',   UseExTime = 1, Time = 0 },
        { name = 'Time 0',     UseExTime = 0, Time = 0 },
        { name = 'Time 1',     UseExTime = 0, Time = 1 },
        { name = 'Time 2',     UseExTime = 0, Time = 2 },
        { name = 'Time 4',     UseExTime = 0, Time = 4 },
        { name = 'Time Input', UseExTime = 0, Time = 0 }
    }

    local Argument_Delay = {
        { name = 'Delay From 0',     Time = 0 },
        { name = 'Delay From 1',     Time = 1 },
        { name = 'Delay From 2',     Time = 2 },
        { name = 'Delay From 4',     Time = 4 },
        { name = 'Delay From Input', Time = 0 },
    }

    local Argument_DelayTo = {
        { name = 'Delay To 0',     Time = 0 },
        { name = 'Delay To 1',     Time = 1 },
        { name = 'Delay To 2',     Time = 2 },
        { name = 'Delay To 4',     Time = 4 },
        { name = 'Delay To Input', Time = 0 },
    }

    local Argument_Xgrp = {
        { name = 'XGroup To 0',     Time = 0 },
        { name = 'XGroup To 2',     Time = 2 },
        { name = 'XGroup To 3',     Time = 3 },
        { name = 'XGroup To 4',     Time = 4 },
        { name = 'XGroup To Input', Time = 0 },
    }

    local Argument_Xblock = {
        { name = 'XBlock To 0',     Time = 0 },
        { name = 'XBlock To 2',     Time = 2 },
        { name = 'XBlock To 3',     Time = 3 },
        { name = 'XBlock To 4',     Time = 4 },
        { name = 'XBlock To Input', Time = 0 },
    }

    local Argument_Xwings = {
        { name = 'XWings To 0',     Time = 0 },
        { name = 'XWings To 2',     Time = 2 },
        { name = 'XWings To 3',     Time = 3 },
        { name = 'XWings To 4',     Time = 4 },
        { name = 'XWings To Input', Time = 0 },
    }

    local appcheck = {}
    for k in pairs(AppImp) do
        appcheck[k] = setmetatable({
            value = ''
        }, {
            ref = ''
        })
    end

    -- Store all Use Layout in a Table to find the last free number
    local TLay = root.ShowData.DataPools.Default.Layouts:Children()
    local TLayNr
    local TLayNrRef
    local First_Id_Lay = {}
    local Current_Id_Lay

    for k in ipairs(TLay) do
        TLayNr = math.floor(tonumber(TLay[k].NO))
        TLayNrRef = k
    end
    if TLayNr == nil then
        TLayNr = 0
    end

    TLayNr = math.floor(TLayNr + 1)

    -- Store all Used Sequence in a Table to find the last free number
    local SeqNr = root.ShowData.DataPools.Default.Sequences:Children()
    local SeqNrStart
    local SeqNrEnd

    for k in pairs(SeqNr) do
        SeqNrStart = math.floor(SeqNr[k].NO)
    end
    if SeqNrStart == nil then
        SeqNrStart = 0
    end

    SeqNrStart = SeqNrStart + 1

    local prefix_index = 1
    local old_prefix_index
    local prefix = 'LC' .. tostring(prefix_index) .. '_'
    local exit = false

    repeat
        old_prefix_index = prefix_index
        for k in pairs(TLay) do
            if string.match(TLay[k].name, prefix) then
                Echo("LC found %s", tostring(TLay[k].name))
                prefix_index = math.floor(prefix_index + 1)
            end
        end
        prefix = 'LC' .. tostring(prefix_index) .. '_'
        if old_prefix_index == prefix_index then
            exit = true
        end
    until exit == true

    -- Store all Used Macro in a Table to find the last free number
    local Macro_Pool = root.ShowData.DataPools.Default.Macros
    local MacroNr = root.ShowData.DataPools.Default.Macros:Children()
    local MacroNrStart

    for k in pairs(MacroNr) do
        MacroNrStart = math.floor(MacroNr[k].NO)
    end
    if MacroNrStart == nil then
        MacroNrStart = 0
    end

    MacroNrStart = MacroNrStart + 1

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do
        TIconNr = math.floor(TIcon[k].NO)
    end

    -- Store all Used MAtricks in a Table to find the last free number
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
    local MatrickNrStart
    for k in pairs(MatrickNr) do
        MatrickNrStart = math.floor(MatrickNr[k].NO)
    end
    if MatrickNrStart == nil then
        MatrickNrStart = 0
    end

    MatrickNrStart = math.floor(MatrickNrStart + 1)
    MatrickNr = MatrickNrStart

    -- Store all Used Preset All 1 in a Table to find the last free number
    local All_5_Nr = root.ShowData.DataPools.Default.PresetPools[25]:Children()
    local All_5_NrStart
    local All_5_NrEnd
    local All_5_Current
    for k in pairs(All_5_Nr) do
        All_5_NrStart = math.floor(All_5_Nr[k].NO)
    end
    if All_5_NrStart == nil then
        All_5_NrStart = 0
    end

    All_5_NrStart = math.floor(All_5_NrStart + 1)
    All_5_Current = All_5_NrStart

    -- variables
    local LayX
    local RefX
    local LayY
    if TLayNrRef then
        RefX = math.floor(0 - TLay[TLayNrRef].DimensionW / 2)
        LayY = TLay[TLayNrRef].DimensionH / 2
    else
        RefX = -960
        LayY = 540
    end
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local TCol
    local StColCode
    local StColName
    local StringColName
    local StColCodeFirstSeqTime
    local ColNr = 0
    local SelectedGrp = {}
    local SelectedGrpName = {}
    local SelectedGrpNo = {}
    local GrpNo
    local SelectedGelNr
    local col_count
    local check = {}
    local NaLay = "Colors"
    local FirstSeqTime
    local LastSeqTime
    local FirstSeqDelayFrom
    local LastSeqDelayFrom
    local FirstSeqDelayTo
    local LastSeqDelayTo
    local FirstSeqGrp
    local LastSeqGrp
    local FirstSeqBlock
    local LastSeqBlock
    local FirstSeqWings
    local LastSeqWings
    local FirstSeqColor
    local LastSeqColor
    local First_All_Color
    local CurrentSeqNr
    local CurrentMacroNr
    local UsedW
    local UsedH
    local MaxColLgn = 40
    local ColLgnCount = 0
    local long_imgimp
    local add_check = 0
    local condition_string
    local MakeX = true
    local CallT
    local Call_inc = 0

    local Fade_Element
    local Delay_F_Element
    local Delay_T_Element
    local Phase_Element
    local Group_Element
    local Block_Element
    local Wings_Element

    local Return_Main_Call = { Mainbox_Call(display_Handle, signalTable, thiscomponent, myHandle)}
    -- local Return_Main_Call = { Mainbox_Call(display_Handle, signalTable, thiscomponent, myHandle, TLayNr, NaLay,
    --     SeqNrStart, MacroNrStart, AppNr, MaxColLgn, MatrickNrStart, ColGels, FixtureGroups, SelectedGelNr, SelectedGrp,
    --     SelectedGrpNo, All_5_NrStart, ColPath, TLay, SeqNr, MacroNr, App, All_5_Nr, MatrickNr) }
    -- local Return_Main_Call ={Mainbox_Call(display_Handle,TLayNr,NaLay,SeqNrStart,MacroNrStart,AppNr,MaxColLgn,MatrickNrStart,ColGels,FixtureGroups,SelectedGelNr,SelectedGrp,SelectedGrpNo,All_5_NrStart)}
    if Return_Main_Call[1] then
        SeqNrStart = Return_Main_Call[2]
        MacroNrStart = Return_Main_Call[3]
        AppNr = Return_Main_Call[4]
        TLayNr = Return_Main_Call[5]
        TLayNr = math.floor(TLayNr)
        NaLay = Return_Main_Call[6]
        MaxColLgn = Return_Main_Call[7]
        MatrickNrStart = Return_Main_Call[8]
        SelectedGelNr = Return_Main_Call[9]
        All_5_NrStart = Return_Main_Call[10]
        All_5_NrStart = math.floor(All_5_NrStart)
        All_5_Current = All_5_NrStart
        Echo(All_5_NrStart)
        SelectedGrp = Return_Main_Call[11]
        -- goto doMagicStuff
        doMagicStuff()
    else
        goto canceled
    end

    

    ::canceled::
    do
        Cmd("ClearAll /nu")
    end --end canceled
end     -- end function Main(display_Handle)
return Main
