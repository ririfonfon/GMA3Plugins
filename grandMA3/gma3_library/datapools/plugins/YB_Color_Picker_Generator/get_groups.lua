local c = Cmd
local ti = TextInput

local function get_groups_input_with_ranges(input,suggested,object_pool)
    local user_input = input
    local result
    local first, last
    local range = {}
    if user_input ~= suggested and user_input ~= nil then
        result = user_input:gsub('[Tthru]*',{['thru'] = '-', ['t'] = '-', ['Thru'] = '-'})
        if result:match('%d+%s+-%s+%d+') then
            first, last = result:match('(%d+)%s+-%s+(%d+)')
            first = tonumber(first)
            last = tonumber(last)
        elseif tonumber(user_input) ~= nil then
            first = tonumber(user_input:match('%D*(%d+).*'))
            last = tonumber(user_input:match('%D*(%d+).*'))
        else
            first = 'incorrect'
            last = 'incorrect'
        end
        -- local sum = last - first
        if first == 'incorrect' then
            Confirm('Incorrect input')
        elseif last >= first then
            if first ~= nil then
                while first <= last do
                    table.insert(range,first)
                    first = first + 1
                end
            end
        elseif last <= first then 
            if first ~= nil then
                while first >= last do
                    table.insert(range,first)
                    first = first - 1
                end
            end
        end
        if #range == 1 then
            result = range[1]
        else
            result = range
        end
    elseif user_input == nil then
        result = nil
    else
        result = user_input
    end
    if type(result) == 'table' then
        local amount_of_entries = #result
        local deleted
        local ind = 1
        local empty
        while ind <= amount_of_entries do
            if object_pool[result[ind]] ~= nil and #object_pool[result[ind]].selectiondata == 0 then
                empty = true
            end
            if object_pool[result[ind]] == nil then
                -- or #object_pool[result[ind]].selectiondata == 0
                table.remove(result,ind)
                deleted = true
                ind = ind
                amount_of_entries = #result
            else
                ind = ind + 1
            end
        end
        if deleted then
            Confirm('Non-existing group(s) detected in the range','Non-existing groups can\'t be referenced by recipes and will be removed. Existing but empty group object can be used.')
        end
        if empty then
            Confirm('Empty Group(s) in the range','Empty group can be filled afterwards as the plugin creates recepie references.')
        end
        -- for k,v in pairs(result) do
        --     Echo(k..' '..v)
        -- end
    end
    -- Echo(result)
    return result
end

function cp_get_groups(DP)
    local DONE = '[DONE]'
    local userInput
    local cp_groups = {}
    local gp_i = 1
    local last_line
    local groups_pool = ShowData().DataPools[DP].Groups
    repeat
        userInput = get_groups_input_with_ranges(ti('Enter group ID or range in format: X Thru Y', DONE),DONE,groups_pool)
        if userInput ~= '' and userInput ~= nil then
            -- Echo(groups_pool[tonumber(userInput)].name)
            -- Echo(#groups_pool[tonumber(userInput)].selectiondata)
            if userInput ~= DONE then
                if type(userInput) ~= 'table' and groups_pool[userInput] == nil then
                    Confirm('Group doen\'t exist','Non-existing group can\'t be referenced by recipes and will be removed. Existing but empty group object can be used.')
                elseif type(userInput) ~= 'table' then
                    table.insert(cp_groups,userInput)
                        if #cp_groups > 1 then
                            last_line = #cp_groups
                            local ind = 1
                            local deleted
                            repeat
                                if cp_groups[ind] == cp_groups[last_line] then
                                    table.remove(cp_groups,last_line)
                                    deleted = true
                                    Confirm('You\'ve already used this group')
                                else
                                    ind = ind + 1
                                end
                            until deleted == true or ind == last_line
                        end
                    gp_i = gp_i + 1
                    if #groups_pool[userInput].selectiondata == 0 then
                        Confirm('This Group is empty','It can be filled afterwards as the plugin creates recepie references.')
                    end
                elseif type(userInput) == 'table' then
                    for ind = 1, #userInput do
                        local exists
                        for idx = 1, #cp_groups do
                            if cp_groups[idx] == userInput[ind] then
                                exists = true
                            end
                        end
                        if not exists then
                            table.insert(cp_groups,userInput[ind])
                        end
                    end
                end
            else
            end
        end
    until userInput == DONE or userInput == nil
    -- for k,v in pairs(cp_groups) do
    --     Echo(k..' '..v)
    -- end
    return cp_groups
end