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
                -- selectors = selectors,
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
        SeqEnd = SeqNum + 11
    end
    -- for k, v in pairs(resultTable.selectors) do
    --     Printf("Selector '%s' = '%d'", k, v)
    --     if c == 1 then
    --         VariaSel = v
    --     elseif c == 2 then
    --         subSel = v
    --     end
    --     c = c + 1
    -- end

    -- Printf("count: %d", count)
    for i = SeqNum, SeqEnd, 1 do
        CmdIndirectWait("Set DataPool 41.6." .. i .. " Property 'Appearance' 320")
    end

    SeqNum = SeqEnd + 6
    SeqEnd = SeqNum + 11

    for i = SeqNum, SeqEnd, 1 do
        CmdIndirectWait("Set DataPool 41.6." .. i .. " Property 'Appearance' 318")
    end

    SeqNum = SeqEnd + 6
    SeqEnd = SeqNum + 11

    for i = SeqNum, SeqEnd, 1 do
        CmdIndirectWait("Set DataPool 41.6." .. i .. " Property 'Appearance' 321")
    end

    SeqNum = SeqEnd + 2

    CmdIndirectWait("Set DataPool 41.6." .. SeqNum .. " Property 'Appearance' 321")
end

return main
