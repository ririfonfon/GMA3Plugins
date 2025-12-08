--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", december 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local TR_Tag, TR_Pool, TR_Fonction, TR_Mtrick, TR_F_fx, TR_F_tx, TR_D_fx, TR_D_tx

    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber((GetVar(Select, "TR_Fonction")))
        -- Printf("TR_Fonction: %i", TR_Fonction)
    end
    if GetVar(Select, "TR_Tag") then
        TR_Tag = GetVar(Select, "TR_Tag")
        -- Printf("TR_Tag: %s", TR_Tag)
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = GetVar(Select, "TR_Pool")
        -- Printf("TR_Pool: %s", TR_Pool)
    end

    local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
    local MAtricksNr = ShowData().DataPools[TR_Pool].MATricks:Children()
    -- for k in ipairs(SeqNr) do
    --     local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
    --     if (string.find(tag, TR_Tag)) then
    --         Printf("Sequence Name: %s", SeqNr[k].Name)
    --         Printf("Tag Name: %s", tag)
    --     end
    -- end
    for k in ipairs(MAtricksNr) do
        -- Printf("MATricks Name: %s", MAtricksNr[k].Name)
        if (MAtricksNr[k].Name == 'TR_INPUT') then
            -- Printf("Found TR_INPUT at index: %i", k)
            TR_Mtrick = k
            TR_F_fx = string.format(MAtricksNr[TR_Mtrick].FadeFromX or 'None')
            -- Printf("FadeFromX: %s", TR_F_fx)
            TR_F_tx = string.format(MAtricksNr[TR_Mtrick].FadeToX or 'None')
            -- Printf("FadeToX: %s", TR_F_tx)
            TR_D_fx = string.format(MAtricksNr[TR_Mtrick].DelayFromX or 'None')
            -- Printf("DelayFromX: %s", TR_D_fx)
            TR_D_tx = string.format(MAtricksNr[TR_Mtrick].DelayToX or 'None')
            -- Printf("DelayToX: %s", TR_D_tx)
        end
    end


    if (TR_Fonction == 1) then
        for k in ipairs(SeqNr) do
            local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
            if (string.find(tag, TR_Tag)) then
                -- Printf("Sequence Name: %s", SeqNr[k].Name)
                -- Printf("Tag Name: %s", tag)
                Cmd('Set ' .. SeqNr[k] .. ' Cue 1 Thru 16 Part 0.1 Property FadeFromX ' .. TR_F_fx)
                Cmd('Set ' .. SeqNr[k] .. ' Cue 1 Thru 16 Part 0.1 Property FadeToX ' .. TR_F_tx)
            end
        end
    elseif (TR_Fonction == 2) then
        for k in ipairs(SeqNr) do
            local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
            if (string.find(tag, TR_Tag)) then
                -- Printf("Sequence Name: %s", SeqNr[k].Name)
                -- Printf("Tag Name: %s", tag)
                Cmd('Set ' .. SeqNr[k] .. ' Cue 1 Thru 16 Part 0.1 Property DelayFromX ' .. TR_D_fx)
                Cmd('Set ' .. SeqNr[k] .. ' Cue 1 Thru 16 Part 0.1 Property DelayToX ' .. TR_D_tx)
            end
        end
    elseif (TR_Fonction == 3) then


    elseif (TR_Fonction == 4) then

    end


    DelVar(Select, "TR_Layout")
    DelVar(Select, "TR_Tag")
    DelVar(Select, "TR_Fonction")
end


return main
