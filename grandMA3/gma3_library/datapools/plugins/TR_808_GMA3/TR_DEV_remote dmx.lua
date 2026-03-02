local thiscomponent = select(4, ...)
local function main()
    local mydatapool = thiscomponent:FindParent(DataPool():GetClass())
    Printf(mydatapool.Name)
    local Construct_Pool = 41
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local RemoteObject = Root().ShowData.Remotes.DmxRemotes
    local startSeq = 613
    for e = 1, 8, 1 do
        local endSeq = startSeq + 11
        for i = startSeq, endSeq, 1 do
            local a = RemoteObject:Acquire()
            RemoteObject[a.No]:Set('Name', 'TR_Remote_#1')
            RemoteObject[a.No]:Set('Address', '100.1')
            RemoteObject[a.No]:Set('Target', SequenceObject[i])
            RemoteObject[a.No]:Set('Fader', 'Master')
        end
        startSeq = endSeq + 6
    end
end
return main
