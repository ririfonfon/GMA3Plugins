local executor_table = {
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215,
    301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315,
    401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415
}

local osc_config = 1
local history_fader, history_status, history_Name, history_key, history_fade_func, history_c_r, history_c_g, history_c_b =
    {}, {}, {}, {}, {}, {}, {}, {}
local osc_template = 'SendOSC %i "/%s%i,i,%i"'
local osc_string_template = 'SendOSC %i "/%s%i,s,%s"'
local enabled = false
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor

local function send_osc(etype, exec_no, value)
    Cmd(osc_template:format(osc_config, etype, exec_no, value))
end
local function send_string_osc(etype, exec_no, value)
    Cmd(osc_string_template:format(osc_config, etype, exec_no, value))
end

local function poll(exec_no)
    local exec = GetExecutor(exec_no)
    local value = exec and mfloor(exec:GetFader {}) or -1
    local Text = exec and exec:GetFaderText {} or -1
    local Name
    if exec ~= nil and exec.Object ~= nil and exec.Object.name ~= ' ' then
        Name = exec.Object.name
    end
    local last_Name = history_Name[exec_no]
    if Name ~= last_Name then
        if Name == nil then Name = exec_no end
        send_string_osc('PageCurrent/Fader_Label', exec_no, Name)
        history_Name[exec_no] = Name
        Echo("n° : " .. exec_no .. " Name : " .. Name)
    end
    local key
    if exec ~= nil then
        key = exec.key
    end
    local last_key = history_key[exec_no]
    if key ~= last_key then
        if key == nil then key = "." end
        send_string_osc('PageCurrent/Key_Label', exec_no, key)
        history_key[exec_no] = key
        Echo("n° : " .. exec_no .. " key_function : " .. key)
    end

    local fader
    if exec ~= nil then
        fader = exec.fader
    end
    local last_fader = history_fade_func[exec_no]
    if fader ~= last_fader then
        if fader == nil then fader = "." end
        send_string_osc('PageCurrent/Fader_Func', exec_no, fader)
        history_fade_func[exec_no] = fader
        Echo("n° : " .. exec_no .. " fader_function : " .. fader)
    end

    local last_value = history_fader[exec_no]
    local status = exec and exec.Object and exec.Object:HasActivePlayback() and 1 or 0
    local last_status = history_status[exec_no]
    if value ~= last_value then
        send_osc('PageCurrent/Fader', exec_no, value)
        history_fader[exec_no] = value
    end
    if status ~= last_status then
        send_osc('PageCurrent/Key', exec_no, status)
        history_status[exec_no] = status
    end

    -- local color_r, color_g, color_b
    -- if exec ~= nil and exec.Object ~= nil and exec.Object.Appearance ~= nil then
    --     color_r = exec.Object.Appearance.ImageR
    --     color_g = exec.Object.Appearance.ImageG
    --     color_b = exec.Object.Appearance.ImageB
    -- end
    -- if exec == nil or exec.Object == nil or exec.Object.Appearance == nil then
    --     color_r = 255
    --     color_g = 255
    --     color_b = 255
    --     Echo('àààààààààààààààààààààààààààààààààààààààààààààààà')
    -- end
    -- local last_color_r = history_c_r[exec_no]
    -- local last_color_g = history_c_g[exec_no]
    -- local last_color_b = history_c_b[exec_no]
    -- if color_r ~= last_color_r then
    --     send_osc('PageCurrent/Fader_Color_R', exec_no, color_r)
    --     history_c_r[exec_no] = color_r
    --     Echo("n° : " .. exec_no .. " color r : " .. color_r)
    -- end
    -- if color_g ~= last_color_g then
    --     send_osc('PageCurrent/Fader_Color_G', exec_no, color_g)
    --     history_c_g[exec_no] = color_g
    --     Echo("n° : " .. exec_no .. " color g : " .. color_g)
    -- end
    -- if color_b ~= last_color_b then
    --     send_osc('PageCurrent/Fader_Color_B', exec_no, color_b)
    --     history_c_b[exec_no] = color_b
    --     Echo("n° : " .. exec_no .. " color b : " .. color_b)
    -- end

end

local function mainloop()
    while enabled do
        for _, exec_no in ipairs(executor_table) do poll(exec_no) end
        coroutine.yield(0.1)
        -- coroutine.yield(0.5)
    end
end

local function maintoggle()
    if enabled then
        enabled = false
    else
        enabled = true
        history_fader, history_status = {}, {}
        mainloop()
    end
end

return maintoggle







-- local function Read_Fader_Send_OSC_nn(executor_nr)
--     local FaderDataStructure = {}
--     FaderDataStructure.token = "FaderMaster"
--     FaderDataStructure.faderDisabled = false
--     local my_ex_obj_1 = GetExecutor(executor_nr)

--     if my_ex_obj_1 == nil then
--         local osc_value = -1
--         Cmd("SendOSC 1 \"/PageCurrent/Fader" .. executor_nr .. ",i," .. osc_value .. "\"")
--         local osc_value = 0
--         Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
--     else
--         local fader_current_Value = my_ex_obj_1:GetFader(FaderDataStructure)
--         local fader_current_Name = my_ex_obj_1:GetFaderText(FaderDataStructure)
--         Printf(fader_current_Name)
--         local exact = fader_current_Value
--         local osc_value = tonumber(string.format("%.1f", exact))
--         --local osc_value = math.floor(exact)
--         Cmd("SendOSC 1 \"/PageCurrent/Fader" .. executor_nr .. ",i," .. osc_value .. "\"")

--         local exec_str = "Exec " .. executor_nr
--         local exec = ObjectList(exec_str)
--         local seq = exec[1]:GetAssignedObj()

--         if seq:HasActivePlayback() then
--             local osc_value = 1
--             Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
--         else
--             local osc_value = 0
--             Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
--         end
--     end
-- end

-- local function main()
--     while true do
--         coroutine.yield(0.5)
--         for i, executor_nr in ipairs(executor_table) do
--             Read_Fader_Send_OSC_nn(executor_nr)
--         end
--     end
-- end

-- return main
