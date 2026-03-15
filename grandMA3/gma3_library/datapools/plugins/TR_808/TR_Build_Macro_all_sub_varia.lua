--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Macro_All_Sub_Varia(Construct_Pool)
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local MacroNum = 1653
    local MacroEnd
    local VariaSel = 1
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Clear_sub')
    for a = 1, 12 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Set DataPool '" ..
            Build_Pool.Name .. "' Macro 'all_sub_#" .. count .. "'.1 Thru 8 'Enabled' 0")
        count = count + 1
    end
    count = 1
    for a = 13, 24 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Set DataPool '" ..
            Build_Pool.Name .. "' Macro 'none_sub_#" .. count .. "'.1 Thru 8 'Enabled' 0")
        count = count + 1
    end
    count = 1
    for a = 25, 36 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][a]:Set('Command', "Set DataPool '" ..
            Build_Pool.Name .. "' Macro 'inv_sub_#" .. count .. "'.1 Thru 8 'Enabled' 0")
        count = count + 1
    end
    count = 1
        for a = 37, 48 do
            MacroObject[MacroNum]:Acquire()
            MacroObject[MacroNum][a]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Inv_Select'." ..
                VariaSel .. " 'Enabled' 0")
            count = count + 1
        end
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][49]:Set('Command',
        "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Mute'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][50]:Set('Command',
        "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Off_Mute'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][51]:Set('Command',
        "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Select'.1 Thru 8 'Enabled' 0")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][52]:Set('Command',
        "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Off_Select'.1 Thru 8 'Enabled' 0")

    count = 1
    MacroNum = MacroNum + 1
    MacroEnd = MacroNum + (8 - VariaSel)

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'all_sub_varia_' .. varia_min[VariaSel])
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command',
            "Go+ DataPool '" .. Build_Pool.Name .. "' Macro 'Clear_sub'")
        MacroObject[i][1]:Set('Wait', 0.1)
        for a = 2, 13 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Macro 'all_sub_#" .. count .. "'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        for a = 14, 25 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Macro 'none_sub_#" .. count .. "'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        for a = 26, 37 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Macro 'inv_sub_#" .. count .. "'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        for a = 38, 49 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Macro 'Inv_Select'." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        MacroObject[i]:Acquire()
        MacroObject[i][50]:Set('Command',
            "Set DataPool '" .. Build_Pool.Name ..
            "' Macro 'Mute'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][51]:Set('Command',
            "Set DataPool '" .. Build_Pool.Name ..
            "' Macro 'Off_Mute'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][52]:Set('Command',
            "Set DataPool '" .. Build_Pool.Name ..
            "' Macro 'Select'." .. VariaSel .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][53]:Set('Command',
            "Set DataPool '" .. Build_Pool.Name ..
            "' Macro 'Off_Select'." .. VariaSel .. " 'Enabled' 1")

        count = 1
        VariaSel = VariaSel + 1
    end
end
