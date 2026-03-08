--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local thiscomponent = select(4, ...)

function Build_Macro_Sub(Construct_Pool)

    local MacroNum = 106
    local MacroEnd = MacroNum + 11
    local VariaSel = 1
    local subSel = 1
    local lay_object
    local count         = 1
    local varia_min     = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag     = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local macro_sel_sub = { 271, 562, 853, 1144, 1435, 1726, 2017, 2308 }
    local macro_value   = { 283, 574, 865, 1156, 1447, 1738, 2029, 2320 }
    local macro_matrick = { 295, 586, 877, 1168, 1459, 1750, 2041, 2332 }
    local macro_fade    = { 320, 611, 902, 1193, 1484, 1775, 2066, 2357 }
    local macro_delay   = { 332, 623, 914, 1205, 1496, 1787, 2078, 2369 }

    -- local Construct_Pool = 43
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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
            "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")

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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
            "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")

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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'TR_808'")
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