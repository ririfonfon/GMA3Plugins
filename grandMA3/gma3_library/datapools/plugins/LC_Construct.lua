--[[
Releases:
* 1.1.9.0

Created by Richard Fontaine "RIRI", March 2024.
--]]

function Construct_Layout(displayHandle, TLay, SeqNrStart, MacroNrStart, MatrickNrStart, MatrickNr, TLayNr, AppNr,
                          All_5_Current, All_5_NrStart, ColPath, SelectedGelNr, SelectedGrp, SelectedGrpNo, TLayNrRef,
                          NaLay, MaxColLgn)
    local Macro_Pool = Root().ShowData.DataPools.Default.Macros
    local All_5_NrEnd
    local Img = Root().ShowData.MediaPools.Symbols:Children()
    local ImgNr
    for k in pairs(Img) do
        ImgNr = math.floor(Img[k].NO)
    end
    if ImgNr == nil then
        ImgNr = 1
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
    local NrAppear
    local NrNeed
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

    local First_Id_Lay = {}
    local SeqNrEnd

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
    local SelectedGrpName = {}
    local check = {}
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
    local First_All_Color
    local CurrentSeqNr
    local CurrentMacroNr
    local UsedW
    local UsedH
    local ColLgnCount = 0
    local long_imgimp
    local add_check = 0
    local condition_string
    local MakeX = true
    local CallT
    local Call_inc = 0
    local Current_Id_Lay

    local Fade_Element
    local Delay_F_Element
    local Delay_T_Element
    local Phase_Element
    local Group_Element
    local Block_Element
    local Wings_Element


    -- fix prefix
    local prefix_index = 1
    local old_prefix_index
    local prefix = 'LC' .. tostring(prefix_index) .. '_'
    local exit = false
    repeat
        old_prefix_index = prefix_index
        for k in pairs(TLay) do
            if string.match(TLay[k].name, prefix) then
                prefix_index = math.floor(prefix_index + 1)
            end
        end
        prefix = 'LC' .. tostring(prefix_index) .. '_'
        if old_prefix_index == prefix_index then
            exit = true
        end
    until exit == true
    -- fix name SelectedGrp
    for g in pairs(SelectedGrp) do
        SelectedGrpName[g] = SelectedGrp[g]:gsub(' ', '_')
    end

    -- fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart

    -- check Symbols
    CheckSymbols(displayHandle, Img, ImgImp, check, add_check, long_imgimp, ImgNr)

    -- Create MAtricks
    local Return_Create_Matricks = { Create_Matricks(MatrickNrStart, prefix, NaLay, SelectedGrp, SelectedGrpName,
        MatrickNr) }
    if Return_Create_Matricks[1] then
        MatrickNr = Return_Create_Matricks[2]
    end

    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. prefix .. NaLay .. "")

    SelectedGelNr = tonumber(SelectedGelNr)
    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    -- Create Appearances Tricks Ref
    local Return_Create_Appear_Tricks = { Create_Appear_Tricks(AppTricks, AppNr, prefix) }
    if Return_Create_Appear_Tricks[1] then
        AppNr = Return_Create_Appear_Tricks[2]
        AppTricks = Return_Create_Appear_Tricks[3]
    end
    -- end Appearances Tricks Ref

    -- Create Appearances
    local Return_Create_Appearances = { Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode,
        StColName, StringColName) }
    if Return_Create_Appearances[1] then
        NrAppear = Return_Create_Appearances[2]
    end
    -- end Appearances

    -- Create Preset 25
    local Return_Create_Preset_25 = { Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix,
        All_5_NrEnd, All_5_Current) }
    if Return_Create_Preset_25[1] then
        All_5_NrEnd = Return_Create_Preset_25[2]
        All_5_Current = Return_Create_Preset_25[2]
    end
    -- endCreate Preset 25

    -- Appearances/Sequences
    local Return_Create_Appearances_Sequences = { Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr,
        SelectedGrp, RefX, LayY, LayH, NrAppear, AppNr, NrNeed, TLayNr, LayW, LayNr, CurrentSeqNr, MaxColLgn, TCol,
        SelectedGrpNo, prefix, All_5_NrStart, MatrickNrStart, SelectedGrpName, AppTricks) }
    if Return_Create_Appearances_Sequences[1] then
        LayY = Return_Create_Appearances_Sequences[2]
        NrNeed = Return_Create_Appearances_Sequences[3]
        LayNr = Return_Create_Appearances_Sequences[4]
        CurrentSeqNr = Return_Create_Appearances_Sequences[5]
        CurrentMacroNr = Return_Create_Appearances_Sequences[6]
        ColLgnCount = Return_Create_Appearances_Sequences[7]
    end
    -- end Appearances/Sequences

    -- Create Appearances/Function
    for q in pairs(AppImp) do
        AppImp[q].Nr = math.floor(NrNeed)
        Cmd('Store App ' .. AppImp[q].Nr .. ' "' .. prefix .. AppImp[q].Name ..
            '" "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref .. '')
        NrNeed = math.floor(NrNeed + 1)
    end
    -- end Create Appearances/Function

    SeqNrEnd = CurrentSeqNr - 1
    -- Add offset for Layout Element distance
    LayY = math.floor(LayY - 150)
    LayX = RefX
    LayX = math.floor(LayX + LayW - 100)

    for a = 1, 3 do
        -- add Sequence FADE
        local Return_Create_Fade_Sequence = { Create_Fade_Sequences(MakeX, FirstSeqTime, LastSeqTime, CurrentSeqNr,
            CurrentMacroNr, prefix, surfix, First_Id_Lay, LayNr, MatrickNrStart, TLayNr, Fade_Element, Argument_Fade,
            AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element, a) }
        if Return_Create_Fade_Sequence[1] then
            CurrentSeqNr = Return_Create_Fade_Sequence[2]
            Delay_F_Element = Return_Create_Fade_Sequence[3]
            LayNr = Return_Create_Fade_Sequence[4]
            LayX = Return_Create_Fade_Sequence[5]
            Current_Id_Lay = Return_Create_Fade_Sequence[6]
            Fade_Element = Return_Create_Fade_Sequence[7]
        end
        -- end add Sequence FADE


        -- Setup DelayFrom seq
        CurrentMacroNr = math.floor(CurrentMacroNr + 5)
        FirstSeqDelayFrom = CurrentSeqNr
        LastSeqDelayFrom = math.floor(CurrentSeqNr + 4)

        -- Create Macro DelayFrom Input
        Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayFrom, LastSeqDelayFrom,
            MatrickNrStart, 2, TLayNr, Delay_F_Element, MatrickNr)

        if MakeX then
            Command_Title('DELAY FROM', LayNr, TLayNr, LayX, LayY, 580, 140, 2)
            LayNr = math.floor(LayNr + 1)
            Command_Title('none', LayNr, TLayNr, LayX, LayY, 580, 140, 3)
            LayNr = math.floor(LayNr + 1)
        end
        -- Create Sequences Delayfrom
        for i = 1, 5 do
            local ia = tonumber(i * 2 + 11)
            local ib = tonumber(i * 2 + 12)
            if i == 1 then
                if a == 1 then
                    First_Id_Lay[5] = math.floor(LayNr)
                    First_Id_Lay[6] = CurrentSeqNr
                elseif a == 2 then
                    First_Id_Lay[7] = CurrentSeqNr
                elseif a == 3 then
                    First_Id_Lay[8] = CurrentSeqNr
                end
                Current_Id_Lay = First_Id_Lay[5]
            end
            Cmd('ClearAll /nu')
            Cmd('Store Sequence ' ..
                CurrentSeqNr .. ' \'' .. prefix .. Argument_Delay[i].name .. surfix[a] .. '\'')
            -- Add Cmd to Squence
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
            if i == 5 then
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Delay[i].name .. surfix[a] .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
            else
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Delay[i].name ..
                    surfix[a] ..
                    '\' Property Command=\'off seq ' ..
                    FirstSeqDelayFrom ..
                    ' thru ' ..
                    LastSeqDelayFrom ..
                    ' - ' ..
                    CurrentSeqNr ..
                    ' ; Set Matricks ' ..
                    MatrickNrStart ..
                    ' Property "DelayFrom' ..
                    surfix[a] ..
                    '" ' ..
                    Argument_Delay[i].Time ..
                    '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' ..
                    a ..
                    '" ; SetUserVariable "LC_Layout" ' ..
                    TLayNr ..
                    ' ; SetUserVariable "LC_Element" ' ..
                    Delay_F_Element ..
                    ' ; SetUserVariable "LC_Matrick" ' ..
                    MatrickNrStart ..
                    ' ; SetUserVariable "LC_Matrick_Thru" ' ..
                    MatrickNr ..
                    ' ; Call Plugin "LC_View" ')
            end
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
            Command_Ext_Suite(CurrentSeqNr)
            -- Add Squences to Layout
            if MakeX then
                Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
                Cmd("Set Layout " ..
                    TLayNr ..
                    "." ..
                    LayNr ..
                    " property appearance <default> PosX " ..
                    LayX ..
                    " PosY " ..
                    LayY ..
                    " PositionW " ..
                    LayW ..
                    " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
                LayX = math.floor(LayX + LayW + 20)
                LayNr = math.floor(LayNr + 1)
                Delay_T_Element = math.floor(LayNr + 1)
            end
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end Sequences DelayFrom

        -- Setup DelayTo seq
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        FirstSeqDelayTo = CurrentSeqNr
        LastSeqDelayTo = math.floor(CurrentSeqNr + 4)
        -- Create Macro DelayTo Input
        Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayTo, LastSeqDelayTo, MatrickNrStart,
            3, TLayNr, Delay_T_Element, MatrickNr)

        if MakeX then
            Command_Title('DELAY TO', LayNr, TLayNr, LayX, LayY, 580, 140, 2)
            LayNr = math.floor(LayNr + 1)
            Command_Title('none', LayNr, TLayNr, LayX, LayY, 580, 140, 3)
            LayNr = math.floor(LayNr + 1)
        end
        -- Create Sequences DelayTo
        for i = 1, 5 do
            local ia = tonumber(i * 2 + 21)
            local ib = tonumber(i * 2 + 22)
            if i == 1 then
                if a == 1 then
                    First_Id_Lay[9] = math.floor(LayNr)
                    First_Id_Lay[10] = CurrentSeqNr
                elseif a == 2 then
                    First_Id_Lay[11] = CurrentSeqNr
                elseif a == 3 then
                    First_Id_Lay[12] = CurrentSeqNr
                end
                Current_Id_Lay = First_Id_Lay[9]
            end
            Cmd('ClearAll /nu')
            Cmd('Store Sequence ' ..
                CurrentSeqNr .. ' \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. '\'')
            -- Add Cmd to Squence
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
            if i == 5 then
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_DelayTo[i].name .. surfix[a] ..
                    '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
            else
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_DelayTo[i].name ..
                    surfix[a] ..
                    '\' Property Command=\'off seq ' ..
                    FirstSeqDelayTo ..
                    ' thru ' ..
                    LastSeqDelayTo ..
                    ' - ' ..
                    CurrentSeqNr ..
                    ' ; Set Matricks ' ..
                    MatrickNrStart ..
                    ' Property "DelayTo' ..
                    surfix[a] ..
                    '" ' ..
                    Argument_DelayTo[i].Time ..
                    ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' ..
                    a ..
                    '" ; SetUserVariable "LC_Layout" ' ..
                    TLayNr ..
                    ' ; SetUserVariable "LC_Element" ' ..
                    Delay_T_Element ..
                    ' ; SetUserVariable "LC_Matrick" ' ..
                    MatrickNrStart ..
                    ' ; SetUserVariable "LC_Matrick_Thru" ' ..
                    MatrickNr ..
                    ' ; Call Plugin "LC_View" ')
            end
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
            Command_Ext_Suite(CurrentSeqNr)
            -- end Sequences
            -- Add Squences to Layout
            if MakeX then
                Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
                Cmd('Set Layout ' ..
                    TLayNr ..
                    '.' ..
                    LayNr ..
                    ' property appearance <default> PosX ' ..
                    LayX ..
                    ' PosY ' ..
                    LayY ..
                    ' PositionW ' ..
                    LayW ..
                    ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
                LayX = math.floor(LayX + LayW + 20)
                LayNr = math.floor(LayNr + 1)
                Phase_Element = math.floor(LayNr + 2)
            end
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end Sequences DelayTo

        -- Add offset for Layout Element distance
        LayY = math.floor(LayY - 150)
        LayX = RefX
        LayX = math.floor(LayX + LayW - 100)

        -- Create Macro Phase Input
        if a == 1 then
            First_Id_Lay[13] = math.floor(LayNr)
            First_Id_Lay[14] = CurrentSeqNr
        elseif a == 2 then
            First_Id_Lay[15] = CurrentSeqNr
        elseif a == 3 then
            First_Id_Lay[16] = CurrentSeqNr
        end
        Current_Id_Lay = First_Id_Lay[13]
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, 4, TLayNr, Phase_Element, MatrickNr)

        -- Create Sequences
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'Phase Input' .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[63].Nr)
        Cmd('set seq ' ..
            CurrentSeqNr ..
            ' cue \'' ..
            prefix .. 'Phase Input' .. surfix[a] .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[64].Nr)
        Command_Ext_Suite(CurrentSeqNr)

        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr ..
                ' property appearance <default> PosX ' ..
                LayX ..
                ' PosY ' ..
                LayY ..
                ' PositionW ' ..
                LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Command_Title('PHASE', LayNr, TLayNr, LayX - 120, LayY - 30, 700, 170, 4)
            LayNr = math.floor(LayNr + 1)
            Command_Title('none > none', LayNr, TLayNr, LayX - 120, LayY - 30, 700, 170, 1)
            LayNr = math.floor(LayNr + 1)
            Group_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- end Sequences Phase
        -- Setup XGroup seq
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        FirstSeqGrp = CurrentSeqNr
        LastSeqGrp = math.floor(CurrentSeqNr + 4)
        -- Create Macro Group Input
        Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeqGrp, LastSeqGrp, MatrickNrStart, 5, TLayNr,
            Group_Element, MatrickNr)

        if MakeX then
            Command_Title('GROUP', LayNr, TLayNr, LayX - 120, LayY - 30, 700, 170, 2)
            LayNr = math.floor(LayNr + 1)
            Command_Title('None', LayNr, TLayNr, LayX - 120, LayY - 30, 700, 170, 3)
            LayNr = math.floor(LayNr + 1)
        end
        -- Create Sequences XGroup
        for i = 1, 5 do
            local ia = tonumber(i * 2 + 31)
            local ib = tonumber(i * 2 + 32)
            if i == 1 then
                if a == 1 then
                    First_Id_Lay[17] = math.floor(LayNr)
                    First_Id_Lay[18] = CurrentSeqNr
                elseif a == 2 then
                    First_Id_Lay[19] = CurrentSeqNr
                elseif a == 3 then
                    First_Id_Lay[20] = CurrentSeqNr
                end
                Current_Id_Lay = First_Id_Lay[17]
            end
            Cmd('ClearAll /nu')
            Cmd('Store Sequence ' ..
                CurrentSeqNr .. ' \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. '\'')
            -- Add Cmd to Squence
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
            if i == 5 then
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xgrp[i].name .. surfix[a] .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
            else
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xgrp[i].name ..
                    surfix[a] ..
                    '\' Property Command=\'off seq ' ..
                    FirstSeqGrp ..
                    ' thru ' ..
                    LastSeqGrp ..
                    ' - ' ..
                    CurrentSeqNr ..
                    ' ; Set Matricks ' ..
                    MatrickNrStart ..
                    ' Property "' ..
                    surfix[a] ..
                    'Group" ' ..
                    Argument_Xgrp[i].Time ..
                    '  ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' ..
                    a ..
                    '" ; SetUserVariable "LC_Layout" ' ..
                    TLayNr ..
                    ' ; SetUserVariable "LC_Element" ' ..
                    Group_Element ..
                    ' ; SetUserVariable "LC_Matrick" ' ..
                    MatrickNrStart ..
                    ' ; SetUserVariable "LC_Matrick_Thru" ' ..
                    MatrickNr ..
                    ' ; Call Plugin "LC_View" ')
            end
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
            Command_Ext_Suite(CurrentSeqNr)
            -- end Sequences
            -- Add Squences to Layout
            if MakeX then
                Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
                Cmd('Set Layout ' ..
                    TLayNr ..
                    '.' ..
                    LayNr ..
                    ' property appearance <default> PosX ' ..
                    LayX ..
                    ' PosY ' ..
                    LayY ..
                    ' PositionW ' ..
                    LayW ..
                    ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
                LayX = math.floor(LayX + LayW + 20)
                LayNr = math.floor(LayNr + 1)
                Block_Element = math.floor(LayNr + 1)
            end
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end
        -- end Sequences XGroup
        -- Setup XBlock seq
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        FirstSeqBlock = CurrentSeqNr
        LastSeqBlock = math.floor(CurrentSeqNr + 4)
        -- Create Macro Block Input
        Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeqBlock, LastSeqBlock, MatrickNrStart, 6,
            TLayNr, Block_Element, MatrickNr)

        if MakeX then
            Command_Title('BLOCK', LayNr, TLayNr, LayX, LayY, 580, 140, 2)
            LayNr = math.floor(LayNr + 1)
            Command_Title('none', LayNr, TLayNr, LayX, LayY, 580, 140, 3)
            LayNr = math.floor(LayNr + 1)
        end
        -- Create Sequences XBlock
        for i = 1, 5 do
            local ia = tonumber(i * 2 + 41)
            local ib = tonumber(i * 2 + 42)
            if i == 1 then
                if a == 1 then
                    First_Id_Lay[21] = math.floor(LayNr)
                    First_Id_Lay[22] = CurrentSeqNr
                elseif a == 2 then
                    First_Id_Lay[23] = CurrentSeqNr
                elseif a == 3 then
                    First_Id_Lay[24] = CurrentSeqNr
                end
                Current_Id_Lay = First_Id_Lay[21]
            end
            Cmd('ClearAll /nu')
            Cmd('Store Sequence ' ..
                CurrentSeqNr .. ' \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] .. '\'')
            -- Add Cmd to Squence
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
            if i == 5 then
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xblock[i].name .. surfix[a] .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
            else
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xblock[i].name ..
                    surfix[a] ..
                    '\' Property Command=\'off seq ' ..
                    FirstSeqBlock ..
                    ' thru ' ..
                    LastSeqBlock ..
                    ' - ' ..
                    CurrentSeqNr ..
                    ' ; Set Matricks ' ..
                    MatrickNrStart ..
                    ' Property "' ..
                    surfix[a] ..
                    'Block" ' ..
                    Argument_Xblock[i].Time ..
                    '  ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' ..
                    a ..
                    '" ; SetUserVariable "LC_Layout" ' ..
                    TLayNr ..
                    ' ; SetUserVariable "LC_Element" ' ..
                    Block_Element ..
                    ' ; SetUserVariable "LC_Matrick" ' ..
                    MatrickNrStart ..
                    ' ; SetUserVariable "LC_Matrick_Thru" ' ..
                    MatrickNr ..
                    ' ; Call Plugin "LC_View" ')
            end
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
            Command_Ext_Suite(CurrentSeqNr)
            -- end Sequences
            -- Add Squences to Layout
            if MakeX then
                Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
                Cmd('Set Layout ' ..
                    TLayNr ..
                    '.' ..
                    LayNr ..
                    ' property appearance <default> PosX ' ..
                    LayX ..
                    ' PosY ' ..
                    LayY ..
                    ' PositionW ' ..
                    LayW ..
                    ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
                LayX = math.floor(LayX + LayW + 20)
                LayNr = math.floor(LayNr + 1)
                Wings_Element = math.floor(LayNr + 1)
            end
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end
        -- end Sequences XBlock
        -- Setup XWings seq
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        FirstSeqWings = CurrentSeqNr
        LastSeqWings = math.floor(CurrentSeqNr + 4)
        -- Create Macro Wings Input
        Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeqWings, LastSeqWings, MatrickNrStart, 7,
            TLayNr, Wings_Element, MatrickNr)

        if MakeX then
            Command_Title('WINGS', LayNr, TLayNr, LayX, LayY, 580, 140, 2)
            LayNr = math.floor(LayNr + 1)
            Command_Title('none', LayNr, TLayNr, LayX, LayY, 580, 140, 3)
            LayNr = math.floor(LayNr + 1)
        end
        -- Create Sequences XWings
        for i = 1, 5 do
            local ia = tonumber(i * 2 + 51)
            local ib = tonumber(i * 2 + 52)
            if i == 1 then
                if a == 1 then
                    First_Id_Lay[25] = math.floor(LayNr)
                    First_Id_Lay[26] = CurrentSeqNr
                elseif a == 2 then
                    First_Id_Lay[27] = CurrentSeqNr
                elseif a == 3 then
                    First_Id_Lay[28] = CurrentSeqNr
                end
                Current_Id_Lay = First_Id_Lay[25]
            end
            Cmd('ClearAll /nu')
            Cmd('Store Sequence ' ..
                CurrentSeqNr .. ' \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] .. '\'')
            -- Add Cmd to Squence
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
            if i == 5 then
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xwings[i].name .. surfix[a] .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
            else
                Cmd('set seq ' ..
                    CurrentSeqNr ..
                    ' cue \'' ..
                    prefix ..
                    Argument_Xwings[i].name ..
                    surfix[a] ..
                    '\' Property Command=\'off seq ' ..
                    FirstSeqWings ..
                    ' thru ' ..
                    LastSeqWings ..
                    ' - ' ..
                    CurrentSeqNr ..
                    ' ; Set Matricks ' ..
                    MatrickNrStart ..
                    ' Property "' ..
                    surfix[a] ..
                    'Wings" ' ..
                    Argument_Xwings[i].Time ..
                    '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' ..
                    a ..
                    '" ; SetUserVariable "LC_Layout" ' ..
                    TLayNr ..
                    ' ; SetUserVariable "LC_Element" ' ..
                    Wings_Element ..
                    ' ; SetUserVariable "LC_Matrick" ' ..
                    MatrickNrStart ..
                    ' ; SetUserVariable "LC_Matrick_Thru" ' ..
                    MatrickNr ..
                    ' ; Call Plugin "LC_View" ')
            end
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
            Command_Ext_Suite(CurrentSeqNr)
            -- end Sequences
            -- Add Squences to Layout
            if MakeX then
                Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
                Cmd('Set Layout ' ..
                    TLayNr ..
                    '.' ..
                    LayNr ..
                    ' property appearance <default> PosX ' ..
                    LayX ..
                    ' PosY ' ..
                    LayY ..
                    ' PositionW ' ..
                    LayW ..
                    ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
                LayX = math.floor(LayX + LayW + 20)
                LayNr = math.floor(LayNr + 1)
            end
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end
        -- end Sequences XWings

        -- add Sequences X Y Z call
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        First_Id_Lay[33 + a] = CurrentMacroNr
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        for m = 1, 31 do
            if m == 1 or m == 6 or m == 11 or m == 16 or m == 17 or m == 22 or m == 27 then
                Call_inc = 0
            end
            if m < 6 then
                CallT = 1
            elseif m < 11 then
                CallT = 5
            elseif m < 16 then
                CallT = 9
            elseif m < 17 then
                CallT = 13
            elseif m < 22 then
                CallT = 17
            elseif m < 27 then
                CallT = 21
            elseif m <= 31 then
                CallT = 25
            end
            Cmd('Insert')
            Cmd('set ' ..
                m ..
                ' Command=\'Assign Sequence ' ..
                First_Id_Lay[CallT + a] + Call_inc .. ' At Layout ' ..
                TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
            Call_inc = math.floor(Call_inc + 1)
        end
        Cmd('ChangeDestination Root')
        Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
            Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
            Wings_Element, MatrickNr)

        First_Id_Lay[28 + a] = CurrentSeqNr
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[66 + tonumber(a * 2 - 1)].Nr)
        Cmd('set seq ' ..
            CurrentSeqNr ..
            ' cue \'' .. prefix .. surfix[a] .. '_Call\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[67 + tonumber(a * 2 - 1)].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr + 1 .. ' \'' .. prefix .. surfix[a] .. '_Reset\'')
        Cmd("set seq " .. CurrentSeqNr + 1 .. " cue 1 Property Appearance=" .. prefix .. "'skull_on'")
        Cmd('set seq ' ..
            CurrentSeqNr + 1 ..
            ' cue \'' .. prefix .. surfix[a] .. '_Reset\' Property Command=\'Go Macro ' .. CurrentMacroNr + 1 .. '')
        Cmd("set seq " .. CurrentSeqNr + 1 .. " Property Appearance=" .. prefix .. "'skull_off'")
        Command_Ext_Suite(CurrentSeqNr + 1)
        if MakeX == false then
            LayNr = math.floor(LayNr + 1)
        end
        if a == 1 then
            First_Id_Lay[32] = LayX
            First_Id_Lay[33] = LayY
            Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] ..
                ' PosY ' ..
                First_Id_Lay[33] + 170 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
            Cmd('Assign Seq ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr + 1 ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] + 85 ..
                ' PosY ' ..
                First_Id_Lay[33] + 170 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        elseif a == 2 then
            Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] ..
                ' PosY ' ..
                First_Id_Lay[33] + 90 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
            Cmd('Assign Seq ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr + 1 ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] + 85 ..
                ' PosY ' ..
                First_Id_Lay[33] + 90 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        elseif a == 3 then
            Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] ..
                ' PosY ' ..
                First_Id_Lay[33] + 10 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
            Cmd('Assign Seq ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' ..
                TLayNr ..
                '.' ..
                LayNr + 1 ..
                ' property appearance <default> PosX ' ..
                First_Id_Lay[32] + 85 ..
                ' PosY ' ..
                First_Id_Lay[33] + 10 ..
                ' PositionW ' ..
                LayW - 35 ..
                ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
        end
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 2)
        CurrentMacroNr = math.floor(CurrentMacroNr + 2)
        MakeX = false
    end -- end Sequences X Y Z call

    -- add line macro X Y Z Call
    for i = 1, 3 do
        Cmd('ChangeDestination Macro ' .. First_Id_Lay[33 + i])
        Cmd('Insert')
        Cmd('set 32 Command=\'Off Sequence ' ..
            First_Id_Lay[29] ..
            ' + ' .. First_Id_Lay[30] .. ' + ' .. First_Id_Lay[31] .. ' - ' .. First_Id_Lay[28 + i])
        Add_Macro_Call(i, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element, Delay_T_Element, Phase_Element,
            Group_Element, Block_Element, Wings_Element)
        Cmd('ChangeDestination Root')
    end
    -- end line macro X Y Z Call

    -- add Kill all LCx_
    if TLayNrRef then
        LayY = TLay[TLayNrRef].DimensionH / 2
    else
        LayY = 540
    end

    LayY = math.floor(LayY + 20) -- Add offset for Layout Element distance
    LayY = math.floor(LayY + (120 * ColLgnCount))
    LayX = RefX
    LayNr = math.floor(LayNr + 1)
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'KILL_ALL\'')
    Cmd("set seq " .. CurrentSeqNr .. " cue 1 Property Appearance=" .. prefix .. "'skull_on'")
    Cmd('set seq ' ..
        CurrentSeqNr .. ' cue \'' .. prefix .. 'KILL_ALL\' Property Command=\'Off Sequence \'' .. prefix .. '*')
    Cmd("set seq " .. CurrentSeqNr .. " Property Appearance=" .. prefix .. "'skull_off'")
    Command_Ext_Suite(CurrentSeqNr)
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd('Set Layout ' ..
        TLayNr ..
        '.' ..
        LayNr ..
        ' property appearance <default> PosX ' ..
        LayX ..
        ' PosY ' ..
        LayY ..
        ' PositionW ' ..
        LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
    -- end Kill all LCx_

    -- add All Color
    LayNr = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    LayX = math.floor(LayX + LayW + 20)
    NrNeed = math.floor(AppNr + 1)

    local Return_AddAllColor = { AddAllColor(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW,
        LayH, SelectedGelNr, MaxColLgn, RefX) }
    if Return_AddAllColor[1] then
        LayNr = Return_AddAllColor[2]
        LayX = Return_AddAllColor[3]
        First_All_Color = Return_AddAllColor[4]
    end

    LayX = math.floor(LayX + LayW + 20)
    -- end All Color

    -- add Macro priority
    CurrentMacroNr = math.floor(CurrentMacroNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'Priority\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1, 6 do
        Cmd('Insert')
    end
    Cmd('Assign Macro ' .. CurrentMacroNr .. ' at Layout ' .. TLayNr)
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        ' property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
        ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
    Cmd('Set Layout ' .. TLayNr .. "." .. LayNr .. ' Property "Appearance" "p_super_png" ')
    Cmd('ChangeDestination Root')
    local Color_message = 'SetUserVariable "LC_Sequence" "' .. First_All_Color .. '"'
    Color_message = string.gsub(Color_message, "'", "")
    Macro_Pool[CurrentMacroNr]:Set('name', '' .. prefix .. 'Priority')
    Macro_Pool[CurrentMacroNr][1]:Set('Command', 'Edit Sequence "' .. prefix .. '*" Property "priority"')
    Macro_Pool[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" 8')
    Macro_Pool[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr)
    Macro_Pool[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr)
    Macro_Pool[CurrentMacroNr][5]:Set('Command', Color_message)
    Macro_Pool[CurrentMacroNr][6]:Set('Command', 'Call Plugin "LC_View"')
    -- end Macro priority

    -- Macro Del LC prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 2)
    condition_string = "Lua 'if Confirm(\"Delete Layout Color LC" ..
        prefix:gsub('%D*', '') ..
        "?\") then; Cmd(\"Go macro " ..
        CurrentMacroNr .. "\"); else Cmd(\"Off macro " .. CurrentMacroNr .. "\"); end'" .. ' /nu'
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'ERASE\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1, 8 do
        Cmd('Insert')
    end
    Cmd('ChangeDestination Root')
    Macro_Pool[CurrentMacroNr]:Set('name', 'Erase [' .. prefix:gsub('_', '') .. ']')
    Macro_Pool[CurrentMacroNr][1]:Set('Command', condition_string)
    Macro_Pool[CurrentMacroNr][1]:Set('Wait', 'Go')
    Macro_Pool[CurrentMacroNr][2]:Set('Command', 'Delete Sequence ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][3]:Set('Command', 'Delete Layout ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][4]:Set('Command', 'Delete Matricks ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][5]:Set('Command', 'Delete Appearance ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][6]:Set('Command', 'Delete Preset 25. ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][7]:Set('Command', 'Delete  Macro ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][8]:Set('Command', 'Delete  Macro ' .. CurrentMacroNr .. ' /nc')
    -- end Macro Del LC prefix

    -- dimension of layout & scal it
    for k in pairs(Root().ShowData.DataPools.Default.Layouts:Children()) do
        if (math.floor(TLayNr) == math.floor(tonumber(Root().ShowData.DataPools.Default.Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    UsedW = Root().ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = Root().ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)
    Cmd('Select Layout ' .. TLayNr)
end -- end Construct_Layout

--end LC_Construct.lua
