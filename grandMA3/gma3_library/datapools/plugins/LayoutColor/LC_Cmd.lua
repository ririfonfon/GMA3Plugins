--[[
Releases:
* 2.3.2.0

Version:
* 2.2.0.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]


function LC_Create_Matricks(MatrickNrStart, prefix, NaLay, NbGroup, MatrickNr, pool_construct)
    local DEBUG = false
    local MatrickObject = Root().ShowData.DataPools[pool_construct].Matricks
    if Debug then Echo('pool ' .. pool_construct .. ' Matrick ' .. MatrickNrStart) end
    LC_Check_Size_Pool(MatrickNrStart, MatrickObject)
    MatrickObject:Acquire()
    MatrickObject:Create(MatrickNrStart)
    MatrickObject[MatrickNrStart]:Set('Name', prefix .. NaLay)
    MatrickNr = math.floor(MatrickNrStart + 1)
    for g = 1, NbGroup, 1 do
        LC_Check_Size_Pool(MatrickNr, MatrickObject)
        MatrickObject:Create(MatrickNr)
        MatrickObject[MatrickNr]:Set('Name', prefix .. '_Group_' .. g)
        MatrickObject[MatrickNr]:Set('FadeFromx', 0)
        MatrickObject[MatrickNr]:Set('FadeFromy', 0)
        MatrickObject[MatrickNr]:Set('FadeFromz', 0)
        MatrickObject[MatrickNr]:Set('FadeTox', 0)
        MatrickObject[MatrickNr]:Set('FadeToy', 0)
        MatrickObject[MatrickNr]:Set('FadeToz', 0)
        MatrickNr = math.floor(MatrickNr + 1)
    end
    return MatrickNr
end -- end LC_Create_Matricks

function LC_Create_Appear_Tricks(AppTricks, AppNr, prefix)
    local AppObject = Root().ShowData.Appearances
    for q in pairs(AppTricks) do
        AppTricks[q].Nr = math.floor(AppNr)
        LC_Check_Size_Pool(AppTricks[q].Nr, AppObject)
        AppObject:Create(AppTricks[q].Nr)
        AppObject[AppTricks[q].Nr]:Set('Name', prefix .. AppTricks[q].Name)
        AppObject[AppTricks[q].Nr]:Set('Appearance', AppTricks[q].StApp:gsub('"', ''))
        AppObject[AppTricks[q].Nr]:Set('Color', AppTricks[q].RGBref:gsub('"', ''))
        AppNr = math.floor(AppNr + 1)
    end
    return AppNr, AppTricks
end -- end LC_Create_Appear_Tricks

function LC_Create_Appearances(AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName)
    local AppObject = Root().ShowData.Appearances
    AppObject:Acquire()
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    NrAppear = math.floor(AppNr)
    LC_Check_Size_Pool(NrAppear, AppObject)
    AppObject:Create(NrAppear)
    AppObject[NrAppear]:Set('Name', prefix .. 'Label')
    AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
    AppObject[NrAppear]:Set('Color', '0, 0, 0, 1')

    NrAppear = math.floor(NrAppear + 1)
    for col in ipairs(TCol) do
        StColCode = TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ", 1"
        StColName = TCol[col].name
        StringColName = StColName:gsub(' ', '_')
        StAppNameOn = prefix .. StringColName .. "_On"
        StAppNameOff = prefix .. StringColName .. "_Off"
        LC_Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        -- AppObject[NrAppear]:Set('Name', "'" .. StAppNameOn:gsub('"', '') .. "'")
        AppObject[NrAppear]:Set('Name', StAppNameOn:gsub('"', ''))
        AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
        LC_Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        -- AppObject[NrAppear]:Set('Name', "'" .. StAppNameOff:gsub('"', '') .. "'")
        AppObject[NrAppear]:Set('Name', StAppNameOff:gsub('"', ''))
        AppObject[NrAppear]:Set('Appearance', StAppOff:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
    end
    -- end
    return NrAppear
end -- end LC_Create_Appearances

function LC_Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current,
                             pool_construct)
    local Preset25Object = Root().ShowData.DataPools[pool_construct].PresetPools[25]
    Preset25Object:Set('PresetMode', 'Universal')

    CmdIndirectWait("ClearAll /nu")
    CmdIndirectWait('Fixture Thru')
    for col in ipairs(TCol) do
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        local convert = prefix .. StringColName
        local Name = string.gsub(convert, " ", "_")
        CmdIndirectWait('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        CmdIndirectWait('Store DataPool ' .. pool_construct .. ' Preset 25.' .. All_5_Current .. '')
        CmdIndirectWait('Label DataPool ' .. pool_construct .. ' Preset 25.' .. All_5_Current .. " " .. Name .. " ")
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end
    CmdIndirectWait("ClearAll /nu")
    return All_5_NrEnd, All_5_Current
end -- end LC_Create_Preset_25

-- SelectedGrp,SelectedGrpNo, SelectedGrpName,
function LC_Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr, NbGroup, RefX, LayY,
                                         LayH, NrAppear, AppNr, NrNeed, TLayNr, LayW, LayNr,
                                         CurrentSeqNr, MaxColLgn, TCol, prefix,
                                         All_5_NrStart, MatrickNrStart, AppTricks,
                                         Construct_Pool, Groups_Pool, Color_Range, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local LastSeqColor, grpnrselect
    local ColLgnCount                                    = 0
    local Ligne_Inc                                      = false
    local GroupsObject                                   = Root().ShowData.DataPools[Groups_Pool].Groups:Children()
    local All5Object                                     = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]
    local MatricksObject                                 = Root().ShowData.DataPools[Construct_Pool].Matricks
    local AppearObject                                   = Root().ShowData.Appearances
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local Group_Tag                                      = {}
    for ta = 1, NbGroup do
        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == prefix .. '_Group_' .. ta then
                table.insert(Group_Tag, TagObject_LC[v])
            end
        end
    end

    for g = 1, NbGroup, 1 do
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!
        NrAppear = math.floor(AppNr + 1)
        NrNeed = math.floor(AppNr + 1)
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', GroupsObject[1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Group' .. g)
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityobjectname', 'Visible')
        Layout_Object[TLayNr][Nr.No]:Set('Action', 0)

        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. '_Select_Group_' .. g)
        for a = 1, 7 do
            MacroObject[CurrentMacroNr]:Insert(a)
        end
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' .. Construct_Pool .. ' Sequence ' ..
            CurrentSeqNr .. ' Thru ' .. CurrentSeqNr + Color_Range - 1 .. ' Cue 1 Part 0.1 Property "Selection"')
        MacroObject[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" 11')
        MacroObject[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr)
        MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Element" ' .. Nr.No)
        MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool)
        MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Sequence" ' .. CurrentSeqNr)
        MacroObject[CurrentMacroNr][7]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Macro set Group ' .. g)
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)
        local FirstSeqColor = CurrentSeqNr

        -- COLOR SEQ  /// Assign Values Preset 21.2 At Sequence 22 Cue 1 part 0.1 /// Set Preset 25 Property'PresetMode' "Universal"
        for col in ipairs(TCol) do
            col_count = col_count + 1
            local StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            local StColName = TCol[col].name
            local StringColName = string.gsub(StColName, " ", "_")
            local ColNr = SelectedGelNr .. "." .. TCol[col].no
            -- Create Sequences
            LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
            SequenceObject:Create(CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('Name', prefix .. StringColName .. "_Group_" .. g)
            LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
            SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
            SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed + 1])
            SequenceObject[CurrentSeqNr][3]:Set('No', 1)
            SequenceObject[CurrentSeqNr][3]:Create(1)
            SequenceObject[CurrentSeqNr][3][1]:Insert()
            SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])
            SequenceObject[CurrentSeqNr][3][1]:Create(1)
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Selection', GroupsObject[1])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Values', All5Object[All_5_NrStart + col - 1])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('MAtricks', MatricksObject[MatrickNrStart])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('SelectionMode', 'Strict')
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Enabled', 'Yes')
            Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. Group_Tag[g])

            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', 100)
            Layout_Object[TLayNr][Nr.No]:Set('height', 100)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)

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
            LastSeqColor = CurrentSeqNr
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end COLOR SEQ

        -- add matrick group

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. "Tricks_Group_" .. g)
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppTricks[2].Nr])

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command', "Assign DataPool " .. Construct_Pool ..
            " MaTricks '" .. prefix .. '_Group_' .. g ..
            "' At DataPool " .. Construct_Pool .. " Sequence " .. FirstSeqColor .. " Thru " .. LastSeqColor ..
            " Cue 1 part 0.1 ;  Assign DataPool " .. Construct_Pool .. " Sequence " .. CurrentSeqNr + 1 ..
            " At DataPool " .. Construct_Pool .. " Layout " .. TLayNr .. "." .. LayNr .. "")

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Tricks')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. "Tricksh" .. '_Group_' .. g)
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppTricks[1].Nr])
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command', "Assign DataPool " .. Construct_Pool ..
            ' MaTricks ' .. MatrickNrStart .. ' At DataPool ' .. Construct_Pool .. ' Sequence ' .. FirstSeqColor ..
            ' Thru ' .. LastSeqColor .. ' Cue 1 part 0.1 ; Assign DataPool ' .. Construct_Pool ..
            ' Sequence ' .. CurrentSeqNr - 1 .. ' At DataPool ' .. Construct_Pool .. ' Layout ' .. TLayNr ..
            '.' .. LayNr .. "")

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW - 35 + 20)

        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. '_Group_' .. g)
        MacroObject[CurrentMacroNr]:Set('Appearance', AppearObject[AppTricks[3].Nr])
        MacroObject[CurrentMacroNr]:Insert(1)

        MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
            Construct_Pool .. ' Matrick ' .. prefix .. '_Group_' .. g)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Macro')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- FirstSeqColor = CurrentSeqNr
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    end                              -- end GRP
    return LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr, ColLgnCount, Ligne_Inc
end                                  -- end LC_Create_Appearances_Sequences

function LC_Create_All_Color(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW, LayH, MaxColLgn,
                             RefX, AppNr, Construct_Pool, CurrentMacroNr, NbGroup)
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

    LayNr = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    LayX = math.floor(LayX + LayW + 20)
    NrNeed = math.floor(AppNr + 1)
    local allmacrocallstar = CurrentMacroNr
    local allmacrocallend
    local col_count = 0
    local First_All_Color
    for col in ipairs(TCol) do
        col_count = col_count + 1
        local StColName = TCol[col].name
        local StringColName = string.gsub(StColName, " ", "_")
        if col == 1 then
            First_All_Color = prefix .. 'ALL' .. StringColName .. 'ALL\''
        end

        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'ALL' .. StringColName .. "ALL")
        for b = 1, NbGroup do
            MacroObject[CurrentMacroNr]:Insert(b)
            MacroObject[CurrentMacroNr][b]:Set('Command', 'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
                prefix .. StringColName .. '* if ' .. Group_Tag[b])
            Cmd("Assign " .. MacroObject[CurrentMacroNr][b] .. " at " .. Group_Tag[b])
            MacroObject[CurrentMacroNr][b]:Set('Enabled', 0)
        end
        MacroObject[CurrentMacroNr]:Insert(NbGroup + 1)
        MacroObject[CurrentMacroNr][NbGroup + 1]:Set('Command',
            'Off DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr)

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. 'ALL' .. StringColName .. "ALL")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', NrNeed + 1)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', NrNeed + 1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command',
            'Go+ DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr)

        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        if (col_count ~= MaxColLgn) then
            LayX = math.floor(LayX + LayW + 20)
        else
            LayX = RefX
            LayX = math.floor(LayX + LayW + 20)
            LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
            LayY = math.floor(LayY - LayH)
            col_count = 0
        end

        NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end
    allmacrocallend = CurrentMacroNr - 1
    LayX = math.floor(LayX + LayW + 20)

    return LayNr, LayX, First_All_Color, CurrentMacroNr, allmacrocallstar, allmacrocallend, CurrentSeqNr
end -- end LC_Create_All_Color

function LC_Command_Title(title, TLayNr, LayNr, LayX, LayY, Pw, Ph, align, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('width', Pw)
    Layout_Object[TLayNr][Nr.No]:Set('height', Ph)
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Titre')
    Layout_Object[TLayNr][Nr.No]:Set('customtexttext', title)
    Layout_Object[TLayNr][Nr.No]:Set('Name', title)
    Layout_Object[TLayNr][Nr.No]:Set('visibilityborder', 'None')
    Layout_Object[TLayNr][Nr.No]:Set('bordersize', 0)
    Layout_Object[TLayNr][Nr.No]:Set('customtextsize', 24)
    Layout_Object[TLayNr][Nr.No]:Set('customtextalignmentv', 'Top')
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', 'None')
    if (align == 1) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Left')
    elseif (align == 2) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Center')
    elseif (align == 3) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Right')
    elseif (align == 4) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Left')
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmentv', 'Bottom')
    end
    return Nr.No
end -- end function LC_Command_Title(...)

function LC_Build_Tag(prefix, NbGroup, surfix, Time_Argument)
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local LC_TAGS_CHECKS = {}
    local LC_TAGS = {}
    local Tag_Type = {}
    for t = 1, NbGroup do
        table.insert(LC_TAGS, prefix .. '_Group_' .. t)
        table.insert(Tag_Type, 'Kill Delayed')
    end

    table.insert(LC_TAGS, prefix .. '_Group_ALL')
    table.insert(Tag_Type, 'Kill Delayed')
    table.insert(LC_TAGS, prefix .. 'Call_Group_ALL')
    table.insert(Tag_Type, 'None')

    for s in ipairs(surfix) do
        for a in ipairs(Time_Argument) do
            if Time_Argument[a].name ~= 'axes' then
                table.insert(LC_TAGS, prefix .. '_' .. Time_Argument[a].name .. '_' .. surfix[s])
                table.insert(Tag_Type, Time_Argument[a].type)
            else
                if s == 1 then
                    table.insert(LC_TAGS, prefix .. '_' .. Time_Argument[a].name)
                    table.insert(Tag_Type, Time_Argument[a].type)
                end
            end
        end
    end

    for i = 1, #LC_TAGS, 1 do
        LC_TAGS_CHECKS[i] = false
    end

    for v in pairs(LC_TAGS) do
        for k in pairs(TagObject_C) do
            if LC_TAGS[v] == TagObject_C[k].Name then
                LC_TAGS_CHECKS[v] = true
                break
            end
        end
    end
    for k in pairs(LC_TAGS_CHECKS) do
        if LC_TAGS_CHECKS[k] == false then
            local nr = TagObject:Acquire()
            TagObject[nr.No]:Set('Name', LC_TAGS[k])
            TagObject[nr.No]:Set('TAGTYPE', Tag_Type[k])
        end
    end
end

function LC_Create_Fade_Sequences(MakeX, FirstSeqTime, LastSeqTime, CurrentSeqNr, CurrentMacroNr, prefix, surfix,
                                  First_Id_Lay, LayNr, MatrickNrStart, TLayNr, Fade_Element, Argument_Fade,
                                  AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element,
                                  a,
                                  Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_fade

    -- Setup Fade Sequence
    local old_prefix                                     = prefix
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
    MacroObject[CurrentMacroNr]:Set('Name', prefix .. 'Time Input' .. surfix[a])
    MacroObject[CurrentMacroNr]:Insert(1)
    if MakeX then
        MacroObject[CurrentMacroNr][1]:Set('Command', '')
        Fade_Element = math.floor(LayNr + 6)
    else
        MacroObject[CurrentMacroNr][1]:Set('Command', '')
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
    MacroObject[CurrentMacroNr][9]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    CurrentMacroNr = CurrentMacroNr + 1

    for v in ipairs(TagObject_LC) do
        if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[1].name .. '_' .. surfix[a] then
            tag_fade = TagObject_LC[v]
        end
    end

    if a == 1 then
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Fade[1].name .. surfix[a])
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[2].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[1].Nr)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Sequence ' ..
            SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')

        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_fade)
        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Fade')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        LayNr = LC_Command_Title('Ex.Time', TLayNr, LayNr, LayX, LayY, 700, 140, 1, Construct_Pool)
        LayNr = LC_Command_Title('FADE', TLayNr, LayNr, LayX, LayY, 700, 140, 2, Construct_Pool)
        LayNr = LC_Command_Title('none > none', TLayNr, LayNr, LayX, LayY, 700, 140, 3, Construct_Pool)
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
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Fade[i].name .. surfix[a])
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        if i == 6 then
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr - 5)
        else
            CurrentMacroNr = Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
                LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool,
                Call_Pool)
            SequenceObject[CurrentSeqNr][3][1]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr - 1)
        end
        SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppImp[ia].Nr)
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_fade)
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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Fade')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_F_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- CurrentMacroNr = CurrentMacroNr + 1
    end -- end Sequences FADE

    return CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay, Fade_Element, CurrentMacroNr, First_Id_Lay
end -- end LC_Create_Fade_Sequences

function LC_Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                                        AppImp, CurrentMacroNr, a, MatrickNrStart, TLayNr, Delay_F_Element, MatrickNr,
                                        MakeX,
                                        LayX, LayY, LayW, LayH, Delay_T_Element, Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_delay_from

    -- Setup Delay from Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    -- Setup DelayFrom Sequence
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 5)
    local FirstSeqDelayFrom                              = CurrentSeqNr
    local LastSeqDelayFrom                               = math.floor(CurrentSeqNr + 4)

    -- Create Macro DelayFrom Input
    -- Delay_F_Element                                      = Delay_F_Element + 2
    LC_Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayFrom, LastSeqDelayFrom,
        MatrickNrStart, 2, TLayNr, Delay_F_Element, MatrickNr, Construct_Pool, Call_Pool)

    if MakeX then
        LC_Command_Title('DELAY FROM', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[2].name .. '_' .. surfix[a] then
                tag_delay_from = TagObject_LC[v]
            end
        end

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_Delay[i].name .. surfix[a])
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
            SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call ' .. Call_Pool .. ' Plugin "DEV_LC_View" ')
        end
        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_delay_from)

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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Delay from')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_T_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayFrom
    return Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr, CurrentMacroNr, Delay_F_Element
end     --LC_Create_Delay_From_Sequences

function LC_Create_Delay_To_Sequences(a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, Argument_DelayTo,
                                      surfix,
                                      MatrickNrStart, TLayNr, Delay_T_Element, MatrickNr, AppImp, LayX, LayY, LayW, LayH,
                                      Phase_Element, CurrentMacroNr, MakeX, Construct_Pool, Call_Pool, Time_Argument)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- fix time_tag
    local TagObject_LC                                   = Root().ShowData.Tags:Children()
    local tag_delay_to

    -- Setup Delay to Sequence
    local old_prefix                                     = prefix
    prefix                                               = 'o' .. prefix
    -- Setup DelayTo Sequence
    CurrentMacroNr                                       = math.floor(CurrentMacroNr + 1)
    local FirstSeqDelayTo                                = CurrentSeqNr
    local LastSeqDelayTo                                 = math.floor(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    -- Delay_T_Element                                      = Delay_T_Element + 2
    LC_Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayTo, LastSeqDelayTo, MatrickNrStart,
        3, TLayNr, Delay_T_Element, MatrickNr, Construct_Pool, Call_Pool)

    if MakeX then
        LC_Command_Title('DELAY TO', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        LC_Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        for v in ipairs(TagObject_LC) do
            if TagObject_LC[v].Name == old_prefix .. '_' .. Time_Argument[3].name .. '_' .. surfix[a] then
                tag_delay_to = TagObject_LC[v]
            end
        end

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', prefix .. Argument_DelayTo[i].name .. surfix[a])
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
            SequenceObject[CurrentSeqNr][3][1]:Set('Command', 'Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call ' .. Call_Pool .. ' Plugin "DEV_LC_View" ')
        end
        Cmd('Assign ' .. SequenceObject[CurrentSeqNr] .. " at " .. tag_delay_to)

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
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Delay to')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayTo
    return First_Id_Lay, Current_Id_Lay, LayX, LayNr, Phase_Element, CurrentSeqNr, CurrentMacroNr, Delay_T_Element
end     -- end LC_Create_Delay_To_Sequences

--end LC_Cmd.lua
