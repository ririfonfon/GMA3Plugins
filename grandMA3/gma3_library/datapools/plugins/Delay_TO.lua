local function main()
    local root = Root();
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
	local tx = tonumber(MatrickNr[1]:Get('DelayToX', Enums.Roles.Display)) or 'None'
    local text
    if (tx ~= "None" ) then
        text = string.format( '"%.2f"', tx )
    else
        text = string.format( '"%s"', tx )
    end
    Cmd('Set Layout 2.54 Property "CustomTextText" '.. text ..' ')
end
return main