--[[
Releases:
* 2.3.2.0

Version:
* 2.3.6.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]
function LC_Get_Object(Construct_Pool)
    local MacroObject    = Root().ShowData.DataPools[Construct_Pool].Macros
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Layout_Object  = Root().ShowData.DataPools[Construct_Pool].Layouts
    local Nr
    return MacroObject, SequenceObject, Layout_Object, Nr
end

function LC_Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, Axes, CurrentSeqNr,First_Id_Lay, TLayNr, Fade_Element,
                               Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
                               Wings_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)


    LC_Check_Size_Pool(CurrentMacroNr + 1, MacroObject)
    MacroObject:Create(CurrentMacroNr + 1)
    MacroObject[CurrentMacroNr + 1]:Set('Name', prefix .. surfix[Axes] .. "_Reset")
    for b = 1, 72 do
        MacroObject[CurrentMacroNr + 1]:Insert(b)
    end
    MacroObject[CurrentMacroNr + 1][1]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][2]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][3]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][4]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][5]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][6]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[Axes] .. '" None')
    MacroObject[CurrentMacroNr + 1][7]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Group" None')
    MacroObject[CurrentMacroNr + 1][8]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Block" None')
    MacroObject[CurrentMacroNr + 1][9]:Set('Command', 'Set DataPool ' ..
        Construct_Pool .. '  Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Wings" None')
    MacroObject[CurrentMacroNr + 1][10]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 1] .. ' Thru ' .. First_Id_Lay[Axes + 1] + 4)
    MacroObject[CurrentMacroNr + 1][11]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 5] .. ' Thru ' .. First_Id_Lay[Axes + 5] + 4)
    MacroObject[CurrentMacroNr + 1][12]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 9] .. ' Thru ' .. First_Id_Lay[Axes + 9] + 4)
    MacroObject[CurrentMacroNr + 1][13]:Set('Command',
        'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 13])
    MacroObject[CurrentMacroNr + 1][14]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 17] .. ' Thru ' .. First_Id_Lay[Axes + 17] + 4)
    MacroObject[CurrentMacroNr + 1][15]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 21] .. ' Thru ' .. First_Id_Lay[Axes + 21] + 4)
    MacroObject[CurrentMacroNr + 1][16]:Set('Command', 'Off DataPool ' ..
        Construct_Pool .. ' Sequence ' .. First_Id_Lay[Axes + 25] .. ' Thru ' .. First_Id_Lay[Axes + 25] + 4)
    MacroObject[CurrentMacroNr + 1][17]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr + 1][18]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][19]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][20]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][21]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][22]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][23]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][24]:Set('Command', 'SetUserVariable "LC_Fonction" 2')
    MacroObject[CurrentMacroNr + 1][25]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][26]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][27]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_F_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][28]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][29]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][30]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][31]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][32]:Set('Command', 'SetUserVariable "LC_Fonction" 3')
    MacroObject[CurrentMacroNr + 1][33]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][34]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][35]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_T_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][36]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][37]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][38]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][39]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][40]:Set('Command', 'SetUserVariable "LC_Fonction" 4')
    MacroObject[CurrentMacroNr + 1][41]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][42]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][43]:Set('Command', 'SetUserVariable "LC_Element" ' .. Phase_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][44]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][45]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][46]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][47]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][48]:Set('Command', 'SetUserVariable "LC_Fonction" 5')
    MacroObject[CurrentMacroNr + 1][49]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][50]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][51]:Set('Command', 'SetUserVariable "LC_Element" ' .. Group_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][52]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][53]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][54]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][55]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][56]:Set('Command', 'SetUserVariable "LC_Fonction" 6')
    MacroObject[CurrentMacroNr + 1][57]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][58]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][59]:Set('Command', 'SetUserVariable "LC_Element" ' .. Block_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][60]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][61]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][62]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][63]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][64]:Set('Command', 'SetUserVariable "LC_Fonction" 7')
    MacroObject[CurrentMacroNr + 1][65]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr + 1][66]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr + 1][67]:Set('Command', 'SetUserVariable "LC_Element" ' .. Wings_Element[Axes] .. '')
    MacroObject[CurrentMacroNr + 1][68]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr + 1][69]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr + 1][70]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr + 1][71]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
    MacroObject[CurrentMacroNr + 1][72]:Set('Command',
        'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr + 1)
end -- end function LC_Create_Macro_Reset(...)

function LC_Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr, Delay_F_Element,
                                    MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'DelayFrom Input' .. surfix[Axes])
    for b = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[Axes] .. '"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_F_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function LC_Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr,
                                  Delay_T_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'DelayTo Input' .. surfix[Axes])
    for b = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[Axes] .. '"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Element" ' .. Delay_T_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function LC_Create_Macro_Phase(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr, Phase_Element,
                               MatrickNr,
                               Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Phase Input' .. surfix[Axes])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[Axes] .. '"')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[Axes] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Element" ' .. Phase_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function LC_Create_Macro_Group(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr,
                               Group_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Group Input' .. surfix[Axes])
    for b = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Group" ')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Element" ' .. Group_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function LC_Create_Macro_Block(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr,
                               Block_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Block Input' .. surfix[Axes])
    for b = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Block" ')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Element" ' .. Block_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function LC_Create_Macro_Wings(CurrentMacroNr, prefix, surfix, Axes, MatrickNrStart, fonct, TLayNr,
                               Wings_Element, MatrickNr, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Wings Input' .. surfix[Axes])
    for b = 1, 9 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[Axes] .. 'Wings" ')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Element" ' .. Wings_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")
end

function Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, Axes, SeqNrStart, SeqNrEnd, MatrickNrStart,
                             TLayNr, Fade_Element, Construct_Pool, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. Argument_Fade[i].name .. surfix[Axes])
    for b = 1, 10 do
        MacroObject[CurrentMacroNr]:Insert(b)
    end
    MacroObject[CurrentMacroNr][1]:Set('Command', 'Set DataPool ' .. Construct_Pool .. '  Sequence ' ..
        SeqNrStart .. ' thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[i].UseExTime .. '')
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks   ' ..
        MatrickNrStart .. ' Property "FadeFrom' .. surfix[Axes] .. '" ' .. Argument_Fade[i].Time .. '')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks   ' ..
        MatrickNrStart .. ' Property "FadeTo' .. surfix[Axes] .. '" ' .. Argument_Fade[i].Time .. '')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Axes" ' .. Axes .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element[Axes] .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    MacroObject[CurrentMacroNr][10]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'LayoutColor_V2'.'LC_View_lua'")

    CurrentMacroNr = CurrentMacroNr + 1
    return CurrentMacroNr
end

--end LC_Macro_Cmd.lua