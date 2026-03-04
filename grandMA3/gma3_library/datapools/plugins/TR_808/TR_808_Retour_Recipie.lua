--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Retour_Recepie()
    local Select = UserVars()
    local TR_Sub, TR_Layout, TR_Pool, TR_Fonction, Target, TR_Lay, TR_N_Layout, TR_N_Object
    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber((GetVar(Select, "TR_Fonction")))
    end
    if GetVar(Select, "TR_Sub") then
        TR_Sub = GetVar(Select, "TR_Sub")
    end
    if GetVar(Select, "TR_Layout") then
        TR_Lay = GetVar(Select, "TR_Layout")
        TR_Layout = string.gsub(TR_Lay, "_", ".")
       
        local a = 1
        for number in string.gmatch(TR_Layout, "%d+") do
            if a == 1 then
                TR_N_Layout = tonumber(number)
            elseif a == 2 then
                TR_N_Object = tonumber(number)
            end
            a = a + 1
        end
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = GetVar(Select, "TR_Pool")
    end
    local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
    local LayoutObject = Root().ShowData.DataPools[TR_Pool].Layouts
    if (TR_Fonction == 1) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Selection == nil) then
                    Target = "Group"
                else
                    Target = SeqNr[k][3][1][1].Selection.Name
                end
                LayoutObject[TR_N_Layout][TR_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (TR_Fonction == 2) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Values == nil) then
                    Target = "Value"
                else
                    Target = SeqNr[k][3][1][1].Values.Name
                end
                LayoutObject[TR_N_Layout][TR_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (TR_Fonction == 3) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].MATricks == nil) then
                    Target = "MaTricks"
                else
                    Target = SeqNr[k][3][1][1].MATricks.Name
                end
                LayoutObject[TR_N_Layout][TR_N_Object]:Set('CustomTextText', Target)
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
                    if value.No then
                        Printf("Name: %s", value.Name)
                        local cue_number = tonumber(value.No // 1000)
                        Printf("Cue Number: %i", cue_number)
                        if (cue_number ~= 0) then
                            local cue_part = SeqNr[k][2 + cue_number][1][1]:Get('Enabled', Enums.Roles.Display) or 'None'
                            Printf("Cue Part: %s", cue_part)
                            if (cue_part == 'Yes') then
                                Printf('YES')
                            else
                                Printf('NO')
                            end
                        end
                    end
                end
            end
        end
    elseif (TR_Fonction == 5) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].FadeFromX == nil) then
                    Target = "N/"
                else
                    Target = tostring(SeqNr[k][3][1][1].FadeFromX) .. "/"
                end
                if (SeqNr[k][3][1][1].FadeToX == nil) then
                    Target = Target .. "N"
                else
                    Target = Target .. tostring(SeqNr[k][3][1][1].FadeToX)
                end
                LayoutObject[TR_N_Layout][TR_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (TR_Fonction == 6) then
        for k in ipairs(SeqNr) do
            if TR_Sub == SeqNr[k].name then
                if (SeqNr[k][3][1][1].DelayFromX == nil) then
                    Target = "N/"
                else
                    Target = tostring(SeqNr[k][3][1][1].DelayFromX) .. "/"
                end
                if (SeqNr[k][3][1][1].DelayToX == nil) then
                    Target = Target .. "N"
                else
                    Target = Target .. tostring(SeqNr[k][3][1][1].DelayToX)
                end
                LayoutObject[TR_N_Layout][TR_N_Object]:Set('CustomTextText', Target)
            end
        end
    end

    DelVar(Select, "TR_Sub")
    DelVar(Select, "TR_Layout")
    DelVar(Select, "TR_Pool")
    DelVar(Select, "TR_Fonction")
end