--[[
Releases:
* 2.4.2.2

Version:
* 2.0.0.0

Created by Richard Fontaine "RIRI", April 2024.
--]]

function PC_Construct_Layout(displayHandle, TLay, SeqNrStart, MacroNrStart, MatrickNrStart, MatrickNr, TLayNr, AppNr,
                             All_5_Current, All_5_NrStart, ColPath, SelectedGelNr, NbGroup, TLayNrRef,
                             NaLay, MaxColLgn, Favourite_Nr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
    Construct_Pool)
    local DEBUG = true
    local Macro_Pool = DataPool().Macros
    local Data_Pool_Nr = DataPool().No
    local All_5_NrEnd
    local Img = ShowData().MediaPools.Images:Children()
    local ImgNr
    for k in pairs(Img) do
        ImgNr = math.floor(Img[k].NO)
    end
    if ImgNr == nil then
        ImgNr = 1
    end

    local NrAppear
    -- local NrNeed
    local StApp_off = '\"Showdata.MediaPools.Images.[off_active_png]\"'
    local StApp_1_2 = '\"Showdata.MediaPools.Images.[1_2_active_png]\"'
    local StApp_2_3 = '\"Showdata.MediaPools.Images.[2_3_active_png]\"'
    local StApp_3_4 = '\"Showdata.MediaPools.Images.[3_4_active_png]\"'
    local StApp_1_3 = '\"Showdata.MediaPools.Images.[1_3_active_png]\"'
    local StApp_1_4 = '\"Showdata.MediaPools.Images.[1_4_active_png]\"'
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
    local NoRef = '1.0,1.0,1.0,1.0'

    local color_ref = {
        { RGBref = '1.0,0.0,0.0,0.5' },
        { RGBref = '0.0,0.0,1.0,0.5' },
        { RGBref = '1.0,0.5,0.0,0.5' },
        { RGBref = '0.0,1.0,1.0,0.5' },
        { RGBref = '0.0,1.0,0.0,0.5' },
        { RGBref = '1.0,0.0,1.0,0.5' },
        { RGBref = '1.0,1.0,0.0,0.5' },
        { RGBref = '0.0,1.0,0.5,0.5' },
        { RGBref = '1.0,0.0,0.5,0.5' },
        { RGBref = '0.5,1.0,0.0,0.5' },
        { RGBref = '0.0,0.5,1.0,0.5' },
        { RGBref = '0.5,0.0,1.0,0.5' },
        { RGBref = '0.5,0.5,1.0,0.5' },
        { RGBref = '0.5,1.0,0.5,0.5' },
        { RGBref = '0.5,0.5,0.5,0.5' },
    }


    local AppImp = {
        { Name = 'off',       StApp = StApp_off,       Nr = '', RGBref = NoRef },
        { Name = '1_2',       StApp = StApp_1_2,       Nr = '', RGBref = NoRef },
        { Name = '2_3',       StApp = StApp_2_3,       Nr = '', RGBref = NoRef },
        { Name = '3_4',       StApp = StApp_3_4,       Nr = '', RGBref = NoRef },
        { Name = '1_3',       StApp = StApp_1_3,       Nr = '', RGBref = NoRef },
        { Name = '1_4',       StApp = StApp_1_4,       Nr = '', RGBref = NoRef },
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
        { Name = 'GRP',     phasefrom = '0', phaseto = '0',   group = '0', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = '>>>',     phasefrom = '0', phaseto = '360', group = '0', wing = '0', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'O/E',     phasefrom = '0', phaseto = '360', group = '2', wing = '0', block = '0', shuffle = '0', transform = 'None' },
        { Name = '><',      phasefrom = '0', phaseto = '360', group = '0', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'SYM3',    phasefrom = '0', phaseto = '360', group = '3', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'SYM',     phasefrom = '0', phaseto = '360', group = '2', wing = '2', block = '0', shuffle = '0', transform = 'None' },
        { Name = 'RND',     phasefrom = '0', phaseto = '360', group = '0', wing = '0', block = '0', shuffle = '9', transform = 'None' },
        { Name = 'PAN><',   phasefrom = '0', phaseto = '360', group = '2', wing = '2', block = '0', shuffle = '0', transform = 'Mirror' },
        { Name = 'PANSYM3', phasefrom = '0', phaseto = '360', group = '0', wing = '2', block = '2', shuffle = '0', transform = 'Mirror' },
        { Name = 'PANSYM',  phasefrom = '0', phaseto = '360', group = '2', wing = '2', block = '2', shuffle = '0', transform = 'Mirror' },
    }

    local Argument_Ref = {
        { Name = '1_2',     Step = 2, Step1 = 0, Step2 = 1, Step3 = 0, Step4 = 0 },
        { Name = '2_3',     Step = 2, Step1 = 1, Step2 = 2, Step3 = 0, Step4 = 0 },
        { Name = '3_4',     Step = 2, Step1 = 2, Step2 = 3, Step3 = 0, Step4 = 0 },
        { Name = '1_3',     Step = 2, Step1 = 0, Step2 = 2, Step3 = 0, Step4 = 0 },
        { Name = '1_4',     Step = 2, Step1 = 0, Step2 = 3, Step3 = 0, Step4 = 0 },
        { Name = '2_4',     Step = 2, Step1 = 1, Step2 = 3, Step3 = 0, Step4 = 0 },
        { Name = '1_2_3',   Step = 3, Step1 = 0, Step2 = 1, Step3 = 2, Step4 = 0 },
        { Name = '2_3_4',   Step = 3, Step1 = 1, Step2 = 2, Step3 = 3, Step4 = 0 },
        { Name = '1_2_3_4', Step = 4, Step1 = 0, Step2 = 1, Step3 = 2, Step4 = 3 },
    }

    local Preset_25_Ref = {}
    local All_Call_Ref = {}
    local All_Call_Y

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
    local CurrentSeqNr
    local CurrentMacroNr
    local UsedW
    local UsedH
    local condition_string
    local Preset_Ref
    local Preset_Ref_End
    local Phaser_Off
    local Phaser_Ref
    local Sequence_Ref
    local Sequence_Ref_End
    local AppRef
    local Ligne_Inc = false
    local ColLgnCount = 0

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
    -- for g in pairs(SelectedGrp) do
    --     SelectedGrpName[g] = SelectedGrp[g]:gsub(' ', '_')
    --     SelectedGrpName[g] = SelectedGrpName[g]:gsub("'", '')
    --     SelectedGrpNo[g] = SelectedGrpNo[g]:gsub("'", '')
    -- end
    -- fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart

    -- Build Tag
    PC_Build_Tag(prefix, NbGroup)
    -- end Build Tag

    -- Create MAtricks
    MatrickNr = math.floor(MatrickNrStart)
    PC_Create_Matricks(MatrickNr, Argument_Matricks, surfix, prefix, Construct_Pool)

    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. prefix .. NaLay .. "")
    -- Create new Layout View
    PC_Check_Size_Pool(TLayNr, Layout_Object)
    Layout_Object:Create(TLayNr)
    Layout_Object[TLayNr]:Set('Name', prefix .. NaLay)

    SelectedGelNr = tonumber(SelectedGelNr)
    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    -- Create Appearances
    NrAppear, AppRef = PC_Create_Appearances(AppNr, prefix, TCol, NrAppear, StColCode,
        StColName, StringColName, AppRef, Construct_Pool)

    -- Create Preset 25
    All_5_NrEnd, All_5_Current = PC_Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix,
        All_5_NrEnd, All_5_Current, Construct_Pool)

    -- PC_Create_Preset_Ref_1234
    All_5_Current, Preset_Ref = PC_Create_Preset_Ref_1234(All_5_Current, SelectedGelNr, Construct_Pool)
    Preset_Ref_End = Preset_Ref + 3

    -- PC_Create_Phaser
    Phaser_Off, All_5_Current = PC_Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref, Phaser_Off,
        Construct_Pool)

    -- Copy_Phaser_Ref
    Phaser_Ref, All_5_Current, Preset_25_Ref = Copy_Phaser_Ref(Phaser_Off, All_5_Current, Phaser_Ref, Preset_25_Ref,
        Construct_Pool)

    -- PC_Create_Active_Appearances
    NrAppear = PC_Create_Active_Appearances(AppImp, NrAppear, prefix)

    -- PC_Create_Group_Appearances
    NrAppear = PC_Create_Group_Appearances(AppImp, NrAppear, prefix, NbGroup, color_ref, Construct_Pool)

    -- PC_Create_Group_Sequence
    CurrentSeqNr, Sequence_Ref, Sequence_Ref_End = PC_Create_Group_Sequence(NbGroup, Phaser_Off,
        CurrentSeqNr, prefix, Sequence_Ref, Sequence_Ref_End, Construct_Pool, Call_Pool)

    -- PC_Create_Layout_Phaser
    CurrentMacroNr, CurrentSeqNr, LayNr, LayY, ColLgnCount, Ligne_Inc = PC_Create_Layout_Phaser(TLayNr, NaLay,
        SelectedGelNr, CurrentSeqNr, Preset_Ref, MaxColLgn, RefX, LayY, LayH, AppNr, LayW, StColName, CurrentMacroNr,
        ColPath, prefix, All_5_NrStart, Construct_Pool)
        
        -- PC_Create_Layout_FixGroup
        CurrentSeqNr, CurrentMacroNr, All_Call_Ref, All_Call_Y, LayNr = PC_Create_Layout_FixGroup(CurrentMacroNr,
            CurrentSeqNr, LayNr, LayY, RefX, LayH, LayW, TLayNr, NaLay, NbGroup, Argument_Matricks,
            surfix, prefix, AppImp, Argument_Ref, AppRef, Preset_25_Ref, Phaser_Off, Phaser_Ref, All_Call_Ref, All_Call_Y,
            Data_Pool_Nr, Ligne_Inc, Construct_Pool)
end -- end Construct_Layout

local function to_dev()
    -- PC_Create_All_Call_Layout
    CurrentMacroNr, LayX, LayNr = PC_Create_All_Call_Layout(CurrentMacroNr, LayNr, LayY, RefX, LayH, LayW, TLayNr,
        SelectedGrp, SelectedGrpName, prefix, All_Call_Ref, All_Call_Y, AppImp, Data_Pool_Nr)
    -- PC_Create_Macro_Priority
    CurrentMacroNr, LayX, LayNr = PC_Create_Macro_Priority(CurrentMacroNr, TLayNr, LayNr, RefX, LayY, LayW, LayH, prefix,
        Sequence_Ref, Sequence_Ref_End, Data_Pool_Nr)
    -- add Favourites
    local Macro_Num_Start
    local Macro_Num_End
    CurrentMacroNr, Macro_Num_End = Create_PC_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Data_Pool_Nr, Favourite_Nr)
    Macro_Num_Start = CurrentMacroNr + 1
    Create_PC_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Data_Pool_Nr, Ligne_Inc, Favourite_Nr, LayX)

    Cmd("ClearAll /nu")
    -- Macro Del PC prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 2)
    condition_string = "Lua 'if Confirm(\"Delete Layout Phaser Color PC" ..
        prefix:gsub('%D*', '') ..
        "?\") then; Cmd(\"Go macro " ..
        CurrentMacroNr .. "\"); else Cmd(\"Off macro " .. CurrentMacroNr .. "\"); end'" .. ' /nu'
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'ERASE\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1, 11 do
        Cmd('Insert')
    end
    Cmd('ChangeDestination Root')
    Macro_Pool[CurrentMacroNr]:Set('name', 'Erase [' .. prefix:gsub('_', '') .. ']')
    Macro_Pool[CurrentMacroNr][1]:Set('Command', condition_string)
    Macro_Pool[CurrentMacroNr][1]:Set('Wait', 'Go')
    Macro_Pool[CurrentMacroNr][2]:Set('Command', 'Delete Sequence ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][3]:Set('Command', 'Delete Sequence o' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][4]:Set('Command', 'Delete Layout ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][5]:Set('Command', 'Delete Matricks ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][6]:Set('Command', 'Delete Appearance ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][7]:Set('Command', 'Delete Preset 25. ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][8]:Set('Command',
        'Delete DataPool ' .. Data_Pool_Nr .. ' Macro ' .. Macro_Num_Start .. ' Thru ' .. Macro_Num_End .. ' /nc')
    Macro_Pool[CurrentMacroNr][9]:Set('Command',
        'Delete Preset 25. ' .. Preset_Ref .. 'Thru Preset 25.' .. Preset_Ref_End .. ' /nc')
    Macro_Pool[CurrentMacroNr][10]:Set('Command', 'Delete  Macro ' .. prefix .. '*' .. ' /nc')
    Macro_Pool[CurrentMacroNr][11]:Set('Command', 'Delete  Macro ' .. CurrentMacroNr .. ' /nc')
    -- end Macro Del PC prefix

    -- dimension of layout & scal it
    for k in pairs(DataPool().Layouts:Children()) do
        if (math.floor(TLayNr) == math.floor(tonumber(DataPool().Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    UsedW = DataPool().Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = DataPool().Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)
    Cmd('Select Layout ' .. TLayNr)
end

-- end PhaserC_Construct.lua
