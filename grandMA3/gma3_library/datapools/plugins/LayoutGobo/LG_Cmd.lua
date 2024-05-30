--[[
Releases:
* 0.0.0.7

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

function GetWheelName(ftype, attribut, NrFixtureModeType)
    CmdIndirectWait("ClearAll")
    CmdIndirectWait("Cd Root")
    CmdIndirectWait("Cd FixtureType '" .. ftype .. "'")
    CmdIndirectWait("Cd DMXModes." .. NrFixtureModeType .. ".DMXChannels.'*" .. attribut .. "'.1")
    return CmdObj().Destination:Children()[1].Wheel.name
end

function CreateAppearances(ft, att, j, prefix, Mode_Cue_Type, NrFixtureModeType, Slot_Id_)
    local gobowheel = GetWheelName(ft, att, NrFixtureModeType)
    CmdIndirectWait("Cd ft '" .. ft .. "'.Wheels.'" .. gobowheel .. "'")
    local wheel = CmdObj().Destination
    for _ , id_slot in ipairs(Slot_Id_) do
        for _, slot in ipairs(wheel:Children()) do
            if tonumber(id_slot) == tonumber(slot.No) then
                CmdIndirectWait("Store Appearance " .. j .. " 'Appearance " .. j .. "'")
                local objlist = ObjectList("Appearance " .. tostring(j))
                j = j + 1
                local obj = objlist[1]
                obj.Name = string.format('%s %s %s %s', prefix .. '_', wheel:Parent():Parent().ShortName, wheel.Name, slot.Name)
                for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
                    obj[prop] = slot[prop]
                end
                if Mode_Cue_Type then
                    CmdIndirectWait("Store Appearance " .. j .. " 'Appearance " .. j .. "'")
                    objlist = ObjectList("Appearance " .. tostring(j))
                    j = j + 1
                    obj = objlist[1]
                    obj.Name = string.format('%s %s %s %s', prefix .. '_ActiveCue_', wheel:Parent():Parent().ShortName,
                    wheel.Name,
                    slot.Name)
                    for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
                        obj[prop] = slot[prop]
                        if prop == 'ImageR' or prop == 'ImageB' then
                            obj[prop] = 0
                        end
                    end
                end
            end
        end
    end
    return j
end

function List_SlotID(att, FixtureID, Slot_ID_, n)
    local handleFixture = ObjectList(FixtureID)[1]
    local mode = handleFixture.MODEDIRECT.name
    local ft = handleFixture.FixtureTYPE.name
    local slot_index = 2
    local slot_index_
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
                    slot_index_ = slot_index - 1
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
                local avgdmx = math.floor(((todmx - fromdmx) / 2) + fromdmx) -- good
                CmdIndirectWait("ClearAll")
                CmdIndirectWait(FixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
                for _, v in ipairs(Select_) do
                    if (CmdObj().Destination:Children()[i].Name == v) then
                        presetnames[PN] = CmdObj().Destination:Children()[i].Name:gsub(' ', '_') -- geting the name of the gobo
                        CmdIndirectWait("Store Preset 25." .. PresetIndex .. " /merge")
                        CmdIndirectWait("Label Preset 25." ..
                            PresetIndex .. " '" .. prefix .. '_' .. presetnames[PN] .. "'")
                        if (tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX) ~= nil) then
                            Slot_ID_[slot_index] = CmdObj().Destination:Children()[i].WHEELSLOTINDEX
                            Printf(tonumber(CmdObj().Destination:Children()[i].WHEELSLOTINDEX))
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
    local check_first_gobo = true
    local first_gobo_name
    CmdIndirectWait("ClearAll; Group " .. Grp)

    local progHandle = StartProgress("List Name")
    local startIdx, endIdx = 1, 8
    SetProgressRange(progHandle, startIdx, endIdx)

    SetProgress(progHandle, 1)
    local length1 = 1
    if Result[1] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then
            length1 = ArrayLength(Preset_Name[1])
            WH[1] = true
        end
    end
    SetProgress(progHandle, 2)
    local length2 = 1
    if Result[2] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
            length2 = ArrayLength(Preset_Name[2])
            WH[2] = true
        end
    end
    SetProgress(progHandle, 3)
    local length3 = 1
    if Result[3] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then
            length3 = ArrayLength(Preset_Name[3])
            WH[3] = true
        end
    end
    SetProgress(progHandle, 4)
    local length4 = 1
    if Result[4] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then
            length4 = ArrayLength(Preset_Name[4])
            WH[4] = true
        end
    end
    SetProgress(progHandle, 5)
    local length5 = 1
    if Result[5] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then
            length5 = ArrayLength(Preset_Name[5])
            WH[5] = true
        end
    end
    SetProgress(progHandle, 6)
    local length6 = 1
    if Result[6] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then
            length6 = ArrayLength(Preset_Name[6])
            WH[6] = true
        end
    end
    SetProgress(progHandle, 7)
    local length7 = 1
    if Result[7] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL2')) ~= nil then
            length7 = ArrayLength(Preset_Name[7])
            WH[7] = true
        end
    end
    SetProgress(progHandle, 8)
    local length8 = 1
    if Result[8] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL3')) ~= nil then
            length4 = ArrayLength(Preset_Name[8])
            WH[8] = true
        end
    end
    StopProgress(progHandle)

    Printf("The length 1 is " .. length1 .. " and 2 is " .. length2 .. " and 3 is " .. length3 ..
        " and 4 is " .. length4 .. " and 5 is " .. length5 .. " and 6 is " .. length6 ..
        " and 7 is " .. length7 .. " and 8 is " .. length8)
    CmdIndirectWait("ClearAll")
    CmdIndirectWait('Store Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextText=\' ' .. GrpName:gsub(' ','_'))
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextSize \'32')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Top')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        " Property PosX " .. LayX .. " PosY " .. LayY ..
        " PositionW " .. LayW .. " PositionH " .. LayH ..
        " VisibilityBorder=0")
    LayNr = math.floor(LayNr + 1)
    LayX = math.floor(LayX + LayW + 20)

    progHandle = StartProgress("Store Sequence & Assign To Layout")
    SetProgress(progHandle, 1)
    if WH[1] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo1'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo1\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length1 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length1, 1 do -- gobo1 loop from Preset to sequence
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[1] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[1] + Slot_ID[1][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[1][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 2)
    if WH[2] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo2'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo2\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length2 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length2, 1 do -- gobo2 loop from Preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[2] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[2] + Slot_ID[2][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[2][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 3)
    if WH[3] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo3'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Gobo3\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length3 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length3, 1 do -- gobo3 loop from Preset to sequence, if there is no gobo3 length3 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[3] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[3] + Slot_ID[3][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[3][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 4)
    if WH[4] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length4 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length4, 1 do -- EFFECTWHEEL loop from Preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[4] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[4] + Slot_ID[4][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[4][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 5)
    if WH[5] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Prism1'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Prism1\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length5 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length5, 1 do -- Prism1 loop from Preset to sequence, if there is no Prism1 length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[5] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[5] + Slot_ID[5][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[5][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 6)
    if WH[6] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Prism2'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_Prism2\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length6 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length6, 1 do -- Prism2 loop from Preset to sequence, if there is no Prism2 length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[6] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[6] + Slot_ID[6][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[6][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 7)
    if WH[7] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL2'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' ..
            prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL2\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length7 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length7, 1 do -- EFFECTWHEEL loop from Preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[7] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[7] + Slot_ID[7][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[7][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    SetProgress(progHandle, 8)
    if WH[8] then
        if check_first_gobo then
            first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL3'
            check_first_gobo = false
        end
        CmdIndirectWait('Store Sequence ' ..
            SeqNrStart ..
            ' \'' ..
            prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_') .. '_EFFECTWHEEL3\' /nc')
        CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' Cue 1 Thru ' .. length8 .. ' /nc')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 0')
        CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
        for i = 1, length8, 1 do -- EFFECTWHEEL loop from Preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            Cue = Cue + 1
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[8] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue ' .. Cue .. ' Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[8] + Slot_ID[8][i] .. ' At Sequence ' .. SeqNrStart .. ' Cue ' .. i)
            CmdIndirectWait('Label Sequence ' ..
                SeqNrStart .. ' Cue ' .. Cue .. ' "' .. Preset_Name[8][i]:gsub(' ', '_') .. '"')
        end
        CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Thru Part 0.1')

        CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
        CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Action=Goto PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)

        SeqNrStart = SeqNrStart + 1
        Cue = 0
    end
    StopProgress(progHandle)
    LayY = math.floor(LayY - 120)
    return SeqNrStart + 1, LayNr, LayY, first_gobo_name
end

function CreateCue(FixtureType, prefix, SeqNrStart, Preset_Name, Grp, Slot_ID, PresetIndex, AppIndex, GrpName,
                   Result, TLayNr, RefX, LayY, LayH, LayW, LayNr, Mode_Line)
    local LayX = RefX
    LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

    SeqNrStart = tonumber(SeqNrStart)
    local WH = { false, false, false, false, false, false, false, false, false }
    local Cue = 0
    local ii
    local check_first_gobo = true
    local first_gobo_name

    CmdIndirectWait("ClearAll; Group " .. Grp)

    local progHandle = StartProgress("List Name")
    local startIdx, endIdx = 1, 8
    SetProgressRange(progHandle, startIdx, endIdx)

    SetProgress(progHandle, 1)
    local length1 = 1
    if Result[1] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then
            length1 = ArrayLength(Preset_Name[1])
            WH[1] = true
        end
    end
    SetProgress(progHandle, 2)
    local length2 = 1
    if Result[2] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
            length2 = ArrayLength(Preset_Name[2])
            WH[2] = true
        end
    end
    SetProgress(progHandle, 3)
    local length3 = 1
    if Result[3] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then
            length3 = ArrayLength(Preset_Name[3])
            WH[3] = true
        end
    end
    SetProgress(progHandle, 4)
    local length4 = 1
    if Result[4] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then
            length4 = ArrayLength(Preset_Name[4])
            WH[4] = true
        end
    end
    SetProgress(progHandle, 5)
    local length5 = 1
    if Result[5] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then
            length5 = ArrayLength(Preset_Name[5])
            WH[5] = true
        end
    end
    SetProgress(progHandle, 6)
    local length6 = 1
    if Result[6] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then
            length6 = ArrayLength(Preset_Name[6])
            WH[6] = true
        end
    end
    SetProgress(progHandle, 7)
    local length7 = 1
    if Result[7] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL2')) ~= nil then
            length7 = ArrayLength(Preset_Name[7])
            WH[7] = true
        end
    end
    SetProgress(progHandle, 8)
    local length8 = 1
    if Result[8] == 1 then
        if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL3')) ~= nil then
            length8 = ArrayLength(Preset_Name[8])
            WH[8] = true
        end
    end
    StopProgress(progHandle)

    Printf("The length 1 is " .. length1 .. " and 2 is " .. length2 .. " and 3 is " .. length3 ..
        " and 4 is " .. length4 .. " and 5 is " .. length5 .. " and 6 is " .. length6 ..
        " and 7 is " .. length7 .. " and 8 is " .. length8)
    CmdIndirectWait("ClearAll")
    CmdIndirectWait('Store Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextText=\' ' .. GrpName:gsub(' ','_'))
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextSize \'32')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Top')
    CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        " Property PosX " .. LayX - LayW - 20 .. " PosY " .. LayY ..
        " PositionW " .. LayW .. " PositionH " .. LayH ..
        " VisibilityBorder=0")
    LayNr = math.floor(LayNr + 1)
    -- LayX = math.floor(LayX + LayW + 20)

    progHandle = StartProgress("Store Cues & Assign To Layout")
    SetProgressRange(progHandle, startIdx, endIdx)
    SetProgress(progHandle, 1)
    if WH[1] then
        for i = 1, length1, 1 do -- gobo1 loop from Preset to sequence
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[1][i]:gsub(' ', '_') .. '_Gobo1'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[1][i]:gsub(' ', '_') .. '_Gobo1\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[1] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[1] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[1] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[1][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 2)
    if WH[2] then
        for i = 1, length2, 1 do -- gobo2 loop from Preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[2][i]:gsub(' ', '_') .. '_Gobo2'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[2][i]:gsub(' ', '_') .. '_Gobo2\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[2] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[2] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[2] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[2][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 3)
    if WH[3] then
        for i = 1, length3, 1 do -- gobo3 loop from Preset to sequence, if there is no gobo3 length3 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[3][i]:gsub(' ', '_') .. '_Gobo3'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[3][i]:gsub(' ', '_') .. '_Gobo3\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[3] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[3] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[3] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[3][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 4)
    if WH[4] then
        for i = 1, length4, 1 do -- EFFECTWHEEL loop from Preset to sequence, if there is no EFFECTWHEEL length4 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[4][i]:gsub(' ', '_') .. '_EFFECTWHEEL'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[4][i]:gsub(' ', '_') .. '_EFFECTWHEEL\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[4] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[4] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[4] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[4][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 5)
    if WH[5] then
        for i = 1, length5, 1 do -- Prism1 loop from Preset to sequence, if there is no Prism1 length4 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[5][i]:gsub(' ', '_') .. '_Prism1'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[5][i]:gsub(' ', '_') .. '_Prism1\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[5] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[5] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[5] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[5][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 6)
    if WH[6] then
        for i = 1, length6, 1 do -- Prism2 loop from Preset to sequence, if there is no Prism2 length4 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[6][i]:gsub(' ', '_') .. '_Prism2'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[6][i]:gsub(' ', '_') .. '_Prism2\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[6] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[6] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[6] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[6][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 7)
    if WH[7] then
        for i = 1, length7, 1 do -- EFFECTWHEEL2 loop from Preset to sequence, if there is no EFFECTWHEEL2 length7 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[7][i]:gsub(' ', '_') .. '_EFFECTWHEEL2'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[7][i]:gsub(' ', '_') .. '_EFFECTWHEEL2\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[7] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[7] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[7] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[7][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
        LayX = math.floor(LayX + LayW + 20)
        if Mode_Line then
            LayY = math.floor(LayY - 120)
            LayX = RefX
        end
    end
    SetProgress(progHandle, 8)
    if WH[8] then
        for i = 1, length8, 1 do -- EFFECTWHEEL3 loop from Preset to sequence, if there is no EFFECTWHEEL3 length8 would be 1 and loop wont commited
            if check_first_gobo then
                first_gobo_name = prefix .. '_' .. FixtureType:gsub(' ', '_') .. '_' .. GrpName:gsub(' ', '_').. '_' .. Preset_Name[8][i]:gsub(' ', '_') .. '_EFFECTWHEEL3'
                check_first_gobo = false
            end
            ii = i * 2
            CmdIndirectWait('Store Sequence ' .. SeqNrStart .. ' \'' .. prefix .. '_' .. FixtureType:gsub(' ', '_') ..
                '_' .. GrpName:gsub(' ', '_') .. '_' .. Preset_Name[8][i]:gsub(' ', '_') .. '_EFFECTWHEEL3\' /nc')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "OffwhenOverridden" 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property "PreferCueAppearance" 1')
            CmdIndirectWait('Assign Preset 25.' .. PresetIndex[8] + i .. ' At Sequence ' .. SeqNrStart ..
                ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Appearance ' ..
                AppIndex[8] + ii .. ' At Sequence ' .. SeqNrStart .. ' Cue 1')
            CmdIndirectWait('Set Sequence ' .. SeqNrStart .. ' Property Appearance=' .. AppIndex[8] + ii - 1)
            CmdIndirectWait('Label Sequence ' .. SeqNrStart .. ' Cue 1 "' .. Preset_Name[8][i]:gsub(' ', '_') .. '"')
            CmdIndirectWait('Assign Group ' .. Grp .. ' At Sequence ' .. SeqNrStart .. ' Cue 1 Part 0.1')
            CmdIndirectWait('Assign Sequence ' .. SeqNrStart .. ' At Layout ' .. TLayNr)
            CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Action=Go PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectName=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)

            SeqNrStart = SeqNrStart + 1
        end
    end
    StopProgress(progHandle)
    LayY = math.floor(LayY - 120)
    return SeqNrStart + 1, LayNr, LayY, first_gobo_name
end

-- end LG_Cmd.lua
