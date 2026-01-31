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
local function main()
    local inputs = {
        { name = "Sequence Number", value = "1", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local SeqNum, VariaSel, SeqEnd, subSel
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "set btn sequence number    ",
                message = "Please enter the sequence number to set.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                inputs = inputs,
                selectors = selectors,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    -- print results:

    for k, v in pairs(resultTable.inputs) do
        -- Printf("Input '%s' = '%s'", k, v)
        SeqNum = tonumber(v)
        SeqEnd = SeqNum + 11
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        elseif k == "Sub Selector" then
            subSel = v
        end
    end

    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local AppObject = Root().ShowData.Appearances

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_mute_#' .. subSel)
        SequenceObject[i]:Set('Appearance', AppObject[320])
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', AppObject[319])
        SequenceObject[i][3][1]:Set('Command', "Set #[DataPool '" .. PoolObject[Construct_Pool].Name ..
            "'.'Sequences'.'" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel ..
            "'] Cue 1 Thru 16 Part 0.1 Property 'Enabled' 0; Set #[DataPool '" ..
            PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_No_Solo']." .. subSel .. " 'Enabled' 0")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Appearance', AppObject[320])
        SequenceObject[i][4][1]:Set('Command', "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name ..
            "'.'Macros'.'" .. varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "']; Set #[DataPool '" ..
            PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_No_Solo']." .. subSel .. " 'Enabled' 1")
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
        SequenceObject[i]:Set('Appearance', AppObject[318])
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', AppObject[317])
        SequenceObject[i][3][1]:Set('Command', "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_On_Solo_Sub_#" .. subSel .. "']")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Appearance', AppObject[318])
        SequenceObject[i][4][1]:Set('Command', "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Off_Solo_Sub_#" .. subSel .. "']")
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
        SequenceObject[i]:Set('Appearance', AppObject[321])
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', AppObject[322])
        SequenceObject[i][3][1]:Set('Command', "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Tag_Sub_#" .. subSel .. "']")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Appearance', AppObject[321])
        SequenceObject[i][4][1]:Set('Command', "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Off_Tag_Sub_#" .. subSel .. "']")
        subSel = subSel + 1
    end

    SeqNum = SeqEnd + 2
    subSel = 1

    Check_Size_Pool(SeqNum, SequenceObject)
    SequenceObject:Create(SeqNum)
    SequenceObject[SeqNum]:Set('Name', varia_min[VariaSel] .. '_select_all_none')
    SequenceObject[SeqNum]:Set('Appearance', AppObject[320])
    SequenceObject[SeqNum]:Set('PreferCueAppearance', 1)
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][3]:Set('No', 1)
    SequenceObject[SeqNum][3]:Create(1)
    SequenceObject[SeqNum][3][1]:Set('Appearance', AppObject[319])
    SequenceObject[SeqNum][3][1]:Set('Command', "Goto Cue 1 #[DataPool '" .. PoolObject[Construct_Pool].Name ..
        "'] Sequence Thru if #[Tag'Select_" .. varia_mag[VariaSel] .. "']")
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][4]:Set('No', 2)
    SequenceObject[SeqNum][4]:Create(1)
    SequenceObject[SeqNum][4][1]:Set('Appearance', AppObject[320])
    SequenceObject[SeqNum][4][1]:Set('Command', "Goto Cue 2 #[DataPool '" .. PoolObject[Construct_Pool].Name ..
        "'] Sequence Thru if #[Tag'Select_" .. varia_mag[VariaSel] .. "']")

    Check_Size_Pool(mute_all, SequenceObject)
    SequenceObject:Create(mute_all)
    SequenceObject[mute_all]:Set('Name', 'mute_all_none')
    SequenceObject[mute_all]:Set('Appearance', AppObject[320])
    SequenceObject[mute_all]:Set('PreferCueAppearance', 1)
    SequenceObject[mute_all]:Insert()
    SequenceObject[mute_all][3]:Set('No', 1)
    SequenceObject[mute_all][3]:Create(1)
    SequenceObject[mute_all][3][1]:Set('Appearance', AppObject[319])
    SequenceObject[mute_all][3][1]:Set('Command',
        "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'Mute']")
    SequenceObject[mute_all]:Insert()
    SequenceObject[mute_all][4]:Set('No', 2)
    SequenceObject[mute_all][4]:Create(1)
    SequenceObject[mute_all][4][1]:Set('Appearance', AppObject[320])
    SequenceObject[mute_all][4][1]:Set('Command',
        "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'Off Mute']")

    Check_Size_Pool(solo_all, SequenceObject)
    SequenceObject:Create(solo_all)
    SequenceObject[solo_all]:Set('Name', 'solo_all_none')
    SequenceObject[solo_all]:Set('Appearance', AppObject[318])
    SequenceObject[solo_all]:Set('PreferCueAppearance', 1)
    SequenceObject[solo_all]:Insert()
    SequenceObject[solo_all][3]:Set('No', 1)
    SequenceObject[solo_all][3]:Create(1)
    SequenceObject[solo_all][3][1]:Set('Appearance', AppObject[317])
    SequenceObject[solo_all][3][1]:Set('Command',
        "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'Select']")
    SequenceObject[solo_all]:Insert()
    SequenceObject[solo_all][4]:Set('No', 2)
    SequenceObject[solo_all][4]:Create(1)
    SequenceObject[solo_all][4][1]:Set('Appearance', AppObject[318])
    SequenceObject[solo_all][4][1]:Set('Command',
        "Go+ #[DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'Off Select']")
end

return main
