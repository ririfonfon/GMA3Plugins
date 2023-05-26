local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...); 
local my_handle     = select(4,...);


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
        display = display_Handle,
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
	-- return GlobalVars(time_ask)


end
