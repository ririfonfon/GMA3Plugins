local function calculate_emitters_rgb(emitters)
    local total_r, total_g, total_b = 0, 0, 0
    local total_intensity = 0
    for _,emitter in ipairs(emitters) do
        local emitter_r = emitter.color[1]
        local emitter_g = emitter.color[2]
        local emitter_b = emitter.color[3]
        local emitter_intensity = emitter.intensity
        total_r = total_r + emitter_r * emitter_intensity
        total_g = total_g + emitter_g * emitter_intensity
        total_b = total_b + emitter_b * emitter_intensity
        total_intensity = total_intensity + emitter_intensity
    end
    if total_intensity == 0 then
        return {0, 0, 0}
    end
    local r = total_r / total_intensity
    local g = total_g / total_intensity
    local b = total_b / total_intensity
    local brightness = 100
    local factor = brightness/math.max(r,g,b)
    return {r*factor, g*factor, b*factor}
end

local function get_rgb_after_filters(main_source_color,filters)
    local r, g, b = main_source_color[1], main_source_color[2], main_source_color[3]
    for _,filter in ipairs(filters) do
        local filter_r = filter.color[1]
        local filter_g = filter.color[2]
        local filter_b = filter.color[3]
        local filter_intensity = filter.intensity
        local blend_r = (100 - filter_intensity) / 100 * 100 + filter_intensity / 100 * filter_r
        local blend_g = (100 - filter_intensity) / 100 * 100 + filter_intensity / 100 * filter_g
        local blend_b = (100 - filter_intensity) / 100 * 100 + filter_intensity / 100 * filter_b
        r = r * (blend_r / 100)
        g = g * (blend_g / 100)
        b = b * (blend_b / 100)
    end
    local brightness = 100
    local factor = brightness/math.max(r,g,b)
    return {r*factor, g*factor, b*factor}
end

local function get_color_modifiers(preset) -- filters or emitters
    local color_modifiers = {}
    local dimmer_emitter
    local is_subtractive
    local preset_data_by_fixtures = GetPresetData(preset).by_fixtures
    local fixture_with_max_values
    local max_rgb_values_amount = 0
    for fid,values in pairs(preset_data_by_fixtures) do
        local rgb_values_count = 0
        for attribute in pairs(values) do
            if attribute:find('ColorRGB_') then
                rgb_values_count = rgb_values_count + 1
            end
        end
        if rgb_values_count > max_rgb_values_amount then
            max_rgb_values_amount = rgb_values_count
            fixture_with_max_values = fid
        end
    end
    for _,color_value in pairs(preset_data_by_fixtures[fixture_with_max_values]) do
        local color_modifier_data = {}
        local ui_channel = GetUIChannel(color_value.ui_channel_index)
        local attribute = GetAttributeByUIChannel(color_value.ui_channel_index)
        if ui_channel and attribute and attribute.special == 'ColorRGB' then
            local filter_object = ui_channel.logical_channel[1].filter
            local emitter_object = ui_channel.logical_channel[1].emitter
            local color_modifier_object
            if filter_object then
                is_subtractive = true
                color_modifier_object = filter_object
                color_modifier_data.intensity = 100 - color_value[1].absolute
                if not dimmer_emitter then
                    local dmx_mode = ui_channel.logical_channel:FindParent('DMXMode')
                    local dimmer_emitter_object = dmx_mode:FindRecursive('Dimmer','ChannelFunction').emitter
                        if not dimmer_emitter_object then
                            dimmer_emitter_object = dmx_mode:FindParent('FixtureType').geometries:FindRecursive('Beam','Beam').EMITTERSPECTRUM
                        end
                    local r,g,b = dimmer_emitter_object:Get('color',Enums.Roles.Display):match('^(.*),(.*),(.*),.*')
                    dimmer_emitter = {r*100,g*100,b*100}
                end
            elseif emitter_object then
                color_modifier_object = emitter_object
                color_modifier_data.intensity = color_value[1].absolute
            else
                color_modifier_object = attribute
                color_modifier_data.intensity = color_value[1].absolute
            end
            local r,g,b = color_modifier_object:Get('color',Enums.Roles.Display):match('^(.*),(.*),(.*),.*')
            Echo(string.format('%-8s intensity = %6.2f,r = %6.2f,g = %6.2f, b = %6.2f',color_modifier_object.name,color_modifier_data.intensity,r*100,g*100,b*100))
            color_modifier_data.color = {r*100,g*100,b*100}
            table.insert(color_modifiers,color_modifier_data)
        end
    end
    if is_subtractive then
        return {is_subtractive, dimmer_emitter, color_modifiers}
    else
        return {is_subtractive, color_modifiers}
    end
end

local function main()
    -- require 'gma3_debug'()
    local preset = GetObject('preset 4.'..TextInput(''))
    if preset.presetmode ~= Enums.PresetMode.Universal then
        Confirm('','The preset has to be Universal',nil,false)
        return
    end
    local result = get_color_modifiers(preset)
    local is_subtractive = result[1]
    local rgb
    if is_subtractive then
        rgb = get_rgb_after_filters(result[2],result[3])
    else
        rgb = calculate_emitters_rgb(result[2])
    end
    local appearance = ShowData().appearances:Acquire()
    appearance:Set('imager',rgb[1]*2.55)
    appearance:Set('imageg',rgb[2]*2.55)
    appearance:Set('imageb',rgb[3]*2.55)
    appearance:Set('backr',rgb[1]*2.55)
    appearance:Set('backg',rgb[2]*2.55)
    appearance:Set('backb',rgb[3]*2.55)
    appearance:Set("backalpha", 255)
end

return main