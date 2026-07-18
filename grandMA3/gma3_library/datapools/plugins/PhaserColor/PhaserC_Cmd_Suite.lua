--[[
Releases:
* 2.4.2.2

Version:
* 2.0.0.0

Created by Richard Fontaine "RIRI", july 2026.
--]]

function PC_Check_Size_Pool(id, PoolObject)
    local DEBUG = false
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        PC_Dialog_End('Error : wrong argument expected integer got ' .. idtype)
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        PC_Dialog_End('Error : id is already used : ' .. id)
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        PC_Dialog_End('Error : id out of range')
        error('id out of range')
    end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function PC_Dialog_End(message)
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 800, 800
    local mybutton = dialog:Append('Button')
    mybutton.Font = 1
    mybutton.TextAutoAdjust = "Yes"
    mybutton.Text = message
end -- end function LC_Dialog_End(message)

function PC_Sequence_Defo(SequenceObject, i)
    SequenceObject[i]:Set('PREFERCUEAPPEARANCE', 'Yes')
    SequenceObject[i]:Set('AUTOSTART', 'Yes')
    SequenceObject[i]:Set('AUTOSTOP', 'Yes')
    SequenceObject[i]:Set('MASTERGOMODE', 'None')
    SequenceObject[i]:Set('AUTOFIX', 'No')
    SequenceObject[i]:Set('AUTOSTOMP', 'No')
    SequenceObject[i]:Set('TRACKING', 'No')
    SequenceObject[i]:Set('WRAPAROUND', 'Yes')
    SequenceObject[i]:Set('RELEASEFIRSTCUE', 'No')
    SequenceObject[i]:Set('RESTARTMODE', 'First Cue')
    SequenceObject[i]:Set('CUECOMMAND', 'Enabled')
    SequenceObject[i]:Set('XFADERELOAD', 'No')
    SequenceObject[i]:Set('OUTPUTFILTER', '')
    SequenceObject[i]:Set('PRIORITY', 'LTP')
    SequenceObject[i]:Set('SOFTLTP', 'Yes')
    SequenceObject[i]:Set('PLAYBACKMASTER', 'None')
    SequenceObject[i]:Set('XFADEMODE', 'AB')
    SequenceObject[i]:Set('RATEMASTER', 'None')
    SequenceObject[i]:Set('RATESCALE', 'One')
    SequenceObject[i]:Set('SPEEDFROMRATE', 'No')
    SequenceObject[i]:Set('INPUTFILTER', '')
    SequenceObject[i]:Set('SWAPPROTECT', 'Yes')
    SequenceObject[i]:Set('KILLPROTECT', 'Yes')
    SequenceObject[i]:Set('INCLUDELINKLASTGO', 'Yes')
    SequenceObject[i]:Set('USEEXECUTORTIME', 'No')
    SequenceObject[i]:Set('OFFWHENOVERRIDDEN', 'No')
    SequenceObject[i]:Set('LOCK', 'No')
    SequenceObject[i]:Set('SEQUMIB', 'Enabled')
    SequenceObject[i]:Set('SEQUMIBMODE', 'None')

    SequenceObject[i]:Set('AUTOPREPOS', 'No')
    SequenceObject[i]:Set('SPEEDMASTER', 'None')
    SequenceObject[i]:Set('SPEEDSCALE', 'One')
    SequenceObject[i]:Set('EXECUTORDISPLAYMODE', 'Both')
    SequenceObject[i]:Set('CUEZEROMODE', 'Off')
    SequenceObject[i]:Set('ACTION', 'Pool Default')
    SequenceObject[i]:Set('TIMINGGOTO', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACK', 'Default')
    SequenceObject[i]:Set('TIMINGGOFAST', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACKFAST', 'Default')
end -- end function PC_Sequence_Defo(SequenceObject, i)

function PC_Get_Object(Construct_Pool)
    local MacroObject    = Root().ShowData.DataPools[Construct_Pool].Macros
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Layout_Object  = Root().ShowData.DataPools[Construct_Pool].Layouts
    local Nr
    local Preset25Object = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]
    Preset25Object:Set('PresetMode', 'Universal')
    local MatrickObject = Root().ShowData.DataPools[Construct_Pool].Matricks
    local AppObject = Root().ShowData.Appearances
    return MacroObject, SequenceObject, Layout_Object, Preset25Object, MatrickObject, AppObject, Nr
end

function PC_Set_Def(L_N, N, Obj)
    Obj[L_N][N.No]:Set('visibilitybar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityobjectname', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilitycid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityvalue', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityicon', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityindicatorbar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityselectionrelevance', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityborder', 'Hidden')
    Obj[L_N][N.No]:Set('fullresolution', 'Yes')
end -- end function LC_Set_Def(L_N, N, Obj)

function PC_Search_Addr_Nat_App(label)
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Addr_Nat_Panel
    for i in pairs(AppearanceObject) do
        if AppearanceObject[i].Name ~= nil then
            if AppearanceObject[i].Name == label then
                Addr_Nat_Panel = AppearanceObject[i]:AddrNative()
            end
        end
    end
    return Addr_Nat_Panel
end

function PC_Search_Object_App(label)
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Object_Panel
    for i in pairs(AppearanceObject) do
        if AppearanceObject[i].Name ~= nil then
            if AppearanceObject[i].Name == label then
                Object_Panel = AppearanceObject[i]
            end
        end
    end
    return Object_Panel
end

function PC_Create_Group_Call(allmacrocallstart, allmacroallend, TLayNr, LayX, LayY, CurrentSeqNr, CurrentMacroNr,
                              NbGroup, Construct_Pool, prefix, AppRef)
    local AppearObject                                   = Root().ShowData.Appearances
    local MacroObject, SequenceObject, Layout_Object, Nr = PC_Get_Object(Construct_Pool)
    local TagObject_PC                                   = Root().ShowData.Tags:Children()
    local Group_Tag                                      = {}
    for ta = 1, NbGroup do
        for v in ipairs(TagObject_PC) do
            if TagObject_PC[v].Name == prefix .. 'Group_' .. ta then
                table.insert(Group_Tag, TagObject_PC[v])
            end
        end
    end

    local Macro_on = CurrentMacroNr
    local inc = 1
    for m = 1, NbGroup do
        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
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
        PC_Check_Size_Pool(CurrentMacroNr, MacroObject)
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
    LayY = -660
    for m = 1, NbGroup do
        PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'onoff_group' .. m)
        PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppRef - 1])

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Macro_on + m - 1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[AppRef])
        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][4]:Set('No', 2)
        SequenceObject[CurrentSeqNr][4]:Create(1)
        SequenceObject[CurrentSeqNr][4][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. Macro_off + m - 1)
        SequenceObject[CurrentSeqNr][4][1]:Set('Appearance', AppearObject[AppRef - 1])

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
        PC_Set_Def(TLayNr, Nr, Layout_Object)

        LayY = math.floor(LayY - 120)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
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
        'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
        CurrentSeqNr - NbGroup .. ' Thru ' .. CurrentSeqNr - 1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[AppRef + 1])

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
    PC_Set_Def(TLayNr, Nr, Layout_Object)

    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    PC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'o' .. prefix .. 'ALL')
    PC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppRef - 1])

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Set('Command',
        'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
        CurrentSeqNr - NbGroup - 1 .. ' Thru ' .. CurrentSeqNr - 2 .. ' Cue 1')
    SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[AppRef])

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', 680)
    Layout_Object[TLayNr][Nr.No]:Set('width', 100)
    Layout_Object[TLayNr][Nr.No]:Set('height', 100)
    Layout_Object[TLayNr][Nr.No]:Set('action', 'Flash')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextText', 'ALL')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextColor', 'FF0000FF')
    Layout_Object[TLayNr][Nr.No]:Set('CustomTextAlignmentV', 'Center')
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'all ALL call')
    PC_Set_Def(TLayNr, Nr, Layout_Object)

    return CurrentSeqNr, CurrentMacroNr
end
