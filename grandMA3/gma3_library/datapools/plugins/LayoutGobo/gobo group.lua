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
    CmdIndirectWait("Blind On")
    CmdIndirectWait('Clearall')
    CmdIndirectWait('SelectFixtures Group ' .. FixtureGroupsNo)
    local FixtureID_
    local myFixtureIndex = SelectionFirst(true)
    local mySubFixture = GetSubfixture(myFixtureIndex)
    if mySubFixture ~= nil then
        FixtureID_ = mySubFixture.fid
        Printf(FixtureID_)
    end
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

    local SeqNr = DataPool().Sequences:Children()
    local SeqNrStart
    for k in ipairs(SeqNr) do
        SeqNrStart = SeqNr[k].NO + 1
    end
    if SeqNrStart == nil then
        SeqNrStart = 1
    end

    -- fix prefix
    local prefix_index = 1
    local old_prefix_index
    local prefix = 'LG' .. tostring(prefix_index) .. '_'
    local exit = false
    repeat
        old_prefix_index = prefix_index
        for k in pairs(SeqNr) do
            if string.match(SeqNr[k].name, prefix) then
                prefix_index = math.floor(prefix_index + 1)
            end
        end
        prefix = 'LG' .. tostring(prefix_index) .. '_'
        if old_prefix_index == prefix_index then
            exit = true
        end
    until exit == true


    local Preset_Name = {}
    local Slot_ID = {}
    local Item_Slot_Select_ID = {}
    local Slot_Select_ID = {}
    local Selected_Slot_Select_ID = {}
    local PresetIndex
    local Index = {}
    local AppIndex = {}
    local slot_index = {}
    local G_Check = { false, false, false, false , false , false}

    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if Fixture has gobo1
        Item_Slot_Select_ID[1] = {}
        Item_Slot_Select_ID[1][1] = true
        Item_Slot_Select_ID[1], slot_index[1] = List_SlotID('Gobo1', Fixture, Item_Slot_Select_ID, 1)
    else
        Item_Slot_Select_ID[1] = {}
        Item_Slot_Select_ID[1][1] = false
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then -- check if Fixture has gobo2
        Item_Slot_Select_ID[2] = {}
        Item_Slot_Select_ID[2][1] = true
        Item_Slot_Select_ID[2], slot_index[2] = List_SlotID('Gobo2', Fixture, Item_Slot_Select_ID, 2)
    else
        Item_Slot_Select_ID[2] = {}
        Item_Slot_Select_ID[2][1] = false
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then -- check if Fixture has gobo3
        Item_Slot_Select_ID[3] = {}
        Item_Slot_Select_ID[3][1] = true
        Item_Slot_Select_ID[3], slot_index[3] = List_SlotID('Gobo3', Fixture, Item_Slot_Select_ID, 3)
    else
        Item_Slot_Select_ID[3] = {}
        Item_Slot_Select_ID[3][1] = false
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if Fixture has EFFECTWHEEL
        Item_Slot_Select_ID[4] = {}
        Item_Slot_Select_ID[4][1] = true
        Item_Slot_Select_ID[4], slot_index[4] = List_SlotID('EFFECTWHEEL', Fixture, Item_Slot_Select_ID, 4)
    else
        Item_Slot_Select_ID[4] = {}
        Item_Slot_Select_ID[4][1] = false
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then -- check if Fixture has Prism1
        Item_Slot_Select_ID[5] = {}
        Item_Slot_Select_ID[5][1] = true
        Item_Slot_Select_ID[5], slot_index[5] = List_SlotID('Prism1', Fixture, Item_Slot_Select_ID, 5)
    else
        Item_Slot_Select_ID[5] = {}
        Item_Slot_Select_ID[5][1] = false
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then -- check if Fixture has Prism2
        Item_Slot_Select_ID[6] = {}
        Item_Slot_Select_ID[6][1] = true
        Item_Slot_Select_ID[6], slot_index[6] = List_SlotID('Prism2', Fixture, Item_Slot_Select_ID, 6)
    else
        Item_Slot_Select_ID[6] = {}
        Item_Slot_Select_ID[6][1] = false
    end

    if (Item_Slot_Select_ID[1][1] == true) then
        Selected_Slot_Select_ID[1] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[1], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[1][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[1] = MessageBox(
            {
                title = "Wheel Gobo1",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[1].states) do
            if (v == true) then
                G_Check[1] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[1][c] = k
                Printf("Gobo1 State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end
    if (Item_Slot_Select_ID[2][1] == true) then
        Selected_Slot_Select_ID[2] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[2], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[2][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[2] = MessageBox(
            {
                title = "Wheel Gobo2",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[2].states) do
            if (v == true) then
                G_Check[2] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[2][c] = k
                Printf("Gobo2 State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end
    if (Item_Slot_Select_ID[3][1] == true) then
        Selected_Slot_Select_ID[3] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[3], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[3][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[3] = MessageBox(
            {
                title = "Wheel Gobo3",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[3].states) do
            if (v == true) then
                G_Check[3] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[3][c] = k
                Printf("Gobo3 State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end
    if (Item_Slot_Select_ID[4][1] == true) then
        Selected_Slot_Select_ID[4] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[4], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[4][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[4] = MessageBox(
            {
                title = "Wheel EFFECTWHEEL",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[4].states) do
            if (v == true) then
                G_Check[4] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[4][c] = k
                Printf("EFFECTWHEEL State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end
    if (Item_Slot_Select_ID[5][1] == true) then
        Selected_Slot_Select_ID[5] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[5], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[5][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[5] = MessageBox(
            {
                title = "Wheel Prism1",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[5].states) do
            if (v == true) then
                G_Check[5] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[5][c] = k
                Printf("Prism1 State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end
    if (Item_Slot_Select_ID[6][1] == true) then
        Selected_Slot_Select_ID[6] = {}
        local Item_List = {}
        local a = 1
        local c = 1
        for i = 2, slot_index[6], 1 do
            Item_List[a] = { name = Item_Slot_Select_ID[6][i], state = false }
            a = a + 1
        end
        Slot_Select_ID[6] = MessageBox(
            {
                title = "Wheel Prism2",
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                states = Item_List,
                icon = "object_plugin1",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text"
            }
        )
        for k, v in pairs(Slot_Select_ID[6].states) do
            if (v == true) then
                G_Check[6] = true
                k = string.sub(k, 4, -1)
                Selected_Slot_Select_ID[6][c] = k
                Printf("Prism2 State '%s' = '%s'", k, tostring(v))
                c = c + 1
            end
        end
    end


    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if Fixture has gobo1
        Index[1] = FirstPreset - 1
        Preset_Name[1], PresetIndex, Slot_ID[1] = CreateLabelPresets("Gobo1", Fixture, FirstPreset,
            Selected_Slot_Select_ID[1])
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then -- check if Fixture has gobo2
        Index[2] = PresetIndex - 1
        Preset_Name[2], PresetIndex, Slot_ID[2] = CreateLabelPresets("Gobo2", Fixture, PresetIndex,
            Selected_Slot_Select_ID[2])
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo3')) ~= nil then -- check if Fixture has gobo3
        Index[3] = PresetIndex - 1
        Preset_Name[3], PresetIndex, Slot_ID[3] = CreateLabelPresets("Gobo3", Fixture, PresetIndex,
            Selected_Slot_Select_ID[3])
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if Fixture has EFFECTWHEEL
        Index[4] = PresetIndex - 1
        Preset_Name[4], PresetIndex, Slot_ID[4] = CreateLabelPresets("EFFECTWHEEL", Fixture, PresetIndex,
            Selected_Slot_Select_ID[4])
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) ~= nil then -- check if Fixture has Prism1
        Index[5] = PresetIndex - 1
        Preset_Name[5], PresetIndex, Slot_ID[5] = CreateLabelPresets("Prism1", Fixture, PresetIndex,
            Selected_Slot_Select_ID[5])
    end
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) ~= nil then -- check if Fixture has Prism2
        Index[6] = PresetIndex - 1
        Preset_Name[6], PresetIndex, Slot_ID[6] = CreateLabelPresets("Prism2", Fixture, PresetIndex,
            Selected_Slot_Select_ID[6])
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
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) then -- check if Fixture has EFFECTWHEEL
        AppIndex[4] = AppNr - 1
        AppNr = createAppearances(FixtureType, "EFFECTWHEEL", AppNr)
    end
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism1')) then -- check if Fixture has Prism1
        AppIndex[5] = AppNr - 1
        AppNr = createAppearances(FixtureType, "Prism1", AppNr)
    end
    CmdIndirectWait("clearall; Fixture " .. FixtureNum)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Prism2')) then -- check if Fixture has Prism2
        AppIndex[6] = AppNr - 1
        AppNr = createAppearances(FixtureType, "Prism2", AppNr)
    end
    CmdIndirectWait("cd root")

    CreateSequence(FixtureType, prefix, SeqNrStart, Preset_Name, FixtureGroupsNo, Slot_ID, Index, AppIndex)
    CmdIndirectWait("Blind Off")
end
return main
