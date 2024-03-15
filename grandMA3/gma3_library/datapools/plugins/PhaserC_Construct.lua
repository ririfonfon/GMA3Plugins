--[[
Releases:
* 1.0.0.0

Created by Richard Fontaine "RIRI", March 2024.
--]]

function Construct_Layout(displayHandle, TLay, SeqNrStart, MacroNrStart, MatrickNrStart, MatrickNr, TLayNr, AppNr,
                          All_5_Current, All_5_NrStart, ColPath, SelectedGelNr, SelectedGrp, SelectedGrpNo, TLayNrRef,
                          NaLay, MaxColLgn)
    local Macro_Pool = Root().ShowData.DataPools.Default.Macros
    local All_5_NrEnd
    local Img = Root().ShowData.MediaPools.Images:Children()
    local ImgNr
    for k in pairs(Img) do
        ImgNr = math.floor(Img[k].NO)
    end
    if ImgNr == nil then
        ImgNr = 1
    end
    local ImgImp = {
        { Name = "\"on\"",                        FileName = "\"on.png\"",                  Filepath = "" },
        { Name = "\"off\"",                       FileName = "\"off.png\"",                 Filepath = "" },
        { Name = "\"[off_active_png]\"",          FileName = "\"off_active.png\"",          Filepath = "" },
        { Name = "\"[1_2_active_png]\"",          FileName = "\"1_2_active.png\"",          Filepath = "" },
        { Name = "\"[2_3_active_png]\"",          FileName = "\"2_3_active.png\"",          Filepath = "" },
        { Name = "\"[3_4_active_png]\"",          FileName = "\"3_4_active.png\"",          Filepath = "" },
        { Name = "\"[1_3_active_png]\"",          FileName = "\"1_3_active.png\"",          Filepath = "" },
        { Name = "\"[2_4_active_png]\"",          FileName = "\"2_4_active_png\"",          Filepath = "" },
        { Name = "\"[1_2_3_active_png]\"",        FileName = "\"1_2_3_active_png\"",        Filepath = "" },
        { Name = "\"[2_3_4_active_png]\"",        FileName = "\"2_3_4_active_png\"",        Filepath = "" },
        { Name = "\"[1_2_3_4_active_png]\"",      FileName = "\"1_2_3_4_active_png\"",      Filepath = "" },
        { Name = "\"[grp_active_png]\"",          FileName = "\"grp_active_png\"",          Filepath = "" },
        { Name = "\"[forward_active_png]\"",      FileName = "\"forward_active_png\"",      Filepath = "" },
        { Name = "\"[oe_active_png]\"",           FileName = "\"oe_active_png\"",           Filepath = "" },
        { Name = "\"[wing_active_png]\"",         FileName = "\"wing_active_png\"",         Filepath = "" },
        { Name = "\"[sym3_active_png]\"",         FileName = "\"sym3_active_png\"",         Filepath = "" },
        { Name = "\"[sym_active_png]\"",          FileName = "\"sym_active_png\"",          Filepath = "" },
        { Name = "\"[rnd_active_png]\"",          FileName = "\"rnd_active_png\"",          Filepath = "" },
        { Name = "\"[pwing_active_png]\"",        FileName = "\"pwing_active_png\"",        Filepath = "" },
        { Name = "\"[psym3_active_png]\"",        FileName = "\"psym3_active_png\"",        Filepath = "" },
        { Name = "\"[psym_active_png]\"",         FileName = "\"psym_active_png\"",         Filepath = "" },
        { Name = "\"[cent_pc_active_png]\"",      FileName = "\"cent_pc_active_png\"",      Filepath = "" },
        { Name = "\"[cinquante_pc_active_png]\"", FileName = "\"cinquante_pc_active_png\"", Filepath = "" },
        { Name = "\"[zero_pc_active_png]\"",      FileName = "\"zero_pc_active_png\"",      Filepath = "" },
        { Name = "\"x_on\"",                      FileName = "\"x_on.png\"",                Filepath = "" },
        { Name = "\"x_off\"",                     FileName = "\"x_off.png\"",               Filepath = "" },
        { Name = "\"y_on\"",                      FileName = "\"y_on.png\"",                Filepath = "" },
        { Name = "\"y_off\"",                     FileName = "\"y_off.png\"",               Filepath = "" },
        { Name = "\"z_on\"",                      FileName = "\"z_on.png\"",                Filepath = "" },
        { Name = "\"z_off\"",                     FileName = "\"z_off.png\"",               Filepath = "" },
        -- { Name = "\"[]\"",  FileName = "\"\"",  Filepath = "" },
    }
    local NrAppear
    local NrNeed
    local StApp_off = '\"Showdata.MediaPools.Images.[off_active_png]\"'
    local StApp_1_2 = '\"Showdata.MediaPools.Images.[1_2_active_png]\"'
    local StApp_2_3 = '\"Showdata.MediaPools.Images.[2_3_active_png]\"'
    local StApp_3_4 = '\"Showdata.MediaPools.Images.[3_4_active_png]\"'
    local StApp_1_3 = '\"Showdata.MediaPools.Images.[1_3_active_png]\"'
    local StApp_2_4 = '\"Showdata.MediaPools.Images.[2_4_active_png]\"'
    local StApp_1_2_3 = '\"Showdata.MediaPools.Images.[1_2_3_active_png]\"'
    local StApp_2_3_4 = '\"Showdata.MediaPools.Images.[2_3_4_active_png]\"'
    local StApp_1_2_3_4 = '\"Showdata.MediaPools.Images.[1_2_3_4_active_png]\"'
    local StApp_grp = '\"Showdata.MediaPools.Images.[grp_active_png]\"'
    local StApp_forward = '\"Showdata.MediaPools.Images.[forward_active_png]\"'
    local StApp_oe = '\"Showdata.MediaPools.Images.[oe_active_png]\"'
    local StApp_wing = '\"Showdata.MediaPools.Images.[wing_active_png]\"'
    local StApp_sym3 = '\"Showdata.MediaPools.Images.[sym3_active_png]\"'
    local StApp_sym = '\"Showdata.MediaPools.Images.[sym_active_png]\"'
    local StApp_rnd = '\"Showdata.MediaPools.Images.[rnd_active_png]\"'
    local StApp_pwing = '\"Showdata.MediaPools.Images.[pwing_active_png]\"'
    local StApp_psym3 = '\"Showdata.MediaPools.Images.[psym3_active_png]\"'
    local StApp_psym = '\"Showdata.MediaPools.Images.[psym_active_png]\"'
    local StApp_cent = '\"Showdata.MediaPools.Images.[cent_pc_active_png]\"'
    local StApp_cinquante = '\"Showdata.MediaPools.Images.[cinquante_pc_active_png]\"'
    local StApp_zero = '\"Showdata.MediaPools.Images.[zero_pc_active_png]\"'
    local StAppXOn = '\"Showdata.MediaPools.Images.x_on\"'
    local StAppXOff = '\"Showdata.MediaPools.Images.x_off\"'
    local StAppYOn = '\"Showdata.MediaPools.Images.y_on\"'
    local StAppYOff = '\"Showdata.MediaPools.Images.y_off\"'
    local StAppZOn = '\"Showdata.MediaPools.Images.z_on\"'
    local StAppZOff = '\"Showdata.MediaPools.Images.z_off\"'


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

    local color_ref = {
        { RGBref = ' color=\'1,0,0,0.5\'' },
        { RGBref = ' color=\'0,1,0,0.5\'' },
        { RGBref = ' color=\'0,0,1,0.5\'' },
        { RGBref = ' color=\'1,1,0,0.5\'' },
        { RGBref = ' color=\'0,1,1,0.5\'' },
        { RGBref = ' color=\'1,0,1,0.5\'' },
        { RGBref = ' color=\'1,0.5,0,0.5\'' },
        { RGBref = ' color=\'0,1,0.5,0.5\'' },
        { RGBref = ' color=\'1,0,0.5,0.5\'' },
        { RGBref = ' color=\'0.5,1,0,0.5\'' },
        { RGBref = ' color=\'0,0.5,1,0.5\'' },
        { RGBref = ' color=\'0.5,0,1,0.5\'' },
        { RGBref = ' color=\'0.5,0.5,1,0.5\'' },
        { RGBref = ' color=\'0.5,1,0.5,0.5\'' },
        { RGBref = ' color=\'0.5,0.5,0.5,0.5\'' },
    }


    local AppImp = {
        { Name = 'off',       StApp = StApp_off,       Nr = '', RGBref = NoRef },
        { Name = '1_2',       StApp = StApp_1_2,       Nr = '', RGBref = NoRef },
        { Name = '2_3',       StApp = StApp_2_3,       Nr = '', RGBref = NoRef },
        { Name = '3_4',       StApp = StApp_3_4,       Nr = '', RGBref = NoRef },
        { Name = '1_3',       StApp = StApp_1_3,       Nr = '', RGBref = NoRef },
        { Name = '2_4',       StApp = StApp_2_4,       Nr = '', RGBref = NoRef },
        { Name = '1_2_3',     StApp = StApp_1_2_3,     Nr = '', RGBref = NoRef },
        { Name = '2_3_4',     StApp = StApp_2_3_4,     Nr = '', RGBref = NoRef },
        { Name = '1_2_3_4',   StApp = StApp_1_2_3_4,   Nr = '', RGBref = NoRef },
        { Name = 'grp',       StApp = StApp_grp,       Nr = '', RGBref = NoRef },
        { Name = 'forward',   StApp = StApp_forward,   Nr = '', RGBref = NoRef },
        { Name = 'oe',        StApp = StApp_oe,        Nr = '', RGBref = NoRef },
        { Name = 'wing',      StApp = StApp_wing,      Nr = '', RGBref = NoRef },
        { Name = 'sym3',      StApp = StApp_sym3,      Nr = '', RGBref = NoRef },
        { Name = 'sym',       StApp = StApp_sym,       Nr = '', RGBref = NoRef },
        { Name = 'rnd',       StApp = StApp_rnd,       Nr = '', RGBref = NoRef },
        { Name = 'pwing',     StApp = StApp_pwing,     Nr = '', RGBref = NoRef },
        { Name = 'psym3',     StApp = StApp_psym3,     Nr = '', RGBref = NoRef },
        { Name = 'psym',      StApp = StApp_psym,      Nr = '', RGBref = NoRef },
        { Name = 'cent',      StApp = StApp_cent,      Nr = '', RGBref = NoRef },
        { Name = 'cinquante', StApp = StApp_cinquante, Nr = '', RGBref = NoRef },
        { Name = 'zero',      StApp = StApp_zero,      Nr = '', RGBref = NoRef },
        { Name = 'x_on',      StApp = StAppXOn,        Nr = '', RGBref = NoRef },
        { Name = 'x_off',     StApp = StAppXOff,       Nr = '', RGBref = NoRef },
        { Name = 'y_on',      StApp = StAppYOn,        Nr = '', RGBref = NoRef },
        { Name = 'y_off',     StApp = StAppYOff,       Nr = '', RGBref = NoRef },
        { Name = 'z_on',      StApp = StAppZOn,        Nr = '', RGBref = NoRef },
        { Name = 'z_off',     StApp = StAppZOff,       Nr = '', RGBref = NoRef },
    }

    local Argument_Matricks = {
        { Name = 'GRP',     phasefrom = '0', phaseto = '0',   group = '0', wing = '0', block = '0', shuffle = '0', transform = 'None' },
        { Name = '>>>',     phasefrom = '0', phaseto = '360', group = '0', wing = '0', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'O/E',     phasefrom = '0', phaseto = '360', group = '2', wing = '0', block = '0', shuffle = '0', transform = 'None' },
        { Name = '><',      phasefrom = '0', phaseto = '360', group = '0', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'SYM3',    phasefrom = '0', phaseto = '360', group = '3', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'SYM',     phasefrom = '0', phaseto = '360', group = '2', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'RND',     phasefrom = '0', phaseto = '360', group = '0', wing = '0', block = '0', shuffle = '9', transform = 'None' },
        { Name = 'PAN><',   phasefrom = '0', phaseto = '360', group = '0', wing = '2', block = '0', shuffle = '0', transform = 'Mirror' },
        { Name = 'PANSYM3', phasefrom = '0', phaseto = '360', group = '0', wing = '2', block = '2', shuffle = '0', transform = 'Mirror' },
        { Name = 'PANSYM',  phasefrom = '0', phaseto = '360', group = '2', wing = '2', block = '2', shuffle = '0', transform = 'Mirror' },
    }

    local Argument_Ref = {
        { Name = '1_2',     Step = 2, Step1 = 0, Step2 = 1, Step3 = 0, Step4 = 0 },
        { Name = '2_3',     Step = 2, Step1 = 1, Step2 = 2, Step3 = 0, Step4 = 0 },
        { Name = '3_4',     Step = 2, Step1 = 2, Step2 = 3, Step3 = 0, Step4 = 0 },
        { Name = '1_3',     Step = 2, Step1 = 0, Step2 = 2, Step3 = 0, Step4 = 0 },
        { Name = '2_4',     Step = 2, Step1 = 1, Step2 = 3, Step3 = 0, Step4 = 0 },
        { Name = '1_2_3',   Step = 3, Step1 = 0, Step2 = 1, Step3 = 2, Step4 = 0 },
        { Name = '2_3_4',   Step = 3, Step1 = 1, Step2 = 2, Step3 = 3, Step4 = 0 },
        { Name = '1_2_3_4', Step = 4, Step1 = 0, Step2 = 1, Step3 = 2, Step4 = 3 },
    }

    local Preset_25_Ref = {}

    local First_Id_Lay = {}
    local Current_Id_Lay
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
    local StColCodeFirstSeqTime
    local ColNr = 0
    local SelectedGrpName = {}
    local GrpNo
    local col_count
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
    local FirstSeqColor
    local LastSeqColor
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
    local Preset_Ref
    local Preset_Ref_End
    local Phaser_Off
    local Phaser_Ref
    local Sequence_Ref
    local AppRef


    -- fix prefix
    local prefix_index = 1
    local old_prefix_index
    local prefix = 'PC' .. tostring(prefix_index) .. '_'
    local exit = false
    repeat
        old_prefix_index = prefix_index
        for k in pairs(TLay) do
            if string.match(TLay[k].name, prefix) then
                prefix_index = math.floor(prefix_index + 1)
            end
        end
        prefix = 'PC' .. tostring(prefix_index) .. '_'
        if old_prefix_index == prefix_index then
            exit = true
        end
    until exit == true
    -- fix name SelectedGrp
    for g in pairs(SelectedGrp) do
        SelectedGrpName[g] = SelectedGrp[g]:gsub(' ', '_')
        SelectedGrpName[g] = SelectedGrpName[g]:gsub("'", '')
        SelectedGrpNo[g] = SelectedGrpNo[g]:gsub("'", '')
    end
    -- fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart
    -- check Symbols
    -- CheckSymbols(displayHandle, Img, ImgImp, check, add_check, long_imgimp, ImgNr)
    -- Create MAtricks
    MatrickNr = math.floor(MatrickNrStart)
    Create_Matrix(MatrickNr, Argument_Matricks, surfix, prefix)
    -- end Create MAtricks
    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. prefix .. NaLay .. "")

    SelectedGelNr = tonumber(SelectedGelNr)
    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    -- Create Appearances
    local Return_Create_Appearances = { Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode,
        StColName, StringColName, AppRef) }
    if Return_Create_Appearances[1] then
        NrAppear = Return_Create_Appearances[2]
        AppRef = Return_Create_Appearances[3]
    end
    -- end Appearances
    -- Create Preset 25
    local Return_Create_Preset_25 = { Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix,
        All_5_NrEnd, All_5_Current) }
    if Return_Create_Preset_25[1] then
        All_5_NrEnd = Return_Create_Preset_25[2]
        All_5_Current = Return_Create_Preset_25[3]
    end
    -- endCreate Preset 25
    -- Create_Preset_Ref_1234
    local Return_Create_Preset_Ref_1234 = { Create_Preset_Ref_1234(prefix, All_5_Current, SelectedGelNr) }
    if Return_Create_Preset_Ref_1234[1] then
        All_5_Current = Return_Create_Preset_Ref_1234[2]
        Preset_Ref = Return_Create_Preset_Ref_1234[3]
        Preset_Ref_End = Preset_Ref + 3
    end
    -- end Create_Preset_Ref_1234
    -- Create_Phaser
    local Return_Create_Phaser = { Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref, Phaser_Off) }
    if Return_Create_Phaser[1] then
        Phaser_Off = Return_Create_Phaser[2]
        All_5_Current = Return_Create_Phaser[3]
    end
    -- end Create_Phaser
    -- Copy_Phaser_Ref
    local Return_Copy_Phaser_Ref = { Copy_Phaser_Ref(Phaser_Off, All_5_Current, Phaser_Ref, Preset_25_Ref) }
    if Return_Copy_Phaser_Ref[1] then
        Phaser_Ref = Return_Copy_Phaser_Ref[2]
        All_5_Current = Return_Copy_Phaser_Ref[3]
        Preset_25_Ref = Return_Copy_Phaser_Ref[4]
    end
    -- end Copy_Phaser_Ref
    -- Create_Active_Appearances
    local Return_Create_Active_Appearances = { Create_Active_Appearances(AppImp, NrAppear, prefix) }
    if Return_Create_Active_Appearances[1] then
        NrAppear = Return_Create_Active_Appearances[2]
    end
    -- end Create_Active_Appearances
    -- Create_Group_Appearances
    local Return_Create_Group_Appearances = { Create_Group_Appearances(AppImp, NrAppear, prefix, SelectedGrp,
        SelectedGrpName, color_ref) }
    if Return_Create_Group_Appearances[1] then
        NrAppear = Return_Create_Group_Appearances[2]
    end
    -- end Create_Group_Appearances
    -- Create_Group_Sequence
    local Return_Create_Group_Sequence = { Create_Group_Sequence(SelectedGrp, SelectedGrpName, Phaser_Off, CurrentSeqNr,
        SelectedGrpNo, prefix, Sequence_Ref) }
    if Return_Create_Group_Sequence[1] then
        CurrentSeqNr = Return_Create_Group_Sequence[2]
        Sequence_Ref = Return_Create_Group_Sequence[3]
    end
    -- end Create_Group_Sequence
    local Return_Create_Layout_Phaser = { Create_Layout_Phaser(TLayNr, NaLay, SelectedGelNr, CurrentSeqNr, Preset_Ref,
        MaxColLgn, RefX, LayY, LayH, AppNr, LayW, StColName, CurrentMacroNr, ColPath, prefix, All_5_NrStart) }
    if Return_Create_Layout_Phaser[1] then
        CurrentMacroNr = Return_Create_Layout_Phaser[2]
        CurrentSeqNr = Return_Create_Layout_Phaser[3]
        LayNr = Return_Create_Layout_Phaser[4]
        LayY = Return_Create_Layout_Phaser[5]
    end

    local Return_Create_Layout_FixGroup = { Create_Layout_FixGroup(CurrentMacroNr, CurrentSeqNr, LayNr, LayY, RefX, LayH,
        LayW, TLayNr, NaLay, SelectedGrp, SelectedGrpName, Argument_Matricks, surfix, prefix, AppImp, Argument_Ref,
        AppRef, Preset_25_Ref,  Phaser_Off, Phaser_Ref, SelectedGrpNo) }
    if Return_Create_Layout_FixGroup[1] then
        CurrentSeqNr = Return_Create_Layout_FixGroup[2]
        CurrentMacroNr = Return_Create_Layout_FixGroup[3]
    end



    -- SeqNrEnd = CurrentSeqNr - 1
    -- -- Add offset for Layout Element distance
    -- LayY = math.floor(LayY - 150)
    -- LayX = RefX
    -- LayX = math.floor(LayX + LayW - 100)

    Cmd("ClearAll /nu")
    -- Macro Del LC prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 2)
    condition_string = "Lua 'if Confirm(\"Delete Layout Phaser Color PC" ..
        prefix:gsub('%D*', '') ..
        "?\") then; Cmd(\"Go macro " ..
        CurrentMacroNr .. "\"); else Cmd(\"Off macro " .. CurrentMacroNr .. "\"); end'" .. ' /nu'
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'ERASE\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1, 9 do
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
    Macro_Pool[CurrentMacroNr][7]:Set('Command',
        'Delete Preset 25. ' .. Preset_Ref .. 'Thru Preset 25.' .. Preset_Ref_End .. ' /nc')
    Macro_Pool[CurrentMacroNr][8]:Set('Command', 'Delete  Macro ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][9]:Set('Command', 'Delete  Macro ' .. CurrentMacroNr .. ' /nc')
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

-- end PhaserC_Construct.lua
