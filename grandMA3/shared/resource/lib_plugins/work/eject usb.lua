local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...);
local my_handle     = select(4,...);

local F=string.format;
local E=Echo;

local function Main(display_handle,argument)

    local running = "1"
    local var = GlobalVars()
    local name = "EjectUSB"
    SetVar(var, name, "1")
    while running == "1" do
        local drives = Root().Temp.DriveCollect
        for i = 1, drives.count, 1 do
            if drives[i].DriveType == "Removeable" then
                Cmd("Eject Drive " .. i)
            end
        end
        running = GetVar(var, name)
        coroutine.yield(1)
    end
    DelVar(var, name)
    Echo("Stopping Plugin")

    
end
