--[[
Releases:
* 2.5.1.1

Version :
* 0.0.0.1

Created by Richard Fontaine "RIRI", November 2026.
--]]

function Layout_Manage_id_lua(id, fonction)
    local id_LM = "id_" .. id
    Echo('LM id ' .. id .. ' fonction ' .. fonction .. ' id_LM ' .. id_LM)
    if (fonction == 0) then
        for i = 301, 2887 do
            local SeqObject = Root().ShowData.DataPools[3].Sequences
            local Seq = SeqObject[i]
            if Seq ~= nil then
                if Seq.Name ~= nil then
                    if Seq.Note == id_LM then
                        Echo(Seq.Name)
                        Cmd('Off DataPool 3 Sequence ' .. Seq.No)
                        coroutine.yield(0.1)
                        CmdIndirectWait('Copy DataPool 10 Sequence ' ..
                            Seq.No .. ' At DataPool 3 Sequence ' .. Seq.No .. ' /NC')
                    end
                end
            end
        end
    elseif (fonction == 1) then
        for i = 301, 2887 do
            local SeqObject = Root().ShowData.DataPools[3].Sequences
            local Seq = SeqObject[i]
            if Seq ~= nil then
                if Seq.Name ~= nil then
                    if Seq.Note == id_LM then
                        Echo(Seq.Name)
                        CmdIndirectWait('Copy DataPool 9 Sequence ' ..
                            Seq.No .. ' At DataPool 3 Sequence ' .. Seq.No .. ' /NC')
                    end
                end
            end
        end
    end
end
