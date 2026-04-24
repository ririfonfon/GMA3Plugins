--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function SOUND_Remote_Dmx(Construct_Pool, SeqNum, Univers, Address, prefix)
    -- local Construct_Pool = 5
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local RemoteObject   = Root().ShowData.Remotes.DmxRemotes
    local startSeq       = SeqNum + 12
    local Count          = 1
    local Sound_Type     = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }

    if prefix == 'B' then
        startSeq = startSeq + 123
        Address = Address + 11
    end
    local endSeq = startSeq + 10

    for i = startSeq, endSeq, 1 do
        local a = RemoteObject:Acquire()
        RemoteObject[a.No]:Set('Name', prefix .. 'Sound ' .. Sound_Type[Count])
        RemoteObject[a.No]:Set('Address', "" .. Univers .. ".0" .. Address - 1 + Count .. "")
        RemoteObject[a.No]:Set('Target', SequenceObject[i])
        RemoteObject[a.No]:Set('Fader', 'Temp')
        Count = Count + 1
    end
end
