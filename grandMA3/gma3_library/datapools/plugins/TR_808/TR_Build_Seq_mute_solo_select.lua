local function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used : ' .. id) end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end
local function Build_Seq_Mute_Solo()

    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local SeqNum = 69
    local SeqEnd = SeqNum + 11
    local VariaSel = 1
    local subSel = 1


    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local app_mute = { '[[27_btn_mute_low_png]]', '[[27_btn_mute_high_png]]', }
    local app_solo = { '[[26_btn_solo_low_png]]', '[[26_btn_solo_high_png]]', }
    local app_select = { '[[29_btn_select_low_png]]', '[[30_btn_solo_high_png]]', }
    local make = false

    for v = 1, 8 do
        for i = SeqNum, SeqEnd, 1 do
            Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_mute_#' .. subSel)
            SequenceObject[i]:Set('Appearance', app_mute[1]) --off state
            SequenceObject[i]:Set('PreferCueAppearance', 1)
            SequenceObject[i]:Insert()
            SequenceObject[i][3]:Set('No', 1)
            SequenceObject[i][3]:Create(1)
            SequenceObject[i][3][1]:Set('Appearance', app_mute[2]) --on state
            SequenceObject[i][3][1]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                "' Sequence '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel ..
                "' Cue 1 Thru 16 Part 0.1 Property 'Enabled' 0; Set DataPool '" ..
                PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_No_Solo'." .. subSel .. " 'Enabled' 0")
            SequenceObject[i]:Insert()
            SequenceObject[i][4]:Set('No', 2)
            SequenceObject[i][4]:Create(1)
            SequenceObject[i][4][1]:Set('Appearance', app_mute[1]) --off state
            SequenceObject[i][4][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
                "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "'; Set DataPool '" ..
                PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_No_Solo'." .. subSel .. " 'Enabled' 1")
            subSel = subSel + 1
        end

        local mute_all = SeqEnd + 2


        SeqNum = SeqEnd + 6
        SeqEnd = SeqNum + 11
        subSel = 1

        for i = SeqNum, SeqEnd, 1 do
            Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_solo_#' .. subSel)
            SequenceObject[i]:Set('Appearance', app_solo[1]) --off state
            SequenceObject[i]:Set('PreferCueAppearance', 1)
            SequenceObject[i]:Insert()
            SequenceObject[i][3]:Set('No', 1)
            SequenceObject[i][3]:Create(1)
            SequenceObject[i][3][1]:Set('Appearance', app_solo[2]) --on state
            SequenceObject[i][3][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_On_Solo_Sub_#" .. subSel .. "'")
            SequenceObject[i]:Insert()
            SequenceObject[i][4]:Set('No', 2)
            SequenceObject[i][4]:Create(1)
            SequenceObject[i][4][1]:Set('Appearance', app_solo[1]) --off state
            SequenceObject[i][4][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_Off_Solo_Sub_#" .. subSel .. "'")
            subSel = subSel + 1
        end

        local solo_all = SeqEnd + 2

        SeqNum = SeqEnd + 6
        SeqEnd = SeqNum + 11
        subSel = 1

        for i = SeqNum, SeqEnd, 1 do
            Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_select_#' .. subSel)
            SequenceObject[i]:Set('Appearance', app_select[1]) --off state
            SequenceObject[i]:Set('PreferCueAppearance', 1)
            SequenceObject[i]:Insert()
            SequenceObject[i][3]:Set('No', 1)
            SequenceObject[i][3]:Create(1)
            SequenceObject[i][3][1]:Set('Appearance', app_select[2]) --on state
            SequenceObject[i][3][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_Tag_Sub_#" .. subSel .. "'")
            SequenceObject[i]:Insert()
            SequenceObject[i][4]:Set('No', 2)
            SequenceObject[i][4]:Create(1)
            SequenceObject[i][4][1]:Set('Appearance', app_select[1]) --off state
            SequenceObject[i][4][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_Off_Tag_Sub_#" .. subSel .. "'")
            Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
                i .. " At Tag 'Select_" .. varia_mag[VariaSel] .. "'")
            subSel = subSel + 1
        end

        SeqNum = SeqEnd + 2
        subSel = 1

        Check_Size_Pool(SeqNum, SequenceObject)
        SequenceObject:Create(SeqNum)
        SequenceObject[SeqNum]:Set('Name', varia_min[VariaSel] .. '_select_all_none')
        SequenceObject[SeqNum]:Set('Appearance', app_select[1]) --off state
        SequenceObject[SeqNum]:Set('PreferCueAppearance', 1)
        SequenceObject[SeqNum]:Insert()
        SequenceObject[SeqNum][3]:Set('No', 1)
        SequenceObject[SeqNum][3]:Create(1)
        SequenceObject[SeqNum][3][1]:Set('Appearance', app_select[2]) --on state
        SequenceObject[SeqNum][3][1]:Set('Command', "Goto Cue 1 DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Sequence Thru if Tag'Select_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[SeqNum]:Insert()
        SequenceObject[SeqNum][4]:Set('No', 2)
        SequenceObject[SeqNum][4]:Create(1)
        SequenceObject[SeqNum][4][1]:Set('Appearance', app_select[1]) --off state
        SequenceObject[SeqNum][4][1]:Set('Command', "Goto Cue 2 DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Sequence Thru if Tag'Select_" .. varia_mag[VariaSel] .. "'")
        if make == false then
            Check_Size_Pool(mute_all, SequenceObject)
            SequenceObject:Create(mute_all)
            SequenceObject[mute_all]:Set('Name', 'mute_all_none')
            SequenceObject[mute_all]:Set('Appearance', app_mute[1]) --off state
            SequenceObject[mute_all]:Set('PreferCueAppearance', 1)
            SequenceObject[mute_all]:Insert()
            SequenceObject[mute_all][3]:Set('No', 1)
            SequenceObject[mute_all][3]:Create(1)
            SequenceObject[mute_all][3][1]:Set('Appearance', app_mute[2]) --on state
            SequenceObject[mute_all][3][1]:Set('Command',
                "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Mute'")
            SequenceObject[mute_all]:Insert()
            SequenceObject[mute_all][4]:Set('No', 2)
            SequenceObject[mute_all][4]:Create(1)
            SequenceObject[mute_all][4][1]:Set('Appearance', app_mute[1]) --off state
            SequenceObject[mute_all][4][1]:Set('Command',
                "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Off_Mute'")

            Check_Size_Pool(solo_all, SequenceObject)
            SequenceObject:Create(solo_all)
            SequenceObject[solo_all]:Set('Name', 'solo_all_none')
            SequenceObject[solo_all]:Set('Appearance', app_solo[1])
            SequenceObject[solo_all]:Set('PreferCueAppearance', 1)
            SequenceObject[solo_all]:Insert()
            SequenceObject[solo_all][3]:Set('No', 1)
            SequenceObject[solo_all][3]:Create(1)
            SequenceObject[solo_all][3][1]:Set('Appearance', app_solo[2]) --on state
            SequenceObject[solo_all][3][1]:Set('Command',
                "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Select'")
            SequenceObject[solo_all]:Insert()
            SequenceObject[solo_all][4]:Set('No', 2)
            SequenceObject[solo_all][4]:Create(1)
            SequenceObject[solo_all][4][1]:Set('Appearance', app_solo[1]) --off state
            SequenceObject[solo_all][4][1]:Set('Command',
                "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Off_Select'")
            make = true
        end
        VariaSel = VariaSel + 1
        SeqNum = SeqEnd + 23
        SeqEnd = SeqNum + 11
        subSel = 1
    end
end

return Build_Seq_Mute_Solo
