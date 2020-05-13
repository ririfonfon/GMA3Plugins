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