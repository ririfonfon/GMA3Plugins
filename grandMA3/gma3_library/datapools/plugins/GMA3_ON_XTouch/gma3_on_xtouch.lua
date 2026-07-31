--[[
Releases:
* 2.2.5.2

Created by Richard Fontaine "RIRI", May 2025.
--]]

-- local executor_table = {
--     101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 181, 182, 183, 184, 185,
--     201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 281, 282, 283, 284, 285,
--     301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 381, 382, 383, 384, 385,
--     401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 481, 482, 483, 484, 485
-- }

local executor_table = {
    101, 102, 103, 104, 105, 106, 107, 108,
    201, 202, 203, 204, 205, 206, 207, 208,
    301, 302, 303, 304, 305, 306, 307, 308,
    401, 402, 403, 404, 405, 406, 407, 408,
}

local map_midi_note = {
    40, 41, 42, 43, 44, 45, 46, 47,
    32, 33, 34, 35, 36, 37, 38, 39,
    24, 25, 26, 27, 28, 29, 30, 31,
    16, 17, 18, 19, 20, 21, 22, 23,
}

local map_midi_cc = {
    101, 102, 103, 104, 105, 106, 107, 108,
    001, 002, 003, 004, 005, 006, 007, 008,
    010, 011, 012, 013, 014, 015, 016, 017,
    018, 019, 020, 021, 022, 023, 024, 025,

}

local osc_config = 1
local h_fader, h_status, h_Name, h_key, h_fade_func, conduite_cue_nr, conduite_cue_name, h_c_r, h_c_g,
h_c_b, ticket, ticket_old, ticket_name, ticket_old_name = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local h_page, h_pname = nil, nil
local osc_template = 'SendOSC %i "/%s%i,i,%i"'
local midi_control_template = 'SendMIDI "Control" %i/%i %i'
local midi_note_template = 'SendMIDI "Note" %i/%i %i'
local midi_program_template = 'SendMIDI "Program" %i/%i'
local osc_string_template = 'SendOSC %i "/%s%i,s,%s"'
local osc_cue_template = 'SendOSC %i "/%s,s,%s"'
local osc_color_template = 'SendOSC %i "/%s%i,s,%s%s%s%s"'
local enabled = false
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local refresh = true


local function send_midi_control(channel, control, value)
    Cmd(midi_control_template:format(channel, control, value))
end
local function send_midi_note(channel, control, value)
    Cmd(midi_note_template:format(channel, control, value))
end
local function send_osc(etype, exec_no, value)
    Cmd(osc_template:format(osc_config, etype, exec_no, value))
end
local function send_string_osc(etype, exec_no, value)
    Cmd(osc_string_template:format(osc_config, etype, exec_no, value))
end

local function send_cue_osc(etype, value)
    Cmd(osc_cue_template:format(osc_config, etype, value))
end

local function send_color_osc(etype, exec_no, value_r, value_g, value_b)
    local r_hex = string.format("%X", value_r)
    if string.len(r_hex) < 2 then
        r_hex = '0' .. r_hex
    end
    local g_hex = string.format("%X", value_g)
    if string.len(g_hex) < 2 then
        g_hex = '0' .. g_hex
    end
    local b_hex = string.format("%X", value_b)
    if string.len(b_hex) < 2 then
        b_hex = '0' .. b_hex
    end
    Cmd(osc_color_template:format(osc_config, etype, exec_no, r_hex, g_hex, b_hex, 'FF'))
end

local function ticket_on(n_exec, color_r, color_g, color_b, Name)
    ticket[n_exec] = true
    h_c_r[n_exec] = color_r
    h_c_g[n_exec] = color_g
    h_c_b[n_exec] = color_b
    ticket_name[n_exec] = Name
end


local Current_Cue_number, last_Current_Cue_number, cue_end, last_Current_Seq_Name, Current_Cue_name
local Cuezero, Cuelist, Cuelist_Name, Cuelist_Number, Cuelist_Seq_Name, Last_Cuelist, Last_Cuelist_Seq_Name, Last_Cuelist_Name, Cuelist_Number_End =
    {}, {}, {}, {}, {}, {}, {}, {}, {}
local function poll(exec_no, cible)
    --------------------------------------------PAGE
    local targetPage = CurrentExecPage()
    local pagenumber = targetPage.No
    local pname = targetPage.name
    local last_pagenumber = h_page
    local last_pname = h_pname
    if pagenumber ~= last_pagenumber or refresh == true then
        -- send_osc('PageNumber', 0, pagenumber)
        h_page = pagenumber
        refresh = true
        ticket = {}
        ticket_old = {}
        ticket_name = {}
        ticket_old_name = {}
        h_c_r = {}
        h_c_g = {}
        h_c_b = {}
        Cuezero = {}
        Cuelist_Name = {}
        Cuelist_Number = {}
        Cuelist_Number_End = {}
        Last_Cuelist_Seq_Name = {}
        Cuelist = {}
        Last_Cuelist = {}
    end
    if pname ~= last_pname or refresh == true then
        -- send_string_osc('PageName', 0, pname)
        h_pname = pname
    end



    --------------------------------------------SELECTED SEQ

    if SelectedSequence() == nil then
        Cmd('Select Sequence 1')
    end
    local id_seq = tonumber(SelectedSequence().No)
    local Current_Seq_Name = SelectedSequence().name
    local Seq_Conduite = GetObject('Seq ' .. id_seq)
    local Cue_Nr
    local Cue_Name
    if SelectedSequence().currentcue ~= nil then
        Current_Cue_name = SelectedSequence().currentcue.name
    else
        Current_Cue_name = 'none'
    end
    for key, value in ipairs(SelectedSequence():Children()) do
        if value.No then
            if value.Name == Current_Cue_name then
                Current_Cue_number = value.No / 1000
                Current_Cue_number = tonumber(Current_Cue_number)
            end
        end
    end
    if last_Current_Seq_Name ~= Current_Seq_Name or refresh == true then
        conduite_cue_name, conduite_cue_nr = {}, {}
        for k in ipairs(Seq_Conduite) do
            if Seq_Conduite[k].No ~= nil then
                Cue_Nr = Seq_Conduite[k].No / 1000
                Cue_Nr = tonumber(Cue_Nr)
                Cue_Name = Seq_Conduite[k].name
                conduite_cue_nr[k] = Cue_Nr
                conduite_cue_name[k] = Cue_Name
                cue_end = k
            end
        end
        last_Current_Seq_Name = Current_Seq_Name
        -- send_cue_osc('Select_seq_name', Current_Seq_Name)
    end
    if last_Current_Cue_number ~= Current_Cue_number or refresh == true then
        -- send_cue_osc('cue', Current_Cue_number)
        -- send_cue_osc('cue_name', Current_Cue_name)
        for k in ipairs(Seq_Conduite) do
            if Seq_Conduite[k].No ~= nil then
                Cue_Nr = Seq_Conduite[k].No / 1000
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
                    -- send_cue_osc('precue', conduite_cue_nr[precue_v])
                    -- send_cue_osc('nextcue', conduite_cue_nr[nextcue_v])
                    -- send_cue_osc('precue_name', conduite_cue_name[precue_v])
                    -- send_cue_osc('nextcue_name', conduite_cue_name[nextcue_v])
                end
            end
        end
        last_Current_Cue_number = Current_Cue_number
    end

    if refresh then
        -- send_cue_osc('Select_seq_name', Current_Seq_Name)
        -- send_cue_osc('cue', Current_Cue_number)
        -- send_cue_osc('cue_name', Current_Cue_name)
    end



    --------------------------------------------FADER BUTTON ROT
    local exec = GetExecutor(exec_no)
    local exec_height, exec_width
    if exec ~= nil then
        if exec.Height ~= nil then
            exec_height = exec.Height
        else
            exec_height = 0
        end
        if exec.Width ~= nil then
            exec_width = exec.Width
        else
            exec_width = 0
        end
    end
    local value = exec and mfloor(exec:GetFader {}) or -1
    local Text = exec and exec:GetFaderText {} or -1


    local Name, Number
    -- if exec ~= nil and exec.Object ~= nil then
    --     Name = exec.Object.name
    --     Number = tonumber(exec.Object.No)
    --     local myseq = GetObject('Seq ' .. Number)
    --     if string.find(exec.Object:AddrNative(DataPool()), exec.Object.name) then
    --         if Last_Cuelist_Seq_Name[exec_no] ~= Name then
    --             Cuelist_Name[exec_no], Cuelist_Number[exec_no], Cuelist_Number_End[exec_no] = {}, {}, {}
    --             for k in ipairs(myseq) do
    --                 if myseq[k].No ~= nil then
    --                     local n_c = myseq[k].No / 1000
    --                     n_c = tonumber(n_c)
    --                     Cuelist_Number[exec_no][k] = n_c
    --                     Cuelist_Name[exec_no][k] = myseq[k].name
    --                     Cuelist_Number_End[exec_no] = k
    --                 end
    --             end
    --             Last_Cuelist_Seq_Name[exec_no] = Name
    --         end

    --         Cuelist[exec_no] = GetObject('seq ' .. Number).currentcue

    --         if Cuelist[exec_no] ~= nil then
    --             if Last_Cuelist[exec_no] ~= Cuelist[exec_no] then
    --                 if Cuelist[exec_no].No == nil then
    --                     -- send_cue_osc('Cue' .. exec_no .. 'Nr', '***')
    --                 else
    --                     -- send_cue_osc('Cue' .. exec_no .. 'Nr', tonumber(Cuelist[exec_no].No / 1000))
    --                 end
    --                 if Cuelist[exec_no].name == nil then
    --                     Cuelist[exec_no].name = 'none'
    --                 end
    --                 -- send_cue_osc('Cue' .. exec_no .. 'Name', Cuelist[exec_no].name)
    --                 for k in ipairs(myseq) do
    --                     if myseq[k].No ~= nil then
    --                         if myseq[k].name == Cuelist[exec_no].name then
    --                             local next_number = k + 1
    --                             if next_number > Cuelist_Number_End[exec_no] then
    --                                 next_number = 3
    --                             end
    --                             -- send_cue_osc('2Cue' .. exec_no .. 'Nr', Cuelist_Number[exec_no][next_number])
    --                             -- send_cue_osc('2Cue' .. exec_no .. 'Name', Cuelist_Name[exec_no][next_number])
    --                         end
    --                     end
    --                 end
    --                 Last_Cuelist[exec_no] = Cuelist[exec_no]
    --             end
    --         end
    --     end
    -- end

    -- local last_Name = h_Name[exec_no]
    -- local clean_cue = false
    -- if Name == nil then
    --     Name = exec_no
    --     clean_cue = true
    -- end
    -- if clean_cue == true and Cuezero[exec_no] == nil then
    --     -- send_cue_osc('Cue' .. exec_no .. 'Nr', '')
    --     -- send_cue_osc('Cue' .. exec_no .. 'Name', '')
    --     -- send_cue_osc('2Cue' .. exec_no .. 'Nr', '')
    --     -- send_cue_osc('2Cue' .. exec_no .. 'Name', '')
    --     Cuezero[exec_no] = true
    -- end
    -- if ticket[exec_no] ~= nil and ticket_old_name[exec_no] ~= true then
    --     last_Name = ''
    --     Name = ticket_name[exec_no]
    --     ticket_old_name[exec_no] = 1000
    -- end
    -- if ticket_old_name[exec_no] ~= true then
    --     if ticket_old_name[exec_no] == 1000 then
    --         ticket_old_name[exec_no] = true
    --     end
    --     if Name ~= last_Name or refresh == true then
    --         -- send_string_osc('PageCurrent/Fader_Label', exec_no, Name)
    --         h_Name[exec_no] = Name
    --     end
    -- end


    local key
    if exec ~= nil then
        key = exec.key
    end
    local last_key = h_key[exec_no]
    if key == nil then key = "" end
    if key ~= last_key or refresh == true then
        -- send_string_osc('PageCurrent/Key_Label', exec_no, key)
        h_key[exec_no] = key
        if key == "" then
            send_midi_note(1, map_midi_note[cible], 0)
        else
            send_midi_note(1, map_midi_note[cible], 1)
        end
    end

    local fader
    if exec ~= nil then
        fader = exec.fader
    end
    local last_fader = h_fade_func[exec_no]
    if fader == nil then fader = "" end
    if fader ~= last_fader or refresh == true then
        -- send_string_osc('PageCurrent/Fader_Func', exec_no, fader)

        h_fade_func[exec_no] = fader
    end

    local last_value = h_fader[exec_no]
    local status = exec and exec.Object and exec.Object:HasActivePlayback() and 1 or 0
    local last_status = h_status[exec_no]
    if value ~= last_value or refresh == true then
        -- send_osc('PageCurrent/Fader', exec_no, value)
        -- Echo('midi nat  exec ' .. exec_no)
        local midi_value = 0
        midi_value = math.floor((value * 127) / 100)
        if midi_value == nil then
            midi_value = 0
        end
        if midi_value < 0 then midi_value = 0 end
        -- Echo('midi exec ' .. map_midi_cc[cible] .. ' fader ' .. midi_value)
        send_midi_control(1, map_midi_cc[cible], midi_value)
        h_fader[exec_no] = value
    end
    if status ~= last_status or refresh == true then
        -- send_osc('PageCurrent/Key', exec_no, status)
        h_status[exec_no] = status
    end


    --------------------------------------------FADER BUTTON COLOR

    local color_r, color_g, color_b, active_value
    if exec ~= nil and exec.Object ~= nil and exec.Object.Appearance ~= nil then
        color_r = exec.Object.Appearance.ImageR
        color_g = exec.Object.Appearance.ImageG
        color_b = exec.Object.Appearance.ImageB
        active_value = 1
        -- Echo(' ok non nil ' .. active_value)
    end

    if exec == nil or exec.Object == nil or exec.Object.Appearance == nil then
        color_r = 255
        color_g = 255
        color_b = 255
        exec_height = 1
        exec_width = 1
        active_value = 0
        -- Echo(' nop nil ' .. active_value)
    end

    local last_color_r = h_c_r[exec_no]
    local last_color_g = h_c_g[exec_no]
    local last_color_b = h_c_b[exec_no]

    if ticket[exec_no] ~= nil and ticket_old[exec_no] ~= true then
        last_color_r = -1
        last_color_g = -1
        last_color_b = -1
        color_r = h_c_r[exec_no]
        color_g = h_c_g[exec_no]
        color_b = h_c_b[exec_no]
        ticket_old[exec_no] = 1000
    end

    if ticket_old[exec_no] ~= true then
        local send_color = false
        if ticket_old[exec_no] == 1000 then
            ticket_old[exec_no] = true
        active_value = 1
        end
        if color_r ~= last_color_r then
            send_color = true
        active_value = 1
            h_c_r[exec_no] = color_r
            if exec_height > 1 then
                for h = 1, exec_height - 1 do
                    ticket_on(exec_no + h * 100, color_r, color_g, color_b, Name)
                    if exec_width > 1 then
                        for w = 1, exec_width - 1 do
                            ticket_on(exec_no + h * 100 + w, color_r, color_g, color_b, Name)
                        end
                    end
                end
            end

            if exec_width > 1 then
                for w = 1, exec_width - 1 do
                    ticket_on(exec_no + w, color_r, color_g, color_b, Name)
                end
            end
        end
        if color_g ~= last_color_g then
            send_color = true
        active_value = 1
            h_c_g[exec_no] = color_g
            if exec_height > 1 then
                for h = 1, exec_height - 1 do
                    ticket_on(exec_no + h * 100, color_r, color_g, color_b, Name)
                    if exec_width > 1 then
                        for w = 1, exec_width - 1 do
                            ticket_on(exec_no + h * 100 + w, color_r, color_g, color_b, Name)
                        end
                    end
                end
            end

            if exec_width > 1 then
                for w = 1, exec_width - 1 do
                    ticket_on(exec_no + w, color_r, color_g, color_b, Name)
                end
            end
        end
        if color_b ~= last_color_b then
            send_color = true
        active_value = 1
            h_c_b[exec_no] = color_b
            if exec_height > 1 then
                for h = 1, exec_height - 1 do
                    ticket_on(exec_no + h * 100, color_r, color_g, color_b, Name)
                    if exec_width > 1 then
                        for w = 1, exec_width - 1 do
                            ticket_on(exec_no + h * 100 + w, color_r, color_g, color_b, Name)
                        end
                    end
                end
            end

            if exec_width > 1 then
                for w = 1, exec_width - 1 do
                    ticket_on(exec_no + w, color_r, color_g, color_b, Name)
                end
            end
        end

        if send_color == true then
            -- send_color_osc('PageCurrent/Fader_Color', exec_no, color_r, color_g, color_b)
            -- Echo(' send value ' .. active_value)
            -- send_midi_note(1, map_midi_note[cible], active_value)
            send_color = false
        end
    end

    if refresh == true then
        refresh = false
    end
end

local state = 0
local function ping()
    state = state + 1
    if state > 20 then
        state = 0
    end
    if state == 0 then
        -- send_osc('PageCurrent/Ping', 0, 1)
        -- send_midi_control(1, 27, 127)
    elseif state == 10 then
        -- send_osc('PageCurrent/Ping', 0, 0)
        -- send_midi_control(1, 27, 127)
    end
end
local function mainloop()
    while enabled do
        for cible, exec_no in ipairs(executor_table) do poll(exec_no, cible) end
        ping()
        coroutine.yield(0.1)
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
