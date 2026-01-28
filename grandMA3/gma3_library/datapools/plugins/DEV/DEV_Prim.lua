local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used') end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end
local function main()
    local pool_construct = 42
    local MatrickNrStart = 1001
    local MatrickObject = Root().ShowData.DataPools[pool_construct].Matricks
    Printf(MatrickObject:Count())
    Check_Size_Pool(MatrickNrStart, MatrickObject)
    MatrickObject:Acquire()
    Printf(MatrickObject:MaxCount())
    MatrickObject:Create(MatrickNrStart)
    MatrickObject[MatrickNrStart]:Set('Name', 'test')


    -- local AppObject = Root().ShowData.Appearances
    -- AppObject:Create(1002)
    -- AppObject[1002]:Set('Name','LC2_tricks_on')
    -- AppObject[1003]:Set('Appearance','Showdata.MediaPools.Symbols.[arrow_right_black_png]')
end
return main
