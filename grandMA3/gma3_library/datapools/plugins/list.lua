--[[
list_fonction v1.0.0.2
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "list_fonction" 

Releases:
* 1.0.0.1 - Inital release
* 1.0.0.2 - gma3 1.8.1.0

Created by Richard Fontaine "RIRI", August 2022.
--]] --

local pluginName     = select(1,...);
local componentName  = select(2,...); 
local signalTable    = select(3,...);
local my_handle      = select(4,...);

local function myFunction(display_handle)

  for k, v in pairs(_G) do
       Printf(string.format("%s\n",  k))
  end

end

return myFunction