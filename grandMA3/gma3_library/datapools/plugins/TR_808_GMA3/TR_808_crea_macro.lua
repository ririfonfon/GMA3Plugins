local function main()
    local inputs = {
        { name = " a macro Number",      value = "", whiteFilter = "0123456789" },
        { name = " b lay object Number", value = "", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 4, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd, subSel, lay_object
    local count, c, f = 1, 1, 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
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
        if f == 1 then
            lay_object = tonumber(v)
        elseif f == 2 then
            MacroNum = tonumber(v)
            MacroEnd = MacroNum + 11
        end
        f = f + 1
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if c == 1 then
            VariaSel = v
        elseif c == 2 then
            subSel = v
        end
        c = c + 1
    end


    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Select_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'Selection'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"SetUserVariable 'TR_Fonction' 1")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Sub' '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Pool' 41")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Value_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'Values'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"SetUserVariable 'TR_Fonction' 2")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Sub' '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Pool' 41")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_MAtricks_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'MAtricks'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"SetUserVariable 'TR_Fonction' 3")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Sub' '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Pool' 41")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Tag_Sub_#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] at #[Tag 'Selected_" .. varia_mag[VariaSel] .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_mute_#" ..
            subSel .. "'] at #[Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_solo_#" ..
            subSel .. "'] at #[Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "']")
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Off_Tag_Sub_#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] at #[Tag 'Selected_" .. varia_mag[VariaSel] .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_mute_#" ..
            subSel .. "'] at #[Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_solo_#" ..
            subSel .. "'] at #[Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "']")
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 4

    CmdIndirect('Store DataPool 41 Macro ' .. MacroNum .. ' \'' .. varia_min[VariaSel] .. '_edit_fade_TR_INPUT')
    CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. MacroNum .. '')
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'FadeFromX'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 2 Command=\"Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'FadeToX'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Fonction' 1")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Pool' 'TR_808_GMA3'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Edit_Tag']")

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1
    lay_object = lay_object + 13

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'Fade_' .. varia_mag[VariaSel] .. '_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'FadeFromX'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'FadeToX'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Fonction' 5")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Sub' '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"SetUserVariable 'TR_Pool' 41")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 7 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 4

    CmdIndirect('Store DataPool 41 Macro ' .. MacroNum .. ' \'' .. varia_min[VariaSel] .. '_edit_delay_TR_INPUT')
    CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. MacroNum .. '')
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'DelayFromX'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 2 Command=\"Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'DelayToX'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Fonction' 2")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Pool' 'TR_808_GMA3'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
    CmdIndirectWait('Insert')
    CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Edit_Tag']")


    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'Delay_' .. varia_mag[VariaSel] .. '_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'DelayFromX'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" ..
            subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'DelayToX'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"SetUserVariable 'TR_Fonction' 6")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"SetUserVariable 'TR_Sub' '" .. varia_mag[VariaSel] .. "_SUB_#" .. subSel .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"SetUserVariable 'TR_Pool' 41")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 7 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 4

    CmdIndirect('Store DataPool 41 Macro ' .. MacroNum .. ' \'' .. varia_min[VariaSel] .. '_SOLO')
    CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. MacroNum .. '')
    for j = 1, 12, 1 do
        CmdIndirectWait('Insert')
        CmdIndirectWait("set " .. j .. " Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_mag[VariaSel] .. "_SUB_#" .. j .. "'] Cue 1 Thru 16 Part 0.1 Property 'Enabled' 0")
    end


    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Rec_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        for j = 1, 16, 1 do
            CmdIndirectWait('Insert')
            CmdIndirectWait("set " .. j .. " Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
                varia_mag[VariaSel] .. "_SUB_#" ..
                subSel .. "'] Cue " .. j .. " Part 0.1 Property 'Enabled' 0")
            CmdIndirectWait("set " .. j .. " Enabled=0")
        end
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 4

    CmdIndirect('Store DataPool 41 Macro ' .. MacroNum .. ' \'' .. varia_min[VariaSel] .. '_NO_SOLO')
    CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. MacroNum .. '')
    for j = 1, 12, 1 do
        CmdIndirectWait('Insert')
        CmdIndirectWait("set " .. j .. " Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Rec_Sub#" .. j .. "']")
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_On_Solo_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"SetUserVariable '" .. varia_mag[VariaSel] .. "_TR_PLUS' 1")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']." .. count .. " 'Enabled' 0")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Rec_Sub#" .. count .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        lay_object = lay_object + 1
        count = count + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Off_Solo_Sub#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"SetUserVariable '" .. varia_mag[VariaSel] .. "_TR_MOINS' 1")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']." .. count .. " 'Enabled' 1")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        lay_object = lay_object + 1
        count = count + 1
    end


    CmdIndirectWait('ChangeDestination Root')
end

return main
