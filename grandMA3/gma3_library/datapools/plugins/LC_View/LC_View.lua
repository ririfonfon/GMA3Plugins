--[[
Releases:
* 2.3.1.1

Created by Richard Fontaine "RIRI", September 2025.
--]]

local function main()

    local Select = UserVars()
    local axes, layout, element, matrick, seq_call, matrickthru, macrostore, data_pool, prefix, macro = 0,0,0,0,0,0,0,0,0,0
    local sel = tonumber((GetVar(Select, "LC_Fonction")))
    if GetVar(Select, "LC_Axes") then
        axes = tonumber((GetVar(Select, "LC_Axes")))
    end
    if GetVar(Select, "LC_Layout") then
        layout = tonumber((GetVar(Select, "LC_Layout")))
    end
    if GetVar(Select, "LC_Element") then
        element = tonumber((GetVar(Select, "LC_Element")))
    end
    if GetVar(Select, "LC_Matrick") then
        matrick = tonumber((GetVar(Select, "LC_Matrick")))
    end
    if GetVar(Select, "LC_Matrick_Thru") then
        matrickthru = tonumber((GetVar(Select, "LC_Matrick_Thru")))
    end
    if GetVar(Select, "LC_Sequence") then
        seq_call = GetVar(Select, "LC_Sequence")
    end
    if GetVar(Select, "LC_DataPool") then
        data_pool = GetVar(Select, "LC_DataPool")
    end
    if GetVar(Select,"LC_Favourites") then
        macrostore = GetVar(Select, "LC_Favourites")
    end
    if GetVar(Select,"LC_Prefix") then
        prefix = GetVar(Select, "LC_Prefix")
    end
    if GetVar(Select,"LC_Macro") then
        macro = GetVar(Select, "LC_Macro")
    end

    if (sel == 1) then
        Fade(axes,layout,element,matrick,data_pool)
    elseif (sel == 2) then
        Delay_From(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 3) then
        Delay_To(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 4) then
        Phase(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 5) then
        Group(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 6) then
        Block(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 7) then
        Wings(axes,layout,element,matrick,matrickthru,data_pool)
    elseif (sel == 8) then
        Priority(layout,element,seq_call,data_pool)
    elseif (sel == 9) then
        PriorityNumber(layout,element,seq_call,data_pool)
    elseif (sel == 10) then
        Favourites(layout,macrostore,data_pool,prefix,macro)
    end

    DelVar(Select, "LC_Fonction")
    DelVar(Select, "LC_Axes")
    DelVar(Select, "LC_Layout")
    DelVar(Select, "LC_Element")
    DelVar(Select, "LC_Matrick")
    DelVar(Select, "LC_Matrick_Thru")
    DelVar(Select, "LC_Sequence")
    DelVar(Select, "LC_Datapool")
    DelVar(Select, "LC_Favourites")
    DelVar(Select, "LC_Prefix")
    DelVar(Select, "LC_Macro")
end
return main

-- end LC_View.lua