local function main()
    local selectors = {
        { name = "Varia Selector", selectedValue = 6, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local SeqNum, VariaSel, SeqEnd, subSel, target_pool
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local varia_place = { 55, 346, 637, 928, 1219, 1510, 1801, 2092 }
    local seq_btn = { 766, 987, 1208, 1429, 1650, 1871, 2092, 2313 }
    local seq_mute = { 69, 137, 205, 273, 341, 409, 477, 545 }
    local seq_solo = { 86, 154, 222, 290, 358, 426, 494, 562 }
    local macro_sel_sub = { 89, 276, 463, 650, 837, 1024, 1211, 1398 }
    local macro_value = { 106, 293, 480, 667, 854, 1041, 1228, 1415 }
    local macro_matrick = { 123, 310, 497, 684, 871, 1058, 1245, 1432 }
    local seq_select_l = { 103, 171, 239, 307, 375, 443, 511, 579 }
    local macro_fade = { 174, 361, 548, 735, 922, 1109, 1296, 1483 }
    local macro_delay = { 191, 378, 565, 752, 939, 1126, 1313, 1500 }
    local macro_e_fade = { 172, 359, 546, 733, 920, 1107, 1294, 1481 }
    local macro_e_delay = { 189, 376, 563, 750, 937, 1124, 1311, 1498 }
    local tag = { 69, 84, 99, 114, 129, 144, 159, 174 }

    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "Change Varia Layout ",
                message = "Please enter the sequence number to set.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                selectors = selectors,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        elseif k == "Sub Selector" then
            subSel = v
        end
    end

    -- btn_sub_seq
    SeqNum = seq_btn[subSel]
    SeqEnd = SeqNum + 15

    for e = 1, 12, 1 do
        for i = SeqNum, SeqEnd, 1 do
            CmdIndirectWait("Assign DataPool 41 Sequence " ..
                i .. " At Tag '" .. varia_min[VariaSel] .. "_btn_sub_#" .. count .. "'")
        end
        count = count + 1
        SeqNum = SeqEnd + 2
        SeqEnd = SeqNum + 15
    end
end

return main
