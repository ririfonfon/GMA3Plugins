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
    local Construct_Pool = 41
    local Layout_Nr = 2
    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    local Layout_Object_C = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools

    for k = 1, 2408 do
        local x = Layout_Object_C[Layout_Nr][k]:Get('posx')
        local y = Layout_Object_C[Layout_Nr][k]:Get('posy')
        Layout_Object_C[Layout_Nr][k]:Set('posx', x - 1030)
        Layout_Object_C[Layout_Nr][k]:Set('posy', y + 524)
    end
end

return main
