--[[
Releases:
* 2.4.2.2

Version:
* 2.3.6.0

Rewrite by Richard Fontaine "RIRI", July 2026.
--]]

local function main()
    local DEBUG = false
    local Select = UserVars()
    local PC_layout, PC_element, PC_seq, PC_pool, Target, PC_prefix, PC_macrostore, PC_macro

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
    if GetVar(Select, "PC_Prefix") then
        PC_prefix = GetVar(Select, "PC_Prefix")
    end
    if GetVar(Select, "PC_Favourites") then
        PC_macrostore = GetVar(Select, "PC_Favourites")
    end
    if GetVar(Select, "PC_Macro") then
        PC_macro = GetVar(Select, "PC_Macro")
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

    elseif (PC_Fonction == 2) then -- PC_Favourites
        local sequences = ObjectList('DataPool ' .. PC_pool ..
            ' Sequence ' .. string.char(34) .. '' .. PC_prefix .. '*' .. string.char(34) .. '')
        local macropool = ShowData().DataPools[PC_pool].Macros
        local layoutspool = ShowData().DataPools[PC_pool].Layouts
        local activeseq = {}
        if Debug then Echo(PC_macrostore) end
        local macronum = tostring(PC_macrostore)
        macronum = macronum:gsub(' Macro', '')
        local mess = 'DataPool ' .. PC_pool
        macronum = macronum:gsub(mess, '')
        macronum = tonumber(macronum)
        if Debug then Echo(macronum) end
        for i = 1, #sequences do
            if sequences[i]:HasActivePlayback() then
                table.insert(activeseq, i)
            end
        end
        if #macropool[macronum] == 0 then
            layoutspool[PC_layout]['Macro ' .. macronum]:Set('visibilityobjectname', true)
        end
        Cmd('label DataPool ' .. PC_pool ..
            ' macro ' .. macronum .. ' ' .. string.char(34) .. PC_prefix .. ' Favourite' .. string.char(34) .. ' /o')
        if #macropool[macronum] > 0 then
            Cmd('delete DataPool ' .. PC_pool .. ' macro ' .. macronum .. '.1 thru')
        end
        Cmd('store DataPool ' .. PC_pool .. ' macro ' .. macronum .. '.1 thru' .. #activeseq .. ' /o')
        for i = 1, #activeseq do
            local seqnumber = activeseq[i]
            macropool[macronum][i]:Set('command', 'go DataPool ' .. PC_pool ..
                ' Sequence ' .. string.char(34) .. '' .. sequences[seqnumber].name .. '' .. string.char(34) .. '')
        end
        Cmd('Set DataPool ' .. PC_pool .. ' Macro ' .. PC_macro .. ' Property "Appearance" "LC_Black"')
        
    elseif (PC_Fonction == 3) then -- PC_Group_select
        local SEQ_Root = ShowData().DataPools[PC_pool].Sequences:Children()
        local pool = DataPool().No
        local GroupObject = ShowData().DataPools[pool].Groups:Children()
        for k in ipairs(SEQ_Root) do
            if SEQ_Root[k].No == PC_seq then
                Target = SEQ_Root[k][3][1][1].Selection.No
                break
            end
        end
        for g in ipairs(GroupObject) do
            if GroupObject[g].No == Target then
                LayoutObject[PC_layout][PC_element]:Set('Object', GroupObject[g])
            end
        end
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
