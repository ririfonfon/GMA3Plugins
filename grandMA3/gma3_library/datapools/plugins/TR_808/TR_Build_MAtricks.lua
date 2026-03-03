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
local function Build_MAtricks()

    local MAtricksNum = 1
    local Construct_Pool = 43
    local MAtricksObject = Root().ShowData.DataPools[Construct_Pool].MAtricks
    local i = MAtricksNum

    Check_Size_Pool(i, MAtricksObject)
    MAtricksObject:Create(i)
    MAtricksObject[i]:Set('Name', 'TR_INPUT')
end

return Build_MAtricks
