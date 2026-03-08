--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Macro_Tempo(Construct_Pool)
    
    local MacroNum = 85
    local MacroEnd
    local VariaSel = 1
    local count = 1
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local Tempo_Count = { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16' }

    -- local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]
    local Reset = MacroNum

    MacroNum = MacroNum + 1
    MacroEnd = MacroNum + 15
    count = 1

    for i = MacroNum, MacroEnd, 1 do
        MacroObject:Delete(i)
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', 'Tempo_#' .. count)
        for a = 1, 8 do
            MacroObject[i]:Acquire()
            MacroObject[i][a]:Set('Command', "Goto DataPool '" .. Build_Pool.Name ..
                "' Cue " .. count .. " Sequence Thru if Tag 'Varia_" .. varia_mag[VariaSel] ..
                "; Goto DataPool '" .. Build_Pool.Name .. "' Cue " .. count ..
                " Sequence Thru if Tag 'Temps_" .. Tempo_Count[count] .. "'")
            VariaSel = VariaSel + 1
        end
        count = count + 1
        VariaSel = 1
    end

    count = 1
    MacroObject:Delete(Reset)
    Check_Size_Pool(Reset, MacroObject)
    MacroObject:Create(Reset)
    MacroObject[Reset]:Set('Name', 'Tempo_Reset')
    for a = 1, 16 do
        MacroObject[Reset]:Acquire()
        MacroObject[Reset][a]:Set('Command', "Set DataPool '" .. Build_Pool.Name ..
            "' Macro 'Tempo_#" .. count .. "'.1 Thru 16 'Enabled' 0")
        count = count + 1
    end
end