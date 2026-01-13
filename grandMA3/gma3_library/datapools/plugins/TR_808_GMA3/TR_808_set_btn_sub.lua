local function main()
    local inputs = {
        { name = "Sequence Number", value = "1224", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Radio Selector", selectedValue = 3, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 }, type = 1 }
    }

    local SeqNum, radioSel
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
        Printf("Input '%s' = '%s'", k, v)
        SeqNum = tonumber(v)
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        radioSel = v
    end

    Printf("SeqNum: %d", SeqNum)
    Printf("varia_min[radioSel]: %s", varia_min[radioSel])
    Printf("varia_mag[radioSel]: %s", varia_mag[radioSel])

    CmdIndirectWait("Set DataPool 41 Sequence " ..
    SeqNum ..
    " Cue 1 Property Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
    varia_mag[radioSel] 
    .. "_SUB_#1'] Cue 1 Part 0.1 Property 'Enabled' 1; Set #[DataPool 'TR_808_GMA3'.'Macros'.'" .. 
    varia_min[radioSel] .."_Rec_Sub_#1'].1 'Enabled' 1")
    CmdIndirectWait("Set DataPool 41 Sequence " ..
    SeqNum ..
    " Cue 2 Property Command=\"Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
    varia_mag[radioSel] 
    .. "_SUB_#1'] Cue 1 Part 0.1 Property 'Enabled' 0; Set #[DataPool 'TR_808_GMA3'.'Macros'.'" .. 
    varia_min[radioSel] .."_Rec_Sub_#1'].1 'Enabled' 0")
end

return main
-- Set #[DataPool 'TR_808_GMA3'.'Sequences'.'A_SUB_#1'] Cue 1 Part 0.1 Property "Enabled" 1
-- ; Set #[DataPool 'TR_808_GMA3'.'Macros'.'a_Rec_Sub_#1'].1 "Enabled" 1
-- Set #[DataPool 'TR_808_GMA3'.'Sequences'.C_SUB_#1] Cue 1 Part 0.1 Property 'Enabled' 1