--[[
Releases:
* 2.3.2.0

Version:
* 2.2.0.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]

function LC_Create_Phase_Sequence(LayY, LayX, LayW, a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, CurrentMacroNr,
                                  prefix, surfix, MatrickNrStart, TLayNr, Phase_Element, MatrickNr, AppImp, MakeX, LayH,
                                  RefX, Group_Element, Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- Setup Phase Sequence
    prefix                                               = 'o' .. prefix
    -- Add offset for Layout Element distance
    LayY                                                 = math.floor(LayY - 150)
    LayX                                                 = RefX
    LayX                                                 = math.floor(LayX + LayW - 100)

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
    -- Phase_Element = Phase_Element + 2
    LC_Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, 4, TLayNr, Phase_Element, MatrickNr,
        Construct_Pool, Call_Pool)


    -- Create Sequences Phase
    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', prefix .. 'Phase Input' .. surfix[a])
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[64].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[63].Nr)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')

    LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)

    -- Add Squences to Layout
    if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Phase')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Group_Element = math.floor(LayNr + 1)
    end
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    return Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element, Phase_Element, First_Id_Lay
end -- end LC_Create_Phase_Sequence

function LC_Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, a,
                                  MatrickNrStart,
                                  TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                                  Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Construct_Pool, Call_Pool,
                                  Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_group

    -- Setup Group Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    -- Setup XGroup Sequence
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    FirstSeqGrp                                          = CurrentSeqNr
    LastSeqGrp                                           = math.floor(CurrentSeqNr + 4)
    -- Create Macro Group Input
    LC_Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeqGrp, LastSeqGrp, MatrickNrStart, 5, TLayNr,
        Group_Element, MatrickNr, Construct_Pool, Call_Pool)

    if MakeX then
        LC_Command_Title('GROUP', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('None', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 3, Construct_Pool)
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
        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[4].name .. '_' .. surfix[a] then
                tag_group = TagObject_LC[v]
            end
        end
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xgrp[i].name .. surfix[a])
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Group" ' .. Argument_Xgrp[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call ' .. Call_Pool .. ' Plugin "DEV_LC_View" ')
        end
        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_group)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
        -- end Sequences

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Group')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Block_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp,
        FirstSeqGrp, Group_Element
end -- end LC_Create_Group_Sequence

function LC_Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, a,
                                  MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY,
                                  First_Id_Lay,
                                  Current_Id_Lay, Argument_Xblock, AppImp, Wings_Element, LayW, LayH, Construct_Pool,
                                  Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_block

    -- Setup Block Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    FirstSeqBlock                                        = CurrentSeqNr
    LastSeqBlock                                         = math.floor(CurrentSeqNr + 4)
    -- Create Macro Block Input
    -- Block_Element                                        = Block_Element + 2
    LC_Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeqBlock, LastSeqBlock, MatrickNrStart, 6,
        TLayNr, Block_Element, MatrickNr, Construct_Pool, Call_Pool)

    if MakeX then
        LC_Command_Title('BLOCK', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[5].name .. '_' .. surfix[a] then
                tag_block = TagObject_LC[v]
            end
        end

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xblock[i].name .. surfix[a])
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart ..
                ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call ' .. Call_Pool .. ' Plugin "DEV_LC_View" ')
        end

        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_block)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
        -- end Sequences

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Block')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Wings_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock,
        LastSeqBlock, Block_Element
end -- end LC_Create_Block_Sequence

function LC_Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, a,
                                  MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY,
                                  First_Id_Lay,
                                  Current_Id_Lay, Argument_Xwings, AppImp, LayW, LayH, Construct_Pool, Call_Pool,
                                  Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_wings

    -- Setup Wings Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    FirstSeqWings                                        = CurrentSeqNr
    LastSeqWings                                         = math.floor(CurrentSeqNr + 4)
    -- Create Macro Wings Input
    -- Wings_Element                                        = Wings_Element + 2
    LC_Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeqWings, LastSeqWings, MatrickNrStart, 7,
        TLayNr, Wings_Element, MatrickNr, Construct_Pool, Call_Pool)

    if MakeX then
        LC_Command_Title('WINGS', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
    end
    -- Create Sequences Wings
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

        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[6].name .. '_' .. surfix[a] then
                tag_wings = TagObject_LC[v]
            end
        end

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xwings[i].name .. surfix[a])
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Wings" ' .. Argument_Xwings[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call ' .. Call_Pool .. ' Plugin "DEV_LC_View" ')
        end

        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_wings)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Wings')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr,
        Wings_Element
end -- end LC_Create_Wings_Sequence

function LC_Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, Call_inc, CallT, MatrickNrStart, a,
                                CurrentSeqNr, TLayNr, Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element,
                                Group_Element, Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY,
                                LayW, LayH, Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_xyz

    -- Setup XYZ Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    First_Id_Lay[33 + a]                                 = CurrentMacroNr
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. surfix[a] .. "_Call")
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
        MacroObject[CurrentMacroNr]:Insert(m)
        MacroObject[CurrentMacroNr][m]:Set('Command', 'Assign DataPool ' .. Construct_Pool .. ' Sequence ' ..
            First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Construct_Pool .. ' Layout ' ..
            TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        Call_inc = math.floor(Call_inc + 1)
    end
    LC_Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
        Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
        Wings_Element, MatrickNr, Construct_Pool, Call_Pool)

    First_Id_Lay[28 + a] = CurrentSeqNr

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[7].name then
            tag_xyz = TagObject_LC[v]
        end
    end

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', prefix .. surfix[a] .. "_Call")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[67 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[66 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')

    Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_xyz)

    LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
    LC_Check_Size_Pool(CurrentSeqNr + 1, SequenceObject)
    SequenceObject:Create(CurrentSeqNr + 1)
    SequenceObject[CurrentSeqNr + 1]:Set('Name', prefix .. surfix[a] .. "_Reset")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr + 1]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr + 1]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr + 1]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr + 1]:Insert()
    SequenceObject[CurrentSeqNr + 1]:Set('Appearance', '[[skull_white_png]]')
    SequenceObject[CurrentSeqNr + 1][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr + 1][3]:Create(1)
    SequenceObject[CurrentSeqNr + 1][3][1]:Set('Appearance', '[[skull_black_png]]')
    SequenceObject[CurrentSeqNr + 1][3][1]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + 1 .. '')

    LC_Command_Ext_Suite(CurrentSeqNr + 1, SequenceObject)
    if MakeX == false then
        LayNr = math.floor(LayNr + 1)
    end
    if a == 1 then
        First_Id_Lay[32] = LayX
        First_Id_Lay[33] = LayY
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    elseif a == 2 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    elseif a == 3 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    end
    return First_Id_Lay, LayNr, CurrentMacroNr
end -- end LC_Create_XYZ_Sequence

function LC_Add_Line_Macro_XYZ(MacroObject, First_Id_Lay, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element,
                               Delay_T_Element, Phase_Element, Group_Element, Block_Element, Wings_Element,
                               Construct_Pool, Call_Pool)
    for i = 1, 3 do
        MacroObject[First_Id_Lay[33 + i]]:Insert(32)
        MacroObject[First_Id_Lay[33 + i]][32]:Set('Command', '')
        LC_Add_Macro_Call(i, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element, Delay_T_Element, Phase_Element,
            Group_Element, Block_Element, Wings_Element, Construct_Pool, First_Id_Lay[33 + i], Call_Pool)
    end
end

function LC_Create_KillallLCx(LayY, LayX, LayNr, ColLgnCount, RefX, CurrentSeqNr, SequenceObject, Nr, Layout_Object,
                              TLayNr, LayW, LayH, prefix, Construct_Pool)
    LayY = 540
    LayY = math.floor(LayY + 20) -- Add offset for Layout Element distance
    LayY = math.floor(LayY + (120 * ColLgnCount))
    LayX = RefX
    LayNr = math.floor(LayNr + 1)
    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', prefix .. "KILL_ALL")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', '[[skull_white_png]]')
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', '[[skull_black_png]]')
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Off DataPool ' .. Construct_Pool .. ' Sequence \'' .. prefix .. '*')

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Kill_All')
    LC_Set_Def(TLayNr, Nr, Layout_Object)

    return CurrentSeqNr, Nr, LayX, LayY, LayNr
    -- end Kill all LCx_
end

function LC_Macro_Priority(LayX, LayY, Ligne_Inc, CurrentMacroNr, First_All_Color, LayW, LayH, TLayNr, LayNr,
                           Construct_Pool, prefix, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LayX = -330
    LayY = 700
    if Ligne_Inc then
        LayY = 800
    end
    CurrentMacroNr = math.floor(CurrentMacroNr)

    local Color_message = 'SetUserVariable "LC_Sequence" "' .. First_All_Color .. '"'
    Color_message = string.gsub(Color_message, "'", "")
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "o" .. prefix .. "Priority")
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
    MacroObject[CurrentMacroNr][7]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

    local address = LC_Search_Addr_Nat_App('p_super_png')

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
    LC_Set_Def(TLayNr, Nr, Layout_Object)
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', address)
end

function LC_Create_Group_Call(allmacrocallstart, allmacroallend, TLayNr, LayX, LayY, CurrentSeqNr, CurrentMacroNr,
                              NbGroup,
                              Construct_Pool, prefix, NrNeed)
    local AppearObject                                   = Root().ShowData.Appearances
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local Group_Tag                                      = {}
    for ta = 1, NbGroup do
        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == prefix .. '_Group_' .. ta then
                table.insert(Group_Tag, TagObject_LC[v])
            end
        end
    end

    local Macro_on = CurrentMacroNr
    local inc = 1
    for m = 1, NbGroup do
        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. "on_call_all_group_" .. m)
        for g = allmacrocallstart, allmacroallend do
            MacroObject[CurrentMacroNr]:Insert(inc)
            MacroObject[CurrentMacroNr][inc]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Macro ' ..
                g .. '.1 Thru Property "Enabled" 1 if ' .. Group_Tag[m])
            inc = inc + 1
        end

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        inc = 1
    end

    local Macro_off = CurrentMacroNr
    inc = 1
    for m = 1, NbGroup do
        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. "off_call_all_group_" .. m)
        for g = allmacrocallstart, allmacroallend do
            MacroObject[CurrentMacroNr]:Insert(inc)
            MacroObject[CurrentMacroNr][inc]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Macro ' ..
                g .. '.1 Thru Property "Enabled" 0 if ' .. Group_Tag[m])
            inc = inc + 1
        end

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        inc = 1
    end

    LayX = -1100
    LayY = 440
    for m = 1, NbGroup do
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'onoff_group' .. m)
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed - 1])

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Macro_on + m - 1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])
        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][4]:Set('No', 2)
        SequenceObject[CurrentSeqNr][4]:Create(1)
        SequenceObject[CurrentSeqNr][4][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Macro_off + m - 1)
        SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', AppearObject[NrNeed - 1])

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', '->')
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextSize', '32')
        Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Grp on off call')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        LayY = math.floor(LayY - 120)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'Inv')
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed - 1])

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
        CurrentSeqNr - NbGroup .. ' Thru ' .. CurrentSeqNr - 1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', 560)
    Layout_Object[TLayNr][Nr.No]:Set('width', 100)
    Layout_Object[TLayNr][Nr.No]:Set('height', 100)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Flash')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', 'INV')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all Inv call')
    LC_Set_Def(TLayNr, Nr, Layout_Object)

    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'None')
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed - 1])

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
        CurrentSeqNr - NbGroup - 1 .. ' Thru ' .. CurrentSeqNr - 2 .. ' Cue 2')
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', 680)
    Layout_Object[TLayNr][Nr.No]:Set('width', 100)
    Layout_Object[TLayNr][Nr.No]:Set('height', 100)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Flash')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', 'None')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all None call')
    LC_Set_Def(TLayNr, Nr, Layout_Object)

    return CurrentSeqNr, CurrentMacroNr
end
