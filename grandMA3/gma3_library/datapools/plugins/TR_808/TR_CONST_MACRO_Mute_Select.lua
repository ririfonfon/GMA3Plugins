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
        { name = "macro Number", value = "1670", whiteFilter = "0123456789" },
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
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]


    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Mute')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 1 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
    
    VariaSel = 1
    MacroNum = MacroNum + 1

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Select')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 1 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
    
    VariaSel = 1
    MacroNum = MacroNum + 2

Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Off_Mute')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 2 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
    VariaSel = 1

    MacroNum = MacroNum + 1

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Off_Select')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 2 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
end

return main
