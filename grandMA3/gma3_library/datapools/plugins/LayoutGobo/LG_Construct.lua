--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", April 2024.
--]]

function Construct_Gobo_Layout(displayHandle, TLay, SeqNrStart, TLayNr, AppNr, Preset_5_Current, Preset_5_NrStart,
                               SelectedGrp, SelectedGrpNo, TLayNrRef, NaLay, MaxGobLgn)
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
                            local G_Check = { false, false, false, false }
                        
                            CmdIndirectWait("Blind On")
                            CmdIndirectWait("clearall; Fixture " .. FixtureNum)
                            if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then -- check if Fixture has gobo1
                                Printf('Gob')
                                Item_Slot_Select_ID[1] = {}
                                Item_Slot_Select_ID[1][1] = true
                                Item_Slot_Select_ID[1], slot_index[1] = List_SlotID('Gobo1', Fixture, Item_Slot_Select_ID, 1)
                            else
                                Printf('NoGob')
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
                            if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if Fixture has gobo3
                                Item_Slot_Select_ID[4] = {}
                                Item_Slot_Select_ID[4][1] = true
                                Item_Slot_Select_ID[4], slot_index[4] = List_SlotID('EFFECTWHEEL', Fixture, Item_Slot_Select_ID, 4)
                            else
                                Item_Slot_Select_ID[4] = {}
                                Item_Slot_Select_ID[4][1] = false
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
                            if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('EFFECTWHEEL')) ~= nil then -- check if Fixture has gobo3
                                Index[4] = PresetIndex - 1
                                Preset_Name[4], PresetIndex, Slot_ID[4] = CreateLabelPresets("EFFECTWHEEL", Fixture, PresetIndex,
                                    Selected_Slot_Select_ID[4])
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
                        
                            CreateSequence(FixtureType, prefix, SeqNrStart, Preset_Name, FixtureGroupsNo, Slot_ID, Index, AppIndex)
                            CmdIndirectWait("Blind Off")
end -- end Construct_Gobo_Layout

-- end LG_Construct.lua
