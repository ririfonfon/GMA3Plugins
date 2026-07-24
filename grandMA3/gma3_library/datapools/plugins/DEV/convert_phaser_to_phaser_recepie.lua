-- grandMA3 Phaser to Phaser Recipe converter v 1.0
-- Created by Yury Belousov

local function my_create(pool, index, undo)
    local maxsize = pool:MaxCount()
    local poolsize = pool:Count()
    if index > poolsize then
        local newsize = math.min(maxsize, math.ceil(index / 1000) * 1000)
        pool:Resize(newsize)
    end
    return pool:Create(index, nil, undo)
end

local function range_free(pool, start_idx, amount)
    if not start_idx then return false end
    local end_idx = start_idx + amount - 1
    for i = start_idx, end_idx do
        if pool[i] then
            return false
        end
    end
    return true
end

local function roundnumber(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    local result = math.floor(num * mult + 0.5) / mult
    return result
end

local function check_if_multistep_preset(preset_data)
    for _, uichannel_data in pairs(preset_data) do
        if type(uichannel_data) == 'table' then
            if #uichannel_data > 1 then
                return true
            end
        end
    end
    return false
end

local function system_time_with_ms()
    local time = os.date('*t')
    return string.format('%02dh%02dm%02d.', time.hour, time.min, time.sec) .. tostring(Time()):match('%d+%.(%d%d%d)%d+')
end

local function phaser_to_phaser_recipe(in_preset, target_preset_pool_index, preset_index, undo)
    if in_preset:IsEmpty() then
        return false, system_time_with_ms() .. ': skipping ' .. in_preset .. ': empty preset\n'
    end
    local matricks_settings = {
        'X', 'Y', 'Z', 'XBLOCK', 'YBLOCK', 'ZBLOCK', 'XGROUP', 'YGROUP', 'ZGROUP', 'XWINGS', 'YWINGS', 'ZWINGS', 'XWIDTH',
        'YWIDTH', 'ZWIDTH', 'XSHUFFLE', 'YSHUFFLE', 'ZSHUFFLE', 'XSHIFT', 'YSHIFT', 'ZSHIFT', 'XINV', 'XINVB', 'XINVG',
        'XINVW', 'YINV', 'YINVB', 'YINVG', 'YINVW', 'ZINV', 'ZINVB', 'ZINVG', 'ZINVW', 'INVERTSTYLE', 'INVERTX',
        'INVERTY', 'INVERTZ', 'PHASERTRANSFORM', 'FADEFROMX', 'FADETOX', 'DELAYFROMX', 'DELAYTOX', 'SPEEDFROMX',
        'SPEEDTOX', 'PHASEFROMX', 'PHASETOX', 'FADEFROMY', 'FADETOY', 'DELAYFROMY', 'DELAYTOY', 'SPEEDFROMY', 'SPEEDTOY',
        'PHASEFROMY', 'PHASETOY', 'FADEFROMZ', 'FADETOZ', 'DELAYFROMZ', 'DELAYTOZ', 'SPEEDFROMZ', 'SPEEDTOZ',
        'PHASEFROMZ', 'PHASETOZ'
    }
    local used_attributes = {}
    if in_preset.storeddata:find('Selective') then
        return false, system_time_with_ms() .. ': skipping ' .. in_preset .. ': selective data detected\n'
    end
    local source_preset_data = GetPresetData(in_preset, false, false)
    if not check_if_multistep_preset(source_preset_data) then
        return false, system_time_with_ms() .. ': skipping ' .. in_preset .. ': single step preset\n'
    end
    local target_preset_pool = GetObject('preset ' .. target_preset_pool_index)
    local converted_preset
    converted_preset = my_create(target_preset_pool, preset_index, undo)
    converted_preset:Set('name', in_preset.name .. ' //phaser recipe')
    local preset_phaser_recipe = converted_preset:Acquire('PhaserRecipe')
    coroutine.yield({ root = 3 })
    local converted_preset_steps = preset_phaser_recipe.phaserrecipesteps
    local value_source_index = 1
    for _, property in ipairs(matricks_settings) do
        preset_phaser_recipe:Set(property, in_preset[property])
    end
    for uichannnel_index = 0, GetUIChannelCount() - 1 do
        local uichannel = source_preset_data[uichannnel_index]
        if uichannel then
            local attrribute = GetAttributeByUIChannel(uichannnel_index)
            if not used_attributes[attrribute] then
                if preset_phaser_recipe.speedfromx == 'None' then
                    preset_phaser_recipe:Set('speedx', (uichannel.speed or 1) * 60)
                end
                if preset_phaser_recipe.phasefromx == 'None' then
                    preset_phaser_recipe:Set('phasex', (uichannel.phase or 0))
                end
                preset_phaser_recipe:Set('measure', (uichannel.measure or #uichannel * 100))
                for step_index, step in ipairs(uichannel) do
                    if step.absolute and step.absolute >= 6500 and step.absolute < 6600 then
                        -- Printf(in_preset..': generator vaue detected')
                        converted_preset:Parent():Delete(converted_preset:Index())
                        return false,
                            system_time_with_ms() .. ': skipping ' .. in_preset ..
                            ': generator or bitmap value detected\n'
                    end
                    if not converted_preset_steps[step_index] then
                        Cmd('insert ' .. converted_preset_steps .. '.' .. step_index .. ' /nc /nu')
                        coroutine.yield({ root = 3 })
                    end
                    local value_source = converted_preset_steps[step_index][value_source_index]
                    if not value_source then
                        Cmd('insert ' .. converted_preset_steps[step_index] .. '.' .. value_source_index .. ' /nc /nu')
                        value_source = converted_preset_steps[step_index][value_source_index]
                        coroutine.yield({ root = 3 })
                    end
                    local spline_type_accel
                    if step.accel_type == 1 then
                        spline_type_accel = 'F '
                    elseif step.accel_type == 2 then
                        spline_type_accel = 'P '
                    else
                        spline_type_accel = ''
                    end
                    local spline_type_decel
                    if step.decel_type == 1 then
                        spline_type_decel = 'F '
                    elseif step.decel_type == 2 then
                        spline_type_decel = 'P '
                    else
                        spline_type_decel = ''
                    end
                    value_source:Set('attributes', attrribute)
                    if step.integrated then
                        Cmd('Assign ' .. step.integrated .. ' at ' .. value_source .. ' /nu')
                    else
                        value_source:Set('RAWVALUEABS', step.absolute == 6600 and 'Release' or step.absolute)
                        value_source:Set('RAWVALUEREL', step.relative == 6600 and 'Release' or step.relative)
                    end
                    value_source:Set('accelx', spline_type_accel .. roundnumber((step.accel or 0), 2))
                    value_source:Set('decelx', spline_type_decel .. roundnumber((step.decel or 0), 2))
                    value_source:Set('transx', roundnumber((step.trans or 100), 2))
                    value_source:Set('widthx', roundnumber((step.width or 100), 2))
                end
                value_source_index = value_source_index + 1
            end
            used_attributes[attrribute] = true
        end
    end
    -- delete empty value_sources
    for _, step in ipairs(converted_preset_steps) do
        for _, value_source in ipairs(step) do
            if not value_source.attributes then
                step:Delete(value_source:Index())
            end
        end
    end
    return true, ''
end

local function UI()
    local suggested_sourse_presets = ''
    local suggested_target_pool = ''
    local suggested_first_target_preset = ''
    local preserve_gaps_label = 'Preserve gaps'
    local preserve_indexing_label = 'Preserve indexing'
    local ignore_gaps_and_indexing_label = 'Ignore gaps and indexing'
    local radio_selector_label = ' '
    local presets_to_convert_label = 'Presets to convert'
    local target_preset_pool_label = 'Target preset pool'
    local first_converted_preset_label = 'First converted preset'
    local title = 'Phaser to Phaser Recipe Converter'
    local ingnored_message =
    'Select presets to be converted, a target preset pool, and an indexing for the newly created presets.\n\n"First converted preset" field is ignored when "preserve indexing" is selected.'
    local preserve_gaps_and_indexing
    local presets_to_convert
    local target_preset_pool
    local first_converted_preset
    local input_is_valid
    repeat
        local result_table =
            MessageBox(
                {
                    title = title,
                    message = ingnored_message,
                    message_align_h = Enums.AlignmentH.Center,
                    message_align_v = Enums.AlignmentV.Top,
                    commands = { { value = 1, name = 'Ok' }, { value = 0, name = 'Cancel' } },
                    selectors = {
                        { name = radio_selector_label, selectedValue = 2, values = { [preserve_indexing_label] = 1, [preserve_gaps_label] = 2, [ignore_gaps_and_indexing_label] = 3 }, type = 1 },
                    },
                    inputs = {
                        { name = presets_to_convert_label,     value = suggested_sourse_presets,      order = 1 },
                        { name = target_preset_pool_label,     value = suggested_target_pool,         whiteFilter = '0123456789', maxTextLength = 2, order = 2 },
                        { name = first_converted_preset_label, value = suggested_first_target_preset, whiteFilter = '0123456789', maxTextLength = 4, order = 3 }
                    },
                    messageTextColor = 'Global.Text',
                    autoCloseOnInput = false
                }
            )
        preserve_gaps_and_indexing = result_table.selectors[radio_selector_label]
        presets_to_convert = ObjectList('preset ' .. result_table.inputs[presets_to_convert_label])
        target_preset_pool = GetObject('preset ' .. result_table.inputs[target_preset_pool_label])
        first_converted_preset = tonumber(result_table.inputs[first_converted_preset_label])
        local does_fit
        local assumed_amount_of_converted_presets
        if not result_table.success then return end
        if preserve_gaps_and_indexing == 1 then
            assumed_amount_of_converted_presets = presets_to_convert[#presets_to_convert]:Index() -
                presets_to_convert[1]:Index() + 1
            does_fit = range_free(target_preset_pool, presets_to_convert[1]:Index(), assumed_amount_of_converted_presets)
        elseif preserve_gaps_and_indexing == 2 then
            assumed_amount_of_converted_presets = presets_to_convert[#presets_to_convert]:Index() -
                presets_to_convert[1]:Index() + 1
            does_fit = range_free(target_preset_pool, first_converted_preset, assumed_amount_of_converted_presets)
        elseif preserve_gaps_and_indexing == 3 then
            assumed_amount_of_converted_presets = #presets_to_convert
            does_fit = range_free(target_preset_pool, first_converted_preset, assumed_amount_of_converted_presets)
        end
        if (
                result_table.result == 1 and
                #presets_to_convert > 0 and
                presets_to_convert[1]:GetClass() == 'Preset' and
                target_preset_pool and
                target_preset_pool:GetClass() == 'Presets' and
                does_fit
            ) then
            input_is_valid = true
        else
            Confirm(title, 'Check your input', nil, false)
            input_is_valid = false
        end
    until input_is_valid or not result_table.success or result_table.result == 0
    if input_is_valid then
        return presets_to_convert, target_preset_pool, first_converted_preset, preserve_gaps_and_indexing
    end
end

local function convert_phasers()
    local phasers, target_preset_pool, first_index, preserve_gaps_and_indexing = UI()
    if not phasers or not target_preset_pool or not first_index then
        return
    end
    local keep_gaps
    if preserve_gaps_and_indexing == 1 then
        first_index = phasers[1]:Index()
        keep_gaps = true
    elseif preserve_gaps_and_indexing == 2 then
        keep_gaps = true
    elseif preserve_gaps_and_indexing == 3 then
        keep_gaps = false
    end
    local keep_gaps_index_delta = phasers[1]:Index() - first_index
    local progress = StartProgress('converting phasers')
    local converted_count = 0
    local log = ''
    local undo = CreateUndo('Phasers convert')
    local start_time = Time()
    SetProgressRange(progress, 1, #phasers)
    for _, phaser in ipairs(phasers) do
        local preset_index
        if keep_gaps then
            preset_index = phaser:Index() - keep_gaps_index_delta
        else
            preset_index = converted_count + first_index
        end
        local success, feedback = phaser_to_phaser_recipe(phaser, target_preset_pool:Index(), preset_index, undo)
        log = log .. feedback
        if success then
            converted_count = converted_count + 1
        end
        IncProgress(progress, 1)
    end
    StopProgress(progress)
    CloseUndo(undo)
    local elapsed_time = Time() - start_time
    local msg = string.format('%d out of %d presets successfully converted in %f seconds', converted_count, #phasers,
        elapsed_time)
    Printf(msg)
    Printf(log)
    Confirm('Phaser to Phaser Recipe Converter', msg, nil, false)
end

return convert_phasers
