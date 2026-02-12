--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local YB_GMA3_CP_GEN = select(3,...)

local function get_rgb_from_preset(preset)
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
        local factor = brightness / math.max(r,g,b)
        return {r * factor, g * factor, b * factor}
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
        local factor = brightness / math.max(r,g,b)
        return {r * factor, g * factor, b * factor}
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
                --[[ if filter_object then
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
                else ]]if emitter_object then
                    color_modifier_object = emitter_object
                    color_modifier_data.intensity = color_value[1].absolute
                else
                    color_modifier_object = attribute
                    color_modifier_data.intensity = color_value[1].absolute                    
                end
                local r,g,b = color_modifier_object:Get('color',Enums.Roles.Display):match('^(.*),(.*),(.*),.*')
                -- Printf(string.format('%s value = %f,r = %f,g = %f, b = %f',color_modifier_object.name,color_modifier_data.intensity,r*100,g*100,b*100))
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
    local result = get_color_modifiers(preset)
    local is_subtractive = result[1]
    if is_subtractive then
        return get_rgb_after_filters(result[2],result[3])
    else
        return calculate_emitters_rgb(result[2])
    end
end


function YB_GMA3_CP_GEN.create_appearances(user_input,position_appearance_file_names,position_preset_names,declared_timings,naming_prefix)
    --[[
        Function to create appearances
    ]]--
        -- require 'gma3_debug'()
    local picker_type = user_input.picker_type
    local selected_presets = user_input.presets_obj
    local first_appear = user_input.first_appear
    local generate_presets = user_input.generate_presets
    -- local filename_active_end = '_black.png'
    -- local filename_inactive_end = '_white.png'
    local filename_active_inactive_ends = {'_black.png','_white.png'}
    local created_appearances = {}
    local color_presets_for_appearances = selected_presets
    local appear_num = first_appear -- ID of the first appearance in the 
    local total_appear_amount = #selected_presets * 3 + #declared_timings[1]*2 + #declared_timings[2]*2 + #declared_timings[3]*2 + #declared_timings[4]*2
    -- local last_appear_bar = total_appear_amount + appear_num - 1
    local progHandle = StartProgress("Creating Appearances")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    local appearances = ShowData().Appearances
    SetProgressRange(progHandle, 1, total_appear_amount)
    ------------------------- create appearances for sequences ---------------------
    if picker_type == 'color' then
        local appearance_types = {'normal','mark','arrow'}
        for _,appearance_type in ipairs(appearance_types) do
            for i,preset in ipairs(selected_presets) do
                local rgb = get_rgb_from_preset(preset)
                -- Echo(table.concat(rgb,','))
                local appearance = appearances:Create(appear_num)
                table.insert(created_appearances,appearance)
                appearance:Set("backr", rgb[1]*2.55)
                appearance:Set("imager", rgb[1]*2.55)
                appearance:Set("backg", rgb[2]*2.55)
                appearance:Set("imageg", rgb[2]*2.55)
                appearance:Set("backb", rgb[3]*2.55)
                appearance:Set("imageb", rgb[3]*2.55)
                appearance:Set("backalpha", 255)
                if appearance_type == 'normal' then
                    appearance:Set("name",color_presets_for_appearances[i].name)
                elseif appearance_type == 'mark' then
                    appearance:Set('mediafilename','SYMBOL/symbols/x_mark_white.png')
                    appearance:Set("name",color_presets_for_appearances[i].name..' [active]')
                elseif appearance_type == 'arrow' then
                    appearance:Set('mediafilename','SYMBOL/symbols/arrow_down.png')
                    appearance:Set("name",color_presets_for_appearances[i].name..' [arrow]')
                    appearance:Set("imager",0)
                    appearance:Set("imageg",0)
                    appearance:Set("imageb",0)
                    appearance:Set("imagemode",'Crop')
                end
                appear_num = appear_num + 1
                IncProgress(progHandle,1)
            end
        end
    elseif picker_type == 'position' then
        local outline_point_file_name = 'outline_point_white.png'
        local arrow_down_black_file_name = 'arrow_down_black.png'
        for active_inactive_index,active_inactive_end in ipairs(filename_active_inactive_ends) do
            for i,preset in ipairs(selected_presets) do
                local appearance = appearances:Create(appear_num)
                table.insert(created_appearances,appearance)
                if generate_presets then
                    local filename = position_appearance_file_names[i]
                    appearance:Set('mediafilename','SYMBOL/symbols/'..filename..active_inactive_end)
                    if active_inactive_index == 1 then
                        appearance:Set('name',naming_prefix..position_preset_names[i]..' [Active]')
                    else
                        appearance:Set('name',naming_prefix..position_preset_names[i])
                    end
                else
                    appearance:Set('mediafilename','SYMBOL/symbols/'..outline_point_file_name)
                    appearance:Set("imager",255)
                    appearance:Set("imageg",255)
                    appearance:Set("imageb",255)
                    appearance:Set("backalpha", 0)
                    if active_inactive_index == 1 then
                        appearance:Set('name',naming_prefix..preset.name..' [Active]')
                    else
                        appearance:Set('name',naming_prefix..preset.name)
                    end
                end
                appear_num = appear_num + 1
            end
        end
        local appearance = appearances:Create(appear_num)
        table.insert(created_appearances,appearance)
        appearance:Set('mediafilename','SYMBOL/symbols/'..arrow_down_black_file_name)
        appearance:Set("name",naming_prefix..'ALL')
        appear_num = appear_num + 1

    end
    ------------------------- create appearances for tming macros ---------------------
    local filename_start = 'number_'
    local timing_appearances_subgroup_data = {
        {subgroup_name='Fade',backr=0,backg=0,backb=0,imager=0,imageg=255,imageb=0,sub_group=declared_timings[1]},
        -- {subgroup_name='DelayFrom',backr=0,backg=0,backb=0,imager=255,imageg=127,imageb=0,sub_group=declared_timings[2]},
        {subgroup_name='Delay',backr=0,backg=0,backb=0,imager=255,imageg=127,imageb=0,sub_group=declared_timings[2]},
        {subgroup_name='Group',backr=0,backg=0,backb=0,imager=255,imageg=0,imageb=0,sub_group=declared_timings[3]},
        {subgroup_name='Wings',backr=0,backg=0,backb=0,imager=0,imageg=255,imageb=255,sub_group=declared_timings[4]},
    }
    for _,values in ipairs(timing_appearances_subgroup_data) do
        for active_inactive_index,active_inactive_end in ipairs(filename_active_inactive_ends) do
            for ind = 1, #values.sub_group do
                local time = values.sub_group[ind]
                local appearance = appearances:Create(appear_num)
                table.insert(created_appearances,appearance)
                appearance:Set("backr",values.backr)
                appearance:Set("imager",values.imager)
                appearance:Set("backg",values.backg)
                appearance:Set("imageg",values.imageg)
                appearance:Set("backb",values.backb)
                appearance:Set("imageb",values.imageb)
                appearance:Set("backalpha", 0)
                if active_inactive_index == 1 then
                    appearance:Set("name",naming_prefix..values.subgroup_name..' ['..tostring(time):gsub('%.','')..'] [active]')
                    if type(time) == 'string' then
                        local new_circle_path = GetPath(Enums.PathType.SymbolImageLibrary)..'/symbols/'..'circle_white.png'
                        if FileExists(new_circle_path) then
                            appearance:Set('mediafilename','SYMBOL/symbols/'..'circle_white.png')
                        else
                            appearance:Set('mediafilename','SYMBOL/symbols/'..'media_stop'..active_inactive_end)
                        end
                    else
                        appearance:Set('mediafilename','SYMBOL/symbols/'..filename_start..time..active_inactive_end)
                    end
                elseif active_inactive_index == 2 then
                    appearance:Set("name",naming_prefix..values.subgroup_name..' ['..tostring(time):gsub('%.','')..']')
                    if type(time) == 'string' then
                        appearance:Set('mediafilename','SYMBOL/symbols/'..'calculator'..active_inactive_end)
                    else
                        appearance:Set('mediafilename','SYMBOL/symbols/'..filename_start..time..active_inactive_end)
                    end
                end
                appear_num = appear_num + 1
                IncProgress(progHandle,1)
            end
            if active_inactive_index == 1 then
                appearances[appear_num-1]:Set("name",naming_prefix..values.subgroup_name..' [INPUT]'..' [active]')
            elseif active_inactive_index == 2 then
                appearances[appear_num-1]:Set("name",naming_prefix..values.subgroup_name..' [INPUT]')
            end
            if values.subgroup_name == 'Delay' and active_inactive_index == 2 then
                local appearance = appearances:Create(appear_num)
                table.insert(created_appearances,appearance)
                appearance:Set("name",naming_prefix..values.subgroup_name..' direction_straight')
                appearance:Set('mediafilename','SYMBOL/symbols/'..'arrow_right_black.png')
                appearance:Set("backr",values.backr)
                appearance:Set("imager",values.imager)
                appearance:Set("backg",values.backg)
                appearance:Set("imageg",values.imageg)
                appearance:Set("backb",values.backb)
                appearance:Set("imageb",values.imageb)
                appearance:Set("backalpha", 0)
                appear_num = appear_num + 1
                appearance = appearances:Create(appear_num)
                table.insert(created_appearances,appearance)
                appearance:Set("name",naming_prefix..values.subgroup_name..' direction_reverse')
                appearance:Set('mediafilename','SYMBOL/symbols/'..'arrow_left_black.png')
                appearance:Set("backr",values.backr)
                appearance:Set("imager",values.imager)
                appearance:Set("backg",values.backg)
                appearance:Set("imageg",values.imageg)
                appearance:Set("backb",values.backb)
                appearance:Set("imageb",values.imageb)
                appearance:Set("backalpha", 0)
                appear_num = appear_num + 1
            end
        end
    end
    ----------------- appearance for Favourites ----------------------
    local appearance = appearances:Create(appear_num)
    table.insert(created_appearances,appearance)
    appearance:Set('mediafilename','SYMBOL/symbols/outline_star_white.png')
    appearance:Set("imager",255)
    appearance:Set("imageg",255)
    appearance:Set("imageb",255)
    appearance:Set("name", naming_prefix..'Favourites')
    IncProgress(progHandle,1)
    appear_num = appear_num + 1

    appearance = appearances:Create(appear_num)
    table.insert(created_appearances,appearance)
    appearance:Set("backr", 0)
    appearance:Set("backg", 0)
    appearance:Set("backb", 0)
    appearance:Set("backalpha", 255)
    appearance:Set("imager", 0)
    appearance:Set("imageg", 0)
    appearance:Set("imageb", 0)
    appearance:Set("imagealpha", 255)
    appearance:Set("name", naming_prefix..'Black Back')
    appear_num = appear_num + 1
    IncProgress(progHandle,1)

    ----------------------- Red Appearance ---------------------------------------
    appearance = appearances:Create(appear_num)
    table.insert(created_appearances,appearance)
    appearance:Set("backr", 255)
    appearance:Set("backg", 0)
    appearance:Set("backb", 0)
    appearance:Set("backalpha", 120)
    appearance:Set("name", naming_prefix..'Red Back')
    IncProgress(progHandle,1)
    StopProgress(progHandle)
    appear_num = appear_num + 1
    return created_appearances
end