local function main()
    local root = Root();
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
	local fx = tonumber(MatrickNr[1]:Get('xWings', Enums.Roles.Display)) or 'None'
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout 2.78 Property "CustomTextText" '.. text ..' ')
end
return main