--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", May 2024.
--]]

function Dec24_To_Dec8(dec24)
    return math.floor(dec24 * 255 / 16777215)
end

function ArrayLength(arr)
    local length = 0
    for _ in pairs(arr) do
        length = length + 1
    end
    return length
end

function GetWheelName(ftype, attribut)
    CmdIndirectWait("ClearAll")
    CmdIndirectWait("Cd Root")
    CmdIndirectWait("Cd FixtureType '" .. ftype .. "'")
    CmdIndirectWait("Cd DMXModes.1.DMXChannels.'*" .. attribut .. "'.1")
    return CmdObj().Destination:Children()[1].Wheel.name
end

function CreateAppearances(ft, att, j, prefix)
    local gobowheel = GetWheelName(ft, att)
    CmdIndirectWait("Cd ft '" .. ft .. "'.Wheels.'" .. gobowheel .. "'")
    local wheel = CmdObj().Destination
    for _, slot in ipairs(wheel:Children()) do
        CmdIndirectWait("Store Appearance " .. j .. " 'Appearance " .. j .. "'")
        local objlist = ObjectList("Appearance " .. tostring(j))
        j = j + 1
        local obj = objlist[1]
        obj.Name = string.format('%s %s %s %s', prefix .. '_', wheel:Parent():Parent().ShortName, wheel.Name, slot.Name)
        for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
            obj[prop] = slot[prop]
        end
    end
    return j
end

function List_SlotID(att, FixtureID, Slot_ID_, n)
    local handleFixture = ObjectList(FixtureID)[1]
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local slot_index = 2
    local GoboAttNum = 1
    local slot_

    CmdIndirectWait("Cd Root")
    CmdIndirectWait("Cd FixtureType '" .. ft .. "'")
    CmdIndirectWait("Cd DMXModes.'*" .. mode .. "*'.DMXChannels")

    while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
        -- this loop is to find where attribute gobo is in the dmxchannels
        GoboAttNum = GoboAttNum + 1
    end
    if GoboAttNum == #CmdObj().Destination:Children() then
        Printf("Returning")
        return
    end -- this is to terminate the function if there is no gobo

    local DefaultP = Dec24_To_Dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
    CmdIndirectWait("Cd '*" .. att .. "'")
    CmdIndirectWait("Cd '*" .. att .. "'")
    if CmdObj().Destination:Children()[1].DMXTO ~= nil then
        local rang = tonumber(CmdObj().Destination:Count())
        for d = 1, rang, 1 do
            local i = 1
            CmdIndirectWait("Cd " .. d)                    -- changing destination
            while i <= #CmdObj().Destination:Children() do -- iterating over the gobos
                if (tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX) ~= nil) then
                    local fromdmx = Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXFROM)
                    local todmx = Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXTO)
                    local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                    CmdIndirectWait("ClearAll")
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

function CreateLabelPresets(att, FixtureID, FirstPresetIndex, Select_, prefix)
    local handleFixture = ObjectList(FixtureID)[1]
    local presetnames = {}
    local Slot_ID_ = {}
    local slot_index = 1
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local PresetIndex = FirstPresetIndex
    local GoboAttNum = 1
    local PN = 1

    CmdIndirectWait("Cd Root")
    CmdIndirectWait("Cd FixtureType '" .. ft .. "'")
    CmdIndirectWait("Cd DMXModes.'*" .. mode .. "*'.DMXChannels")

    while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
        -- this loop is to find where attribute gobo is in the dmxchannels
        GoboAttNum = GoboAttNum + 1
    end
    if GoboAttNum == #CmdObj().Destination:Children() then
        Printf("Returning")
        return
    end -- this is to terminate the function if there is no gobo

    local DefaultP = Dec24_To_Dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
    CmdIndirectWait("Cd '*" .. att .. "'")
    CmdIndirectWait("Cd '*" .. att .. "'")
    if CmdObj().Destination:Children()[1].DMXTO ~= nil then
        local rang = tonumber(CmdObj().Destination:Count())
        for d = 1, rang, 1 do
            local i = 1
            CmdIndirectWait("Cd " .. d)                    -- changing destination
            while i <= #CmdObj().Destination:Children() do -- iterating over the gobos
                local fromdmx = Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXFROM)
                local todmx = Dec24_To_Dec8(CmdObj().Destination:Children()[i].DMXTO)
                -- local avgdmx = math.floor((fromdmx + todmx) / 2) -- so there is no problem of the conversion from decimal24 to deecimal8
                local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                CmdIndirectWait("ClearAll")
                CmdIndirectWait(FixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
                for _, v in ipairs(Select_) do
                    if (CmdObj().Destination:Children()[i].Name == v) then
                        Printf(' obj %s Sel %s', CmdObj().Destination:Children()[i].Name, v)
                        presetnames[PN] = CmdObj().Destination:Children()[i].Name -- geting the name of the gobo
                        CmdIndirectWait("Store Preset 25." .. PresetIndex .. " /merge")
                        CmdIndirectWait("Label Preset 25." ..
                            PresetIndex .. " '" .. prefix .. '_' .. presetnames[PN] .. "'")
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

function CreateSequence(FixtureType, prefix, SeqNrStart, Preset_Name, Grp, Slot_ID, PresetIndex, AppIndex, GrpName,
                        Result, TLayNr, RefX, LayY, LayH, LayW, LayNr)
    local LayX = RefX
    LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

    SeqNrStart = tonumber(SeqNrStart)
    local WH = { false, false, false, false, false }
    local Cue = 0
    CmdIndirectWait("ClearAll; Group " .. Grp)
    local length1 = 1

    if Result[1] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then
            length1 = ArrayLength(Preset_Name[1])
            WH[1] = true
        end
    end
    local length2 = 1
    if Result[2] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
            length2 = ArrayLength(Preset_Name[2])
            WH[2] = true
        end
    end
    local length3 = 1
    if Result[3] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then
            length3 = ArrayLength(Preset_Name[3])
            WH[3] = true
        end
    end
    local length4 = 1
    if Result[4] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then
            length4 = ArrayLength(Preset_Name[4])
            WH[4] = true
        end
    end
    local length5 = 1
    if Result[5] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then
            length5 = ArrayLength(Preset_Name[5])
            WH[5] = true
        end
    end
    local length6 = 1
    if Result[6] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then
            length6 = ArrayLength(Preset_Name[6])
            WH[6] = true
        end
    end
    Printf("The length 1 is " .. length1 .. " and 2 is " .. length2 .. " and 3 is " .. length3 ..
        " and 4 is " .. length4 .. " and 5 is " .. length5 .. " and 6 is " .. length6)
    CmdIndirectWait("ClearAll")
    CmdIndirectWait('Store Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextText=\' ' .. GrpName .. ' \'')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextSize \'32')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Top')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        " Property PosX " .. LayX .. " PosY " .. LayY ..
        " PositionW " .. LayW .. " PositionH " .. LayH ..
        " VisibilityBorder=0")
    LayNr = math.floor(LayNr + 1)
    LayX = math.floor(LayX + LayW + 20)

    if WH[1] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_Gobo1\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length1 .. ' /nc')
        for i = 1, length1, 1 do -- gobo1 loop from Preset to sequence
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[1] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[1] + Slot_ID[1][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[1][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance <Default> Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    if WH[2] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_Gobo2\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length2 .. ' /nc')
        for i = 1, length2, 1 do -- gobo2 loop from Preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[2] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[2] + Slot_ID[2][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[2][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')
        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    if WH[3] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_Gobo3\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length3 .. ' /nc')
        for i = 1, length3, 1 do -- gobo3 loop from Preset to sequence, if there is no gobo3 length3 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[3] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[3] + Slot_ID[3][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[3][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')
        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    if WH[4] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_EFFECTWHEEL\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length4 .. ' /nc')
        for i = 1, length4, 1 do -- EFFECTWHEEL loop from Preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[4] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[4] + Slot_ID[4][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[4][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')
    end
    if WH[5] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_Prism1\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length5 .. ' /nc')
        for i = 1, length5, 1 do -- Prism1 loop from Preset to sequence, if there is no Prism1 length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[5] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[5] + Slot_ID[5][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[5][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')
        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    if WH[6] then
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType .. '_' .. GrpName .. '_Prism2\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length6 .. ' /nc')
        for i = 1, length6, 1 do -- Prism2 loop from Preset to sequence, if there is no Prism2 length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[6] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[6] + Slot_ID[6][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[6][i] .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')
        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    return SeqNrStart + 1, LayNr
end

-- end LG_Cmd.lua
