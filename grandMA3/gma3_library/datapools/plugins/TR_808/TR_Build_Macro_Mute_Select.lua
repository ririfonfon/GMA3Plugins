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
local function Build_Macro_Mute_Select()
    
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local MacroNum = 1670
    local VariaSel = 1
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

return Build_Macro_Mute_Select
