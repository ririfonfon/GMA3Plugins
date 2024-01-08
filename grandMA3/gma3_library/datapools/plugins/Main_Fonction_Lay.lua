local function main()

    local Select = UserVars()
    local sel = GetVar(Select, "LC_Fonction")
    local axes = GetVar(Select, "LC_Axes")
    local layout = GetVar(Select, "LC_Layout")
    local element = GetVar(Select, "LC_Element")
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
end
return main