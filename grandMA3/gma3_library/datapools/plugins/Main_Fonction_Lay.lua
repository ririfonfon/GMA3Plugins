local function main()

    local Select = UserVars()
    local sel = GetVar(Select, "LC1_Fonction")
    local axes = GetVar(Select, "LC1_Axes")
    local layout = GetVar(Select, "LC1_Layout")
    local element = GetVar(Select, "LC1_Element")

    if (sel == 1) then
        Fade(axes,layout,element)
    elseif (sel == 2) then
        Delay_From(axes,layout,element)
    elseif (sel == 3) then
        Delay_To(axes,layout,element)
    elseif (sel == 4) then
        Phase(axes,layout,element)
    elseif (sel == 5) then
        Group(axes,layout,element)
    elseif (sel == 6) then
        Block(axes,layout,element)
    elseif (sel == 7) then
        Wings(axes,layout,element)
    end
end
return main