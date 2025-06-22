--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", june 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local TR_Sub, TR_Layout, TR_Pool, TR_Fonction, Target
    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber(GetVar(Select, "TR_Fonction"))
        Printf("TR_Fonction: %i", TR_Fonction)
    end
    if GetVar(Select, "TR_Sub") then
        TR_Sub = GetVar(Select, "TR_Sub")
        Printf("TR_Sub: %s", TR_Sub)
    end
    if GetVar(Select, "TR_Layout") then
        TR_Layout = tonumber(GetVar(Select, "TR_Layout"))
        Printf("TR_Layout: %i", TR_Layout)
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = tonumber(GetVar(Select, "TR_Pool"))
        Printf("TR_Pool: %i", TR_Pool)
    end
    local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
    if (TR_Fonction == 1) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Selection == nil) then
                    Target = "Group"
                else
                    Target = SeqNr[k][3][1][1].Selection.Name
                end
                Printf("Group Name: %s", Target)
                Cmd('Set DataPool ' ..
                    TR_Pool .. ' Layout ' .. TR_Layout .. ' Property CustomTextText=\' ' .. Target .. ' \'')
            end
        end
        Printf("no_group")
    elseif (TR_Fonction == 2) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Selection == nil) then
                    Target = "Value"
                else
                    Target = SeqNr[k][3][1][1].Values.Name
                end
                Printf("Value Name: %s", Target)
                Cmd('Set DataPool ' ..
                    TR_Pool .. ' Layout ' .. TR_Layout .. ' Property CustomTextText=\' ' .. Target .. ' \'')
            end
        end
    elseif (TR_Fonction == 3) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Selection == nil) then
                    Target = "Value"
                else
                    Target = SeqNr[k][3][1][1].MATricks.Name
                end
                Printf("MATricks Name: %s", Target)
                Cmd('Set DataPool ' ..
                    TR_Pool .. ' Layout ' .. TR_Layout .. ' Property CustomTextText=\' ' .. Target .. ' \'')
            end
        end
    elseif (TR_Fonction == 4) then
        for k in ipairs(SeqNr) do
            local nr_seq = tonumber(SeqNr[k].No)
            if TR_Sub == SeqNr[k].name then
                Printf("Seq Nr: %i", nr_seq)
                Printf("ok")
                local current_cue = tonumber(SeqNr[k].CurrentCue.No // 1000)
                Printf("Current Cue: %i", current_cue)
                for key, value in ipairs(SeqNr[k]:Children()) do
                    if value.No  then
                        Printf("Name: %s", value.Name)
                        local cue_number = tonumber(value.No // 1000)
                        Printf("Cue Number: %i", cue_number)
                        if (cue_number ~= 0) then
                            local cue_part = SeqNr[k][2+cue_number][1][1]:Get('Enabled', Enums.Roles.Display) or 'None'
                            Printf("Cue Part: %s", cue_part)
                        end
                    end
                end
            end
        end
    end


    DelVar(Select, "TR_Sub")
    DelVar(Select, "TR_Layout")
    DelVar(Select, "TR_Pool")
    DelVar(Select, "TR_Fonction")
end


return main
