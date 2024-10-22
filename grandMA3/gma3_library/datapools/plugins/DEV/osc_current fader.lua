local function Read_Fader_Send_OSC_nn(executor_nr)
    local FaderDataStructure = {}
    FaderDataStructure.token = "FaderMaster"
    FaderDataStructure.faderDisabled = false
    local my_ex_obj_1 = GetExecutor(executor_nr)

    if my_ex_obj_1 == nil then
        local osc_value = -1
        Cmd("SendOSC 1 \"/PageCurrent/Fader" .. executor_nr .. ",i," .. osc_value .. "\"")
        local osc_value = 0
        Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
    else
        local fader_current_Value = my_ex_obj_1:GetFader(FaderDataStructure)
        local fader_current_Name = my_ex_obj_1:GetName(FaderDataStructure)
        local exact = fader_current_Value
        local osc_value = tonumber(string.format("%.1f", exact))
        --local osc_value = math.floor(exact)
        Cmd("SendOSC 1 \"/PageCurrent/Fader" .. executor_nr .. ",i," .. osc_value .. "\"")

        local exec_str = "Exec " .. executor_nr
        local exec = ObjectList(exec_str)
        local seq = exec[1]:GetAssignedObj()

        if seq:HasActivePlayback() then
            local osc_value = 1
            Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
        else
            local osc_value = 0
            Cmd("SendOSC 1 \"/PageCurrent/Key" .. executor_nr .. ",i," .. osc_value .. "\"")
        end
    end
end

local function main()
    local executor_table = {
        101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
        201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215,
        301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315,
        401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415
    }
    while true do
        coroutine.yield(0.5)
        for i, name in ipairs(executor_table) do
            Read_Fader_Send_OSC_nn(name)
        end
    end
end

return main
