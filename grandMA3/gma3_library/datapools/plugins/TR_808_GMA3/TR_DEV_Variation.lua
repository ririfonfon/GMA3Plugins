-- coroutine.yield(0.15)
--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", december 2025.

--]]
local Printf, Echo, GetExecutor, CmdIndirectWait, ipairs, mfloor = Printf, Echo, GetExecutor, CmdIndirectWait, ipairs,
    math.floor


local function main()
    local Select = UserVars()
    local TR_Pool, TR_Varia_Call, TR_Cible
    Printf(
        "*******************************************************TR_Variation called************************************************")
    if GetVar(Select, "TR_Varia_Call") then
        TR_Varia_Call = GetVar(Select, "TR_Varia_Call")
        Printf("TR_Varia_Call : %s", TR_Varia_Call)
    end
    if GetVar(Select, "TR_Cible") then
        TR_Cible = GetVar(Select, "TR_Cible")
        Printf("TR_Cible : %s", TR_Cible)
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = GetVar(Select, "TR_Pool")
        Printf("TR_Pool: %i", TR_Pool)
    end

    -- TR_Pool = 41
    -- TR_Varia_Call = "Varia_A"

    -- local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
    local tag_pool = ShowData().Tags:Children()
    local tar = {}

    -- clean TAG NEXT_SUB
    for t in ipairs(tag_pool) do
        if tag_pool[t].Name == TR_Cible then
            local target = tag_pool[t]:CmdlineChildren()
            for r in ipairs(target) do
                tar[r] = target[r].No
            end
            for s in ipairs(tar) do
                CmdIndirectWait('Assign Off DataPool ' .. TR_Pool .. ' Sequence ' .. tar[s] .. ' At Tag ' .. TR_Cible)
            end
        end
    end

    for t in ipairs(tag_pool) do
        if tag_pool[t].Name == TR_Varia_Call then
            local target = tag_pool[t]:CmdlineChildren()
            for r in ipairs(target) do
                tar[r] = target[r].No
            end
            for s in ipairs(tar) do
                CmdIndirectWait('Assign DataPool ' .. TR_Pool .. ' Sequence ' .. tar[s] .. ' At Tag ' .. TR_Cible)
            end
        end
    end

    -- for k in ipairs(SeqNr) do
    --     local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
    --     if (string.find(tag, TR_Varia_Call)) then
    --         Printf("Sequence Name: %s", SeqNr[k].Name)
    --         Printf("Tag Name: %s", tag)
    --         CmdIndirectWait('Assign ' .. SeqNr[k].. ' At TAG TR_Cible')
    --     end
    -- end






    -- DelVar(Select, "TR_Pool")
    -- DelVar(Select, "TR_Varia_Call")
    -- DelVar(Select, "TR_Load")
end


return main
