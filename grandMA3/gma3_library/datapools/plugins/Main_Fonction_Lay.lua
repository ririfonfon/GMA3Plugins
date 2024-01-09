--[[
Releases:
* 1.1.6.3

Created by Richard Fontaine "RIRI", January 2023.
--]]

local function main()

    local Select = UserVars()
    local sel = tonumber(GetVar(Select, "LC_Fonction"))
    local axes = tonumber(GetVar(Select, "LC_Axes"))
    local layout = tonumber(GetVar(Select, "LC_Layout"))
    local element = tonumber(GetVar(Select, "LC_Element"))
    local matrick = tonumber(GetVar(Select, "LC_Matrick"))

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
    end

    DelVar(Select, "LC_Fonction")
    DelVar(Select, "LC_Axes")
    DelVar(Select, "LC_Layout")
    DelVar(Select, "LC_Element")
    DelVar(Select, "LC_Matrick")
end
return main