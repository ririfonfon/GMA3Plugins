local E = Echo
local Maf = math.floor

local function main()

    local root = Root();
    local FixtureGroups = root.ShowData.DataPools.Default.Groups:Children()

    local SelectedGrp = {}
    local SelectedGrpNo = {}

    local result_nr = {}
    local group_number

    local N_FG
    for k in ipairs(FixtureGroups) do
    N_FG = tonumber(FixtureGroups[k].NO)
    end
    local N_digit = 1
    if N_FG > 1000 then
        N_digit = 4
    elseif N_FG > 100 then
        N_digit = 3
    elseif N_FG > 10 then
        N_digit =2
    end

    local states = {}
    local TGrpChoise = {}
    for k in ipairs(FixtureGroups) do
        if N_digit == 1 then
            TGrpChoise[k] = {["name"] =  FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
            table.insert(states, TGrpChoise[k])
        elseif N_digit == 2 then
            if Maf(FixtureGroups[k].NO) < 10 then
                TGrpChoise[k] = {["name"] = '0' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k]) 
            elseif Maf(FixtureGroups[k].NO) >9 then
                TGrpChoise[k] = {["name"] =  FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])   
            end
        elseif N_digit == 3 then
            if Maf(FixtureGroups[k].NO) < 10 then
                TGrpChoise[k] = {["name"] = '00' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])
            elseif Maf(FixtureGroups[k].NO) >9 and Maf(FixtureGroups[k].NO) <100 then
                TGrpChoise[k] = {["name"] = '0' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])
            elseif Maf(FixtureGroups[k].NO) > 99 and Maf(FixtureGroups[k].NO) < 1000 then
                TGrpChoise[k] = {["name"] =  FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])                 
            end
        elseif N_digit == 4 then
            if Maf(FixtureGroups[k].NO) < 10 then
                TGrpChoise[k] = {["name"] = '000' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])
            elseif Maf(FixtureGroups[k].NO) > 9 and Maf(FixtureGroups[k].NO) < 100 then
                TGrpChoise[k] = {["name"] = '00' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])               
            elseif Maf(FixtureGroups[k].NO) > 99 and Maf(FixtureGroups[k].NO) < 1000 then
                TGrpChoise[k] = {["name"] = '0' .. FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])
            elseif Maf(FixtureGroups[k].NO) > 999 then
                TGrpChoise[k] = {["name"] =  FixtureGroups[k].NO .. ' ' .. FixtureGroups[k].name  , ["state"] = false}
                table.insert(states, TGrpChoise[k])   
            end
        end
    end

    -- open messagebox:
    local resultTable =
        MessageBox(
        {
            title = "Messagebox example 2",
            -- message = "This is a message",
            -- message_align_h = Enums.AlignmentH.Left,
            -- message_align_v = Enums.AlignmentV.Top,
            commands = {{value = 1, name = "Ok"}, {value = 0, name = "Cancel"}},
            states = states,
            backColor = "Global.Default",
            icon = "logo_small",
            titleTextColor = "Global.AlertText",
            messageTextColor = "Global.Text"
        }
    )

    -- print results:
    Printf("Success = "..tostring(resultTable.success))
    Printf("Result = "..resultTable.result)
    for k,v in pairs(resultTable.states) do
        if v then
            E(k)
            group_number = string.sub(k, 1, N_digit)
            group_number = tonumber(group_number)
            E(group_number)
            table.insert(result_nr, group_number) 
        end    
    end
    
    table.sort(result_nr, function(a,b) return a<b end)
    E("******** in order *************")
    for i,v in ipairs(result_nr) do
        E("result '%i'",v)
        for k in ipairs(FixtureGroups) do
            if FixtureGroups[k].NO == v then
                E(FixtureGroups[k].NO)
                table.insert(SelectedGrp, FixtureGroups[k].name)
                table.insert(SelectedGrpNo, FixtureGroups[k].NO)
            end
        end
    end

    E("****** check tables ***********")
    for k,v in ipairs(SelectedGrpNo) do
        E(v)
    end

    for k,v in pairs(SelectedGrp) do
        E(v)
    end
end

return main