local E = Echo

local function main()
    -- create inputs:
    local states = {
        {name = "State A", state = false},
        {name = "State B", state = false},
        {name = "State C", state = false},
        {name = "State D", state = false},
        {name = "State E", state = false},
        {name = "State F", state = false},
        {name = "State G", state = false},
        -- {name = "State D", state = false, group = 2},
    }
    local inputs = {
        {name = "Numbers Only", value = "1234", whiteFilter = "0123456789"},
        {name = "Text Only", value = "TextOnly", blackFilter = "0123456789"},
        {name = "Maximum 10 characters", value = "abcdef", maxTextLength = 10}
    }
    local selectors = {
        { name="Swipe Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=0},
        { name="Radio Selector", selectedValue=2, values={["Test"]=1,["Test2"]=2}, type=1}
    }

    for k in ipairs(states) do
        E(states[k].name)
    end

    -- open messagebox:
    local resultTable =
        MessageBox(
        {
            title = "Messagebox example 2",
            message = "This is a message",
            message_align_h = Enums.AlignmentH.Left,
            message_align_v = Enums.AlignmentV.Top,
            commands = {{value = 1, name = "Ok"}, {value = 0, name = "Cancel"}},
            states = states,
            inputs = inputs,
            selectors = selectors,
            backColor = "Global.Default",
            icon = "logo_small",
            titleTextColor = "Global.AlertText",
            messageTextColor = "Global.Text"
        }
    )

    -- print results:
    Printf("Success = "..tostring(resultTable.success))
    Printf("Result = "..resultTable.result)
    for k,v in pairs(resultTable.inputs) do
        Printf("Input '%s' = '%s'",k,v)
    end
    for k,v in pairs(resultTable.states) do
        Printf("State '%s' = '%s'",k,tostring(v))
    end
    for k,v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'",k,v)
    end
end

return main