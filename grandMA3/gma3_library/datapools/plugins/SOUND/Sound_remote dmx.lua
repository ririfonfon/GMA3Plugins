local thiscomponent = select(4, ...)
local function main()
    local mydatapool = thiscomponent:FindParent(DataPool():GetClass())
    Printf(mydatapool.Name)
    local Construct_Pool = 5
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local RemoteObject = Root().ShowData.Remotes.DmxRemotes
    local startSeq = 16
    local Count = 1
    local endSeq = startSeq + 10
    local Sound_Type = { 'All', 'Bass', 'Mid', 'High', 'Band 1', 'Band 2', 'Band 3', 'Band 4', 'Band 5', 'Band 6',
    'Band 7' }

    for i = startSeq, endSeq, 1 do
        local a = RemoteObject:Acquire()
        RemoteObject[a.No]:Set('Name', 'Sound ' .. Sound_Type[Count])
        RemoteObject[a.No]:Set('Address', "210.0" .. 40 + Count .. "")
        RemoteObject[a.No]:Set('Target', SequenceObject[i])
        RemoteObject[a.No]:Set('Fader', 'Temp')
        Count = Count + 1
    end
end
return main
