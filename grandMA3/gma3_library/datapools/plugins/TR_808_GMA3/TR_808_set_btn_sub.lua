local function main()
    local inputs = {
        { name = "Sequence Number", value = "", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 6, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local SeqNum, VariaSel, SeqEnd, subSel
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
        -- Printf("Input '%s' = '%s'", k, v)
        SeqNum = tonumber(v)
        SeqEnd = SeqNum + 15
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

    -- Printf("SeqNum: %d", SeqNum)
    -- Printf("varia_min[VariaSel]: %s", varia_min[VariaSel])
    -- Printf("varia_mag[VariaSel]: %s", varia_mag[VariaSel])
    for e = 1, 12, 1 do
        -- Printf("count: %d", count)
        for i = SeqNum, SeqEnd, 1 do
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
        SeqNum = SeqEnd + 2
        SeqEnd = SeqNum + 15
        count = 1
        subSel = subSel + 1
    end
end

return main
-- Set #[DataPool 'TR_808_GMA3'.'Sequences'.'A_SUB_#1'] Cue 1 Part 0.1 Property "Enabled" 1
-- ; Set #[DataPool 'TR_808_GMA3'.'Macros'.'a_Rec_Sub_#1'].1 "Enabled" 1
-- Set #[DataPool 'TR_808_GMA3'.'Sequences'.C_SUB_#1] Cue 1 Part 0.1 Property 'Enabled' 1
