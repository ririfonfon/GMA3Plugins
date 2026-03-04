--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Edit_Tag()
    local Select = UserVars()
    local TR_Tag, TR_Pool, TR_Fonction, TR_Mtrick, TR_F_fx, TR_F_tx, TR_D_fx, TR_D_tx, TR_Pool_Nr

    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber((GetVar(Select, "TR_Fonction")))
    end
    if GetVar(Select, "TR_Tag") then
        TR_Tag = GetVar(Select, "TR_Tag")
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = GetVar(Select, "TR_Pool")
        Printf("TR_Pool: %s", TR_Pool)
    end

    local Pool = ShowData().DataPools:Children()
    for _, v in pairs(Pool) do
        if v.Name == TR_Pool then
            TR_Pool_Nr = v.No
        end
    end
    local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
    local MAtricksNr = ShowData().DataPools[TR_Pool].MATricks:Children()

    for k in ipairs(MAtricksNr) do
        if (MAtricksNr[k].Name == 'TR_INPUT') then
            TR_Mtrick = k
            TR_F_fx = string.format(MAtricksNr[TR_Mtrick].FadeFromX or 'None')
            TR_F_tx = string.format(MAtricksNr[TR_Mtrick].FadeToX or 'None')
            TR_D_fx = string.format(MAtricksNr[TR_Mtrick].DelayFromX or 'None')
            TR_D_tx = string.format(MAtricksNr[TR_Mtrick].DelayToX or 'None')
        end
    end


    if (TR_Fonction == 1) then
        for k in ipairs(SeqNr) do
            local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
            if (string.find(tag, TR_Tag)) then
               
                for i = 1, 16 do
                    local Recipe = ObjectList("DataPool " .. TR_Pool_Nr ..
                        " Sequence " .. SeqNr[k].No .. " Cue " .. i .. " Part 0")[1]
                    Recipe[1]:Set('FadeFromX', TR_F_fx)
                    Recipe[1]:Set('FadeToX', TR_F_tx)
                end
                local MacroName = string.gsub(SeqNr[k].Name, "_", "_Fade_", 1)
                CmdIndirectWait('GO+ DataPool ' ..
                    TR_Pool_Nr .. ' Macro "' .. MacroName .. '".3 Thru Macro "' .. MacroName .. '".7')
                coroutine.yield(0.1)
            end
        end
    elseif (TR_Fonction == 2) then
        for k in ipairs(SeqNr) do
            local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
            if (string.find(tag, TR_Tag)) then
               
                for i = 1, 16 do
                    local Recipe = ObjectList("DataPool " .. TR_Pool_Nr ..
                        " Sequence " .. SeqNr[k].No .. " Cue " .. i .. " Part 0")[1]
                    Recipe[1]:Set('DelayFromX', TR_D_fx)
                    Recipe[1]:Set('DelayToX', TR_D_tx)
                end
                local MacroName = string.gsub(SeqNr[k].Name, "_", "_Delay_", 1)
                CmdIndirectWait('GO+ DataPool ' ..
                    TR_Pool_Nr .. ' Macro "' .. MacroName .. '".3 Thru Macro "' .. MacroName .. '".7')
                coroutine.yield(0.1)
            end
        end
    elseif (TR_Fonction == 3) then


    elseif (TR_Fonction == 4) then

    end


    DelVar(Select, "TR_Layout")
    DelVar(Select, "TR_Tag")
    DelVar(Select, "TR_Fonction")
end