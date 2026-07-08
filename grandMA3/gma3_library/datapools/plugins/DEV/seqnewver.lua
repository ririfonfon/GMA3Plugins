return function()
    local SequenceObject = Root().ShowData.DataPools[6].Sequences
    local GroupsObject   = Root().ShowData.DataPools[1].Groups:Children()

    local CurrentSeqNr   = 2
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', 'test new v')
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Insert()
    -- SequenceObject[CurrentSeqNr][3][1]:Create(1)
    SequenceObject[CurrentSeqNr][3][1]:Acquire('StandardRecipe')
    SequenceObject[CurrentSeqNr][3][1]:Acquire('PhaserRecipe')


    -- local recipe = SequenceObject[CurrentSeqNr][3][1][1]
    -- recipe:Dump()
    SequenceObject[CurrentSeqNr][3][1][1]:Set('Selection', GroupsObject[1])
    SequenceObject[CurrentSeqNr][3][1][2]:Set('Selection', GroupsObject[1])

--     cuePartHandle:Acquire('StandardRecipe')
--     cuePartHandle:Acquire('PhaserRecipe')
end
