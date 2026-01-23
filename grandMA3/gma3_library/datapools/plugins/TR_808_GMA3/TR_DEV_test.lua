local function main()
    local inputs = {
        { name = "macro Number",    value = "85", whiteFilter = "0123456789" },
        { name = "DataPool Number", value = "41", whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 }, type = 1 },
    }

    local MacroNum, VariaSel, MacroEnd, subSel, lay_object, DataPoolNum
    local count = 1
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
        if k == "macro Number" then
            MacroNum = tonumber(v)
        elseif k == "DataPool Number" then
            DataPoolNum = tonumber(v)
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        end
    end
    local MacroObject = Root().ShowData.DataPools[DataPoolNum].Macros
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'test_varia_' .. varia_min[VariaSel])
    for i = 1, 8 do
        MacroObject[MacroNum]:Insert (i)
        MacroObject[MacroNum][i]:Set('Command',
            "Set #[DataPool 'TR_808_GMA3'.'Macros'.'test_varia_" ..
            varia_min[VariaSel] .. "']." .. i .. " 'Enabled' 1")
    end

    Printf("Macro %d created in DataPool %d", MacroNum, DataPoolNum)
end

return main

-- GetObject('Macro 85.1').Command = 'SetUservariable "A_TR_Solo" +1$A_TR_Solo'
