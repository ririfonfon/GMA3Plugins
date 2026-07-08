--[[
Releases:
* 2.3.2.0

Version:
* 2.3.6.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]

function LC_Create_Phase_Sequence(LayY, LayX, LayW, Axes, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay,
                                  CurrentMacroNr, prefix, surfix, MatrickNrStart, TLayNr, Phase_Element, MatrickNr,
                                  AppImp, MakeX, LayH, RefX, Group_Element, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_V

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == prefix .. 'V_' .. surfix[Axes] then
            tag_V = TagObject_LC[v]
        end
    end

    -- Setup Phase Sequence
    prefix = 'o' .. prefix
    -- Add offset for Layout Element distance
    LayY   = math.floor(LayY - 150)
    LayX   = RefX
    LayX   = math.floor(LayX + LayW - 100)

    -- Create Macro Phase Input
    if Axes == 1 then
        First_Id_Lay[13] = math.floor(LayNr)
        First_Id_Lay[14] = CurrentSeqNr
    elseif Axes == 2 then
        First_Id_Lay[15] = CurrentSeqNr
    elseif Axes == 3 then
        First_Id_Lay[16] = CurrentSeqNr
    end
    Current_Id_Lay = First_Id_Lay[13]
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    if Axes == 1 then
        Phase_Element[Axes] = Phase_Element[Axes] + 1
    elseif Axes == 2 then
        Phase_Element[Axes] = Phase_Element[Axes]
    elseif Axes == 3 then
        Phase_Element[Axes] = Phase_Element[Axes]
    end
    LC_Create_Macro_Phase(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, 4, TLayNr, Phase_Element, MatrickNr,
        Construct_Pool, Call_Pool)


    -- Create Sequences Phase
    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', prefix .. 'Phase Input' .. surfix[Axes])
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

    local Visi = 0
    -- Add Squences to Layout
    if MakeX then
        Visi = 1
        LayNr = LC_Command_Title('PHASE', 'Titre', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4, Construct_Pool,
            Visi)
    end
    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Phase')
    Layout_Object[TLayNr][Nr.No]:Set('VisibilityElement', Visi)
    Layout_Object[TLayNr][Nr.No]:Set('Tags', tag_V.Name .. ':0')
    -- Cmd('Assign ' .. Layout_Object[TLayNr][Nr.No] .. " at " .. tag_V)
    LC_Set_Def(TLayNr, Nr, Layout_Object)
    LayX = math.floor(LayX + LayW + 20)
    LayNr = LC_Command_Title('none > none', 'Value' .. surfix[Axes], TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170,
        1, Construct_Pool, Visi)
    Layout_Object[TLayNr][LayNr]:Set('Tags', tag_V.Name .. ':0')
    -- Cmd('Assign ' .. Layout_Object[TLayNr][LayNr] .. " at " .. tag_V)
    LayNr = math.floor(LayNr + 1)
    Group_Element[Axes] = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    return Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element, Phase_Element, First_Id_Lay
end -- end LC_Create_Phase_Sequence

function LC_Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, Axes,
                                  MatrickNrStart, TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay,
                                  Current_Id_Lay, Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Construct_Pool,
                                  Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_group, tag_V


    -- Setup Group Sequence
    local old_prefix = prefix
    prefix           = 'o' .. prefix
    -- Setup XGroup Sequence
    CurrentMacroNr   = math.floor(CurrentMacroNr + 1)
    FirstSeqGrp      = CurrentSeqNr
    LastSeqGrp       = math.floor(CurrentSeqNr + 4)

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. Time_Argument[4].name .. '_' .. surfix[Axes] then
            tag_group = TagObject_LC[v]
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[Axes] then
            tag_V = TagObject_LC[v]
        end
    end

    if Axes == 2 then
        Echo('axes 2 ge[] ' .. Group_Element[Axes])
        Group_Element[Axes] = Group_Element[Axes] - 1
        Echo(' after axes 2 ge[] ' .. Group_Element[Axes])
    elseif Axes == 3 then
        Echo('axes 3 ge[] ' .. Group_Element[Axes])
        Group_Element[Axes] = Group_Element[Axes] - 1
        Echo('after axes 3 ge[] ' .. Group_Element[Axes])
    end

    -- Create Macro Group Input
    LC_Create_Macro_Group(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, 5, TLayNr, Group_Element, MatrickNr,
        Construct_Pool, Call_Pool)

    local Visi = 0
    if MakeX then
        Visi = 1
        LayNr = LC_Command_Title('GROUP', 'Titre', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 2, Construct_Pool,
            Visi)
    end
    LayNr = LC_Command_Title('None', 'Value' .. surfix[Axes], TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 3,
        Construct_Pool, Visi)
    Layout_Object[TLayNr][LayNr]:Set('Tags', tag_V.Name .. ':0')
    -- Cmd('Assign ' .. Layout_Object[TLayNr][LayNr] .. " at " .. tag_V)
    -- Create Sequences XGroup
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 31)
        local ib = tonumber(i * 2 + 32)
        if i == 1 then
            if Axes == 1 then
                First_Id_Lay[17] = math.floor(LayNr)
                First_Id_Lay[18] = CurrentSeqNr
            elseif Axes == 2 then
                First_Id_Lay[19] = CurrentSeqNr
            elseif Axes == 3 then
                First_Id_Lay[20] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[17]
        end
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xgrp[i].name .. surfix[Axes])
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
                'Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] ..
                'Group" ' .. Argument_Xgrp[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. Axes ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Group_Element[Axes] ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool "' .. Call_Pool.Name .. '"."Plugins"."LayoutColor_V2"."LC_View_lua" ')
        end
        SequenceObject[CurrentSeqNr]:Set('Tags', tag_group.Name .. ':0')
        -- Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_group)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
        -- end Sequences

        -- Add Squences to Layout
        -- if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Group')
        Layout_Object[TLayNr][Nr.No]:Set('VisibilityElement', Visi)
        Layout_Object[TLayNr][Nr.No]:Set('Tags', tag_V.Name .. ':0')
        -- Cmd('Assign ' .. Layout_Object[TLayNr][Nr.No] .. " at " .. tag_V)
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        Block_Element[Axes] = math.floor(LayNr + 1)
        -- end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp,
        FirstSeqGrp, Group_Element
end -- end LC_Create_Group_Sequence

function LC_Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, Axes,
                                  MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY,
                                  First_Id_Lay, Current_Id_Lay, Argument_Xblock, AppImp, Wings_Element, LayW, LayH,
                                  Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_block, tag_V


    -- Setup Block Sequence
    local old_prefix = prefix
    prefix           = 'o' .. prefix
    CurrentMacroNr   = math.floor(CurrentMacroNr + 1)
    FirstSeqBlock    = CurrentSeqNr
    LastSeqBlock     = math.floor(CurrentSeqNr + 4)
    -- Create Macro Block Input
    if Axes == 1 then
        Block_Element[Axes] = Block_Element[Axes] + 1
    elseif Axes == 2 then
        Block_Element[Axes] = Block_Element[Axes]
    elseif Axes == 3 then
        Block_Element[Axes] = Block_Element[Axes]
    end
    LC_Create_Macro_Block(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, 6, TLayNr, Block_Element, MatrickNr,
        Construct_Pool, Call_Pool)

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. Time_Argument[5].name .. '_' .. surfix[Axes] then
            tag_block = TagObject_LC[v]
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[Axes] then
            tag_V = TagObject_LC[v]
        end
    end

    local Visi = 0
    if MakeX then
        Visi = 1
        LayNr = LC_Command_Title('BLOCK', 'Titre', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool, Visi)
    end

    LayNr = LC_Command_Title('none', 'Value' .. surfix[Axes], TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool,
        Visi)
        Layout_Object[TLayNr][LayNr]:Set('Tags', tag_V.Name .. ':0')
    -- Cmd('Assign ' .. Layout_Object[TLayNr][LayNr] .. " at " .. tag_V)
    -- Create Sequences XBlock
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 41)
        local ib = tonumber(i * 2 + 42)
        if i == 1 then
            if Axes == 1 then
                First_Id_Lay[21] = math.floor(LayNr)
                First_Id_Lay[22] = CurrentSeqNr
            elseif Axes == 2 then
                First_Id_Lay[23] = CurrentSeqNr
            elseif Axes == 3 then
                First_Id_Lay[24] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[21]
        end


        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xblock[i].name .. surfix[Axes])
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
                ' Property "' .. surfix[Axes] .. 'Block" ' .. Argument_Xblock[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. Axes ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Block_Element[Axes] ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool "' .. Call_Pool.Name .. '"."Plugins"."LayoutColor_V2"."LC_View_lua" ')
        end

        SequenceObject[CurrentSeqNr]:Set('Tags', tag_block.Name .. ':0')
        -- Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_block)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
        -- end Sequences

        -- Add Squences to Layout
        -- if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Block')
        Layout_Object[TLayNr][Nr.No]:Set('VisibilityElement', Visi)
        Layout_Object[TLayNr][Nr.No]:Set('Tags', tag_V.Name .. ':0')
        -- Cmd('Assign ' .. Layout_Object[TLayNr][Nr.No] .. " at " .. tag_V)
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        Wings_Element[Axes] = math.floor(LayNr + 1)
        -- end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock,
        LastSeqBlock, Block_Element
end -- end LC_Create_Block_Sequence

function LC_Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, Axes,
                                  MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY,
                                  First_Id_Lay, Current_Id_Lay, Argument_Xwings, AppImp, LayW, LayH, Construct_Pool,
                                  Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_wings, tag_V

    -- Setup Wings Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    FirstSeqWings                                        = CurrentSeqNr
    LastSeqWings                                         = math.floor(CurrentSeqNr + 4)
    -- Create Macro Wings Input
    if Axes == 1 then
        Wings_Element[Axes] = Wings_Element[Axes] + 1
    elseif Axes == 2 then
        Wings_Element[Axes] = Wings_Element[Axes]
    elseif Axes == 3 then
        Wings_Element[Axes] = Wings_Element[Axes]
    end
    LC_Create_Macro_Wings(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, 7, TLayNr, Wings_Element, MatrickNr,
        Construct_Pool, Call_Pool)

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. Time_Argument[6].name .. '_' .. surfix[Axes] then
            tag_wings = TagObject_LC[v]
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[Axes] then
            tag_V = TagObject_LC[v]
        end
    end

    local Visi = 0
    if MakeX then
        Visi = 1
        LayNr = LC_Command_Title('WINGS', 'Titre', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool, Visi)
    end

    LayNr = LC_Command_Title('none', 'Value' .. surfix[Axes], TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool,
        Visi)
        Layout_Object[TLayNr][LayNr]:Set('Tags', tag_V.Name .. ':0')
    -- Cmd('Assign ' .. Layout_Object[TLayNr][LayNr] .. " at " .. tag_V)
    -- Create Sequences Wings
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 51)
        local ib = tonumber(i * 2 + 52)
        if i == 1 then
            if Axes == 1 then
                First_Id_Lay[25] = math.floor(LayNr)
                First_Id_Lay[26] = CurrentSeqNr
            elseif Axes == 2 then
                First_Id_Lay[27] = CurrentSeqNr
            elseif Axes == 3 then
                First_Id_Lay[28] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[25]
        end


        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Xwings[i].name .. surfix[Axes])
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
                'Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] ..
                'Wings" ' .. Argument_Xwings[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. Axes ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Wings_Element[Axes] ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool "' .. Call_Pool.Name .. '"."Plugins"."LayoutColor_V2"."LC_View_lua" ')
        end

        SequenceObject[CurrentSeqNr]:Set('Tags', tag_wings.Name .. ':0')
        -- Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_wings)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)

        -- Add Squences to Layout
        -- if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Wings')
        Layout_Object[TLayNr][Nr.No]:Set('VisibilityElement', Visi)
        Layout_Object[TLayNr][Nr.No]:Set('Tags', tag_V.Name .. ':0')
        -- Cmd('Assign ' .. Layout_Object[TLayNr][Nr.No] .. " at " .. tag_V)
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        -- end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr,
        Wings_Element
end -- end LC_Create_Wings_Sequence

function LC_Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, MatrickNrStart, Axes, CurrentSeqNr, TLayNr,
                                Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element,
                                Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY, LayW, LayH,
                                Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_xyz
    local tag_V                                          = {}

    -- Setup XYZ Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    First_Id_Lay[33 + Axes]                              = CurrentMacroNr
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. surfix[Axes] .. "_Call")
    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. Time_Argument[7].name then
            tag_xyz = TagObject_LC[v]
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[1] then
            tag_V[1] = TagObject_LC[v].Name
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[2] then
            tag_V[2] = TagObject_LC[v].Name
        elseif TagObject_LC[v].Name == old_prefix .. 'V_' .. surfix[3] then
            tag_V[3] = TagObject_LC[v].Name
        end
    end
    local Visi = {
        { 1, 0, 0 },
        { 0, 1, 0 },
        { 0, 0, 1 }
    }
    for m = 1, 3 do
        MacroObject[CurrentMacroNr]:Insert(m)
        MacroObject[CurrentMacroNr][m]:Set('Command',
            'Set DataPool ' .. Construct_Pool .. ' Layout 1.1 Thru Property VisibilityElement ' .. Visi[Axes][m] ..
            ' if Tag ' .. tag_V[m])
    end
    LC_Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, Axes, CurrentSeqNr, First_Id_Lay, TLayNr,
        Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element, Wings_Element,
        MatrickNr, Construct_Pool, Call_Pool)

    First_Id_Lay[28 + Axes] = CurrentSeqNr


    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', prefix .. surfix[Axes] .. "_Call")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[67 + tonumber(Axes * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[66 + tonumber(Axes * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')

        SequenceObject[CurrentSeqNr]:Set('Tags', tag_xyz.Name .. ':0')
    -- Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_xyz)

    LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
    LC_Check_Size_Pool(CurrentSeqNr + 1, SequenceObject)
    SequenceObject:Create(CurrentSeqNr + 1)
    SequenceObject[CurrentSeqNr + 1]:Set('Name', prefix .. surfix[Axes] .. "_Reset")
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
    if Axes == 1 then
        First_Id_Lay[32] = LayX
        First_Id_Lay[33] = LayY
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_y_z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_y_z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    elseif Axes == 2 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'x_Y_z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'x_Y_z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    elseif Axes == 3 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'x_y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'x_y_Z')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
    end
    return First_Id_Lay, LayNr, CurrentMacroNr
end -- end LC_Create_XYZ_Sequence

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
    MacroObject[CurrentMacroNr][7]:Set('Command',
        "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")

    local address = LC_Search_Addr_Nat_App('p_htp_png')

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
    Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Priority')
    LC_Set_Def(TLayNr, Nr, Layout_Object)
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', address)
end

function LC_Create_Group_Call(allmacrocallstart, allmacroallend, TLayNr, LayX, LayY, CurrentSeqNr, CurrentMacroNr,
                              NbGroup, Construct_Pool, prefix, NrNeed)
    local AppearObject                                   = Root().ShowData.Appearances
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local Group_Tag                                      = {}
    for ta = 1, NbGroup do
        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == prefix .. 'Group_' .. ta then
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
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'ALL')
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
        CurrentSeqNr - NbGroup - 1 .. ' Thru ' .. CurrentSeqNr - 2 .. ' Cue 1')
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
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all ALL call')
    LC_Set_Def(TLayNr, Nr, Layout_Object)

    return CurrentSeqNr, CurrentMacroNr
end
