--[[
    Releases:
    * 0.0.0.91
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Macro_Mute_Select(Construct_Pool, Call_Pool)
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local MacroNum = 1670
    local VariaSel = 1
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

    VariaSel = 1
    MacroNum = MacroNum + 2

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Inv_Select')
    for a = 1, 8 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Go+ DataPool '" ..
            Build_Pool.Name .. "' Macro '" .. varia_min[VariaSel] .. "_INV'")
        MacroObject[MacroNum][a]:Set('Enabled', 0)
        VariaSel = VariaSel + 1
    end

    VariaSel = 1
    MacroNum = MacroNum + 1

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Priority')
    for a = 1, 5 do
        MacroObject[MacroNum]:Insert(a)
    end
    MacroObject[MacroNum][1]:Set('Command', "Edit DataPool '" ..
        Build_Pool.Name .. "' Sequence 'a_Sub_#1' Property 'priority'")
    MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'TR_Fonction' 10")
    MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
    MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_2410")
    MacroObject[MacroNum][5]:Set('Command', "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_By_Riri'")
end
