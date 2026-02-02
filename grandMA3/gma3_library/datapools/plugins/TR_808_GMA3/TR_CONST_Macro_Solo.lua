local function main()
    local inputs = {
        { name = "Macro Number",    value = "",   whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd
    local subSel = 1
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
        if k == "Macro Number" then
            MacroNum = tonumber(v)
            MacroEnd = MacroNum + 11
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Sub Selector" then
            subSel = tonumber(v)
        elseif k == "Varia Selector" then
            VariaSel = tonumber(v)
        end
    end
    local Construct_Pool = 43
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools


    for i = MacroNum, MacroEnd, 1 do
        MacroObject:Delete(i)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', '' .. varia_min[VariaSel] .. '_On_Solo_Sub_#' .. subSel)
        for a = 1, 6 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command', "SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
        MacroObject[i][2]:Set('Command', "SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'plus'")
        MacroObject[i][3]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO'." .. count .. " 'Enabled' 0")
        MacroObject[i][4]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO'")
        MacroObject[i][5]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "'")
        MacroObject[i][6]:Set('Command', "Call DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Plugins'.'TR_808_CHECK_SOLO'")
        subSel = subSel + 1
        count = count + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1
    count = 1

    for i = MacroNum, MacroEnd, 1 do
        MacroObject:Delete(i)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', '' .. varia_min[VariaSel] .. '_Off_Solo_Sub_#' .. subSel)
        for a = 1, 5 do
            MacroObject[i]:Insert(a)
        end
        MacroObject[i][1]:Set('Command', "SetUserVariable 'Order' '" .. varia_mag[VariaSel] .. "'")
        MacroObject[i][2]:Set('Command', "SetUserVariable 'math_" .. varia_min[VariaSel] .. "' 'minus'")
        MacroObject[i][3]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO'." .. count .. " 'Enabled' 1")
        MacroObject[i][4]:Set('Command', "Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Macros'.'" ..
            varia_min[VariaSel] .. "_SOLO'")
        MacroObject[i][5]:Set('Command', "Call DataPool '" .. PoolObject[Construct_Pool].Name .. "'.'Plugins'.'TR_808_CHECK_SOLO'")
        subSel = subSel + 1
        count = count + 1
    end
end

return main
