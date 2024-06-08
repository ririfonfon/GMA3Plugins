local c = Cmd
local ti = TextInput

local function get_presets_input_with_ranges(input,suggested,object_pool)
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
        while ind <= amount_of_entries do
            if object_pool[result[ind]] == nil or object_pool[result[ind]].storeddata ~= 'Universal' then
                table.remove(result,ind)
                deleted = true
                ind = ind
                amount_of_entries = #result
            else
                ind = ind + 1
            end
        end
        if deleted then
            Confirm('Non-universal/not existing presets deleted from range')
        end
        -- for k,v in pairs(result) do
        --     Echo(k..' '..v)
        -- end
    end
    -- Echo(result)
    return result
end

function cp_get_color_presets(DP)
    local DONE = '[DONE]'
    local userInput
    local cp_presets = {}
    local pr_i = 1
    local last_line
    local ColorPresetPool = ShowData().DataPools[DP].PresetPools[4]
    repeat 
        userInput = get_presets_input_with_ranges(ti('Enter prest ID or range in format: X Thru Y', DONE),DONE,ColorPresetPool)
        if userInput ~= '' and userInput ~= nil then
            -- Echo(groups_pool[tonumber(userInput)].name)
            -- Echo(#groups_pool[tonumber(userInput)].selectiondata)
            if userInput ~= DONE then
                if type(userInput) ~= 'table' and ColorPresetPool[userInput] == nil then
                    Confirm('Preset doesn\'t exist')
                elseif type(userInput) ~= 'table' then
                    if ColorPresetPool[userInput].storeddata == 'Universal' then
                        table.insert(cp_presets,userInput)
                            if #cp_presets > 1 then
                                last_line = #cp_presets
                                local ind = 1
                                local deleted
                                repeat
                                    if cp_presets[ind] == cp_presets[last_line] then
                                        table.remove(cp_presets,last_line)
                                        deleted = true
                                        Confirm('You\'ve already used this preset')
                                    else
                                        ind = ind + 1
                                    end
                                until deleted == true or ind == last_line
                            end
                        pr_i = pr_i + 1
                    else
                        Confirm('Preset is not universal')
                    end
                elseif type(userInput) == 'table' then
                    for ind = 1, #userInput do
                        local exists
                        for idx = 1, #cp_presets do
                            if cp_presets[idx] == userInput[ind] then
                                exists = true
                            end
                        end
                        if not exists then
                            table.insert(cp_presets,userInput[ind])
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
    local amount_of_presets = #cp_presets
    local GPD = GetPresetData
    local colors_R = {} -- Table for Red values for appearances
    local colors_G = {} -- Table for Green values for appearances
    local colors_B = {} -- Table for Blue values for appearances
    for i = 1, amount_of_presets do
        if GPD(ColorPresetPool[cp_presets[i]])[3] == nil then
            c('universal 1 at preset 4.'..cp_presets[i]..' /nu;store preset 4.'..cp_presets[i]..' /m /nu;clearall /nu')
        end
        colors_R[i] = 255*GPD(ColorPresetPool[cp_presets[i]])[3][1].absolute/100
    end
    for i = 1, amount_of_presets do
        colors_G[i] = 255*GPD(ColorPresetPool[cp_presets[i]])[4][1].absolute/100
    end
    for i = 1, amount_of_presets do
        colors_B[i] = 255*GPD(ColorPresetPool[cp_presets[i]])[5][1].absolute/100
    end
    return cp_presets, colors_R, colors_G, colors_B
end