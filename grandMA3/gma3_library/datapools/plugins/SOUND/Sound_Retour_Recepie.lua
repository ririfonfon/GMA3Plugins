--[[
    Releases:
    * 0.0.0.91
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local function main()
    local Select = UserVars()
    local S_Seq, S_Layout, S_Pool, S_Fonction, Target, S_Lay, S_N_Layout, S_N_Object
    if GetVar(Select, "S_Fonction") then
        S_Fonction = tonumber((GetVar(Select, "S_Fonction")))
    end
    if GetVar(Select, "S_Seq") then
        S_Seq = GetVar(Select, "S_Seq")
    end
    if GetVar(Select, "S_Layout") then
        S_Lay = GetVar(Select, "S_Layout")
        S_Layout = string.gsub(S_Lay, "_", ".")

        local a = 1
        for number in string.gmatch(S_Layout, "%d+") do
            if a == 1 then
                S_N_Layout = tonumber(number)
            elseif a == 2 then
                S_N_Object = tonumber(number)
            end
            a = a + 1
        end
    end
    if GetVar(Select, "S_Pool") then
        S_Pool = GetVar(Select, "S_Pool")
    end
    local SeqNr = ShowData().DataPools[S_Pool].Sequences:Children()
    local LayoutObject = Root().ShowData.DataPools[S_Pool].Layouts
    if (S_Fonction == 1) then
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Selection == nil) then
                    Target = "Group"
                else
                    Target = SeqNr[k][3][1][1].Selection.Name
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 2) then
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][1].Values == nil) then
                    Target = "Value"
                else
                    Target = SeqNr[k][3][1][1].Values.Name
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 3) then
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][1].MASicks == nil) then
                    Target = "MaSicks"
                else
                    Target = SeqNr[k][3][1][1].MASicks.Name
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 4) then
        for k in ipairs(SeqNr) do
            local nr_seq = tonumber(SeqNr[k].No)
            if S_Seq == SeqNr[k].name then
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
    elseif (S_Fonction == 5) then
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
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
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 6) then
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
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
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 10) then
        local AppearanceObject = Root().ShowData.Appearances:Children()
        local App_Panel_Name = { 'p_super_png', 'p_swap_png', 'p_htp_png', 'p_highest_png',
            'p_high_png', 'p_ltp_png', 'p_low_png', 'p_lowest_png' }
        local Addr_Nat_Panel = { 0, 0, 0, 0, 0, 0, 0, 0 }
        for k in pairs(App_Panel_Name) do
            for i in pairs(AppearanceObject) do
                if AppearanceObject[i].Name ~= nil then
                    if AppearanceObject[i].Name == App_Panel_Name[k] then
                        Addr_Nat_Panel[k] = AppearanceObject[i]:AddrNative()
                    end
                end
            end
        end
        local priority
        for k in ipairs(SeqNr) do
            if SeqNr[k].Name == 'a_Sub_#1' then
                priority = SeqNr[k]:Get('Priority', Enums.Roles.Display) or 'None'
            end
        end
        for k in ipairs(SeqNr) do
            local tag = string.format(SeqNr[k]:Get('Tags') or 'None')
            if (string.find(tag, 'SUB_#1')) or (string.find(tag, 'SUB_#2')) or (string.find(tag, 'SUB_#3')) or
                (string.find(tag, 'SUB_#4')) or (string.find(tag, 'SUB_#5')) or (string.find(tag, 'SUB_#6')) or
                (string.find(tag, 'SUB_#7')) or (string.find(tag, 'SUB_#8')) or (string.find(tag, 'SUB_#9')) or
                (string.find(tag, 'SUB_#10')) or (string.find(tag, 'SUB_#11')) or (string.find(tag, 'SUB_#12'))
            then
                SeqNr[k]:Set('priority', priority)
            end
        end
        if priority == "Super" then
            Target = Addr_Nat_Panel[1]
        elseif priority == "Swap" then
            Target = Addr_Nat_Panel[2]
        elseif priority == "HTP" then
            Target = Addr_Nat_Panel[3]
        elseif priority == "Highest" then
            Target = Addr_Nat_Panel[4]
        elseif priority == "High" then
            Target = Addr_Nat_Panel[5]
        elseif priority == "LTP" then
            Target = Addr_Nat_Panel[6]
        elseif priority == "Low" then
            Target = Addr_Nat_Panel[7]
        elseif priority == "Lowest" then
            Target = Addr_Nat_Panel[8]
        end
        LayoutObject[S_N_Layout][S_N_Object]:Set('Appearance', Target)
    end

    DelVar(Select, "S_Seq")
    DelVar(Select, "S_Layout")
    DelVar(Select, "S_Pool")
    DelVar(Select, "S_Fonction")
end
return main
