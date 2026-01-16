local function main()
    local inputs = {
        { name = " a macro Number", value = "", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 4, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 }, type = 1 },
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
            MacroNum = tonumber(v)
        end
        f = f + 1
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if c == 1 then
            VariaSel = v
        end
        c = c + 1
    end
    MacroEnd = MacroNum + (8 - VariaSel)


    for i = MacroNum, MacroEnd, 1 do
        CmdIndirect('Store DataPool 41 Macro ' .. i .. ' \'all_sub_varia_' .. varia_min[VariaSel])
        CmdIndirectWait('ChangeDestination DataPool 41 Macro ' .. i .. '')
        CmdIndirectWait('Insert')
        CmdIndirectWait("set 1 Command=\"Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'Clear_sub']")
        for a = 2, 13 do
            CmdIndirectWait('Insert')
            CmdIndirectWait("set " ..
                a .. " Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'all_sub_#" .. count .. "']." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        for a = 14, 25 do
            CmdIndirectWait('Insert')
            CmdIndirectWait("set " ..
                a .. " Command=\"Set #[DataPool 'TR_808_GMA3'.'Macros'.'none_sub_#" .. count .. "']." ..
                VariaSel .. " 'Enabled' 1")
            count = count + 1
        end
        count = 1
        VariaSel = VariaSel + 1
    end
    CmdIndirectWait('ChangeDestination Root')
end

return main
