local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...);
local my_handle     = select(4,...);

local F=string.format;
local E=Echo;
local MacroNb = 17
local MacroIndex = 13
local command = ""
local ColorGel = 1
local ColorGelNb = 4
local PColor = 901
local function myFunction(display_handle)

-- command = F("store Macro %d .1 Thru %d . %d",MacroNb ,MacroNb ,MacroIndex)
-- Cmd(command)
Cmd("store Macro %d .1 Thru %d . %d",MacroNb ,MacroNb ,MacroIndex)
Cmd('CD Macro ' .. MacroNb)
Cmd('Set 1 Command "Store Group 999/o" ')
Cmd('Set 2 Command "Store Preset 25.999/o" ')
Cmd('Set 3 Command "Group 999 At Preset 25.999')
Cmd('Set 4 Command "Store Sequence 999 cue 1 /o ')
Cmd('Set 5 Command "Go Sequence 999 cue 1')
Cmd('Set 6 Command "Blind On" ')
Cmd('Set 7 Command "Fixture Thru" ')
Cmd('Set 8 Command "Down; Down; Down" ')
Cmd('Set 9 Command "at Gel %d . %d" ',ColorGel ,ColorGelNb)
Cmd('Set 10 Command "Store preset 4. %d /m" ',PColor)
Cmd('Set 11 Command "ClearAll;  Preset 25.999; At Preset 25.999" ')
Cmd('Set 12 Command "Blind Off" ')
Cmd('Set 13 Command "Off Sequence 999" ')
Cmd('CD Root')
    
end

return myFunction