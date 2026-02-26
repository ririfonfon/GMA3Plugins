local function main()
    local PoolObject = DataPool()
    local PPoolObject = Root().ShowData.DataPools:Children()
    Printf(PoolObject.Name)
    Printf(PPoolObject.Name)

end
return main
