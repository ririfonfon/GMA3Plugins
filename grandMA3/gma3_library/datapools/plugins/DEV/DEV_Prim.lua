local function main()
    -- local pool_construct = 42
    -- local MatrickNrStart = 10
    -- local MatrickObject = Root().ShowData.DataPools[pool_construct].Matricks
    -- MatrickObject:Acquire()
    -- MatrickObject:Create(MatrickNrStart)
    -- MatrickObject[MatrickNrStart]:Set('Name', 'test')

    local AppObject = Root().ShowData.Appearances
    AppObject:Create(981)
    AppObject[981]:Set('Name','LC2_tricks_on')
    AppObject[981]:Set('Appearance','Showdata.MediaPools.Symbols.[arrow_right_black_png]')
end
return main
