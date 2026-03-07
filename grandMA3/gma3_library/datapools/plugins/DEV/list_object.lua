return function()
    local objectNumber = 101
    local object = GetExecutor(objectNumber) -- exec

    local Construct_Pool = 43
    -- local object = Root().ShowData.DataPools[Construct_Pool].Sequences
    -- local object = Root().ShowData.DataPools[Construct_Pool].Macros[4]

    local count = Obj.PropertyCount(object)
    for i = 0, count - 1 do
        local Pname = Obj.PropertyName(object, i)
        Echo(Pname)
        -- Echo(object.Pname)
    end
end
