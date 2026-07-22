--[[
Releases:
* 2.4.2.2

Version:
* 2.0.0.0

Created by Richard Fontaine "RIRI", July 2026.
--]]

function PC_Build_Tag(prefix, NbGroup)
    local TagObject      = Root().ShowData.Tags
    local TagObject_C    = Root().ShowData.Tags:Children()
    local PC_TAGS_CHECKS = {}
    local PC_TAGS        = {}
    local Tag_Type       = {}
    local Grp1234        = { "COLOR_1", "COLOR_2", "COLOR_3", "COLOR_4" }
    for t = 1, NbGroup do
        table.insert(PC_TAGS, prefix .. 'Group_Ref_' .. t)
        table.insert(Tag_Type, 'Kill Delayed')
        table.insert(PC_TAGS, prefix .. 'Group_Matricks_' .. t)
        table.insert(Tag_Type, 'Kill Delayed')
        table.insert(PC_TAGS, prefix .. 'Group_' .. t)
        table.insert(Tag_Type, 'Kill Delayed')
    end
    for t = 1, 4 do
        table.insert(PC_TAGS, prefix .. Grp1234[t])
        table.insert(Tag_Type, 'Kill Delayed')
    end
    table.insert(PC_TAGS, prefix .. 'Group_ALL')
    table.insert(Tag_Type, 'Kill Delayed')
    table.insert(PC_TAGS, prefix .. 'Call_Group_ALL')
    table.insert(Tag_Type, 'None')

    for i = 1, #PC_TAGS, 1 do
        PC_TAGS_CHECKS[i] = false
    end

    for v in pairs(PC_TAGS) do
        for k in pairs(TagObject_C) do
            if PC_TAGS[v] == TagObject_C[k].Name then
                PC_TAGS_CHECKS[v] = true
                break
            end
        end
    end
    for k in pairs(PC_TAGS_CHECKS) do
        if PC_TAGS_CHECKS[k] == false then
            local nr = TagObject:Acquire()
            TagObject[nr.No]:Set('Name', PC_TAGS[k])
            TagObject[nr.No]:Set('TAGTYPE', Tag_Type[k])
        end
    end
end

function PC_Create_Matricks(MatrickNr, Argument_Matricks, surfix, prefix, Construct_Pool)
    local DEBUG = false
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)

    if Debug then Echo('pool ' .. Construct_Pool .. ' Matrick ' .. MatrickNr) end
    PC_Check_Size_Pool(MatrickNr, MatrickObject)

    for axes in pairs(surfix) do
        for g in pairs(Argument_Matricks) do
            MatrickObject:Acquire()
            MatrickObject:Create(MatrickNr)
            MatrickObject[MatrickNr]:Set('Name', prefix .. surfix[axes] .. Argument_Matricks[g].Name:gsub('\'', ''))
            MatrickObject[MatrickNr]:Set('PhaseFrom' .. surfix[axes], Argument_Matricks[g].phasefrom)
            MatrickObject[MatrickNr]:Set('PhaseTo' .. surfix[axes], Argument_Matricks[g].phaseto)
            MatrickObject[MatrickNr]:Set(surfix[axes] .. 'Group', Argument_Matricks[g].group)
            MatrickObject[MatrickNr]:Set(surfix[axes] .. 'Wings', Argument_Matricks[g].wing)
            MatrickObject[MatrickNr]:Set(surfix[axes] .. 'Block', Argument_Matricks[g].block)
            MatrickObject[MatrickNr]:Set(surfix[axes] .. 'Shuffle', Argument_Matricks[g].shuffle)
            MatrickObject[MatrickNr]:Set('PhaserTransform', Argument_Matricks[g].transform)
            MatrickNr = math.floor(MatrickNr + 1)
        end
    end
end

function PC_Create_Appearances(AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName, AppRef, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)

    AppObject:Acquire()
    AppRef = AppNr
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    NrAppear = math.floor(AppNr)
    PC_Check_Size_Pool(NrAppear, AppObject)
    AppObject:Create(NrAppear)
    AppObject[NrAppear]:Set('Name', prefix .. 'Label')
    AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
    AppObject[NrAppear]:Set('Color', '0, 0, 0, 1')

    NrAppear = math.floor(AppNr + 1)
    for col in ipairs(TCol) do
        StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        StAppNameOn = prefix .. StringColName .. "_On"
        StAppNameOff = prefix .. StringColName .. "_Off"
        PC_Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        AppObject[NrAppear]:Set('Name', StAppNameOn:gsub('"', ''))
        AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
        PC_Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        AppObject[NrAppear]:Set('Name', StAppNameOff:gsub('"', ''))
        AppObject[NrAppear]:Set('Appearance', StAppOff:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
    end
    return NrAppear, AppRef
end

function PC_Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current,
                             Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)

    CmdIndirectWait("ClearAll /nu")
    CmdIndirectWait('Fixture Thru')
    for col in ipairs(TCol) do
        Preset25Object:Acquire()
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        local convert = prefix .. StringColName
        local Name = string.gsub(convert, " ", "_")
        Preset25Object:Create(All_5_Current)
        Preset25Object[All_5_Current]:Set('Name', All_5_Current .. "_" .. Name)

        CmdIndirectWait('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        CmdIndirectWait('Store ' .. Preset25Object[All_5_Current] .. '/u/nc')
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end
    CmdIndirectWait("ClearAll /nu")
    return All_5_NrEnd, All_5_Current
end

function PC_Create_Preset_Ref_1234(All_5_Current, SelectedGelNr, Construct_Pool)
    local Preset25Object = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]
    Preset25Object:Set('PresetMode', 'Universal')

    CmdIndirectWait("ClearAll /nu")
    CmdIndirectWait('Fixture Thru')
    for i = 1, 4 do
        Preset25Object:Acquire()
        Preset25Object:Create(All_5_Current)
        CmdIndirectWait('At Gel ' .. SelectedGelNr .. ".1")
        CmdIndirectWait('Store ' .. Preset25Object[All_5_Current] .. '/u/nc')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    local Preset_Ref = All_5_Current - 4
    CmdIndirectWait("ClearAll /nu")
    return All_5_Current, Preset_Ref
end

function PC_Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref, Phaser_Off, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)
    local transition
    local Preset_cal

    CmdIndirectWait("ClearAll /nu")
    CmdIndirectWait('Fixture Thru')
    CmdIndirectWait('Attribute "ColorRGB_R" At Relative 0')
    CmdIndirectWait('Attribute "ColorRGB_G" At Relative 0')
    CmdIndirectWait('Attribute "ColorRGB_B" At Relative 0')
    CmdIndirectWait('Attribute "ColorRGB_W" At Relative 0')
    CmdIndirectWait('Store DataPool ' .. Construct_Pool .. ' Preset 25.' .. All_5_Current .. '/u/nc')
    Preset25Object[All_5_Current]:Set('Name', All_5_Current .. "_" .. prefix .. "off")
    Phaser_Off = All_5_Current
    All_5_Current = math.floor(All_5_Current + 1)
    for i = 1, 3 do
        if (i == 1) then
            transition = 100
        elseif (i == 2) then
            transition = 50
        elseif (i == 3) then
            transition = 0
        end
        CmdIndirectWait("ClearAll /nu")
        CmdIndirectWait('Fixture Thru')
        for g in ipairs(Argument_Ref) do
            for st = 1, Argument_Ref[g].Step do
                if (st == 1) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step1
                elseif (st == 2) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step2
                elseif (st == 3) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step3
                elseif (st == 4) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step4
                end
                CmdIndirectWait('Next Step')
                CmdIndirectWait('At DataPool ' .. Construct_Pool .. ' Preset 25.' .. Preset_cal .. '')
            end

            for st = 1, Argument_Ref[g].Step do
                CmdIndirectWait('Attribute "ColorRGB_R"')
                CmdIndirectWait('At Transition Percent ' .. transition)
                CmdIndirectWait('Attribute "ColorRGB_G"')
                CmdIndirectWait('At Transition Percent ' .. transition)
                CmdIndirectWait('Attribute "ColorRGB_B"')
                CmdIndirectWait('At Transition Percent ' .. transition)
                CmdIndirectWait('Attribute "ColorRGB_W"')
                CmdIndirectWait('At Transition Percent ' .. transition)
                CmdIndirectWait('Previous Step')
            end

            CmdIndirectWait('Store DataPool ' .. Construct_Pool .. ' Preset 25.' .. All_5_Current .. '/u/nc')
            Preset25Object[All_5_Current]:Set('Name', prefix .. Argument_Ref[g].Name)
            All_5_Current = math.floor(All_5_Current + 1)
        end
    end
    CmdIndirectWait("ClearAll /nu")
    return Phaser_Off, All_5_Current
end

function Copy_Phaser_Ref(Phaser_Off, All_5_Current, Phaser_Ref, Preset_25_Ref, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)

    Preset25Object:Set('PresetMode', 'Universal')
    Phaser_Ref = All_5_Current
    Preset_25_Ref[1] = Phaser_Off
    for i = 1, 9 do
        Preset_25_Ref[i + 1] = All_5_Current
        local cop = Phaser_Off + i
        Cmd('Copy DataPool ' .. Construct_Pool .. ' Preset 25.' .. cop ..
            ' At DataPool ' .. Construct_Pool .. ' Preset 25.' .. All_5_Current .. '')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    return Phaser_Ref, All_5_Current, Preset_25_Ref
end

function PC_Create_Active_Appearances(AppImp, NrAppear, prefix)
    local AppObject = Root().ShowData.Appearances
    AppObject:Acquire()
    for q in pairs(AppImp) do
        AppImp[q].Nr = math.floor(NrAppear)
        PC_Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        AppObject[NrAppear]:Set('Name', prefix .. AppImp[q].Name)
        AppObject[NrAppear]:Set('Appearance', AppImp[q].StApp:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', AppImp[q].RGBref)
        NrAppear = math.floor(NrAppear + 1)
    end
    return NrAppear
end

function PC_Create_Group_Appearances(AppImp, NrAppear, prefix, NbGroup, color_ref, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)

    AppObject:Acquire()
    local a = 1
    for grp = 1, NbGroup do
        for q = 1, 20 do
            AppImp[q].Nr = math.floor(NrAppear)
            PC_Check_Size_Pool(NrAppear, AppObject)
            AppObject:Create(NrAppear)
            AppObject[NrAppear]:Set('Name', prefix .. AppImp[q].Name .. 'Group' .. grp)
            AppObject[NrAppear]:Set('Appearance', AppImp[q].StApp:gsub('"', ''))
            AppObject[NrAppear]:Set('Color', color_ref[a].RGBref)
            NrAppear = math.floor(NrAppear + 1)
        end
        a = a + 1
        if a > 15 then
            a = 1
        end
    end
    return NrAppear
end

function PC_Create_Group_Sequence(NbGroup, Phaser_Off, CurrentSeqNr, prefix, Sequence_Ref, Sequence_Ref_End,
                                  Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr = PC_Get_Object(
        Construct_Pool)
    local GroupsObject                                                                             = DataPool().Groups


    Sequence_Ref = CurrentSeqNr
    for g = 1, NbGroup do
        PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Group_' .. g)
        PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
        SequenceObject[CurrentSeqNr]:Set('SwapProtect', 'Yes')
        SequenceObject[CurrentSeqNr]:Set('KillProtect', 'Yes')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Insert()
        SequenceObject[CurrentSeqNr][3][1]:Acquire('StandardRecipe')
        SequenceObject[CurrentSeqNr][3][1][1]:Set('Selection', GroupsObject[1])
        SequenceObject[CurrentSeqNr][3][1][1]:Set('Values', Preset25Object[Phaser_Off])
        SequenceObject[CurrentSeqNr][3][1][1]:Set('SelectionMode', 'Normal')
        SequenceObject[CurrentSeqNr][3][1][1]:Set('Enabled', 'Yes')

        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    Sequence_Ref_End = math.floor(CurrentSeqNr - 1)
    return CurrentSeqNr, Sequence_Ref, Sequence_Ref_End
end

function PC_Create_Layout_Phaser(TLayNr, NaLay, SelectedGelNr, CurrentSeqNr, Preset_Ref, MaxColLgn, RefX, LayY,
                                 LayH, AppNr, LayW, StColName, CurrentMacroNr, ColPath, prefix, All_5_NrStart,
                                 Construct_Pool)
    local DEBUG                  = false
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)
    local AppearObject           = Root().ShowData.Appearances
    local TCol
    local NrNeed
    local LayNr                  = 1
    local Grp1234                = { "COLOR_1", "COLOR_2", "COLOR_3", "COLOR_4" }
    local ColLgnCount            = 0
    local Ligne_Inc              = false
    local TagObject_PC           = Root().ShowData.Tags:Children()
    local Group_Tag              = {}

    for ta = 1, 4 do
        for v in ipairs(TagObject_PC) do
            if TagObject_PC[v].Name == prefix .. Grp1234[ta] then
                table.insert(Group_Tag, TagObject_PC[v])
            end
        end
    end


    -- CmdIndirectWait('Select Layout ' .. TLayNr)

    TCol = ColPath:Children()[SelectedGelNr]
    -- check how long Gel

    Preset_Ref = math.floor(Preset_Ref)
    MaxColLgn = tonumber(MaxColLgn)

    -- Group 1234
    for g in ipairs(Grp1234) do
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        NrNeed = math.floor(AppNr + 1)
        LayNr = math.floor(LayNr)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('Note', Grp1234[g])
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', g)
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextSize', 32)


        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)


        -- create color 1234
        for col in ipairs(TCol) do
            col_count = col_count + 1
            StColName = TCol[col].name

            -- Create Sequences
            PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
            SequenceObject:Create(CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('Name', prefix .. StColName .. '_' .. Grp1234[g])
            PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
            SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
            SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed + 1])
            SequenceObject[CurrentSeqNr]:Set('Tags', Group_Tag[g].Name .. ':0')

            -- Create Macros
            local add_all5 = tonumber(All_5_NrStart + TCol[col].no - 1)
            PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
            MacroObject:Create(CurrentMacroNr)
            MacroObject[CurrentMacroNr]:Set('Name', prefix .. StColName .. "_" .. Grp1234[g])
            MacroObject[CurrentMacroNr]:Insert(1)
            MacroObject[CurrentMacroNr][1]:Set('Command',
                'Copy ' .. Preset25Object[add_all5] .. ' At ' .. Preset25Object[Preset_Ref] .. ' /o /nu')


            -- Add Cmd to Sequences
            SequenceObject[CurrentSeqNr][3]:Set('No', 1)
            SequenceObject[CurrentSeqNr][3]:Create(1)
            SequenceObject[CurrentSeqNr][3][1]:Insert()
            SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])
            SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])

            -- end Cmd to Sequences

            -- Add Sequences to Layout
            if Debug then Echo('add sequence to layout') end

            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq_' .. Grp1234[g])
            PC_Set_Def(TLayNr, Nr, Layout_Object)
            -- end Sequences to Layout

            NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color

            if (col_count ~= MaxColLgn) then
                LayX = math.floor(LayX + LayW + 20)
            else
                LayX = RefX
                LayX = math.floor(LayX + LayW + 20)
                LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
                LayY = math.floor(LayY - LayH)
                col_count = 0
                if (g == 1) then ColLgnCount = math.floor(ColLgnCount + 1) end
                Ligne_Inc = true
            end
            LayNr = math.floor(LayNr + 1)

            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end
        -- end create color 1234

        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
        Preset_Ref = math.floor(Preset_Ref + 1)
    end
    -- end Group 1234

    return CurrentMacroNr, CurrentSeqNr, LayNr, LayY, ColLgnCount, Ligne_Inc
end

function PC_Create_Layout_FixGroup(CurrentMacroNr, CurrentSeqNr, LayNr, LayY, RefX, LayH, LayW, TLayNr, NbGroup,
                                   Argument_Matricks, surfix, prefix, AppImp, AppRef, Preset_25_Ref, Phaser_Off,
                                   Phaser_Ref, All_Call_Ref, All_Call_Y, Ligne_Inc, Construct_Pool, Call_Pool)
    local DEBUG                  = false
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)
    local AppearObject           = Root().ShowData.Appearances
    local Groups_Pool            = 1
    local GroupsObject           = Root().ShowData.DataPools[Groups_Pool].Groups:Children()

    LayY                         = math.floor(LayY - 20) -- Add offset for Layout Element distance
    LayY                         = math.floor(LayY - LayH)
    All_Call_Y                   = LayY
    LayY                         = math.floor(LayY - 20) -- Add offset for Layout Element distance
    LayY                         = math.floor(LayY - LayH)
    local LayX                   = RefX
    local TagObject_PC           = Root().ShowData.Tags:Children()
    local Group_Tag              = {}
    local Group_Tag_Ma           = {}
    local Group_Tag_Call
    for ta = 1, NbGroup do
        for v in ipairs(TagObject_PC) do
            if TagObject_PC[v].Name == prefix .. 'Group_Ref_' .. ta then
                table.insert(Group_Tag, TagObject_PC[v].Name)
            elseif TagObject_PC[v].Name == prefix .. 'Group_Matricks_' .. ta then
                table.insert(Group_Tag_Ma, TagObject_PC[v].Name)
            elseif TagObject_PC[v].Name == prefix .. 'Call_Group_ALL' then
                Group_Tag_Call = TagObject_PC[v].Name
            end
        end
    end

    for g = 1, NbGroup do
        All_Call_Ref[g] = {}
    end

    PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Inv')
    PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppRef])

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go+ DataPool ' .. Construct_Pool .. ' Sequence Thru if Tag "' .. prefix .. 'Call_Group_ALL"')
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[AppRef + 1])

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', -1220)
    Layout_Object[TLayNr][Nr.No]:Set('posy', -540)
    Layout_Object[TLayNr][Nr.No]:Set('width', 100)
    Layout_Object[TLayNr][Nr.No]:Set('height', 100)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Flash')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', 'INV')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all Inv call')
    PC_Set_Def(TLayNr, Nr, Layout_Object)

    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'ALL')
    PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppRef])

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go+ Cue 2 DataPool ' .. Construct_Pool .. ' Sequence Thru if Tag "' .. prefix .. 'Call_Group_ALL"')
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[AppRef + 1])

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', -1100)
    Layout_Object[TLayNr][Nr.No]:Set('posy', -540)
    Layout_Object[TLayNr][Nr.No]:Set('width', 100)
    Layout_Object[TLayNr][Nr.No]:Set('height', 100)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Flash')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', 'ALL')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all ALL call')
    PC_Set_Def(TLayNr, Nr, Layout_Object)

    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    local on_appobject = PC_Search_Object_App('PC_on_select')
    local off_appobject = PC_Search_Object_App('PC_off_select')

    for g = 1, NbGroup do
        LayX = math.floor(LayX - (LayW + 20)) -- Max Y Position minus hight from element. 0 are at the Bottom!
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', GroupsObject[1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Group' .. g)
        PC_Set_Def(TLayNr, Nr, Layout_Object)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityobjectname', 'Visible')
        Layout_Object[TLayNr][Nr.No]:Set('Action', 0)

        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Select_Group_' .. g)
        for v = 1, 7 do
            MacroObject[CurrentMacroNr]:Insert(v)
        end
        local seq_id = PC_Search_Object('o' .. prefix .. 'Group_' .. g , SequenceObject)
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' .. Construct_Pool ..
            ' Sequence ' .. seq_id.No .. ' Cue 1 Part 0.1 Property "Selection"')
        MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "PC_Fonction" 3')
        MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "PC_Layout" ' .. TLayNr)
        MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "PC_Element" ' .. Nr.No)
        MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "PC_Data_Pool" ' .. Construct_Pool)
        MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "PC_Sequence" ' .. seq_id.No)
        MacroObject[CurrentMacroNr][7]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'PhaserColor_V2_4'.'PC_View'")

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Macro set Group ' .. g)
        PC_Set_Def(TLayNr, Nr, Layout_Object)

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)

        All_Call_Ref[g][1] = CurrentSeqNr
        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)

        PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Active_Group_' .. g)
        PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', on_appobject)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Insert()
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', off_appobject)
        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][4]:Set('No', 2)
        SequenceObject[CurrentSeqNr][4]:Create(1)
        SequenceObject[CurrentSeqNr][4][1]:Insert()
        SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', on_appobject)
        SequenceObject[CurrentSeqNr]:Set('Tags', Group_Tag_Call .. ':0')

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Call on off Grp ' .. g)
        PC_Set_Def(TLayNr, Nr, Layout_Object)

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        local Seq_Start = CurrentSeqNr
        local Seq_End = Seq_Start + 8

        for i = 1, 10 do
            All_Call_Ref[g][i + 1] = CurrentSeqNr

            -- Create Seq
            PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
            SequenceObject:Create(CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Group_' .. g .. '_' .. AppImp[i].Name)
            PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
            SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
            SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
            SequenceObject[CurrentSeqNr]:Set('Tags', Group_Tag[g] .. ':0')

            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr]:Set('Appearance', prefix .. AppImp[i].Name .. 'Group' .. g)
            SequenceObject[CurrentSeqNr][3]:Set('No', 1)
            SequenceObject[CurrentSeqNr][3]:Create(1)
            SequenceObject[CurrentSeqNr][3][1]:Insert()
            SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', prefix .. AppImp[i].Name)
            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr][4]:Set('No', 2)
            SequenceObject[CurrentSeqNr][4]:Create(1)
            SequenceObject[CurrentSeqNr][4][1]:Insert()
            SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', prefix .. AppImp[i].Name .. 'Group' .. g)
            -- end Create Seq

            -- Create Macros
            PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
            MacroObject:Create(CurrentMacroNr)
            MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Group_' .. g .. '_' .. AppImp[i].Name)
            MacroObject[CurrentMacroNr]:Insert(1)
            MacroObject[CurrentMacroNr][1]:Set('Command',
                'Assign ' .. Preset25Object[Preset_25_Ref[i]] .. ' At DataPool ' ..
                Construct_Pool .. '  Sequence o' .. prefix .. 'Group_' .. g .. ' Cue 1 Part 0.1')
            SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])
            -- end Create Macros

            -- Assign Seq to Layout
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Call' .. AppImp[i].Name .. 'Group' .. g)
            PC_Set_Def(TLayNr, Nr, Layout_Object)
            -- end Assign Seq to Layout

            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end

        Seq_Start = CurrentSeqNr
        Seq_End = Seq_Start + 9

        for i = 11, 20 do
            All_Call_Ref[g][i + 1] = CurrentSeqNr

            -- Create Seq
            PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
            SequenceObject:Create(CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Group_' .. g .. '_' .. AppImp[i].Name)
            PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
            SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
            SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
            SequenceObject[CurrentSeqNr]:Set('Tags', Group_Tag_Ma[g] .. ':0')

            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr]:Set('Appearance', prefix .. AppImp[i].Name .. 'Group' .. g)
            SequenceObject[CurrentSeqNr][3]:Set('No', 1)
            SequenceObject[CurrentSeqNr][3]:Create(1)
            SequenceObject[CurrentSeqNr][3][1]:Insert()
            SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', prefix .. AppImp[i].Name)
            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr][4]:Set('No', 2)
            SequenceObject[CurrentSeqNr][4]:Create(1)
            SequenceObject[CurrentSeqNr][4][1]:Insert()
            SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', prefix .. AppImp[i].Name .. 'Group' .. g)
            -- end Create Seq

            -- Create Macros
            PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
            MacroObject:Create(CurrentMacroNr)
            MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Group_' .. g .. '_' .. AppImp[i].Name)
            MacroObject[CurrentMacroNr]:Insert(1)
            MacroObject[CurrentMacroNr][1]:Set('Command', 'Assign DataPool ' .. Construct_Pool .. ' MAtricks ' ..
                prefix .. surfix[1] .. Argument_Matricks[i - 10].Name .. ' At DataPool ' ..
                Construct_Pool .. '  Sequence o' .. prefix .. 'Group_' .. g .. ' Cue 1 Part 0.1')
            SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])
            -- end Create Macros

            -- Assign Seq to Layout
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Call' .. AppImp[i].Name .. 'Group' .. g)
            PC_Set_Def(TLayNr, Nr, Layout_Object)
            -- end Assign Seq to Layout

            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
        LayY = math.floor(LayY - LayH)
        LayX = RefX
    end

    -- Create Seq 100 50 0
    PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. '100_50_0')
    PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', prefix .. 'cent')
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Insert()
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', prefix .. 'cent')
    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][4]:Set('No', 2)
    SequenceObject[CurrentSeqNr][4]:Create(1)
    SequenceObject[CurrentSeqNr][4][1]:Insert()
    SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', prefix .. 'cinquante')
    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][5]:Set('No', 3)
    SequenceObject[CurrentSeqNr][5]:Create(1)
    SequenceObject[CurrentSeqNr][5][1]:Insert()
    SequenceObject[CurrentSeqNr][5][1]:Set('Appearance', prefix .. 'zero')
    -- end Create Seq 100 50 0

    -- Create Macros
    PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'cent')
    for a = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(a)
        MacroObject[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Off + a .. ' At DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end
    SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'cinquante')
    for a = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(a)
        MacroObject[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Off + a + 9 .. ' At DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end
    SequenceObject[CurrentSeqNr][4][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'zero')
    for a = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(a)
        MacroObject[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Off + a + 18 .. ' At DataPool ' .. Construct_Pool ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end
    SequenceObject[CurrentSeqNr][5][1]:Set('Command', 'Go+ ' .. MacroObject[CurrentMacroNr])
    -- end Create Macros

    -- Assign Seq to Layout
    if Ligne_Inc then
        LayY = -540
    else
        LayY = -60
    end

    -- Assign Seq to Layout
    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Transition')
    PC_Set_Def(TLayNr, Nr, Layout_Object)
    -- end Assign Seq to Layout

    LayX = math.floor(LayX + LayW + 20)
    LayNr = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)

    return CurrentSeqNr, CurrentMacroNr, All_Call_Ref, All_Call_Y, LayNr
end

function PC_Create_All_Call_Layout(CurrentMacroNr, LayNr, LayY, RefX, LayH, LayW, TLayNr,
                                   NbGroup, prefix, All_Call_Ref, All_Call_Y, AppImp, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)

    LayY = math.floor(All_Call_Y)
    local LayX = RefX
    LayX = math.floor(LayX + LayW + 20)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    local Ref_Macro_Call_off
    local Ref_Macro_Call_on
    local Ref_Macro_Call_Fonction = CurrentMacroNr
    local allmacroallstart = CurrentMacroNr
    local allmacroallend

    -- Create Macros
    for i = 1, 20 do
        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. "ALL" .. AppImp[i].Name)
        for g = 1, NbGroup do
            MacroObject[CurrentMacroNr]:Insert(g)
            MacroObject[CurrentMacroNr][g]:Set('Command', 'Go+ Cue 1 DataPool ' .. Construct_Pool ..
                ' Sequence ' .. All_Call_Ref[g][i + 1] .. '')
            All_Call_Ref[g][20 + i] = CurrentMacroNr
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end
    Ref_Macro_Call_off = CurrentMacroNr
    for g = 1, NbGroup do
        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. "Group_" .. g .. 'Alloff')

        for i = 1, 20 do
            MacroObject[CurrentMacroNr]:Insert(i)
            MacroObject[CurrentMacroNr][i]:Set('Command', 'Set DataPool ' .. Construct_Pool ..
                ' Macro ' .. All_Call_Ref[g][20 + i] .. '.' .. g .. ' Property Enabled 0')
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    Ref_Macro_Call_on = CurrentMacroNr
    for g = 1, NbGroup do
        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. "Group_" .. g .. 'Allon')
        for i = 1, 20 do
            MacroObject[CurrentMacroNr]:Insert(i)
            MacroObject[CurrentMacroNr][i]:Set('Command', 'Set DataPool ' .. Construct_Pool ..
                ' Macro ' .. All_Call_Ref[g][20 + i] .. '.' .. g .. ' Property Enabled 1')
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end

    for g = 1, NbGroup do
        SequenceObject[All_Call_Ref[g][1]][3][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Ref_Macro_Call_off + g - 1)
        SequenceObject[All_Call_Ref[g][1]][4][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Ref_Macro_Call_on + g - 1)
    end

    local address = PC_Search_Addr_Nat_App('arrow_down_png')
    for i = 1, 20 do
        -- Assign Macro to Layout
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[Ref_Macro_Call_Fonction + i - 1])
        Layout_Object[TLayNr][Nr.No]:Set('Appearance', address)
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'call ligne')
        PC_Set_Def(TLayNr, Nr, Layout_Object)

        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
    end
    allmacroallend = CurrentMacroNr - 1
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    return CurrentMacroNr, LayX, LayNr, allmacroallstart, allmacroallend
end

function PC_Create_Macro_Priority(CurrentMacroNr, TLayNr, LayNr, LayX, LayY, LayW, LayH, prefix, Sequence_Ref,
                                  Sequence_Ref_End, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)
    LayY = 560
    CurrentMacroNr = math.floor(CurrentMacroNr)
    PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Priority')

    for i = 1, 7 do
        MacroObject[CurrentMacroNr]:Insert(i)
    end
    local Seq_message = 'SetUserVariable "PC_Sequence" "' .. Sequence_Ref .. '"'
    Seq_message = string.gsub(Seq_message, "'", "")
    MacroObject[CurrentMacroNr]:Set('name', '' .. prefix .. 'Priority')
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' .. Construct_Pool ..
        '  Sequence ' .. Sequence_Ref .. " Thru " .. Sequence_Ref_End .. ' Property "priority"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "PC_Fonction" 1')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "PC_Layout" ' .. TLayNr)
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "PC_Data_Pool" ' .. Construct_Pool)
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "PC_Sequence" ' .. Sequence_Ref)
    MacroObject[CurrentMacroNr][7]:Set('Command',
    "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'PhaserColor_V2_4'.'PC_View'")
    
    local address = PC_Search_Addr_Nat_App('p_htp_png')
    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', address)
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Priority')
    PC_Set_Def(TLayNr, Nr, Layout_Object)
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', address)
    
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "PC_Element" ' .. Nr.No)

    LayX = math.floor(LayX + LayW + 20)
    LayNr = math.floor(LayNr + 1)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    return CurrentMacroNr, LayX, LayNr
end

-- end PhaserC_Cmd.lua
