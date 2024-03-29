--[[
Releases:
* 1.1.7.3

Created by Richard Fontaine "RIRI", January 2024.
--]]

local function main()

    local Select = UserVars()
    local axes, layout, element, matrick, seq_call = 0,0,0,0,0
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
    if GetVar(Select, "LC_Sequence") then
        seq_call = GetVar(Select, "LC_Sequence")
    end

    if (sel == 1) then
        Fade(axes,layout,element,matrick)
    elseif (sel == 2) then
        Delay_From(axes,layout,element,matrick)
    elseif (sel == 3) then
        Delay_To(axes,layout,element,matrick)
    elseif (sel == 4) then
        Phase(axes,layout,element,matrick)
    elseif (sel == 5) then
        Group(axes,layout,element,matrick)
    elseif (sel == 6) then
        Block(axes,layout,element,matrick)
    elseif (sel == 7) then
        Wings(axes,layout,element,matrick)
    elseif (sel == 8) then
        Priority(layout,element,seq_call)
    end

    DelVar(Select, "LC_Fonction")
    DelVar(Select, "LC_Axes")
    DelVar(Select, "LC_Layout")
    DelVar(Select, "LC_Element")
    DelVar(Select, "LC_Matrick")
    DelVar(Select, "LC_Sequence")
end
return main