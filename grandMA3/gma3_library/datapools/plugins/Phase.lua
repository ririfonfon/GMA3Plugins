local function main()
    local root = Root();
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
	local fx = MatrickNr[1]:Get('PhaseFromX', Enums.Roles.Display)
	local tx = MatrickNr[1]:Get('PhaseToX', Enums.Roles.Display)
    local text
    if (fx ~= "None" and fx ~= "90°" and fx ~= "180°" and fx ~= "270°" and fx ~= "360°" ) then
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
        text = string.format( '"%.2f > %.2f"', fx , tx )
        else
        text = string.format( '"%.2f > %s"', fx , tx )
        end
    else
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
        text = string.format( '"%s > %.2f"', fx , tx )
        else
        text = string.format( '"%s > %s"', fx , tx )
        end
    end
    Cmd('Set Layout 2.62 Property "CustomTextText" '.. text ..' ')
end
return main