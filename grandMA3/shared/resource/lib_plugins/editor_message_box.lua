local function main()
	-- create inputs:
	local states = {
		{name = "State A", state = true, group = 1},
		{name = "State B", state = false, group = 1},
		{name = "State C", state = true, group = 2},
		{name = "State D", state = false, group = 2}
	}
	local inputs = {
		{name = "Numbers Only", value = "1234", whiteFilter = "0123456789"},
		{name = "Text Only", value = "TextOnly", blackFilter = "0123456789"},
		{name = "Maximum 10 characters", value = "abcdef", maxTextLength = 10}
	}
	local selectors = {
		{ name="Swipe Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=0},
		{ name="Radio Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=1}
	}

	-- open messagebox:
	local resultTable =
		MessageBox(
		{
			title = "Messagebox example",
			message = "This is a message",
			message_align_h = Enums.AlignmentH.Left,
			message_align_v = Enums.AlignmentV.Top,
			commands = {{value = 1, name = "Ok"}, {value = 0, name = "Cancel"}},
			states = states,
			inputs = inputs,
			selectors = selectors,
			backColor = "Global.Default",
			-- timeout = 10000, --milliseconds
			-- timeoutResultCancel = false,
			icon = "logo_small",
			titleTextColor = "Global.AlertText",
			messageTextColor = "Global.Text"
		}
	)

	-- print results:
	Printf("Success = "..tostring(resultTable.success))
	Printf("Result = "..resultTable.result)
	for k,v in pairs(resultTable.inputs) do
		Printf("Input '%s' = '%s'",k,v)
	end
	for k,v in pairs(resultTable.states) do
		Printf("State '%s' = '%s'",k,tostring(v))
	end
	for k,v in pairs(resultTable.selectors) do
		Printf("Selector '%s' = '%d'",k,v)
	end
end

return main
