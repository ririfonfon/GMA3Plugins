--[[
Releases:
* 2.0.0.6

Created by Richard Fontaine "RIRI", March 2024.
--]]

local function main()

    local Select = UserVars()
    local axes, layout, element, matrick, seq_call, matrickthru, data_pool = 0,0,0,0,0,0,0
    local sel = tonumber(GetVar(Select, "LC_Fonction"))
    if GetVar(Select, "LC_Axes") then
        axes = tonumber(GetVar(Select, "LC_Axes"))
    end
    if GetVar(Select, "LC_Layout") then
        layout = tonumber(GetVar(Select, "LC_Layout"))
    end
    if GetVar(Select, "LC_Element") then
        element = tonumber(GetVar(Select, "LC_Element"))
    end
    if GetVar(Select, "LC_Matrick") then
        matrick = tonumber(GetVar(Select, "LC_Matrick"))
    end
    if GetVar(Select, "LC_Matrick_Thru") then
        matrickthru = tonumber(GetVar(Select, "LC_Matrick_Thru"))
    end
    if GetVar(Select, "LC_Sequence") then
        seq_call = GetVar(Select, "LC_Sequence")
    end
    if GetVar(Select, "LC_DataPool") then
        data_pool = GetVar(Select, "LC_DataPool")
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
    end

    DelVar(Select, "LC_Fonction")
    DelVar(Select, "LC_Axes")
    DelVar(Select, "LC_Layout")
    DelVar(Select, "LC_Element")
    DelVar(Select, "LC_Matrick")
    DelVar(Select, "LC_Matrick_Thru")
    DelVar(Select, "LC_Sequence")
    DelVar(Select, "LC_Datapool")
end
return main

-- end LC_View.lua