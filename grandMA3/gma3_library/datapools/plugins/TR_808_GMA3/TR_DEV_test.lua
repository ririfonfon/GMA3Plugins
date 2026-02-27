local thiscomponent = select(4, ...)
local function main()
    local PoolObject = DataPool()
    Printf(PoolObject.Name)
    -- local PPoolObject = Root().ShowData.DataPools:Children()
    -- Printf(PPoolObject.Name)
    local mydatapool = thiscomponent:FindParent(DataPool():GetClass())
    Printf(mydatapool.Name)

end
return main
