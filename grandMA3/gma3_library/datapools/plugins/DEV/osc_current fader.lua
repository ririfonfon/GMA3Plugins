local executor_table = {
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 181, 182, 183, 184, 185,
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 281, 282, 283, 284, 285,
    301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 381, 382, 383, 384, 385,
    401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 481, 482, 483, 484, 485
}

local osc_config = 1
local h_fader, h_status, h_Name, h_key, h_fade_func, conduite_cue_nr, conduite_cue_name, h_c_r, h_c_g, h_c_b =
    {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local h_page, h_pname = nil, nil
local osc_template = 'SendOSC %i "/%s%i,i,%i"'
local osc_string_template = 'SendOSC %i "/%s%i,s,%s"'
local osc_cue_template = 'SendOSC %i "/%s,s,%s"'
local enabled = false
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor

local list = false
local refresh = true



local function send_osc(etype, exec_no, value)
    Cmd(osc_template:format(osc_config, etype, exec_no, value))
end
local function send_string_osc(etype, exec_no, value)
    Cmd(osc_string_template:format(osc_config, etype, exec_no, value))
end

local function send_cue_osc(etype, value)
    Cmd(osc_cue_template:format(osc_config, etype, value))
end

local Current_Cue_number, last_Current_Cue_number, cue_end
local function poll(exec_no)
    local targetPage = CurrentExecPage()
    local pagenumber = targetPage.No
    local pname = targetPage.name
    local last_pagenumber = h_page
    local last_pname = h_pname
    if pagenumber ~= last_pagenumber or refresh == true then
        send_osc('PageNumber', 0, pagenumber)
        h_page = pagenumber
        Echo('page : ' .. pagenumber)
        refresh = true
    end
    if pname ~= last_pname or refresh == true then
        send_string_osc('PageName', 0, pname)
        h_pname = pname
        Echo('page name : ' .. pname)
    end

    local Seq = DataPool().Sequences:Children()
    local Seq_Conduite = Seq[1]
    local Cue_Nr
    local Cue_Name
    local Current_Cue_name = SelectedSequence().currentcue[1].name

    for key, value in ipairs(SelectedSequence():Children()) do
        if value.No then
            if value.Name == Current_Cue_name then
                Current_Cue_number = math.floor(value.No / 1000)
                Current_Cue_number = tonumber(Current_Cue_number)
            end
        end
    end

    if list == false then
        for k in ipairs(Seq_Conduite) do
            if Seq_Conduite[k].No ~= nil then
                Cue_Nr = math.floor(Seq_Conduite[k].No / 1000)
                Cue_Nr = tonumber(Cue_Nr)
                Cue_Name = Seq_Conduite[k].name
                conduite_cue_nr[k] = Cue_Nr
                conduite_cue_name[k] = Cue_Name
                cue_end = k
                Echo('k ' .. k .. ' nr ' ..Cue_Nr)
            end
        end
        Echo('00000000000000000000 : ' .. cue_end)
        list = true
    end

    if last_Current_Cue_number ~= Current_Cue_number then
        send_cue_osc('cue', Current_Cue_number)
        send_cue_osc('cue_name', Current_Cue_name)
        for k in ipairs(Seq_Conduite) do
            if Seq_Conduite[k].No ~= nil then
                Cue_Nr = math.floor(Seq_Conduite[k].No / 1000)
                Cue_Nr = tonumber(Cue_Nr)
                Cue_Name = Seq_Conduite[k].name
                if Cue_Name == Current_Cue_name then
                    local precue_v = k - 1
                    local nextcue_v = k + 1
                    if precue_v < 3 then
                        precue_v = cue_end
                    end
                    if nextcue_v > cue_end then
                        nextcue_v = 3
                    end
                    send_cue_osc('precue', conduite_cue_nr[precue_v])
                    send_cue_osc('nextcue', conduite_cue_nr[nextcue_v])
                    send_cue_osc('precue_name', conduite_cue_name[precue_v])
                    send_cue_osc('nextcue_name', conduite_cue_name[nextcue_v])
                end
            end
        end
        last_Current_Cue_number = Current_Cue_number
    end






    local exec = GetExecutor(exec_no)
    local value = exec and mfloor(exec:GetFader {}) or -1
    local Text = exec and exec:GetFaderText {} or -1
    local Name
    if exec ~= nil and exec.Object ~= nil then
        Name = exec.Object.name
    end
    local last_Name = h_Name[exec_no]
    if Name == nil then Name = exec_no end
    if Name ~= last_Name or refresh == true then
        send_string_osc('PageCurrent/Fader_Label', exec_no, Name)
        h_Name[exec_no] = Name
        Echo("n° : " .. exec_no .. " Name : " .. Name)
    end
    local key
    if exec ~= nil then
        key = exec.key
    end
    local last_key = h_key[exec_no]
    if key == nil then key = "" end
    if key ~= last_key or refresh == true then
        send_string_osc('PageCurrent/Key_Label', exec_no, key)
        h_key[exec_no] = key
        Echo("n° : " .. exec_no .. " key_Label : " .. key)
    end

    local fader
    if exec ~= nil then
        fader = exec.fader
    end
    local last_fader = h_fade_func[exec_no]
    if fader == nil then fader = "" end
    if fader ~= last_fader or refresh == true then
        send_string_osc('PageCurrent/Fader_Func', exec_no, fader)
        h_fade_func[exec_no] = fader
        Echo("n° : " .. exec_no .. " fader_function : " .. fader)
    end

    local last_value = h_fader[exec_no]
    local status = exec and exec.Object and exec.Object:HasActivePlayback() and 1 or 0
    local last_status = h_status[exec_no]
    if value ~= last_value or refresh == true then
        send_osc('PageCurrent/Fader', exec_no, value)
        h_fader[exec_no] = value
    end
    if status ~= last_status or refresh == true then
        send_osc('PageCurrent/Key', exec_no, status)
        h_status[exec_no] = status
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
    -- local last_color_r = h_c_r[exec_no]
    -- local last_color_g = h_c_g[exec_no]
    -- local last_color_b = h_c_b[exec_no]
    -- if color_r ~= last_color_r then
    --     send_osc('PageCurrent/Fader_Color_R', exec_no, color_r)
    --     h_c_r[exec_no] = color_r
    --     Echo("n° : " .. exec_no .. " color r : " .. color_r)
    -- end
    -- if color_g ~= last_color_g then
    --     send_osc('PageCurrent/Fader_Color_G', exec_no, color_g)
    --     h_c_g[exec_no] = color_g
    --     Echo("n° : " .. exec_no .. " color g : " .. color_g)
    -- end
    -- if color_b ~= last_color_b then
    --     send_osc('PageCurrent/Fader_Color_B', exec_no, color_b)
    --     h_c_b[exec_no] = color_b
    --     Echo("n° : " .. exec_no .. " color b : " .. color_b)
    -- end

    if refresh == true then
        refresh = false
    end
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
        h_fader, h_status = {}, {}
        mainloop()
    end
end

return maintoggle
