--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Macro_Mute_Select(Construct_Pool)
    
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local MacroNum = 1670
    local VariaSel = 1
    -- local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]


    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Mute')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 1 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end

    VariaSel = 1
    MacroNum = MacroNum + 1

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Select')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 1 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end

    VariaSel = 1
    MacroNum = MacroNum + 2

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Off_Mute')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 2 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
    VariaSel = 1

    MacroNum = MacroNum + 1

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Off_Select')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ Cue 2 DataPool '" ..
            Build_Pool.Name .. "' Sequence thru if Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
        VariaSel = VariaSel + 1
    end
end