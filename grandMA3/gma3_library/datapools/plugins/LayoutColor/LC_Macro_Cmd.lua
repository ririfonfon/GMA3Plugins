--[[
Releases:
* 2.3.2.0

Version:
* 2.2.0.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]
function LC_Get_Object(Construct_Pool)
    local MacroObject    = Root().ShowData.DataPools[Construct_Pool].Macros
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Layout_Object  = Root().ShowData.DataPools[Construct_Pool].Layouts
    local Nr
    return MacroObject, SequenceObject, Layout_Object, Nr
end

function LC_Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
                            Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
                            Wings_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)


    LC_Check_Size_Pool(CurrentMacroNr + 1, MacroObject)
    MacroObject:Create(CurrentMacroNr + 1)
    MacroObject[CurrentMacroNr + 1]:Set('Name', prefix .. surfix[a] .. "_Reset")
    for b = 1, 72 do
        MacroObject[CurrentMacroNr + 1]:Insert(b)
    end
    MacroObject[CurrentMacroNr + 1][1]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][2]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][3]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][4]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][5]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][6]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[a] .. '" None')
    MacroObject[CurrentMacroNr + 1][7]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Group" None')
    MacroObject[CurrentMacroNr + 1][8]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Block" None')
    MacroObject[CurrentMacroNr + 1][9]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Wings" None')
    MacroObject[CurrentMacroNr + 1][10]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 1] .. ' Thru ' .. First_Id_Lay[a + 1] + 4)
    MacroObject[CurrentMacroNr + 1][11]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 5] .. ' Thru ' .. First_Id_Lay[a + 5] + 4)
    MacroObject[CurrentMacroNr + 1][12]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 9] .. ' Thru ' .. First_Id_Lay[a + 9] + 4)
    MacroObject[CurrentMacroNr + 1][13]:Set('Command',
        'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 13])
    MacroObject[CurrentMacroNr + 1][14]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 17] .. ' Thru ' .. First_Id_Lay[a + 17] + 4)
    MacroObject[CurrentMacroNr + 1][15]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 21] .. ' Thru ' .. First_Id_Lay[a + 21] + 4)
    MacroObject[CurrentMacroNr + 1][16]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[a + 25] .. ' Thru ' .. First_Id_Lay[a + 25] + 4)
    MacroObject[CurrentMacroNr + 1][17]:Set('Command',
        'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr + 1)
    MacroObject[CurrentMacroNr + 1][18]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr + 1][19]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][20]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][21]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    MacroObject[CurrentMacroNr + 1][22]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][23]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][24]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][25]:Set('Command', 'SetUserVariable "LC_Fonction" 2')
    MacroObject[CurrentMacroNr + 1][26]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][27]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][28]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_F_Element .. '')
    MacroObject[CurrentMacroNr + 1][29]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][30]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][31]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][32]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][33]:Set('Command', 'SetUserVariable "LC_Fonction" 3')
    MacroObject[CurrentMacroNr + 1][34]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][35]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][36]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_T_Element .. '')
    MacroObject[CurrentMacroNr + 1][37]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][38]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][39]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][40]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][41]:Set('Command', 'SetUserVariable "LC_Fonction" 4')
    MacroObject[CurrentMacroNr + 1][42]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][43]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][44]:Set('Command', 'SetUserVariable "LC_Element" ' .. Phase_Element .. '')
    MacroObject[CurrentMacroNr + 1][45]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][46]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][47]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][48]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][49]:Set('Command', 'SetUserVariable "LC_Fonction" 5')
    MacroObject[CurrentMacroNr + 1][50]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][51]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][52]:Set('Command', 'SetUserVariable "LC_Element" ' .. Group_Element .. '')
    MacroObject[CurrentMacroNr + 1][53]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][54]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][55]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][56]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][57]:Set('Command', 'SetUserVariable "LC_Fonction" 6')
    MacroObject[CurrentMacroNr + 1][58]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][59]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][60]:Set('Command', 'SetUserVariable "LC_Element" ' .. Block_Element .. '')
    MacroObject[CurrentMacroNr + 1][61]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][62]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][63]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][64]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr + 1][65]:Set('Command', 'SetUserVariable "LC_Fonction" 7')
    MacroObject[CurrentMacroNr + 1][66]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr + 1][67]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][68]:Set('Command', 'SetUserVariable "LC_Element" ' .. Wings_Element .. '')
    MacroObject[CurrentMacroNr + 1][69]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][70]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][71]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][72]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end -- end function LC_Create_Macro_Reset(...)

function LC_Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr,
                                 LayNr, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'DelayFrom Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. '  Sequence ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function LC_Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                               MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'DelayTo Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. '  Sequence ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function LC_Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, fonct, TLayNr, LayNr, MatrickNr,
                            Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Phase Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function LC_Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Group Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. '  Sequence ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Group" ')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function LC_Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Block Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. '  Sequence ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Block" ')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function LC_Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Wings Input' .. surfix[a])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. '  Sequence ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Wings" ')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

end

function Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime, LastSeqTime, CurrentSeqNr,
                             SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. Argument_Fade[i].name .. surfix[a])
    for b = 1, 11 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', '')
    -- MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' ..
    --     Construct_Pool .. '  Sequence ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Set DataPool ' .. Construct_Pool .. '  Sequence ' ..
        SeqNrStart .. ' thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[i].UseExTime .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks   ' ..
        MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '" ' .. Argument_Fade[i].Time .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks   ' ..
        MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '" ' .. Argument_Fade[i].Time .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][11]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

    CurrentMacroNr = CurrentMacroNr + 1
    return CurrentMacroNr
end

function LC_Add_Macro_Call(a, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element, Delay_T_Element, Phase_Element,
                        Group_Element, Block_Element, Wings_Element, Construct_Pool, CurrentMacroNr, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    for b = 33, 81 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end

    MacroObject[CurrentMacroNr][33]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr][34]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][35]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][36]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    MacroObject[CurrentMacroNr][37]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][38]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][39]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][40]:Set('Command', 'SetUserVariable "LC_Fonction" 2')
    MacroObject[CurrentMacroNr][41]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][42]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][43]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_F_Element .. '')
    MacroObject[CurrentMacroNr][44]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][45]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][46]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][47]:Set('Command', 'SetUserVariable "LC_Fonction" 3')
    MacroObject[CurrentMacroNr][48]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][49]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][50]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_T_Element .. '')
    MacroObject[CurrentMacroNr][51]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][52]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][53]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][54]:Set('Command', 'SetUserVariable "LC_Fonction" 4')
    MacroObject[CurrentMacroNr][55]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][56]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][57]:Set('Command', 'SetUserVariable "LC_Element" ' .. Phase_Element .. '')
    MacroObject[CurrentMacroNr][58]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][59]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][60]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][61]:Set('Command', 'SetUserVariable "LC_Fonction" 5')
    MacroObject[CurrentMacroNr][62]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][63]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][64]:Set('Command', 'SetUserVariable "LC_Element" ' .. Group_Element .. '')
    MacroObject[CurrentMacroNr][65]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][66]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][67]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][68]:Set('Command', 'SetUserVariable "LC_Fonction" 6')
    MacroObject[CurrentMacroNr][69]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][70]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][71]:Set('Command', 'SetUserVariable "LC_Element" ' .. Block_Element .. '')
    MacroObject[CurrentMacroNr][72]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][73]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][74]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    MacroObject[CurrentMacroNr][75]:Set('Command', 'SetUserVariable "LC_Fonction" 7')
    MacroObject[CurrentMacroNr][76]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][77]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][78]:Set('Command', 'SetUserVariable "LC_Element" ' .. Wings_Element .. '')
    MacroObject[CurrentMacroNr][79]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][80]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][81]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
end

--end LC_Macro_Cmd.lua
