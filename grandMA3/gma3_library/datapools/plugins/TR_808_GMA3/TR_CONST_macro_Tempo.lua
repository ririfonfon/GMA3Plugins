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
    local Tempo_Count = { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "create macro Tempo for TR-808",
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

    local Construct_Pool = 41
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools

    local Reset = MacroNum

    MacroNum = MacroNum + 1
    MacroEnd = MacroNum + 15
    count = 1

    for i = MacroNum, MacroEnd, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Tempo_#' .. count)
        for a = 1, 8 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command', "Goto DataPool '" .. PoolObject[Construct_Pool].Name ..
                "' Cue " .. count .. " Sequence Thru if Tag 'Varia_" .. varia_mag[VariaSel] ..
                "; Goto DataPool '" .. PoolObject[Construct_Pool].Name .. "' Cue " .. count ..
                " Sequence Thru if Tag 'Temps_" .. Tempo_Count[count] .. "'")
            VariaSel = VariaSel + 1
        end
        count = count + 1
        VariaSel = 1
    end

    count = 1
    MacroObject:Delete(Reset)
    Check_Size_Pool(Reset, MacroObject)
    MacroObject:Create(Reset)
    MacroObject[Reset]:Set('Name', 'Tempo_Reset')
    for a = 1, 16 do
        MacroObject[Reset]:Acquire()
        MacroObject[Reset][a]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
            "'.'Macros'.'Tempo_#" .. count .. "'.1 Thru 16 'Enabled' 0")
        count = count + 1
    end
end

return main
