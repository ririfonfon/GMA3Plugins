--[[
Releases:
* 2.4.2.2

Version:
* 2.3.6.0

Rewrite by Richard Fontaine "RIRI", July 2026.
--]]

local function main()
    local Select = UserVars()
    local PC_layout, PC_element, PC_seq, PC_pool, Target

    local PC_Fonction = tonumber((GetVar(Select, "PC_Fonction")))
    if GetVar(Select, "PC_Layout") then
        PC_layout = tonumber((GetVar(Select, "PC_Layout")))
    end
    if GetVar(Select, "PC_Element") then
        PC_element = tonumber((GetVar(Select, "PC_Element")))
    end
    if GetVar(Select, "PC_Data_Pool") then
        PC_pool = GetVar(Select, "PC_Data_Pool")
    end
    if GetVar(Select, "PC_Sequence") then
        PC_seq = GetVar(Select, "PC_Sequence")
    end

    local SeqNr = ShowData().DataPools[PC_pool].Sequences:Children()
    local LayoutObject = Root().ShowData.DataPools[PC_pool].Layouts

    if (PC_Fonction == 1) then -- Priority
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
            if SeqNr[k].No == PC_seq then
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
        LayoutObject[PC_layout][PC_element]:Set('Appearance', Target)
    end

    DelVar(Select, "PC_Fonction")
    DelVar(Select, "PC_Layout")
    DelVar(Select, "PC_Element")
    DelVar(Select, "PC_Sequence")
    DelVar(Select, "PC_Data_Pool")
    DelVar(Select, "PC_Favourites")
    DelVar(Select, "PC_Prefix")
    DelVar(Select, "PC_Macro")
end
return main

-- end PC_View.lua
