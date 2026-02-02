local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
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
        { name = "macro Number", value = "1", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 }, type = 1 },
    }

    local MacroNum, VariaSel, MacroEnd, subSel, lay_object
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "create macro for TR-808",
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
        if k == "macro Number" then
            MacroNum = tonumber(v)
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        end
    end

    local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Clear_sub')
    for a = 1, 12 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'all_sub_#" .. count .. "'.1 Thru 8 'Enabled' 0")
        count = count + 1
    end
    count = 1
    for a = 13, 24 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Set DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Macro 'none_sub_#" .. count .. "'.1 Thru 8 'Enabled' 0")
        count = count + 1
    end
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][25]:Set('Command',
        "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Mute'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][26]:Set('Command',
        "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Off_Mute'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][27]:Set('Command',
        "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Select'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][28]:Set('Command',
        "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Off_Select'.1 Thru 8 'Enabled' 0")





    MacroNum = MacroNum + 1
    MacroEnd = MacroNum + (8 - VariaSel)

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'all_sub_varia_' .. varia_min[VariaSel])
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command',
            "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'Clear_sub'")
        for a = 2, 13 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'all_sub_#" .. count .. "'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        for a = 14, 25 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "' Macro 'none_sub_#" .. count .. "'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        MacroObject[i]:Acquire()
        MacroObject[i][26]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Macro 'Mute'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][27]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Macro 'Off_Mute'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][28]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Macro 'Select'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][29]:Set('Command',
            "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Macro 'Off_Select'." .. VariaSel .. " 'Enabled' 1")

        count = 1
        VariaSel = VariaSel + 1
    end
end

return main
