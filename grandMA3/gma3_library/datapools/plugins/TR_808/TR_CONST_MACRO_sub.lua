local thiscomponent = select(4, ...)

local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used : ' .. id) end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

local function main()
    local inputs        = {
        { name = "macro Number", value = "106", whiteFilter = "0123456789" },
    }
    local selectors     = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd, subSel, lay_object
    local count         = 1
    local varia_min     = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag     = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }

    local seq_btn       = { 55, 346, 637, 928, 1219, 1510, 1801, 2092 }
    local seq_mute      = { 247, 538, 829, 1120, 1411, 1702, 1993, 2284 }
    local seq_solo      = { 259, 550, 841, 1132, 1423, 1714, 2005, 2296 }
    local macro_sel_sub = { 271, 562, 853, 1144, 1435, 1726, 2017, 2308 }
    local macro_value   = { 283, 574, 865, 1156, 1447, 1738, 2029, 2320 }
    local macro_matrick = { 295, 586, 877, 1168, 1459, 1750, 2041, 2332 }
    local seq_select_l  = { 307, 598, 889, 1180, 1471, 1762, 2053, 2344 }
    local macro_fade    = { 320, 611, 902, 1193, 1484, 1775, 2066, 2357 }
    local macro_delay   = { 332, 623, 914, 1205, 1496, 1787, 2078, 2369 }
    local macro_e_fade  = { 344, 635, 926, 1217, 1508, 1799, 2090, 2381 }
    local macro_e_delay = { 345, 636, 927, 1218, 1509, 1800, 2091, 2382 }

    -- open messagebox:
    local resultTable   =
        MessageBox(
            {
                title = "create macro for TR-808",
                message = "Please enter the macro number.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                inputs = inputs,
                selectors = selectors,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    -- print results:

    for k, v in pairs(resultTable.inputs) do
        Printf("Input '%s' = '%s'", k, v)
        if k == "lay object Number" then
            lay_object = tonumber(v)
        elseif k == "macro Number" then
            MacroNum = tonumber(v)
            MacroEnd = MacroNum + 11
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        elseif k == "Sub Selector" then
            subSel = v
        end
    end

    local Construct_Pool = 43
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]
    local Call_Pool = thiscomponent:FindParent(DataPool():GetClass())
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros

    for b = 1, 8 do
        lay_object = tonumber(macro_sel_sub[VariaSel])
        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Select_Sub_#' .. subSel)
            for a = 1, 6 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'Selection'")
            MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 1")
            MacroObject[i][3]:Set('Command',
                "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
            MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
            MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[i][6]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Retour_Recipie'")
            subSel = subSel + 1
            lay_object = lay_object + 1
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        lay_object = tonumber(macro_value[VariaSel])
        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Value_Sub_#' .. subSel)
            for a = 1, 6 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'Values'")
            MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 2")
            MacroObject[i][3]:Set('Command',
                "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
            MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
            MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[i][6]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Retour_Recipie'")
            subSel = subSel + 1
            lay_object = lay_object + 1
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        lay_object = tonumber(macro_matrick[VariaSel])
        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_MAtricks_Sub_#' .. subSel)
            for a = 1, 6 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'MAtricks'")
            MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 3")
            MacroObject[i][3]:Set('Command',
                "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
            MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
            MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[i][6]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Retour_Recipie'")
            subSel = subSel + 1
            lay_object = lay_object + 1
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Tag_Sub_#' .. subSel)
            for a = 1, 3 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command',
                "Assign DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' at Tag 'Selected_" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][2]:Set('Command',
                "Assign DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_btn_mute_#" .. subSel .. "' at Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][3]:Set('Command',
                "Assign DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_btn_solo_#" .. subSel .. "' at Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
            subSel = subSel + 1
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Off_Tag_Sub_#' .. subSel)
            for a = 1, 3 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command',
                "Assign Off DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' at Tag 'Selected_" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][2]:Set('Command',
                "Assign Off DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_btn_mute_#" .. subSel .. "' at Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][3]:Set('Command',
                "Assign Off DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_btn_solo_#" .. subSel .. "' at Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "'")
            subSel = subSel + 1
        end

        MacroNum = MacroEnd + 4

        Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_edit_fade_TR_INPUT')
        for a = 1, 6 do
            MacroObject[MacroNum]:Insert(a)
        end
        MacroObject[MacroNum][1]:Set('Command',
            "Edit DataPool '" .. Build_Pool.Name .. "'.'MAtricks'.'TR_INPUT' Property 'FadeFromX'")
        MacroObject[MacroNum][2]:Set('Command',
            "Edit DataPool '" .. Build_Pool.Name .. "'.'MAtricks'.'TR_INPUT' Property 'FadeToX'")
        MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'TR_Fonction' 1")
        MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
        MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
        MacroObject[MacroNum][6]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Edit_Tag'")

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        lay_object = tonumber(macro_fade[VariaSel])
        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Fade_Sub_#' .. subSel)
            for a = 1, 7 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'FadeFromX'")
            MacroObject[i][2]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'FadeToX'")
            MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Fonction' 5")
            MacroObject[i][4]:Set('Command',
                "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
            MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
            MacroObject[i][6]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[i][7]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Retour_Recipie'")
            subSel = subSel + 1
            lay_object = lay_object + 1
        end

        MacroNum = MacroEnd + 4

        Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_edit_delay_TR_INPUT')
        for a = 1, 6 do
            MacroObject[MacroNum]:Insert(a)
        end
        MacroObject[MacroNum][1]:Set('Command',
            "Edit DataPool '" .. Build_Pool.Name .. "'.'MAtricks'.'TR_INPUT' Property 'DelayFromX'")
        MacroObject[MacroNum][2]:Set('Command',
            "Edit DataPool '" .. Build_Pool.Name .. "'.'MAtricks'.'TR_INPUT' Property 'DelayToX'")
        MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'TR_Fonction' 2")
        MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
        MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
        MacroObject[MacroNum][6]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Edit_Tag'")

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        lay_object = tonumber(macro_delay[VariaSel])
        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Delay_Sub_#' .. subSel)
            for a = 1, 7 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'DelayFromX'")
            MacroObject[i][2]:Set('Command', "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue 1 Thru 16 Part 0.1 Property 'DelayToX'")
            MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Fonction' 6")
            MacroObject[i][4]:Set('Command',
                "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
            MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
            MacroObject[i][6]:Set('Command', "SetUserVariable 'TR_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[i][7]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_Retour_Recipie'")
            subSel = subSel + 1
            lay_object = lay_object + 1
        end

        MacroNum = MacroEnd + 4

        Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_SOLO')
        for j = 1, 12, 1 do
            MacroObject[MacroNum]:Insert(j)
            MacroObject[MacroNum][j]:Set('Command',
                "Set DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                varia_min[VariaSel] .. "_Sub_#" .. j .. "' Cue 1 Thru 16 Part 0.1 Property 'Enabled' 0")
        end


        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Rec_Sub_#' .. subSel)
            for j = 1, 16, 1 do
                MacroObject[i]:Insert(j)
                MacroObject[i][j]:Set('Command',
                    "Set DataPool '" .. Build_Pool.Name .. "' Sequence '" ..
                    varia_min[VariaSel] .. "_Sub_#" ..
                    subSel .. "' Cue " .. j .. " Part 0.1 Property 'Enabled' 0")
                MacroObject[i][j]:Set('Enabled', 0)
            end
            subSel = subSel + 1
        end

        MacroNum = MacroEnd + 4

        Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_NO_SOLO')

        for j = 1, 12, 1 do
            MacroObject[MacroNum]:Insert(j)
            MacroObject[MacroNum][j]:Set('Command',
                "Go+ DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_Rec_Sub#" .. j .. "'")
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1

        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_On_Solo_Sub_#' .. subSel)
            for a = 1, 6 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][2]:Set('Command', "SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'plus'")
            MacroObject[i][3]:Set('Command', "Set DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_SOLO'." .. count .. " 'Enabled' 0")
            MacroObject[i][4]:Set('Command', "Go+ DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_SOLO'")
            MacroObject[i][5]:Set('Command', "Go+ DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "'")
            MacroObject[i][6]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_CHECK_SOLO'")
            subSel = subSel + 1
            count = count + 1
        end

        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        subSel = 1
        count = 1

        for i = MacroNum, MacroEnd, 1 do
            Check_Size_Pool(i, MacroObject)
            MacroObject:Create(i)
            MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Off_Solo_Sub_#' .. subSel)
            for a = 1, 5 do
                MacroObject[i]:Insert(a)
            end
            MacroObject[i][1]:Set('Command', "SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
            MacroObject[i][2]:Set('Command', "SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'minus'")
            MacroObject[i][3]:Set('Command', "Set DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_SOLO'." .. count .. " 'Enabled' 1")
            MacroObject[i][4]:Set('Command', "Go+ DataPool '" .. Build_Pool.Name .. "' Macro '" ..
                varia_min[VariaSel] .. "_SOLO'")
            MacroObject[i][5]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808_CHECK_SOLO'")
            subSel = subSel + 1
            count = count + 1
        end
        VariaSel = VariaSel + 1
        MacroNum = MacroEnd + 23
        MacroEnd = MacroNum + 11
        subSel = 1
        count = 1
    end
end

return main
