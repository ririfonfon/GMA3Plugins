local function main()

    local Select = UserVars()
    local sel = GetVar(Select, "LC1_Fonction")
    local axes = GetVar(Select, "LC1_Axes")
    -- Echo(sel)
    -- Echo(axes)
    if (sel == 1) then
        Fade(axes)
    elseif (sel == 2) then
        Delay_From(axes)
    elseif (sel == 3) then
        Delay_From(axes)
    elseif (sel == 4) then
        Delay_To(axes)
    elseif (sel == 5) then
        Phase(axes)
    elseif (sel == 6) then
        Group(axes)
    elseif (sel == 7) then
        Block(axes)
    elseif (sel == 8) then
        Wings(axes)
    end
end
return main