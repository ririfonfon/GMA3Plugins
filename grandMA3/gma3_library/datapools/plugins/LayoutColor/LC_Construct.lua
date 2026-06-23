--[[
Releases:
* 2.3.2.0

Created by Richard Fontaine "RIRI", June 2024. Update may 2026
--]]
-- SelectedGrp, SelectedGrpNo,
function LC_Construct_Layout(TLay, SeqNrStart, MacroNrStart, MatrickNrStart, MatrickNr, TLayNr,
                             AppNr, All_5_Current, All_5_NrStart, ColPath, SelectedGelNr,
                             NbGroup, TLayNrRef, NaLay, MaxColLgn,
                             Favourite_Nr, Construct_Pool, Groups_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
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
    -- if TLayNrRef then
    --     RefX = math.floor(0 - TLay[TLayNrRef].DimensionW / 2)
    --     LayY = TLay[TLayNrRef].DimensionH / 2
    -- else
    RefX = -960
    LayY = 540
    -- end
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local TCol
    local StColCode
    local StColName
    local StringColName
    -- local SelectedGrpName = {}
    local check = {}
    local FirstSeqTime
    local LastSeqTime
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

    local Ligne_Inc = false

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
    -- -- fix name SelectedGrp
    -- for g in pairs(SelectedGrp) do
    --     SelectedGrpName[g] = SelectedGrp[g]:gsub(' ', '_')
    -- end

    -- fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart
    -- check Symbols
    CheckSymbols(Img, ImgImp, check, add_check, long_imgimp, ImgNr)
    Echo('Check ok')

    -- Create MAtricks
    MatrickNr = Create_Matricks(MatrickNrStart, prefix, NaLay, NbGroup, MatrickNr, Construct_Pool)
    Echo('matricks ok')


    -- Create new Layout View
    LC_Check_Size_Pool(TLayNr, Layout_Object)
    Layout_Object:Create(TLayNr)
    Layout_Object[TLayNr]:Set('Name', "'" .. prefix .. NaLay .. "'")
    -- CmdIndirectWait('Select Layout ' .. TLayNr)

    SelectedGelNr = tonumber(SelectedGelNr)
    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    -- Create Appearances Tricks Ref
    AppNr, AppTricks = Create_Appear_Tricks(AppTricks, AppNr, prefix)
    -- end Appearances Tricks Ref
    Echo('Create Appear trick ok')

    -- Create Appearances
    NrAppear = Create_Appearances(AppNr, prefix, TCol, NrAppear, StColCode, StColName,
        StringColName)
    -- end Appearances
    Echo('Creat APP ok')

    -- Create Preset 25
    All_5_NrEnd, All_5_Current = Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr,
        prefix, All_5_NrEnd, All_5_Current, Construct_Pool)
    -- endCreate Preset 25
    Echo('Preset 25 ok')

    -- Appearances/Sequences
    LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr, ColLgnCount,
    Ligne_Inc = Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr, NbGroup, RefX,
        LayY, LayH, NrAppear, AppNr, NrNeed, TLayNr, LayW, LayNr, CurrentSeqNr, MaxColLgn,
        TCol, prefix, All_5_NrStart, MatrickNrStart,
        AppTricks, Construct_Pool, Groups_Pool)
    -- end Appearances/Sequences
    Echo('Crea app_sequence ok')
end

local function suite()
    -- Create Appearances/Function
    for q in pairs(AppImp) do
        AppImp[q].Nr = math.floor(NrNeed)
        CmdIndirectWait('Store App ' .. AppImp[q].Nr .. ' "' .. prefix .. AppImp[q].Name ..
            '" "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref .. '')
        NrNeed = math.floor(NrNeed + 1)
    end
    -- end Create Appearances/Function

    SeqNrEnd = CurrentSeqNr - 1
    -- Add offset for Layout Element distance
    LayY = math.floor(LayY - 150)
    LayX = RefX
    LayX = math.floor(LayX + LayW - 100)

    -- Create Function for X Y Z
    for a = 1, 3 do
        -- Create Sequence FADE
        CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay,
        Fade_Element, CurrentMacroNr = Create_Fade_Sequences(MakeX,
            FirstSeqTime, LastSeqTime, CurrentSeqNr, CurrentMacroNr, prefix, surfix, First_Id_Lay, LayNr, MatrickNrStart,
            TLayNr, Fade_Element, Argument_Fade, AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay,
            Delay_F_Element, a, Construct_Pool)
        -- end Create Sequence FADE

        -- Create Sequences Delayfrom
        Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr, CurrentMacroNr =
            Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                AppImp, CurrentMacroNr, a, MatrickNrStart, TLayNr, Delay_F_Element, MatrickNr, MakeX, LayX, LayY, LayW,
                LayH, Delay_T_Element, Construct_Pool)
        -- end Create Sequences Delayfrom

        -- Create Sequences DelayTo
        First_Id_Lay, Current_Id_Lay, LayX, LayNr, Phase_Element, CurrentSeqNr, CurrentMacroNr =
            Create_Delay_To_Sequences(a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, Argument_DelayTo,
                surfix, MatrickNrStart, TLayNr, Delay_T_Element, MatrickNr, AppImp, LayX, LayY, LayW, LayH, Phase_Element,
                CurrentMacroNr, MakeX, Construct_Pool)
        -- end Create Sequences DelayTo

        -- Create_Sequence_Phase
        Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element = Create_Phase_Sequence(LayY, LayX,
            LayW, a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, CurrentMacroNr, prefix, surfix, MatrickNrStart,
            TLayNr, Phase_Element, MatrickNr, AppImp, MakeX, LayH, RefX, Group_Element, Construct_Pool)
        -- end Sequences Phase

        -- Create_sequence_xgroup
        CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp, FirstSeqGrp =
            Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, a,
                MatrickNrStart, TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Construct_Pool)
        -- end Sequences XGroup

        -- Create_Block_Sequence
        CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock, LastSeqBlock =
            Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, a,
                MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                Argument_Xblock, AppImp, Wings_Element, LayW, LayH, Construct_Pool)
        -- end Create_Block_Sequence

        -- Create_Wings_Sequence
        CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr =
            Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, a,
                MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                Argument_Xwings, AppImp, LayW, LayH, Construct_Pool)
        -- end Create_Wings_Sequence

        -- Create_XYZ_Sequence
        First_Id_Lay, LayNr, CurrentMacroNr = Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, Call_inc,
            CallT, MatrickNrStart, a, CurrentSeqNr, TLayNr, Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element,
            Group_Element, Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY, LayW, LayH,
            Construct_Pool)
        -- Create_XYZ_Sequence

        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 2)
        CurrentMacroNr = math.floor(CurrentMacroNr + 2)
        MakeX = false
    end --end  Create Function for X Y Z

    -- add line macro X Y Z Call
    for i = 1, 3 do
        MacroObject[First_Id_Lay[33 + i]]:Insert(32)
        MacroObject[First_Id_Lay[33 + i]][32]:Set('Command',
            'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. First_Id_Lay[29] ..
            ' + ' .. First_Id_Lay[30] .. ' + ' .. First_Id_Lay[31] .. ' - ' .. First_Id_Lay[28 + i])

        -- CmdIndirectWait('ChangeDestination Macro ' .. First_Id_Lay[33 + i])
        -- Cmd('Insert')
        -- CmdIndirectWait('Set 32 Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. First_Id_Lay[29] ..
        --     ' + ' .. First_Id_Lay[30] .. ' + ' .. First_Id_Lay[31] .. ' - ' .. First_Id_Lay[28 + i])
        Add_Macro_Call(i, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element, Delay_T_Element, Phase_Element,
            Group_Element, Block_Element, Wings_Element, Construct_Pool, First_Id_Lay[33 + i])
        -- CmdIndirectWait('ChangeDestination Root')
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
    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. "KILL_ALL'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', prefix .. "'skull_off'")
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', prefix .. "'skull_on'")
    SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence \'' .. prefix .. '*')


    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'KILL_ALL\'')
    -- CmdIndirectWait("Set Seq " .. CurrentSeqNr .. " cue 1 Property Appearance=" .. prefix .. "'skull_on'")
    -- CmdIndirectWait('Set Seq ' ..
    --     CurrentSeqNr .. ' cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence \'' .. prefix .. '*')
    -- CmdIndirectWait("Set Seq " .. CurrentSeqNr .. " Property Appearance=" .. prefix .. "'skull_off'")
    -- Command_Ext_Suite(CurrentSeqNr)

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Kill_All')

    -- CmdIndirectWait("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    -- end Kill all LCx_

    -- Create_All_Color
    LayNr, LayX, First_All_Color = Create_All_Color(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY,
        LayW, LayH, MaxColLgn, RefX, AppNr, Construct_Pool)
    -- Create_All_Color

    -- add Macro priority
    for k in pairs(DataPool().Layouts:Children()) do
        if (math.floor(TLayNr) == math.floor(tonumber(DataPool().Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    -- UsedW = DataPool().Layouts:Children()[TLayNrRef].UsedW / 2
    -- LayX = math.floor(UsedW - 20)
    LayX = -330
    LayY = 700
    if Ligne_Inc then
        LayY = 800
    end
    CurrentMacroNr = math.floor(CurrentMacroNr)

    local Color_message = 'SetUserVariable "LC_Sequence" "' .. First_All_Color .. '"'
    Color_message = string.gsub(Color_message, "'", "")
    Echo('ici ' .. CurrentMacroNr)
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. "Priority'")
    for b = 1, 7 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command',
        'Edit DataPool ' .. Construct_Pool .. ' Sequence "' .. prefix .. '*" Property "priority"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" 8')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr)
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr)
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool)
    MacroObject[CurrentMacroNr][6]:Set('Command', Color_message)
    MacroObject[CurrentMacroNr][7]:Set('Command', 'Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View"')

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
    LC_Set_Def(TLayNr, Nr, Layout_Object)
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', 'p_super_png')

    -- CmdIndirectWait('Assign Macro ' .. CurrentMacroNr .. ' at Layout ' .. TLayNr)
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. "." .. LayNr .. ' Property "Appearance" "p_super_png" ')
    -- CmdIndirectWait('ChangeDestination Root')
    -- end Macro priority

    -- add Favourites
    local Macro_Num_Start
    local Macro_Num_End
    LayNr = math.floor(LayNr + 1)
    CurrentMacroNr, Macro_Num_End = Create_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Construct_Pool, Favourite_Nr)
    Macro_Num_Start = CurrentMacroNr + 1
    Create_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Construct_Pool, Ligne_Inc, Favourite_Nr)
    -- end Favourites

    -- Macro Del LC prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 2)
    condition_string = "Lua 'if Confirm(\"Delete Layout Color LC" ..
        prefix:gsub('%D*', '') ..
        "?\") then; CmdIndirectWait(\"Go macro " ..
        CurrentMacroNr .. "\"); else CmdIndirectWait(\"Off macro " .. CurrentMacroNr .. "\"); end'" .. ' /nu'
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. CurrentMacroNr .. ' \'' .. "ERASE'")
    for b = 1, 11 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    --     CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'ERASE\'')
    -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    -- for i = 1, 11 do
    --     Cmd('Insert')
    -- end
    -- CmdIndirectWait('ChangeDestination Root')
    MacroObject[CurrentMacroNr]:Set('name', 'Erase [' .. prefix:gsub('_', '') .. ']')
    MacroObject[CurrentMacroNr][1]:Set('Command', condition_string)
    MacroObject[CurrentMacroNr][1]:Set('Wait', 'Go')
    MacroObject[CurrentMacroNr][2]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Sequence ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][3]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Layout ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][4]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Matricks ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'Delete Appearance ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][6]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Preset 25. ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][7]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Macro ' .. Macro_Num_Start .. ' Thru ' .. Macro_Num_End .. ' /nc')
    MacroObject[CurrentMacroNr][8]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Macro ' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][9]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Macro o' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][10]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Sequence o' .. prefix .. '*' .. ' /nc')
    MacroObject[CurrentMacroNr][11]:Set('Command',
        'Delete DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. ' /nc')
    -- end Macro Del LC prefix

    -- dimension of layout & scal it
    for k in pairs(DataPool().Layouts:Children()) do
        if (math.floor(TLayNr) == math.floor(tonumber(DataPool().Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    UsedW = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()[TLayNrRef].UsedH / 2
    Layout_Object[TLayNr]:Set('DimensionW', UsedW)
    Layout_Object[TLayNr]:Set('DimensionH', UsedH)

    -- CmdIndirectWait("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)
    CmdIndirectWait('Select Layout ' .. TLayNr)
end -- end Construct_Layout

--end LC_Construct.lua
