local function dec24_to_dec8(dec24)
    return math.floor(dec24 * 255 / 16777215)
end

local function arrayLength(arr)
    local length = 0
    for _ in pairs(arr) do
        length = length + 1
    end
    return length
end



local function getWheelName(ftype, attribut)
    CmdIndirectWait("Clearall")
    CmdIndirectWait("cd root")
    CmdIndirectWait("cd FixtureType '" .. ftype .. "'")
    CmdIndirectWait("cd DMXModes.1.DMXChannels.'*" .. attribut .. "'.1")
    return CmdObj().Destination:Children()[1].Wheel.name
end

local function createAppearances(ft, att, j)
    local gobowheel = getWheelName(ft, att)
    CmdIndirectWait("cd ft '" .. ft .. "'.Wheels.'" .. gobowheel .. "'")
    local wheel = CmdObj().Destination
    for _, slot in ipairs(wheel:Children()) do
        CmdIndirectWait("Store appearance " .. j .. " 'Appearance " .. j .. "'")
        local objlist = ObjectList("appearance " .. tostring(j))
        j = j + 1
        local obj = objlist[1]
        obj.Name = string.format('FT %s %s %s', wheel:Parent():Parent().ShortName, wheel.Name, slot.Name)
        for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
            obj[prop] = slot[prop]
        end
    end
    return j
end

local function Check_SlotID(att, FixtureID)
    local Slot_ID_ = {}
    local handleFixture = ObjectList(FixtureID)[1]
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local slot_index = 1
    local GoboAttNum = 1

    CmdIndirectWait("cd root")
    CmdIndirectWait("cd FixtureType '" .. ft .. "'")
    CmdIndirectWait("cd DMXModes.'*" .. mode .. "*'.DMXChannels")

    while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
        -- this loop is to find where attribute gobo is in the dmxchannels
        GoboAttNum = GoboAttNum + 1
    end
    if GoboAttNum == #CmdObj().Destination:Children() then
        Printf("Returning")
        return
    end -- this is to terminate the function if there is no gobo

    local DefaultP = dec24_to_dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
    CmdIndirectWait("cd '*" .. att .. "'")
    CmdIndirectWait("cd '*" .. att .. "'")
    if CmdObj().Destination:Children()[1].DMXTO ~= nil then
        local rang = tonumber(CmdObj().Destination:Count())
        for d = 1, rang, 1 do
            local i = 1
            CmdIndirectWait("cd " .. d)                    -- changing destination
            while i <= #CmdObj().Destination:Children() do -- iterating over the gobos
                if (tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX) ~= nil) then
                    Slot_ID_[slot_index] = CmdObj().Destination:Children()[i].WHEELSLOTINDEX
                else
                    Slot_ID_[slot_index] = 1
                end
                i = i + 1
                slot_index = slot_index + 1
            end
            CmdIndirectWait('Cd ..')
        end
        return Slot_ID_
    else
        Printf("No " .. att .. " here")
    end
end


local function CreateLabelPresets(att, FixtureID, FirstPresetIndex)
    local handleFixture = ObjectList(FixtureID)[1]
    local presetnames = {}
    local Slot_ID_ = {}
    local slot_index = 1
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local PresetIndex = FirstPresetIndex
    local GoboAttNum = 1
    local PN = 1

    CmdIndirectWait("cd root")
    CmdIndirectWait("cd FixtureType '" .. ft .. "'")
    CmdIndirectWait("cd DMXModes.'*" .. mode .. "*'.DMXChannels")

    while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
        -- this loop is to find where attribute gobo is in the dmxchannels
        GoboAttNum = GoboAttNum + 1
    end
    if GoboAttNum == #CmdObj().Destination:Children() then
        Printf("Returning")
        return
    end -- this is to terminate the function if there is no gobo

    local DefaultP = dec24_to_dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
    CmdIndirectWait("cd '*" .. att .. "'")
    CmdIndirectWait("cd '*" .. att .. "'")
    if CmdObj().Destination:Children()[1].DMXTO ~= nil then
        local rang = tonumber(CmdObj().Destination:Count())
        for d = 1, rang, 1 do
            local i = 1
            CmdIndirectWait("cd " .. d)                    -- changing destination
            while i <= #CmdObj().Destination:Children() do -- iterating over the gobos
                if (tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX) ~= nil) then
                    Slot_ID_[slot_index] = CmdObj().Destination:Children()[i].WHEELSLOTINDEX
                else
                    Slot_ID_[slot_index] = 1
                end
                local fromdmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM)
                local todmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO)
                -- local avgdmx = math.floor((fromdmx + todmx) / 2) -- so there is no problem of the conversion from decimal24 to deecimal8
                local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                CmdIndirectWait("Clearall")
                CmdIndirectWait(FixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
                CmdIndirectWait("store preset 25." .. PresetIndex .. " /merge")
                presetnames[PN] = CmdObj().Destination:Children()[i].Name -- geting the name of the gobo
                CmdIndirectWait("Label preset 25." .. PresetIndex .. " '" .. presetnames[PN] .. "'")
                PresetIndex = PresetIndex + 1
                i = i + 1
                PN = PN + 1
                slot_index = slot_index + 1
            end
            CmdIndirectWait('Cd ..')
        end

        return presetnames, PresetIndex, Slot_ID_
    else
        Printf("No " .. att .. " here")
    end
end

local function CreateSequence(SeqNameF, Preset_Name, Grp, Slot_ID, PresetIndex, AppIndex)
    CmdIndirectWait("delete seq '" .. SeqNameF .. "' /nc") -- delete existing sequence
    local cue = 0
    local length1 = arrayLength(Preset_Name[1])
    CmdIndirectWait("Clearall; Group " .. Grp)
    local length2 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
        length2 = arrayLength(Preset_Name[2])
    end
    local length3 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then
        length3 = arrayLength(Preset_Name[3])
    end
    local length4 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then
        length4 = arrayLength(Preset_Name[4])
    end
    Printf("The length 1 is " ..
        length1 .. " and 2 is " .. length2 .. " and 3 is " .. length3 .. " and 4 is " .. length4)
    CmdIndirectWait("Clearall")

    CmdIndirectWait("store seq '" .. SeqNameF .. "' /nc")
    CmdIndirectWait("store seq '" .. SeqNameF .. "' cue 1 t " .. length1 + length2 + length3 + length4 .. " /nc")
    for i = 1, length1, 1 do -- gobo1 loop from preset to sequence
        cue = cue + 1
        CmdIndirectWait("assign preset 25." .. PresetIndex[1] + i .. " at seq '" .. SeqNameF ..
            "' cue " .. cue .. " part 0.1")
        CmdIndirectWait("assign appearance " ..
            AppIndex[1] + Slot_ID[1][i] .. " at seq '" .. SeqNameF .. "' cue " .. i)
        CmdIndirectWait("label seq '" .. SeqNameF .. "'  cue " .. cue .. " '" .. Preset_Name[1][i] .. "'")
    end

    for i = 1, length2, 1 do -- gobo2 loop from preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited
        cue = cue + 1
        CmdIndirectWait("assign preset 25." .. PresetIndex[2] + i .. " at seq '" .. SeqNameF ..
            "' cue " .. cue .. " part 0.1")
        CmdIndirectWait("assign appearance " ..
            AppIndex[2] + Slot_ID[2][i] .. " at seq '" .. SeqNameF .. "' cue " .. cue)
        CmdIndirectWait("label seq '" .. SeqNameF .. "'  cue " .. cue .. " '" .. Preset_Name[2][i] .. "'")
    end

    for i = 1, length3, 1 do -- gobo3 loop from preset to sequence, if there is no gobo3 length3 would be 1 and loop wont commited
        cue = cue + 1
        CmdIndirectWait("assign preset 25." .. PresetIndex[3] + i .. " at seq '" .. SeqNameF ..
            "' cue " .. cue .. " part 0.1")
        CmdIndirectWait("assign appearance " ..
            AppIndex[3] + Slot_ID[3][i] .. " at seq '" .. SeqNameF .. "' cue " .. cue)
        CmdIndirectWait("label seq '" .. SeqNameF .. "'  cue " .. cue .. " '" .. Preset_Name[3][i] .. "'")
    end

    for i = 1, length4, 1 do -- EFFECTWHEEL loop from preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
        cue = cue + 1
        CmdIndirectWait("assign preset 25." .. PresetIndex[4] + i .. " at seq '" .. SeqNameF ..
            "' cue " .. cue .. " part 0.1")
        CmdIndirectWait("assign appearance " ..
            AppIndex[4] + Slot_ID[4][i] .. " at seq '" .. SeqNameF .. "' cue " .. cue)
        CmdIndirectWait("label seq '" .. SeqNameF .. "'  cue " .. cue .. " '" .. Preset_Name[4][i] .. "'")
    end

    CmdIndirectWait("assign group " .. Grp .. " at seq '" .. SeqNameF .. "' cue 1 t part 0.1")
end


local function main(display)
    Echo(
        '**********************************************************************************************************************************************************************')
    local FixtureGroups = DataPool().Groups:Children()
    local Grp_Select = {}
    local FixtureGroupsNo
    for k in ipairs(FixtureGroups) do
        table.insert(Grp_Select, "'" .. FixtureGroups[k].name .. "'")
    end
    local _, FixtureGroupsSelect = PopupInput { title = 'Select Fixture Group', caller = display, items = Grp_Select, add_args = { FilterSupport = "Yes" } }
    FixtureGroupsSelect = FixtureGroupsSelect:gsub("'", "")
    for k in ipairs(FixtureGroups) do
        if (FixtureGroups[k].name == FixtureGroupsSelect) then
            FixtureGroupsNo = FixtureGroups[k].NO
        end
    end
    local FixtureID_ = #DataPool().Groups[FixtureGroupsNo].Selectiondata
    local Fixture = 'Fixture ' .. FixtureID_ .. ''
    local FixtureNum = tonumber(FixtureID_)
    local FixtureType = ObjectList(Fixture)[1].FixtureTYPE.name

    local All_5_Nr = DataPool().PresetPools[25]:Children()
    local FirstPreset
    for k in ipairs(All_5_Nr) do
        FirstPreset = All_5_Nr[k].NO + 1
    end
    if FirstPreset == nil then
        FirstPreset = 1
    end

    local App = ShowData().Appearances:Children()
    local AppNr
    for k in ipairs(App) do
        AppNr = App[k].NO + 1
    end
    if AppNr == nil then
        AppNr = 1
    end


    local SeqName = "Gobo Group 1"
    local Preset_Name = {}
    local Slot_ID = {}
    local PresetIndex
    local Index = {}
    local AppIndex = {}

    CmdIndirectWait("Blind On")
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if Fixture has gobo1
        Index[1] = FirstPreset - 1
        Preset_Name[1], PresetIndex, Slot_ID[1] = CreateLabelPresets("Gobo1", Fixture, FirstPreset)
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then -- check if Fixture has gobo2
        Index[2] = PresetIndex - 1
        Preset_Name[2], PresetIndex, Slot_ID[2] = CreateLabelPresets("Gobo2", Fixture, PresetIndex)
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then -- check if Fixture has gobo3
        Index[3] = PresetIndex - 1
        Preset_Name[3], PresetIndex, Slot_ID[3] = CreateLabelPresets("Gobo3", Fixture, PresetIndex)
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if Fixture has gobo3
        Index[4] = PresetIndex - 1
        Preset_Name[4], PresetIndex, Slot_ID[4] = CreateLabelPresets("EFFECTWHEEL", Fixture, PresetIndex)
    end

    CmdIndirectWait("cd root")

    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) then -- check if Fixture has gobo1
        AppIndex[1] = AppNr - 1
        AppNr = createAppearances(FixtureType, "Gobo1", AppNr)
    end
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) then -- check if Fixture has gobo2
        AppIndex[2] = AppNr - 1
        AppNr = createAppearances(FixtureType, "Gobo2", AppNr)
    end
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) then -- check if Fixture has gobo3
        AppIndex[3] = AppNr - 1
        AppNr = createAppearances(FixtureType, "Gobo3", AppNr)
    end
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) then -- check if Fixture has gobo3
        AppIndex[4] = AppNr - 1
        AppNr = createAppearances(FixtureType, "EFFECTWHEEL", AppNr)
    end

    CmdIndirectWait("cd root")

    CreateSequence(SeqName, Preset_Name, FixtureGroupsNo, Slot_ID, Index, AppIndex)
    CmdIndirectWait("Blind Off")
end
return main
