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
        { name = "Sequence Number", value = "766", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local SeqNum, VariaSel, SeqEnd, subSel
    local count = 1
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
        SeqEnd = SeqNum + 15
    end
    for k, v in pairs(resultTable.selectors) do
        -- Printf("Selector '%s' = '%d'", k, v)
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
    for v = 1, 8 do
        for e = 1, 12, 1 do
            for i = SeqNum, SeqEnd, 1 do
                Check_Size_Pool(i, SequenceObject)
                SequenceObject:Create(i)
                SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_sub_' .. subSel .. '_t_' .. count)
                SequenceObject[i]:Set('Appearance', AppObject[270])
                SequenceObject[i]:Set('PreferCueAppearance', 1)
                SequenceObject[i]:Insert()
                SequenceObject[i][3]:Set('No', 1)
                SequenceObject[i][3]:Create(1)
                SequenceObject[i][3][1]:Set('Appearance', AppObject[271])
                SequenceObject[i][3][1]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 1; Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub#" .. subSel .. "'." .. count .. " 'Enabled' 1")
                SequenceObject[i]:Insert()
                SequenceObject[i][4]:Set('No', 2)
                SequenceObject[i][4]:Create(1)
                SequenceObject[i][4][1]:Set('Appearance', AppObject[270])
                SequenceObject[i][4][1]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 0; Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub#" .. subSel .. "'." .. count .. " 'Enabled' 0")
                Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
                    i .. " At Tag '" .. varia_min[VariaSel] .. "_btn_sub_#" .. subSel .. "'")
                count = count + 1
            end
            SeqNum = SeqEnd + 2
            SeqEnd = SeqNum + 15
            count = 1
            subSel = subSel + 1
        end
        SeqNum = SeqEnd + 2
        SeqEnd = SeqNum + 15
        VariaSel = VariaSel + 1
        subSel = 1
    end
end

return main
