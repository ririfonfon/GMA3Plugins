--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", April 2024.
--]]

function Construct_Gobo_Layout(displayHandle, TLay, SeqNrStart, TLayNr, AppNr, Preset_3_Current, Preset_3_NrStart,
                               SelectedGrp, SelectedGrpNo, TLayNrRef, NaLay, MaxGobLgn)
    Echo(
        '**********************************************************************************************************************************************************************')

    local SelectedFixtureType = {}
    
    local fixtureNo = "101"
    local fixture = 'Fixture ' .. fixtureNo .. ''
    local fixturenum = tonumber(fixtureNo)
    local FixtureType = ObjectList(fixture)[1].FIXTURETYPE.name
    local FirstPreset = 101
    local SeqName = "Gobo Group 1"
    local Preset_Name = {}
    local Slot_ID = {}
    Slot_ID[1] = {}
    Slot_ID[2] = {}
    Slot_ID[3] = {}

    Cmd("clearall; fixture " .. fixtureNo)

    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if fixture has gobo1
        Preset_Name[1] = CreateLabelPresets("Gobo1", fixture, FirstPreset)
        Slot_ID[1] = Check_SlotID("Gobo1", fixture, Slot_ID[1])
    end
    FirstPreset = FirstPreset + 50
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then -- check if fixture has gobo2
        Preset_Name[2] = CreateLabelPresets("Gobo2", fixture, FirstPreset)
        Slot_ID[2] = Check_SlotID("Gobo2", fixture, Slot_ID[2])
    end
    FirstPreset = FirstPreset + 50
    Cmd("clearall; fixture " .. fixtureNo)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then -- check if fixture has gobo3
        Preset_Name[3] = CreateLabelPresets("Gobo3", fixture, FirstPreset)
        Slot_ID[3] = Check_SlotID("Gobo3", fixture, Slot_ID[3])
    end

    Cmd("cd root")

    Cmd("clearall; fixture " .. fixtureNo)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) then -- check if fixture has gobo1
        createAppearances(FixtureType, "Gobo1", 1000 + fixturenum)
    end
    Cmd("clearall; fixture " .. fixtureNo)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) then -- check if fixture has gobo2
        createAppearances(FixtureType, "Gobo2", 1050 + fixturenum)
    end
    Cmd("clearall; fixture " .. fixtureNo)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) then -- check if fixture has gobo3
        createAppearances(FixtureType, "Gobo3", 1100 + fixturenum)
    end
    Cmd("cd root")
    -- printTable(Preset_Name[1])
    -- printTable(Preset_Name[2])
    -- printTable(Preset_Name[3])
    CreateSequence(SeqName, Preset_Name[1], Preset_Name[2], Preset_Name[3], tostring(math.floor(fixturenum / 100)),
        fixturenum, Slot_ID[1], Slot_ID[2], Slot_ID[3])
    Cmd("Blind Off")
end -- end Construct_Gobo_Layout

-- end LG_Construct.lua
