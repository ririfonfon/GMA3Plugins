--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", May 2024.
--]]

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

local function List_SlotID(att, FixtureID, Slot_ID_, n)
    -- local Slot_ID_ = {}
    local handleFixture = ObjectList(FixtureID)[1]
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local slot_index = 2
    local GoboAttNum = 1
    local slot_

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
                    local fromdmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM)
                    local todmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO)
                    local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                    CmdIndirectWait("Clearall")
                    CmdIndirectWait(FixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
                    -- Slot_ID_[n][slot_index] = {'handle', name = CmdObj().Destination:Children()[i].Name, state = false }
                    local slot_index_ = slot_index - 1
                    Slot_ID_[n][slot_index] =
                        string.format('%02d %s', slot_index_, tostring(CmdObj().Destination:Children()[i].Name))
                    slot_ = slot_index
                else
                    Slot_ID_[n][slot_index] = 'Empty'
                end
                i = i + 1
                slot_index = slot_index + 1
            end
            CmdIndirectWait('Cd ..')
        end
        return Slot_ID_[n], slot_
    else
        Printf("No " .. att .. " here")
    end
end


local function CreateLabelPresets(att, FixtureID, FirstPresetIndex, Select_)
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
                local fromdmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM)
                local todmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO)
                -- local avgdmx = math.floor((fromdmx + todmx) / 2) -- so there is no problem of the conversion from decimal24 to deecimal8
                local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                CmdIndirectWait("Clearall")
                CmdIndirectWait(FixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
                for _, v in ipairs(Select_) do
                    if (CmdObj().Destination:Children()[i].Name == v) then
                        Printf(' obj %s Sel %s', CmdObj().Destination:Children()[i].Name, v)
                        presetnames[PN] = CmdObj().Destination:Children()[i].Name -- geting the name of the gobo
                        CmdIndirectWait("store preset 25." .. PresetIndex .. " /merge")
                        CmdIndirectWait("Label preset 25." .. PresetIndex .. " '" .. presetnames[PN] .. "'")
                        if (tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX) ~= nil) then
                            Slot_ID_[slot_index] = CmdObj().Destination:Children()[i].WHEELSLOTINDEX
                        else
                            Slot_ID_[slot_index] = 1
                        end
                        PresetIndex = PresetIndex + 1
                        PN = PN + 1
                        slot_index = slot_index + 1
                    end
                end
                i = i + 1
            end
            CmdIndirectWait('Cd ..')
        end

        return presetnames, PresetIndex, Slot_ID_
    else
        Printf("No " .. att .. " here")
    end
end

local function CreateSequence(FixtureType, prefix, SeqNrStart, Preset_Name, Grp, Slot_ID, PresetIndex, AppIndex)
    SeqNrStart = tonumber(SeqNrStart)
    local WH = { false, false, false, false, false }
    local cue = 0
    CmdIndirectWait("Clearall; Group " .. Grp)
    local length1 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then
        length1 = arrayLength(Preset_Name[1])
        WH[1] = true
    end
    local length2 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
        length2 = arrayLength(Preset_Name[2])
        WH[2] = true
    end
    local length3 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then
        length3 = arrayLength(Preset_Name[3])
        WH[3] = true
    end
    local length4 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then
        length4 = arrayLength(Preset_Name[4])
        WH[4] = true
    end
    local length5 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then
        length5 = arrayLength(Preset_Name[5])
        WH[5] = true
    end
    local length6 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then
        length6 = arrayLength(Preset_Name[6])
        WH[6] = true
    end
    Printf("The length 1 is " ..
        length1 ..
        " and 2 is " .. length2 .. " and 3 is " .. length3 .. " and 4 is " .. length4 .. " and 5 is " .. length5)
    CmdIndirectWait("Clearall")

    if WH[1] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_Gobo1\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length1 .. ' /nc')
        for i = 1, length1, 1 do -- gobo1 loop from preset to sequence
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[1] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[1] + Slot_ID[1][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[1][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
        SeqNrStart = SeqNrStart + 1
        cue = 0
    end
    if WH[2] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_Gobo2\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length2 .. ' /nc')
        for i = 1, length2, 1 do -- gobo2 loop from preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[2] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[2] + Slot_ID[2][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[2][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
        SeqNrStart = SeqNrStart + 1
        cue = 0
    end
    if WH[3] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_Gobo3\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length3 .. ' /nc')
        for i = 1, length3, 1 do -- gobo3 loop from preset to sequence, if there is no gobo3 length3 would be 1 and loop wont commited
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[3] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[3] + Slot_ID[3][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[3][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
        SeqNrStart = SeqNrStart + 1
        cue = 0
    end
    if WH[4] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_EFFECTWHEEL\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length4 .. ' /nc')
        for i = 1, length4, 1 do -- EFFECTWHEEL loop from preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[4] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[4] + Slot_ID[4][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[4][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
    end
    if WH[5] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_Prism1\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length5 .. ' /nc')
        for i = 1, length5, 1 do -- Prism1 loop from preset to sequence, if there is no Prism1 length4 would be 1 and loop wont commited
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[5] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[5] + Slot_ID[5][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[5][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
        SeqNrStart = SeqNrStart + 1
        cue = 0
    end
    if WH[6] then
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_Prism2\' /nc')
        CmdIndirectWait('store seq ' .. SeqNrStart .. ' cue 1 t ' .. length6 .. ' /nc')
        for i = 1, length6, 1 do -- Prism2 loop from preset to sequence, if there is no Prism2 length4 would be 1 and loop wont commited
            cue = cue + 1
            CmdIndirectWait('assign preset 25.' .. PresetIndex[6] + i .. ' at seq ' .. SeqNrStart ..
                ' cue ' .. cue .. ' part 0.1')
            CmdIndirectWait('assign appearance ' ..
                AppIndex[6] + Slot_ID[6][i] .. ' at seq ' .. SeqNrStart .. ' cue ' .. i)
            CmdIndirectWait('label seq ' .. SeqNrStart .. ' cue ' .. cue .. ' "' .. Preset_Name[6][i] .. '"')
        end
        CmdIndirectWait('assign group ' .. Grp .. ' at seq ' .. SeqNrStart .. ' cue 1 t part 0.1')
        SeqNrStart = SeqNrStart + 1
        cue = 0
    end
end

-- end LG_Cmd.lua