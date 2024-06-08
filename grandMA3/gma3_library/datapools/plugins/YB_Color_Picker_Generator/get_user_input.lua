local c = Cmd
local ti = TextInput

function cp_get_first_pool_num(object_amount,pool)
    local object_num = 1
    local i = 1
        while object_num <= object_amount do
            if pool[i] ~= nil then
                object_num = 1
                i = i + 1
            else
                object_num = object_num + 1
                i = i + 1
            end
        end
    return (i-object_amount)
end

local function get_suitable_user_input(msg, placeholder)
    local userInput = ''
    repeat
      userInput = ti(msg, placeholder)
      userInput = userInput:match('%D*(%d+)%D*')
    until userInput ~= placeholder and userInput ~= nil
    return userInput
end

function cp_check_selected_pool_num(message,suggested,object_amount,pool)
    local result = false
    local input = tonumber(get_suitable_user_input(message,suggested))
    local last_pool_obj = input + tonumber(object_amount) - 1
        repeat
            while input <= last_pool_obj and result == false do
                if pool[input] ~= nil or last_pool_obj > 9999 then
                    result = false
                    Confirm('Occupied / Not enough space')
                    input = tonumber(get_suitable_user_input(message,suggested))
                    last_pool_obj = input + object_amount - 1
                else
                    input = input + 1
                end
            end
            result = true
        until result == true
    return tonumber(input-object_amount)
end