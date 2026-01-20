local function main()
    local inputs = {
        { name = " a macro Number", value = "", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd, lay_object
    local subSel = 1
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
        MacroNum = tonumber(v)
        MacroEnd = MacroNum + 11
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if c == 1 then
            subSel = v
        elseif c == 2 then
            VariaSel = tonumber(v)
        end
        c = c + 1
    end
    Printf("VariaSel: %d", VariaSel)

    -- local i = MacroNum
    CmdIndirectWait('Delete DataPool 41 Macro ' .. MacroNum .. ' Thru ' .. MacroEnd ..'')
    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_On_Solo_Sub_#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'plus'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']." .. count .. " 'Enabled' 0")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 6 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        count = count + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1
    count = 1

    CmdIndirectWait('Delete DataPool 41 Macro ' .. MacroNum .. ' Thru ' .. MacroEnd ..'')
    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'' .. varia_min[VariaSel] .. '_Off_Solo_Sub_#' .. subSel)
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 2 Command=\"SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'minus'")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 3 Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']." .. count .. " 'Enabled' 1")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 4 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO']")
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 5 Command=\"Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        count = count + 1
    end

    CmdIndirectWait('ChangeDestination Root')
end

return main
