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
local function Build_Macro_All_None()

    local MacroNum, VariaSel, MacroEnd
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }

    MacroNum = 1602
    MacroEnd = MacroNum + 11
    VariaSel = 1


    local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]


    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'all_sub_#' .. count)
        for a = 1, 8 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Go+ Cue 1 DataPool '" .. Build_Pool.Name .. "' Sequence thru if Tag '" ..
                varia_min[VariaSel] .. "_btn_sub_#" .. count .. "'")
            VariaSel = VariaSel + 1
        end
        VariaSel = 1
        count = count + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    count = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'none_sub_#' .. count)
        for a = 1, 8 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Go+ Cue 2 DataPool '" .. Build_Pool.Name .. "' Sequence thru if Tag '" ..
                varia_min[VariaSel] .. "_btn_sub_#" .. count .. "'")
            VariaSel = VariaSel + 1
        end
        VariaSel = 1
        count = count + 1
    end
end

return Build_Macro_All_None
