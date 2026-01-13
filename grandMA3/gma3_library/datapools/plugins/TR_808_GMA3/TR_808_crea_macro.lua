local function main()
    local inputs = {
        { name = "Sequence Number", value = "", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 4, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd, subSel
    local count, c = 1, 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "set btn sequence number    ",
                message = "Please enter the sequence number to set.",
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
        MacroNum = tonumber(v)
        MacroEnd = MacroNum + 11
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


    for e = 1, 12, 1 do
        for i = MacroNum, MacroEnd, 1 do
            CmdIndirect('Store DataPool 41 Macro ' .. MacroNum .. ' \'' .. varia_min[VariaSel] .. '_Select_Sub#' .. subSel )
            CmdIndirectWait("Set DataPool 41 Sequence " ..
                i ..
                " Cue 1 Property Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
                varia_mag[VariaSel]
                ..
                "_SUB_#" ..
                subSel ..
                "'] Cue " .. count .. " Part 0.1 Property 'Enabled' 1; Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
                varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "']." .. count .. " 'Enabled' 1")
            CmdIndirectWait("Set DataPool 41 Sequence " ..
                i ..
                " Cue 2 Property Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
                varia_mag[VariaSel]
                ..
                "_SUB_#" ..
                subSel ..
                "'] Cue " .. count .. " Part 0.1 Property 'Enabled' 0; Set #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
                varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "']." .. count .. " 'Enabled' 0")
            count = count + 1
        end
        MacroNum = MacroEnd + 6
        MacroEnd = MacroNum + 11
        count = 1
        subSel = subSel + 1
    end
end

return main
