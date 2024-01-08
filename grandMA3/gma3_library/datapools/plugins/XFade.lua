local function main()
    local root = Root();
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
	local fx = tonumber(MatrickNr[1]:Get('FadeFromX', Enums.Roles.Display)) or 'None'
	local tx = tonumber(MatrickNr[1]:Get('FadeToX', Enums.Roles.Display)) or 'None'
    local text
    if (fx ~= "None" ) then
        if (tx ~= "None") then
        text = string.format( '"%.2f > %.2f"', fx , tx )
        else
        text = string.format( '"%.2f > %s"', fx , tx )
        end
    else
        if (tx ~= "None") then
        text = string.format( '"%s > %.2f"', fx , tx )
        else
        text = string.format( '"%s > %s"', fx , tx )
        end
    end
    Cmd('Set Layout 2.40 Property "CustomTextText" '.. text ..' ')
end
return main