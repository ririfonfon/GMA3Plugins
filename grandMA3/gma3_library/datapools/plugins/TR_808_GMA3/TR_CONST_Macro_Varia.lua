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
        { name = "Macro Number", value = "4", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd
    local subSel = 1
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "create macro Varia for TR-808",
                message = "Please enter the macro number.",
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
        Printf("Input '%s' = '%s'", k, v)
        if k == "Macro Number" then
            MacroNum = tonumber(v) -- Varia_ABC
            MacroEnd = MacroNum + 7
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Sub Selector" then
            subSel = tonumber(v)
        elseif k == "Varia Selector" then
            VariaSel = tonumber(v)
        end
    end
    local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools

    local MNum_V, MEnd_V, MNum_Call, MEnd_Call, MNum_Play, MEnd_Play, nr, nr_C, nr_P

    MNum_V = MacroNum
    MEnd_V = MacroEnd
    nr = MEnd_V + 9            -- de Varia_ABC >>> Varia_Call
    MNum_Call = MEnd_V + 10    -- Varia_ _Call
    MEnd_Call = MNum_Call + 7
    nr_C = MEnd_Call + 2       -- de Varia_ _ Call >>> Varia_Current
    nr_P = MEnd_Call + 4       -- de Varia_ _Call >>> Varia_Play
    MNum_Play = MEnd_Call + 27 -- Varia_ _Play
    MEnd_Play = MNum_Play + 7

    Printf('MNum_V : ' .. MNum_V .. ' MEnd_V : ' .. MEnd_V .. ' nr : ' .. nr ..
        ' MNum_Call : ' .. MNum_Call .. ' MEnd_Call : ' .. MEnd_Call ..
        ' nr_C : ' .. nr_C .. ' nr_ P : ' .. nr_P .. ' MNum_Play : ' .. MNum_Play .. ' MEnd_Play : ' .. MEnd_Play)


    subSel = 1
    count = 1
    VariaSel = 1
    -- Varia_ _Play
    for i = MNum_Play, MEnd_Play, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Varia_' .. varia_mag[VariaSel] .. '_Play')
        for a = 1, 3 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command',
            "Goto Cue 3 DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence Thru if Tag 'Variation_Play'")
        MacroObject[i][2]:Set('Command', "Goto Cue 2 DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Sequence 'btn_" .. varia_min[VariaSel] .. "_green'")
        MacroObject[i][3]:Set('Command', "GO+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Sequence '" .. varia_mag[VariaSel] .. "_Tempo'")
        subSel = subSel + 1
        count = count + 1
        VariaSel = VariaSel + 1
    end

    subSel = 1
    count = 1
    VariaSel = 1
    -- Varia_ _ Call
    for i = MNum_Call, MEnd_Call, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Varia_' .. varia_mag[VariaSel] .. '_Call')
        for a = 1, 18 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command',
            "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_Reset']")
        MacroObject[i][2]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#1'." .. count .. " 'Enabled' 1")
        MacroObject[i][3]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#2'." .. count .. " 'Enabled' 1")
        MacroObject[i][4]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#3'." .. count .. " 'Enabled' 1")
        MacroObject[i][5]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#4'." .. count .. " 'Enabled' 1")
        MacroObject[i][6]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#5'." .. count .. " 'Enabled' 1")
        MacroObject[i][7]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#6'." .. count .. " 'Enabled' 1")
        MacroObject[i][8]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#7'." .. count .. " 'Enabled' 1")
        MacroObject[i][9]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#8'." .. count .. " 'Enabled' 1")
        MacroObject[i][10]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#9'." .. count .. " 'Enabled' 1")
        MacroObject[i][11]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#10'." .. count .. " 'Enabled' 1")
        MacroObject[i][12]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#11'." .. count .. " 'Enabled' 1")
        MacroObject[i][13]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#12'." .. count .. " 'Enabled' 1")
        MacroObject[i][14]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#13'." .. count .. " 'Enabled' 1")
        MacroObject[i][15]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#14'." .. count .. " 'Enabled' 1")
        MacroObject[i][16]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#15'." .. count .. " 'Enabled' 1")
        MacroObject[i][17]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Tempo_#16'." .. count .. " 'Enabled' 1")
        MacroObject[i][18]:Set('Command', "Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Varia_" .. varia_mag[VariaSel] .. "_Play'")
        subSel = subSel + 1
        count = count + 1
        VariaSel = VariaSel + 1
    end

    -- de Varia_ABC >>> Varia_Call
    MacroObject:Delete(nr)
    Check_Size_Pool(nr, MacroObject)
    MacroObject:Create(nr)
    MacroObject[nr]:Set('Name', 'Varia_Call')
    for a = 1, 9 do
        MacroObject[nr]:Insert(a)
    end
    MacroObject[nr][1]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_A_Play'")
    MacroObject[nr][2]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_B_Play'")
    MacroObject[nr][3]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_C_Play'")
    MacroObject[nr][4]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_D_Play'")
    MacroObject[nr][5]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_E_Play'")
    MacroObject[nr][6]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_F_Play'")
    MacroObject[nr][7]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_G_Play'")
    MacroObject[nr][8]:Set('Command',
        "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_H_Play'")
    MacroObject[nr][9]:Set('Command',
        "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Call'.1 Thru 9 'Enabled' 0")

    -- de Varia_ _ Call >>> Varia_Current
    MacroObject:Delete(nr_C)
    Check_Size_Pool(nr_C, MacroObject)
    MacroObject:Create(nr_C)
    MacroObject[nr_C]:Set('Name', 'Varia_Current')
    for a = 1, 8 do
        MacroObject[nr_C]:Insert(a)
    end
    MacroObject[nr_C][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_A';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_A' ")
    MacroObject[nr_C][2]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_B';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_B' ")
    MacroObject[nr_C][3]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_C';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_C' ")
    MacroObject[nr_C][4]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_D';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_D' ")
    MacroObject[nr_C][5]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_E';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_E' ")
    MacroObject[nr_C][6]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_F';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_F' ")
    MacroObject[nr_C][7]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_G';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_G' ")
    MacroObject[nr_C][8]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Edit_Varia_H';Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Sequence 'Varia_H' ")


    -- de Varia_ _ Call >>> Varia_Play
    MacroObject:Delete(nr_P)
    Check_Size_Pool(nr_P, MacroObject)
    MacroObject:Create(nr_P)
    MacroObject[nr_P]:Set('Name', 'Varia_Play')
    for a = 1, 8 do
        MacroObject[nr_P]:Insert(a)
    end
    MacroObject[nr_P][1]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_A_Play'")
    MacroObject[nr_P][1]:Set('Enabled', 0)
    MacroObject[nr_P][2]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_B_Play'")
    MacroObject[nr_P][2]:Set('Enabled', 0)
    MacroObject[nr_P][3]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_C_Play'")
    MacroObject[nr_P][3]:Set('Enabled', 0)
    MacroObject[nr_P][4]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_D_Play'")
    MacroObject[nr_P][4]:Set('Enabled', 0)
    MacroObject[nr_P][5]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_E_Play'")
    MacroObject[nr_P][5]:Set('Enabled', 0)
    MacroObject[nr_P][6]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_F_Play'")
    MacroObject[nr_P][6]:Set('Enabled', 0)
    MacroObject[nr_P][7]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_G_Play'")
    MacroObject[nr_P][7]:Set('Enabled', 0)
    MacroObject[nr_P][8]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
        "' Macro 'Varia_H_Play'")
    MacroObject[nr_P][8]:Set('Enabled', 0)

    -----

    subSel = 1
    count = 1
    VariaSel = 1
    for i = MNum_V, MEnd_V, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Varia_' .. varia_mag[VariaSel])
        for a = 1, 6 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Call'." .. count .. " 'Enabled' 1")
        MacroObject[i][2]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Call'.9 'Enabled' 1")
        MacroObject[i][3]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Current'.1 Thru 8 'Enabled' 0")
        MacroObject[i][4]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Current'." .. count .. " 'Enabled' 1")
        MacroObject[i][5]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Play'.1 Thru 8 'Enabled' 0")
        MacroObject[i][6]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'Varia_Play'." .. count .. "  'Enabled' 1")
        subSel = subSel + 1
        count = count + 1
        VariaSel = VariaSel + 1
    end

    local varia_place = { 55, 346, 637, 928, 1219, 1510, 1801, 2092, 2383 }

    local MNum_E, MEnd_E
    MNum_E = MEnd_Play + 10
    MEnd_E = MNum_E + 7
    subSel = 1
    count = 1
    VariaSel = 1
    for i = MNum_E, MEnd_E, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Edit_Varia_' .. varia_mag[VariaSel])
        for a = 1, 3 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Layout 1.55 Thru 2382 'VisibilityElement' = '0'")
        MacroObject[i][2]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Layout 1." ..
            varia_place[count] .. " Thru " .. varia_place[count + 1] - 1 .. " 'VisibilityElement' = '1'")
        MacroObject[i][3]:Set('Command', "Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'all_sub_varia_" .. varia_min[VariaSel] .. "'")

        subSel = subSel + 1
        count = count + 1
        VariaSel = VariaSel + 1
    end
end

return main
