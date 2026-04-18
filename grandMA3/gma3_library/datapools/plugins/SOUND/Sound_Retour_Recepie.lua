--[[
    Releases:
    * 0.0.0.91
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]
local my_table, my_handle = select(3, ...)


function Sound_Retour_Recepie()
    local Select = UserVars()
    local S_Seq, S_Layout, S_Pool, S_Fonction, Target, S_Lay, S_N_Layout, S_N_Object, S_Part, S_Master
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
    if GetVar(Select, "S_Part") then
        S_Part = tonumber((GetVar(Select, "S_Part")))
    end

    if GetVar(Select, "S_Master") then
        S_Master = tonumber((GetVar(Select, "S_Master")))
    end

    local SeqNr = ShowData().DataPools[S_Pool].Sequences:Children()
    local LayoutObject = Root().ShowData.DataPools[S_Pool].Layouts

    if (S_Fonction == 1) then -- Group
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][S_Part].Selection == nil) then
                    Target = "Group"
                else
                    Target = SeqNr[k][3][1][S_Part].Selection.Name
                end
                Echo(S_N_Layout .. " " .. S_N_Object .. " " .. Target)
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 2) then -- Values
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][S_Part].Values == nil) then
                    Target = "Value"
                else
                    Target = SeqNr[k][3][1][S_Part].Values.Name
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 3) then -- Matricks
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][S_Part].MAtricks == nil) then
                    Target = "Matricks"
                else
                    Target = SeqNr[k][3][1][S_Part].MAtricks.Name
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 4) then -- Fader_Master
        local Value
        local proxy = Root().ShowData.DataPools[S_Pool].Groups[S_Master]
        local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
        -- local clic = GetFocusDisplay().ScreenOverlay.CLICKED
        -- -- local clic = GetFocusDisplay().ScreenOverlay.Clicked()
        -- local clic = GetFocusDisplay().ScreenOverlay
        -- Echo(clic.clicked)
        -- dialog.X, dialog.Y = 00, 00
        dialog.H, dialog.W = 400, 10
        local fader = dialog:Append('UiFader')

        fader.target = proxy
        fader.Text = proxy.Name
        fader.changed = 'fader_changed'
        fader.plugincomponent = my_handle

        function my_table.fader_changed(caller)
            Value = caller.value
        end

        repeat
            coroutine.yield(0.1)
        until not IsObjectValid(dialog)
        -- Echo(Value)
        LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Value)
    elseif (S_Fonction == 5) then -- Fade
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][S_Part].FadeFromX == nil) then
                    Target = "N/"
                else
                    Target = tostring(SeqNr[k][3][1][S_Part].FadeFromX) .. "/"
                end
                if (SeqNr[k][3][1][S_Part].FadeToX == nil) then
                    Target = Target .. "N"
                else
                    Target = Target .. tostring(SeqNr[k][3][1][S_Part].FadeToX)
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 6) then -- Delay
        for k in ipairs(SeqNr) do
            if S_Seq == SeqNr[k].name then
                if (SeqNr[k][3][1][S_Part].DelayFromX == nil) then
                    Target = "N/"
                else
                    Target = tostring(SeqNr[k][3][1][S_Part].DelayFromX) .. "/"
                end
                if (SeqNr[k][3][1][S_Part].DelayToX == nil) then
                    Target = Target .. "N"
                else
                    Target = Target .. tostring(SeqNr[k][3][1][S_Part].DelayToX)
                end
                LayoutObject[S_N_Layout][S_N_Object]:Set('CustomTextText', Target)
            end
        end
    elseif (S_Fonction == 10) then -- Priority
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
            if SeqNr[k].Name == S_Seq then
                priority = SeqNr[k]:Get('Priority', Enums.Roles.Display) or 'None'
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
    DelVar(Select, "S_Part")
    DelVar(Select, "S_Master")
end
