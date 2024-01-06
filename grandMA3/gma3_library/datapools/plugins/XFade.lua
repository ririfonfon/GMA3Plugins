local function main()
    local Maf = math.floor
    local root = Root();
    local TLay = root.ShowData.DataPools.Default.Layouts:Children()
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
	local fx = tonumber(MatrickNr[1]:Get('FadeFromX', Enums.Roles.Display)) or 'None' 
	local tx = tonumber(MatrickNr[1]:Get('FadeToX', Enums.Roles.Display)) or 'None' 
	Echo ("FromX = ")
	Echo (fx)
    Echo ("ToX = ")
	Echo (tx)
    local text = string.format( '"%.2f > %.2f"', fx , tx )
    Cmd('Set Layout 2.99 Property "CustomTextText" ' .. text ..' ')
end
return main