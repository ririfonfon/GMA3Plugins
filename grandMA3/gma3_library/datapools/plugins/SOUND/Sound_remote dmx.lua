--[[
Releases:
* 2.3.2.0

Version :
* 0.0.0.93

Created by Richard Fontaine "RIRI", April 2026.
--]]

function SOUND_Remote_Dmx(Construct_Pool, SeqNum, Univers, Address, prefix)
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local RemoteObject   = Root().ShowData.Remotes.DmxRemotes
    local startSeq       = SeqNum + 12
    local Count          = 1
    local Sound_Type     = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }

    if prefix == "B" then
        startSeq = startSeq + 152
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

function SOUND_Remote_Dmx_Cross(Construct_Pool, Grp_Start, Univers, Address)
    Sound_Dialog_End('Sound By Riri Build Cross_AB Mode ..')
    local GroupObject  = Root().ShowData.DataPools[Construct_Pool].Groups
    local RemoteObject = Root().ShowData.Remotes.DmxRemotes
    local Sound_Type   = { 'A', 'B' }
    local Master_Group = { Grp_Start + 11, Grp_Start + 24 }
    Address            = Address + 22

    for i = 1, 2, 1 do
        local a = RemoteObject:Acquire()
        RemoteObject[a.No]:Set('Name', 'Cross_' .. Sound_Type[i])
        RemoteObject[a.No]:Set('Address', "" .. Univers .. ".0" .. Address - 1 + i .. "")
        RemoteObject[a.No]:Set('Target', GroupObject[Master_Group[i]])
        RemoteObject[a.No]:Set('Fader', 'Master')
    end
    Sound_Dialog_End(
    'ALL Good Sound By Riri Finish \n\n\n Remenber\n\n AMasterALLSOUND \n & \n BMasterALLSOUND \n\n Value are 0 \n\n Make Cross remote \n\n or set a value\n\n\n\n Enjoy')
end
