function Create_Fade_Sequences(MakeX, FirstSeqTime, LastSeqTime, CurrentSeqNr, CurrentMacroNr, prefix, surfix,
                               First_Id_Lay, LayNr, MatrickNrStart, TLayNr, Fade_Element, Argument_Fade,
                               AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element, a,
                               Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- Setup Fade Sequence
    prefix                                               = 'o' .. prefix
    if MakeX then
        FirstSeqTime = CurrentSeqNr
        First_Id_Lay[37] = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 5)
    else
        FirstSeqTime = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 4)
    end
    -- Create Macro Time Input
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. 'Time Input' .. surfix[a] .. "'")
    MacroObject[CurrentMacroNr]:Insert(1)
    if MakeX then
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
        Fade_Element = math.floor(LayNr + 3)
    else
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    end
    for i = 2, 9, 1 do
        MacroObject[CurrentMacroNr]:Insert(i)
    end
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View"')
    CurrentMacroNr = CurrentMacroNr + 1
    -- CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Time Input' .. surfix[a] .. '')
    -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    -- Cmd('Insert')
    -- if MakeX then
    --     CmdIndirectWait('set 1 Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
    --         FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    --     Fade_Element = math.floor(LayNr + 3)
    -- else
    --     CmdIndirectWait('set 1 Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
    --         First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    -- end
    -- Cmd('Insert')
    -- CmdIndirectWait('set 2 Command=\'Edit DataPool ' ..
    --     Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 3 Command=\'Edit DataPool ' ..
    --     Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 4 Command=\'SetUserVariable "LC_Fonction" 1')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 5 Command=\'SetUserVariable "LC_Axes" ' .. a .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 6 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 7 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 8 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 9 Command=\'Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View"')
    -- CmdIndirectWait('ChangeDestination Root')
    if a == 1 then
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Fade[1].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[2].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[1].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; Set Sequence ' ..
            SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')


        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[1].name .. surfix[a] .. '\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[1].Nr)
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' ..
        --     Construct_Pool .. ' Sequence ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr ..
        --     ' ; Set Sequence ' ..
        --     SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[2].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')

        LayNr = math.floor(LayNr + 1)
        Command_Title('Ex.Time', TLayNr, LayNr, LayX, LayY, 700, 140, 1, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('FADE', TLayNr, LayNr, LayX, LayY, 700, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX, LayY, 700, 140, 3, Construct_Pool)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end

    for i = 2, 6 do
        local ia = tonumber(i * 2 - 1)
        local ib = tonumber(i * 2)
        if i == 2 then
            if a == 1 then
                First_Id_Lay[1] = math.floor(LayNr)
                First_Id_Lay[2] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[3] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[4] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[1]
        end
        -- Create Sequences

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Fade[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ia].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        if i == 6 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. "'")
        else
            CurrentMacroNr = Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
                LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool)
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + i - 1 .. "'")
        end
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 6 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        -- Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
        --     LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool)
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr ..
        --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + i - 1 .. '')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_F_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences FADE

    --     if MakeX then
    --         CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    --         CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --             ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --             ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --             ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    --         LayX = math.floor(LayX + LayW + 20)
    --         LayNr = math.floor(LayNr + 1)
    --         Delay_F_Element = math.floor(LayNr + 1)
    --     end
    --     CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    -- end -- end Sequences FADE
    return CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay, Fade_Element, CurrentMacroNr
end -- end Create_Fade_Sequences

function Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                                     AppImp, CurrentMacroNr, a, MatrickNrStart, TLayNr, Delay_F_Element, MatrickNr, MakeX,
                                     LayX, LayY, LayW, LayH, Delay_T_Element, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup DelayFrom Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 5)
    local FirstSeqDelayFrom = CurrentSeqNr
    local LastSeqDelayFrom = math.floor(CurrentSeqNr + 4)

    -- Create Macro DelayFrom Input
    Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayFrom, LastSeqDelayFrom,
        MatrickNrStart, 2, TLayNr, Delay_F_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('DELAY FROM', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
    end

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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Delay[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqDelayFrom .. ' Thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Delay[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqDelayFrom .. ' Thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
        --         MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
        --         '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_T_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        --     CmdIndirectWait("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        --     CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        --         " Property PosX " .. LayX .. " PosY " .. LayY ..
        --         " PositionW " .. LayW .. " PositionH " .. LayH ..
        --         " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Delay_T_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayFrom
    return Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr, CurrentMacroNr
end     --Create_Delay_From_Sequences

function Create_Delay_To_Sequences(a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, Argument_DelayTo, surfix,
                                   MatrickNrStart, TLayNr, Delay_T_Element, MatrickNr, AppImp, LayX, LayY, LayW, LayH,
                                   Phase_Element, CurrentMacroNr, MakeX, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup DelayTo Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    local FirstSeqDelayTo = CurrentSeqNr
    local LastSeqDelayTo = math.floor(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayTo, LastSeqDelayTo, MatrickNrStart,
        3, TLayNr, Delay_T_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('DELAY TO', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
    end

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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqDelayTo .. ' Thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqDelayTo .. ' Thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
        --         MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- if MakeX then
        --     -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        --     -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Phase_Element = math.floor(LayNr + 2)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayTo
    return First_Id_Lay, Current_Id_Lay, LayX, LayNr, Phase_Element, CurrentSeqNr, CurrentMacroNr
end     -- end Create_Delay_To_Sequences

function Create_Phase_Sequence(LayY, LayX, LayW, a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, CurrentMacroNr,
                               prefix, surfix, MatrickNrStart, TLayNr, Phase_Element, MatrickNr, AppImp, MakeX, LayH,
                               RefX, Group_Element, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
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
    Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, 4, TLayNr, Phase_Element, MatrickNr,
        Construct_Pool)

    -- Create Sequences Phase

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. 'Phase Input' .. surfix[a] .. "'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[64].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[63].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('Command', 'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')


    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'Phase Input' .. surfix[a] .. '\'')
    -- Add CmdIndirectWait to Squence
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[63].Nr)
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[64].Nr)
    -- Command_Ext_Suite(CurrentSeqNr)

    -- Add Squences to Layout
    if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Group_Element = math.floor(LayNr + 1)
    end
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    -- if MakeX then
    -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    -- LayX = math.floor(LayX + LayW + 20)
    -- LayNr = math.floor(LayNr + 1)
    -- Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4)
    -- LayNr = math.floor(LayNr + 1)
    -- Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1)
    -- LayNr = math.floor(LayNr + 1)
    -- Group_Element = math.floor(LayNr + 1)
    -- end
    -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    return Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element
end -- end Create_Phase_Sequence

function Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, a, MatrickNrStart,
                               TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                               Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup XGroup Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqGrp = CurrentSeqNr
    LastSeqGrp = math.floor(CurrentSeqNr + 4)
    -- Create Macro Group Input
    Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeqGrp, LastSeqGrp, MatrickNrStart, 5, TLayNr,
        Group_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('GROUP', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('None', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 3, Construct_Pool)
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
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqGrp .. ' Thru ' .. LastSeqGrp .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Group" ' .. Argument_Xgrp[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqGrp .. ' Thru ' .. LastSeqGrp .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
        --         'Group" ' .. Argument_Xgrp[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Block_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- if MakeX then
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     " Action='Layout Default' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Block_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp,
        FirstSeqGrp
end -- end Create_Group_Sequence

function Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xblock, AppImp, Wings_Element, LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqBlock = CurrentSeqNr
    LastSeqBlock = math.floor(CurrentSeqNr + 4)
    -- Create Macro Block Input
    Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeqBlock, LastSeqBlock, MatrickNrStart, 6,
        TLayNr, Block_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('BLOCK', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xblock[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqBlock .. ' Thru ' .. LastSeqBlock .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart ..
                ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqBlock .. ' Thru ' .. LastSeqBlock .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart ..
        --         ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Wings_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        -- LayX = math.floor(LayX + LayW + 20)
        --     -- LayNr = math.floor(LayNr + 1)
        --     Wings_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock,
        LastSeqBlock
end -- end Create_Block_Sequence

function Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xwings, AppImp, LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqWings = CurrentSeqNr
    LastSeqWings = math.floor(CurrentSeqNr + 4)
    -- Create Macro Wings Input
    Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeqWings, LastSeqWings, MatrickNrStart, 7,
        TLayNr, Wings_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('WINGS', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xwings[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqWings .. ' Thru ' .. LastSeqWings .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Wings" ' .. Argument_Xwings[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] .. '\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr ..
        --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqWings .. ' Thru ' .. LastSeqWings .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
        --         'Wings" ' .. Argument_Xwings[i].Time ..
        --         '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end -- end Sequences
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        --     CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --         ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --         ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --         ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr
end -- end Create_Wings_Sequence

function Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, Call_inc, CallT, MatrickNrStart, a,
                             CurrentSeqNr, TLayNr, Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element,
                             Group_Element, Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY,
                             LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    First_Id_Lay[33 + a] = CurrentMacroNr
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Call'")
    -- CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
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
        MacroObject[CurrentMacroNr]:Insert(1)
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Assign DataPool ' .. Construct_Pool .. ' Sequence ' ..
            First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Construct_Pool .. ' Layout ' ..
            TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        -- Cmd('Insert')
        -- CmdIndirectWait('Set ' .. m .. ' Command=\'Assign DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --     First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Construct_Pool .. ' Layout ' ..
        --     TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        Call_inc = math.floor(Call_inc + 1)
    end
    -- CmdIndirectWait('ChangeDestination Root')
    Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
        Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
        Wings_Element, MatrickNr, Construct_Pool)

    First_Id_Lay[28 + a] = CurrentSeqNr

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Call'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[67 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[66 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('Command', 'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')

    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[66 + tonumber(a * 2 - 1)].Nr)
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[67 + tonumber(a * 2 - 1)].Nr)
    -- Command_Ext_Suite(CurrentSeqNr)

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Reset'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', prefix:gsub('o', '') .. "'skull_off'")
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', prefix:gsub('o', '') .. "'skull_on'")
    SequenceObject[CurrentSeqNr][3]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + 1 .. '')

    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr + 1 .. ' \'' .. prefix .. surfix[a] .. '_Reset\'')
    -- CmdIndirectWait("Set Sequence " ..
    --     CurrentSeqNr + 1 .. " Cue 1 Property Appearance=" .. prefix:gsub('o', '') .. "'skull_on'")
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr + 1 ..
    --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + 1 .. '')
    -- CmdIndirectWait("Set Sequence " ..
    --     CurrentSeqNr + 1 .. " Property Appearance=" .. prefix:gsub('o', '') .. "'skull_off'")
    -- Command_Ext_Suite(CurrentSeqNr + 1)
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
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 170 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 170 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    elseif a == 2 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 90 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 90 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    elseif a == 3 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 10 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 10 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    end
    return First_Id_Lay, LayNr, CurrentMacroNr
end -- end Create_XYZ_Sequence