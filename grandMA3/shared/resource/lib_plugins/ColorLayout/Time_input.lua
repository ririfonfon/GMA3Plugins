
local F = string.format
local E = Echo
local Maf = math.floor

return function (display,argument)

	local ask 
    local myargu

    if argument then
        for myarg in argument:gmatch("([^,]+)") do 
            E(myarg)
            myargu = myarg 
        end
    end

	local box = MessageBox({
        title = 'time',
        backColor = "1.7",
        inputs = {{
            name = 'time',
            value = ask,
            maxTextLength = 4,
            vkPlugin = "TextInputTimeOnly"
        }}
		
    })

	ask = box.inputs.time
	ask = string.gsub(ask,'"',"" )

	Cmd('setglobalvariable "time_ask" '  .. ' '  .. ask .. '\'')
	Cmd("Go Macro " .. myargu .."")

end