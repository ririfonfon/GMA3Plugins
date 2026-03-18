local function main()
	local Construct_Pool = 46
	local Build_Pool     = Root().ShowData.DataPools[Construct_Pool]
	local varia_min      = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
	local varia_mag      = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
	local VariaSel       = 1
	local luaCode            = "local val = GetVar(UserVars(),'" .. varia_mag[VariaSel] ..
		"_TR_Solo') ; if val == 0 then Cmd('Go+ DataPool " ..
		Build_Pool.Name .. " Macro '" .. varia_min[VariaSel] .. "_NO_SOLO') end"
	Printf(luaCode)
end

return main
