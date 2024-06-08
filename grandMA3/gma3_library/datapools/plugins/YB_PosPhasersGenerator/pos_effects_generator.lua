--[[ grandMA3 Moving Phaser Engine creator v 1.1]]
--[[ Created by Yury Belousov ]]

local gl_start_pos_x = -480-- starting x point for layout elements
local gl_start_pos_y = 150 -- starting y point for layout elements
local gl_gap_x = 60 -- x-gap between layout elements
local gl_gap_y = 60 -- y-gap between layout elements
local gl_size_x = 50 -- height of layout elements
local gl_size_y = 50 -- width of layout elements
--------------------------------------------------------------------
------------- Don't change anything below this line ----------------
--------------------------------------------------------------------
local POS_EFFECTS_ENGINE_CREATOR = select(3,...)
local C = Cmd
local TI = TextInput
local E = Echo

local function import_symbol(filename)
    local symbols_pool = ShowData().mediapools.symbols
    if not symbols_pool['['..filename:gsub('%.','_')..']'] then
        local symbol_handle = symbols_pool:Aquire()
        local path = GetPath(Enums.PathType.SymbolImageLibrary)
        -- symbol_handle:Import(path,filename..'.xml')
        C('Import Image 2.'..symbol_handle.no..' /File "'..filename..'.xml" /Path "'..path..'" /o /nu')
        coroutine.yield(0)
    end
end

local function checkifmovingfixture(group,DP)
    local groupselectiondata = ShowData().DataPools[DP].Groups[group].selectiondata
    local result = true
    if #groupselectiondata == 0 then
      result = false
    else
      for i=1, #groupselectiondata do
        local subfixtureindex = groupselectiondata[i].sf_index
        local uichannels = GetUIChannels(GetSubfixture(subfixtureindex),true)
        local pan = false
        local tilt = false
        for ind=1,#uichannels do
          local subattribute = uichannels[ind].subattribute
          if subattribute == 'Pan' then
            pan = true
          end
          if subattribute == 'Tilt' then
            tilt = true
          end
        end
        if not pan or not tilt then
          result = false
          break
        end
      end
    end
    -- Echo(group..' '..tostring(result))
    return result
end

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
        -- local sumz = last - first
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
            if object_pool[result[ind]] == nil or #object_pool[result[ind]].selectiondata == 0 then
                table.remove(result,ind)
                deleted = true
                ind = ind
                amount_of_entries = #result
            else
                ind = ind + 1
            end
        end
        if deleted then
            Confirm('Empty/not existing groups deleted from range')
        end
        -- for k,v in pairs(result) do
        --     Echo(k..' '..v)
        -- end
    end
    -- Echo(result)
    return result
end

function POS_EFFECTS_ENGINE_CREATOR.get_groups(DP)
    local DONE = '[DONE]'
    local userInput
    local cp_groups = {}
    local gp_i = 1
    local last_line
    local groups_pool = ShowData().DataPools[DP].Groups
    repeat
        userInput = get_groups_input_with_ranges(TI('Enter group ID or range in format: X Thru Y', DONE),DONE,groups_pool)
        if userInput ~= '' and userInput ~= nil then
            if userInput ~= DONE then
                if type(userInput) ~= 'table' and groups_pool[userInput] == nil then
                    Confirm('Group doen\'t exist','Non-existing group can\'t be referenced by recipes and will be removed.')
                elseif type(userInput) ~= 'table' then
                    if checkifmovingfixture(userInput,DP) then
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
                    else
                        Confirm('Not suitable Group','Group is empty of not all the fixtures in the group have Pan and Tilt.')
                    end
                elseif type(userInput) == 'table' then
                    local pantiltsuitable = true
                    for ind = 1, #userInput do
                        local exists
                        if checkifmovingfixture(userInput[ind],DP) then
                            for idx = 1, #cp_groups do
                                if cp_groups[idx] == userInput[ind] then
                                    exists = true
                                end
                            end
                            if not exists then
                                table.insert(cp_groups,userInput[ind])
                            end
                        else
                           pantiltsuitable = false
                        end
                    end
                    if not pantiltsuitable then
                        Confirm('Not suitable Groups','One ore more Groups from the range are empty or not all fixtures in these Groups have Pan and Tilt. Groups were deleted from the range.')                         
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

function POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(object_amount,pool)
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
      userInput = TI(msg, placeholder)
      userInput = userInput:match('%D*(%d+)%D*')
    until userInput ~= placeholder and userInput ~= nil
    return userInput
end

function POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num(message,suggested,object_amount,pool)
    local result = false
    local input = tonumber(get_suitable_user_input(message,suggested))
    local last_pool_obj = input + object_amount - 1
        repeat
            while input <= last_pool_obj and result == false do
                if pool[input] ~= nil then
                    result = false
                    Confirm('Occupied / Not enoug space')
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

function POS_EFFECTS_ENGINE_CREATOR.create_name_prefix(DP)
    local macro_pool = ShowData().datapools[DP].Macros
    local all1_presets_pool = ShowData().datapools[DP].PresetPools[2]
    local appearances_pool = ShowData().Appearances
    local matricks_pool = ShowData().DataPools[DP].MAtricks
    local groups_pool = ShowData().DataPools[DP].Groups
    local layouts_pool = ShowData().datapools[DP].Layouts
    local sequence_pool = ShowData().datapools[DP].Sequences
    local pools = {macro_pool,all1_presets_pool,appearances_pool,matricks_pool,layouts_pool,sequence_pool}
    local prefix_index = 1
    local prefix = 'MPE'..tostring(prefix_index)..'_'
    local obj_i = 1
    local pools_i = 1
    local detected = false
    repeat
        repeat
            if #pools[pools_i]:Children() ~= 0 and string.match(pools[pools_i]:Children()[obj_i].name,prefix) then
                prefix_index = prefix_index + 1
                detected = true
                prefix = 'MPE'..tostring(prefix_index)..'_'
                obj_i = 1
            end
            obj_i = obj_i + 1
        until pools[pools_i]:Children()[obj_i] == nil
        obj_i = 1
        if detected then
            pools_i = 1
            detected = false
        else
            pools_i = pools_i + 1
        end
    until pools[pools_i] == nil
    return prefix
end

function POS_EFFECTS_ENGINE_CREATOR.declare_timing_values()
    local fades = {}
        fades[1] = 0
        fades[2] = 1
        fades[3] = 2
        fades[4] = 4
        fades[5] = '(Movement Engine X Fade)'
        fades['appearanceR'] = 0
        fades['appearanceG'] = 100
        fades['appearanceB'] = 0
    local delays_from = {}
        delays_from[1] = 0
        delays_from[2] = 1
        delays_from[3] = 2
        delays_from[4] = 4
        delays_from[5] = '(Movement Engine X Delay-from)'
        delays_from['appearanceR'] = 100
        delays_from['appearanceG'] = 50
        delays_from['appearanceB'] = 0
    local delays_to = {}
        delays_to[1] = 0
        delays_to[2] = 1
        delays_to[3] = 2
        delays_to[4] = 4
        delays_to[5] = '(Movement Engine X Delay-to)'
        delays_to['appearanceR'] = 100
        delays_to['appearanceG'] = 50
        delays_to['appearanceB'] = 0
    local groups = {}
        groups[1] = 0
        groups[2] = 2
        groups[3] = 3
        groups[4] = 4
        groups[5] = '(Movement Engine X Groups)'
        groups['appearanceR'] = 100
        groups['appearanceG'] = 0
        groups['appearanceB'] = 0
    local blocks = {}
        blocks[1] = 0
        blocks[2] = 2
        blocks[3] = 3
        blocks[4] = 4
        blocks[5] = '(Movement Engine X Blocks)'
        blocks['appearanceR'] = 50
        blocks['appearanceG'] = 0
        blocks['appearanceB'] = 100
    local phase = {}
        phase[1] = 0
        phase[2] = 90
        phase[3] = 180
        phase[4] = 270
        phase[5] = 360
        phase['appearanceR'] = 100
        phase['appearanceG'] = 100
        phase['appearanceB'] = 100
    local result = {phase,groups,blocks,fades,delays_from,delays_to}
    return result
end

function POS_EFFECTS_ENGINE_CREATOR.declare_filenames()
    local filenames = {
        'pos_straight_black.png',
        'pos_straight_white.png',
        'pos_fan_in_black.png',
        'pos_fan_in_white.png',
        'pos_fan_out_black.png',
        'pos_fan_out_white.png',
        'pos_cross_black.png',
        'pos_cross_white.png',
        'pos_up_straight_black.png',
        'pos_up_straight_white.png',
        'pos_up_fan_in_black.png',
        'pos_up_fan_in_white.png',
        'pos_up_fan_out_black.png',
        'pos_up_fan_out_white.png',
        'pos_up_cross_black.png',
        'pos_up_cross_white.png'
    }
    return filenames
end

function POS_EFFECTS_ENGINE_CREATOR.create_appearances(selected_presets, first_appear,filenames,in_declared_timings,choise,naming_prefix,progress_bar_time,DP)
    --[[
        Function to create appearances
    ]]--
    C('cd 13.2.2')
    C('call library')
    C('cd root')

    local software_version = Version()
    local appearances = ShowData().Appearances
    local all1_preset_pool = ShowData().datapools[DP].PresetPools[21]
    
    local fades = in_declared_timings[4]
    local delays_from = in_declared_timings[5]
    local delays_to = in_declared_timings[6]
    local xgroups = in_declared_timings[2]
    local xblocks = in_declared_timings[3]
    local xphase = in_declared_timings[1]
    
    local switch_filename_active = 'switch_horizontal_right_black.png'
    local switch_filename = 'switch_horizontal_left_white.png'
    local switch_name = 'switch'
    
    local group_filename = 'group1.png'
    local group_name = 'group'

    local forms_filenames_active = {'center_out_black.png','center_out_90_black.png','outline_circle_black.png','infinity_black.png'}
    local forms_filenames = {'center_out_white.png','center_out_90_white.png','outline_circle_white.png','infinity_white.png'}
    local forms_names = {'form_pan','form_tilt','form_circle','form_eight'}
    local forms_data = {forms_filenames_active,forms_filenames,forms_names}

    local selection_order_filenames = {'in_order_white.png','shuffle_white.png'}
    local selection_order_filenames_active = {'in_order_black.png','shuffle_black.png'}
    for name=1,#selection_order_filenames do
        import_symbol(selection_order_filenames[name])
        import_symbol(selection_order_filenames_active[name])
    end
    local selection_order_names = {'in_order','shuffle'}
    local selection_order_data = {selection_order_filenames_active,selection_order_filenames,selection_order_names}

    local mirror_filenames = {'mirrored_white.png','non_mirrored_white.png'}
    local mirror_filenames_active = {'mirrored_black.png','non_mirrored_black.png'}
    for name=1,#mirror_filenames do
        import_symbol(mirror_filenames[name])
        import_symbol(mirror_filenames_active[name])
    end
    local mirror_names = {'mirrored','non_mirrored'}
    local mirror_data = {mirror_filenames_active,mirror_filenames,mirror_names}

    local first_appearances_group = {forms_data,selection_order_data,mirror_data}

    local fade_filenames_active = {'number_'..fades[1]..'_black.png','number_'..fades[2]..'_black.png','number_'..fades[3]..'_black.png','number_'..fades[4]..'_black.png','calculator_black.png'}
    local fade_filenames = {'number_'..fades[1]..'_white.png','number_'..fades[2]..'_white.png','number_'..fades[3]..'_white.png','number_'..fades[4]..'_white.png','calculator_white.png'}
    local fade_names = {'xfade_0','xfade_1','xfade_2','xfade_4','xfade_input'}
    local fade_data = {fade_filenames_active,fade_filenames,fade_names}
    
    local delays_from_filenames_active = fade_filenames_active
    local delays_from_filenames = fade_filenames
    local delays_from_names = {'xdelay_from_0','xdelay_from_1','xdelay_from_2','xdelay_from_4','xdelay_from_input'}
    local delays_from_data = {delays_from_filenames_active,delays_from_filenames,delays_from_names}
    
    local delays_to_filenames_active = fade_filenames_active
    local delays_to_filenames = fade_filenames
    local delays_to_names = {'xdelay_to_0','xdelay_to_1','xdelay_to_2','xdelay_to_4','xdelay_to_input'}
    local delays_to_data = {delays_to_filenames_active,delays_to_filenames,delays_to_names}
    
    local xgroups_filenames_active = {'number_'..xgroups[1]..'_black.png','number_'..xgroups[2]..'_black.png','number_'..xgroups[3]..'_black.png','number_'..xgroups[4]..'_black.png','calculator_black.png'}
    local xgroups_filenames = {'number_'..xgroups[1]..'_white.png','number_'..xgroups[2]..'_white.png','number_'..xgroups[3]..'_white.png','number_'..xgroups[4]..'_white.png','calculator_white.png'}
    local xgroups_names = {'xgroup_0','xgroup_2','xgroup_3','xgroup_4','xgroup_input'}
    local xgroups_data = {xgroups_filenames_active,xgroups_filenames,xgroups_names}
    
    local xblocks_filenames_active = xgroups_filenames_active
    local xblocks_filenames = xgroups_filenames
    local xblocks_names = {'xblock_0','xblock_2','xblock_3','xblock_4','xblock_input'}
    local xblocks_data = {xblocks_filenames_active,xblocks_filenames,xblocks_names}

    local xphase_filenames_active = {'arrow_left_black.png','0_degree_black.png','90_degree_black.png','180_degree_black.png','360_degree_black.png'}
    local xphase_filenames = {'arrow_right_white.png','0_degree_white.png','90_degree_white.png','180_degree_white.png','360_degree_white.png'}
    for name=2,#xphase_filenames do
        import_symbol(xphase_filenames[name])
        import_symbol(xphase_filenames_active[name])
    end
    local xphase_names = {'xphase_invert','xphase_0','xphase_90','xphase_180','xphase_360'}
    local xphase_data = {xphase_filenames_active,xphase_filenames,xphase_names}
    
    local second_appearances_group = {xphase_data,xgroups_data,xblocks_data,fade_data,delays_from_data,delays_to_data}

    local appear_amount = 2 + 2 + #forms_filenames_active*2 + #selection_order_filenames_active*2 + #mirror_filenames_active*2 + 5*2*#in_declared_timings + 1  -- 2 for group symbols, 2 for switch symbol, 4*2 for forms symbols, 2*2 for selection order symbols, 2*2 for mirror symbols, 5*2*6 for matricks settings symbols, 1 is for one additional appearance for macro
    local appear_ind = first_appear
    local last_appear = first_appear + appear_amount - 1
    ---------------------- creating appearances ----------------
    -- C('delete appearance 1501 thru 1581 /nc')
    C('store appearance '..appear_ind..' thru '..last_appear..' /nu')
    -- switch appearance
    appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..switch_filename_active)
    appearances[appear_ind]:Set("imager",255)
    appearances[appear_ind]:Set("imageg",255)
    appearances[appear_ind]:Set("imageb",255)
    appearances[appear_ind]:Set("name", naming_prefix..switch_name..' [active]')
    appear_ind = appear_ind + 1
    appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..switch_filename)
    appearances[appear_ind]:Set("imager",255)
    appearances[appear_ind]:Set("imageg",255)
    appearances[appear_ind]:Set("imageb",255)
    appearances[appear_ind]:Set("name", naming_prefix..switch_name)
    appear_ind = appear_ind + 1
    -- group appearance 
    appearances[appear_ind]:Set('mediafilename','SYMBOL/object/'..group_filename)
    appearances[appear_ind]:Set("imager",255)
    appearances[appear_ind]:Set("imageg",255)
    appearances[appear_ind]:Set("imageb",255)
    appearances[appear_ind]:Set("IMAGEALPHA",255)
    appearances[appear_ind]:Set("name", naming_prefix..group_name..' [active]')
    appear_ind = appear_ind + 1
    appearances[appear_ind]:Set('mediafilename','SYMBOL/object/'..group_filename)
    appearances[appear_ind]:Set("imager",255)
    appearances[appear_ind]:Set("imageg",255)
    appearances[appear_ind]:Set("imageb",255)
    appearances[appear_ind]:Set("IMAGEALPHA",30*2.55)
    appearances[appear_ind]:Set("name", naming_prefix..group_name)
    appear_ind = appear_ind + 1
    -- forms, shufffle, mirror appearances
    for type=1,#first_appearances_group do
        for ind=1,#first_appearances_group[type][1] do
            appearances[appear_ind]:Set("backr",0)
            appearances[appear_ind]:Set("imager",255)
            appearances[appear_ind]:Set("backg",0)
            appearances[appear_ind]:Set("imageg",255)
            appearances[appear_ind]:Set("backb",0)
            appearances[appear_ind]:Set("imageb",255)
            appearances[appear_ind]:Set("backalpha", 0)
            appearances[appear_ind]:Set("name",naming_prefix..first_appearances_group[type][3][ind]..' [active]')
            appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..first_appearances_group[type][1][ind])
            appear_ind = appear_ind + 1
            appearances[appear_ind]:Set("backr",0)
            appearances[appear_ind]:Set("imager",255)
            appearances[appear_ind]:Set("backg",0)
            appearances[appear_ind]:Set("imageg",255)
            appearances[appear_ind]:Set("backb",0)
            appearances[appear_ind]:Set("imageb",255)
            appearances[appear_ind]:Set("backalpha", 0)
            appearances[appear_ind]:Set("name",naming_prefix..first_appearances_group[type][3][ind])
            appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..first_appearances_group[type][2][ind])
            appear_ind = appear_ind + 1
        end
    end
    -- matricks appearances
    for type=1,#second_appearances_group do
        for ind=1,#second_appearances_group[type][1] do
            appearances[appear_ind]:Set("backr",0)
            appearances[appear_ind]:Set("imager",in_declared_timings[type]['appearanceR']*2.55)
            appearances[appear_ind]:Set("backg",0)
            appearances[appear_ind]:Set("imageg",in_declared_timings[type]['appearanceG']*2.55)
            appearances[appear_ind]:Set("backb",0)
            appearances[appear_ind]:Set("imageb",in_declared_timings[type]['appearanceB']*2.55)
            appearances[appear_ind]:Set("backalpha", 0)
            appearances[appear_ind]:Set("name",naming_prefix..second_appearances_group[type][3][ind]..' [active]')
            appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..second_appearances_group[type][1][ind])
            appear_ind = appear_ind + 1
            appearances[appear_ind]:Set("backr",0)
            appearances[appear_ind]:Set("imager",in_declared_timings[type]['appearanceR']*2.55)
            appearances[appear_ind]:Set("backg",0)
            appearances[appear_ind]:Set("imageg",in_declared_timings[type]['appearanceG']*2.55)
            appearances[appear_ind]:Set("backb",0)
            appearances[appear_ind]:Set("imageb",in_declared_timings[type]['appearanceB']*2.55)
            appearances[appear_ind]:Set("backalpha", 0)
            appearances[appear_ind]:Set("name",naming_prefix..second_appearances_group[type][3][ind])
            appearances[appear_ind]:Set('mediafilename','SYMBOL/symbols/'..second_appearances_group[type][2][ind])
            appear_ind = appear_ind + 1
        end
    end
    appearances[appear_ind]:Set("backr", 255)
    appearances[appear_ind]:Set("backg", 0)
    appearances[appear_ind]:Set("backb", 0)
    appearances[appear_ind]:Set("backalpha", 120)
    appearances[appear_ind]:Set("name", naming_prefix..'Red Back')
    appear_ind = appear_ind + 1

    last_appear = appear_ind
    return last_appear
end

function POS_EFFECTS_ENGINE_CREATOR.import_predefined_phasers(all1_presets_pool,first_preset,naming_prefix)
    local predefined_import_num = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(111,all1_presets_pool) -- 111 for 107 predefined presets and four presets for pan, tilt, circle, eight
    C('import preset 21.'..predefined_import_num..' /File "predefined_phaser.xml" /nu')
    local pan_phaser_num = predefined_import_num + 12 - 1
    local tilt_phaser_num = predefined_import_num + 11 - 1
    local circle_phaser_num = predefined_import_num + 7 - 1
    local eight_phaser_num = predefined_import_num + 9 - 1
    C('copy preset 21.'..pan_phaser_num..' + '..tilt_phaser_num..' + '..circle_phaser_num..' + '..eight_phaser_num..' at 21.'..(predefined_import_num + 107)..' /nu')
    C('delete preset 21.'..predefined_import_num..' thru '..(predefined_import_num+107-1)..' /nc /nu')
    C('move preset 21.'..(predefined_import_num + 107)..' thru '..(predefined_import_num + 111 - 1).. ' at preset 21.'..first_preset..' /nu')
    all1_presets_pool[first_preset]:Set('name',naming_prefix..'pan_sin')
    all1_presets_pool[first_preset+1]:Set('name',naming_prefix..'tilt_sin')
    all1_presets_pool[first_preset+2]:Set('name',naming_prefix..'circle')
    all1_presets_pool[first_preset+3]:Set('name',naming_prefix..'eight')
end

function POS_EFFECTS_ENGINE_CREATOR.create_matricks(first_matricks,naming_prefix,index)
    C('store matricks '..first_matricks..' "'..naming_prefix..index..'_phaser_engine"'..' /nu')
end

function POS_EFFECTS_ENGINE_CREATOR.create_sequence(first_sequence,group_amount,first_appearance,first_preset,first_matrick,sequence_pool,selected_page,naming_prefix,index,DP)
    local appearances_pool = ShowData().appearances
    local executor = 101 + index - 1
    C('store sequence '..first_sequence..' "'..naming_prefix..index..'_phaser_engine" /nu')
    C('store sequence '..first_sequence..' cue 1 part 0.1 thru'..group_amount..' /nu')
    C('assign preset 21.'..first_preset..' at sequence '..first_sequence..' cue 1 part 0.* /nu')
    C('assign matricks '..first_matrick..' at sequence '..first_sequence..' cue 1 part 0.* /nu')
    sequence_pool[first_sequence]:Set('appearance',appearances_pool[first_appearance+1].name)
    sequence_pool[first_sequence]:Set('prefercueappearance',true)
    -- sequence_pool[first_sequence]:Set('speedmaster','Speed1')
    sequence_pool[first_sequence][3][1]:Set('appearance',appearances_pool[first_appearance].name)
    C('assign sequence '..first_sequence..' at page '..selected_page..'.'..executor..' /nu')
    local button_excutor = ObjectList('page '..selected_page..'.'..(executor))[1]
    C('set page '..selected_page..'.'..executor..' property "height" 3 /nu')
    button_excutor:Set('key','LearnSpeed')
    local fader_excutor = ObjectList('page '..selected_page..'.'..(executor+100))[1]
    fader_excutor:Set('fader','Temp')
    fader_excutor:Set('key','HalfSpeed')
    local encoder_execitor = ObjectList('page '..selected_page..'.'..(executor+200))[1]
    encoder_execitor:Set('fader','Speed')
    encoder_execitor:Set('key','DoubleSpeed')
end

function POS_EFFECTS_ENGINE_CREATOR.create_macros(groups,first_macro,first_sequence,first_matrick,first_appearance,first_preset,in_declared_timings,naming_prefix,index,DP)
    local macro_pool = ShowData().datapools[DP].Macros
    local appearances_pool = ShowData().Appearances
    local groups_pool = ShowData().DataPools[DP].Groups
    local sequence_pool = ShowData().datapools[DP].Sequences
    local all1_presets_pool = ShowData().datapools[DP].PresetPools[21]
    local matricks_pool = ShowData().DataPools[DP].MAtricks
    local preset_amount = 4
    local switch_appearance_amount = 2
    local groups_appearance_amount = 2
    local forms_macros_amount = preset_amount
    local order_macros_amount = 2
    local mirror_macros_amount = 2
    local matricks_macros_amount = 5*6
    local reset_macro = 1
    local macros_amount = #groups + forms_macros_amount + order_macros_amount + mirror_macros_amount + matricks_macros_amount + reset_macro -- 4 for forms, 2  for order, 2 for mirror, 5*6 for matricks
    local last_macro = first_macro+macros_amount-1
    C('store macro '..first_macro..' thru '..last_macro..' /nu')
    -- create group endble/disable macros
    local sequence_ind = first_sequence
    local sequence_name = sequence_pool[sequence_ind].name
    local matrick_name = matricks_pool[first_matrick].name
    local macro_ind = first_macro
    local macros_gap
    local appearance_gap
    for i=1,#groups do
        local active_group_appearance = appearances_pool[first_appearance + switch_appearance_amount].name
        local inactive_group_appearance = appearances_pool[first_appearance + switch_appearance_amount + 1].name
        local lua_command = [[
            Lua "
            if not DataPool().Sequences[']]..sequence_name..[['][3][1][]]..i..[[].selection then 
                Cmd('Assign Group \']]..groups_pool[groups[i]].name..[[\' At Sequence \']]..sequence_name..[[\' Cue 1 Part 0.]]..i..[[ /nu') 
                Cmd('Assign Appearance \']]..active_group_appearance..[[\' at Macro \']]..naming_prefix..index..'_group_'..groups[i]..[[\' /nu') 
            else 
                Cmd('Set Sequence \']]..sequence_name..[[\' Cue 1 Part 0.]]..i..[[ \'selection\' \'None\' /nu') 
                Cmd('Assign Appearance \']]..inactive_group_appearance..[[\' at Macro \']]..naming_prefix..index..'_group_'..groups[i]..[[\' /nu') 
            end
            "
            ]]
            lua_command = lua_command:gsub('\n%s+',' ')
            C('store macro '..macro_ind..'.1 /nu')
        macro_pool[macro_ind][1]:Set('command',lua_command)
        macro_pool[macro_ind]:Set('name',naming_prefix..index..'_group_'..groups[i])
        macro_pool[macro_ind]:Set('appearance',inactive_group_appearance)
        macro_ind = macro_ind + 1
    end
    -- create forms macros
    appearance_gap = switch_appearance_amount + groups_appearance_amount
    macros_gap = #groups
    for preset_ind=first_preset, (first_preset+preset_amount-1) do
        local preset_name = all1_presets_pool[preset_ind].name
        local macro_name = naming_prefix..index..'_form_'..preset_name:match(naming_prefix..'(.*)')
        macro_pool[macro_ind]:Set('name',macro_name)
        macro_ind = macro_ind + 1
    end
    local forms_appearance_iterator = 1
    macro_ind = macro_ind - preset_amount
    for preset_ind=first_preset, (first_preset+preset_amount-1) do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+forms_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+forms_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local preset_name = all1_presets_pool[preset_ind].name
        local macro_name = naming_prefix..index..'_form_'..preset_name:match(naming_prefix..'(.*)')
        local cmd_1 = "Assign Preset 21.'"..preset_name.."' At Sequence '"..sequence_name.."' Cue 1 Part 0.* /nu"
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(forms_macros_amount*2),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        forms_appearance_iterator = forms_appearance_iterator + 2
        macro_ind = macro_ind + 1
    end
    -- create selection order macros    
    appearance_gap = appearance_gap + forms_macros_amount*2
    macros_gap = macros_gap + forms_macros_amount
    for matricks_macros_appearance_iterator = 1,(order_macros_amount+1),2 do
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        macro_pool[macro_ind]:Set('name',macro_name)
        macro_ind = macro_ind + 1
    end
    macro_ind = macro_ind - order_macros_amount
    for matricks_macros_appearance_iterator = 1,(order_macros_amount+1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local cmd_1
        if matricks_macros_appearance_iterator == 1 then
            cmd_1 = 'Set MAtricks "'..matrick_name..'" "xshuffle" 0 /nu; Set MAtricks "'..matrick_name..'" "yshuffle" 0 /nu; Set MAtricks "'..matrick_name..'" "zshuffle" 0 /nu'
        elseif matricks_macros_appearance_iterator == (order_macros_amount+1) then
            cmd_1 = 'Set MAtricks "'..matrick_name..'" Property DoShuffle 1 /nu; Cook Sequence "'..sequence_name..'" Cue 1 /Merge /nu'
        end
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(order_macros_amount+1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- create mirror macros  
    appearance_gap = appearance_gap + order_macros_amount*2
    macros_gap = macros_gap + order_macros_amount
    for matricks_macros_appearance_iterator = 1,(order_macros_amount+1),2 do
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        macro_pool[macro_ind]:Set('name',macro_name)
        macro_ind = macro_ind + 1
    end
    macro_ind = macro_ind - mirror_macros_amount
    for matricks_macros_appearance_iterator = 1,(order_macros_amount+1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local cmd_1
        if matricks_macros_appearance_iterator == 1 then
            cmd_1 = 'Set MAtricks "'..matrick_name..'" "xwings" 2 /nu; Set MAtricks "'..matrick_name..'" "phasertransform" "Mirror" /nu'
        elseif matricks_macros_appearance_iterator == (order_macros_amount+1) then
            cmd_1 = 'Set MAtricks "'..matrick_name..'" "xwings" 0 /nu; Set MAtricks "'..matrick_name..'" "phasertransform" "None" /nu'
        end
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(order_macros_amount+1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    ------------------------------------------
    -- create matricks macros ----------------
    appearance_gap = appearance_gap + mirror_macros_amount*2
    macros_gap = macros_gap + mirror_macros_amount
    for matricks_macros_appearance_iterator = 1,(matricks_macros_amount*2-1),2 do
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        macro_pool[macro_ind]:Set('name',macro_name)
        macro_ind = macro_ind + 1
    end
    macro_ind = macro_ind - matricks_macros_amount
    local active_phase_switch_appearance = appearances_pool[first_appearance + appearance_gap].name
    local inactive_phase_switch_appearance = appearances_pool[first_appearance + appearance_gap + 1].name
    local phase_switch_macro_name = macro_pool[macro_ind].name
    local lua_command = [[
        Lua "
        local matrick = DataPool().matricks[']]..matrick_name..[[']
        local phasetox = matrick:Get('phasetox',Enums.Roles.Display)
        phasetox = phasetox:match('(%-?%d+).*')
        if tonumber(phasetox) and tonumber(phasetox) > 0 then
            phasetox = - phasetox
            matrick:Set('phasetox',phasetox)
            Cmd('Assign Appearance \']]..active_phase_switch_appearance..[[\' at macro \']]..phase_switch_macro_name..[[\'')
        elseif tonumber(phasetox) and tonumber(phasetox) < 0 then
            phasetox = math.abs(phasetox)
            matrick:Set('phasetox',phasetox)
            Cmd('Assign Appearance \']]..inactive_phase_switch_appearance..[[\' at macro \']]..phase_switch_macro_name..[[\'')
        end
        "
        ]]
    lua_command = lua_command:gsub('\n%s+',' ')
    C('store macro '..macro_ind..'.1 /nu')
    macro_pool[macro_ind][1]:Set('command',lua_command)
    macro_pool[macro_ind]:Set('appearance',inactive_phase_switch_appearance)
    macro_ind = macro_ind + 1

    -- phase macros
    appearance_gap = appearance_gap + 1*2 -- 1 for 1 switch macro
    macros_gap = macros_gap + 1
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-2-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local phaseto = macro_name:match(naming_prefix..index..'_xphase_(.+)')
        local cmd_1 = 'Set MAtricks "'..matrick_name..'" "phasefromx" 0 /nu; Set MAtricks "'..matrick_name..'" "phasetox" '..phaseto..' /nu'
        local cmd_2 = 'Assign appearance "'..inactive_phase_switch_appearance..'" at macro "'..phase_switch_macro_name..'" /nu; '
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-2-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- groups macros
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2) - 1*2 -- 1 for 1 switch macro
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6) - 1
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local xgroups = macro_name:match(naming_prefix..index..'_xgroup_(.+)')
        if xgroups == 'input' then
            xgroups = '()'
        end
        local cmd_1 = 'Set MAtricks "'..matrick_name..'" "xgroup" '..xgroups..' /nu'
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- blocks macros
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2)
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6)
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local xblock = macro_name:match(naming_prefix..index..'_xblock_(.+)')
        if xblock == 'input' then
            xblock = '()'
        end
        local cmd_1 = 'Set MAtricks "'..matrick_name..'" "xblock" '..xblock..' /nu'
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- fade macros
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2)
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6)
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local xfade = macro_name:match(naming_prefix..index..'_xfade_(.+)')
        if xfade == 'input' then
            xfade = '()'
        end
        local cmd_1
        if xfade ~= '()' then
            cmd_1 = 'Set MAtricks "'..matrick_name..'" Property "fadefromx" '..xfade..' /nu; Set Sequence "'..sequence_name..'" Cue "offcue" CueFade '..xfade..' /nu'
        else
            cmd_1 = 'SetUserVariable "poseffectfade" () /nu; Set MAtricks "'..matrick_name..'" Property "fadefromx" $poseffectfade /nu; Set Sequence "'..sequence_name..'" Cue "offcue" CueFade $poseffectfade /nu; DeleteUserVariable "poseffectfade" /nu'
        end
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- delayfrom macros
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2)
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6)
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local xdelayfrom = macro_name:match(naming_prefix..index..'_xdelay_from_(.+)')
        if xdelayfrom == 'input' then
            xdelayfrom = '()'
        end
        local cmd_1 = 'Set MAtricks "'..matrick_name..'" "delayfromx" '..xdelayfrom..' /nu'
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -- delayto macros
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2)
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6)
    for matricks_macros_appearance_iterator = 1,(((matricks_macros_amount/6)*2)-1),2 do
        local active_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator)].name
        local inactive_appearance = appearances_pool[(first_appearance+appearance_gap-1+matricks_macros_appearance_iterator+1)].name
        C('store macro '..macro_ind..'.1 thru 3 /nu')
        local macro_name = appearances_pool[(first_appearance+appearance_gap+matricks_macros_appearance_iterator)].name
        macro_name = naming_prefix..index..'_'..macro_name:match(naming_prefix..'(.*)')
        local xdelayto = macro_name:match(naming_prefix..index..'_xdelay_to_(.+)')
        if xdelayto == 'input' then
            xdelayto = '()'
        end
        local cmd_1 = 'Set MAtricks "'..matrick_name..'" "delaytox" '..xdelayto..' /nu'
        local cmd_2 = ''
        local macro_iterator = 1
        for i = 1,(((matricks_macros_amount/6)*2)-1),2 do
            local inactive_appearance_line2 = appearances_pool[(first_appearance+appearance_gap+i)].name
            local macro_name_line2 = macro_pool[first_macro+macros_gap+macro_iterator-1].name
            cmd_2 = cmd_2..'Assign appearance "'..inactive_appearance_line2..'" at macro "'..macro_name_line2..'" /nu; '
            macro_iterator = macro_iterator + 1
        end
        local cmd_3 = 'Assign appearance "'..active_appearance..'" at macro "'..macro_name..'" /nu'
        macro_pool[macro_ind][1]:Set('command',cmd_1)
        macro_pool[macro_ind][2]:Set('command',cmd_2)
        macro_pool[macro_ind][3]:Set('command',cmd_3)
        macro_pool[macro_ind]:Set('appearance',inactive_appearance)
        macro_ind = macro_ind + 1
    end
    -------- reate reset macro
    appearance_gap = appearance_gap + math.floor((matricks_macros_amount/6)*2)
    macros_gap = macros_gap + math.floor(matricks_macros_amount/6)
    C('store macro '..macro_ind..'.1 thru 3')
    local macro_name = naming_prefix..'RESET ENGINE '..index
    local preset_name = all1_presets_pool[first_preset].name
    local pan_sin_form_macro_name = macro_pool[first_macro+#groups].name
    local selection_in_order_macro_name = macro_pool[first_macro+#groups+4].name
    local no_mirror_macro_name = macro_pool[first_macro+#groups+7].name
    local phase_0_macro_name = macro_pool[first_macro+#groups+9].name
    local group_0_macro_name = macro_pool[first_macro+#groups+13].name
    local blocks_0_macro_name = macro_pool[first_macro+#groups+18].name
    local fade_0_macro_name = macro_pool[first_macro+#groups+23].name
    local delay_from_0_macro_name = macro_pool[first_macro+#groups+28].name
    local delay_to_0_macro_name = macro_pool[first_macro+#groups+33].name
    local matricks_macros_names = {pan_sin_form_macro_name,selection_in_order_macro_name,no_mirror_macro_name,phase_0_macro_name,group_0_macro_name,blocks_0_macro_name,fade_0_macro_name,delay_from_0_macro_name,delay_to_0_macro_name}
    macro_pool[macro_ind]:Set('name',macro_name)
    macro_pool[macro_ind]:Set('appearance', first_appearance+appearance_gap)
    local cmd_1 = 'Assign Preset 21."'..preset_name..'" At Sequence "'..sequence_name..'" Cue 1 Part 0.* /NoOops'
    local cmd_2 = 'Set Sequence "'..sequence_name..'" Cue 1 Part 0.* "selection" "None" /nu'
    local cmd_3 = 'Assign Appearance "'..naming_prefix..'group" at macro "'..naming_prefix..index..'_group_*" /nu; '
    for i=1,#matricks_macros_names do
        local cmd_macro_name = matricks_macros_names[i]
        cmd_3 = cmd_3..'go macro "'..cmd_macro_name..'" /nu; '
    end
    macro_pool[macro_ind][1]:Set('command',cmd_1)
    macro_pool[macro_ind][2]:Set('command',cmd_2)
    macro_pool[macro_ind][3]:Set('command',cmd_3)
    macro_ind = macro_ind + 1
end

function POS_EFFECTS_ENGINE_CREATOR.create_delete_macro(first_macro,in_last_macro,first_sequence,number_of_presets,amount_of_groups,mpe_layout,first_appear,in_last_appear,first_preset,first_matrx,presets,choise,index,name_prefix,DP)
    local macros_pool = ShowData().datapools[DP].Macros
    local last_macro = first_macro + (amount_of_groups + 4 + 2 + 2 + 5*6 + 1)*index - 1
    local last_appear = first_appear + (2 + 2 + 4*2 + 2*2 + 2*2 + 5*2*6 + 1) - 1  ------------------------ 2 for group symbols, 2 for switch symbol, 4*2 for forms symbols, 2*2 for selection order symbols, 2*2 for mirror symbols, 5*2*6 for matricks settings symbols, 1 is for one additional appearance for macro
    local macro_num = last_macro + 1
    local line1 = 'Delete Sequence '..first_sequence..' thru '..(first_sequence+index-1)..' /nc /nu'
    local line2 = 'Delete Macro '..first_macro..' thru '..last_macro..' /nc /nu'
    local line3 = ''
    local line4 = 'Delete Layout '..mpe_layout..' /nc /nu'
    local line5 = 'Delete Appearance '..first_appear..' thru '..last_appear..' /nc /nu'
    local line6 = ''
    local condition_string = "Lua 'if Confirm(\"Delete Moving Phaser Engine "..name_prefix:gsub('%D*','').."?\") then; Cmd(\"Go macro "..macro_num.."\"); else Cmd(\"Off macro "..macro_num.."\"); end'"..' /nu'
    line6 = 'Delete Preset 21.'..first_preset..' thru '..(first_preset+number_of_presets-1)..' /nc /nu'
    local line7 = 'Delete Matricks '..first_matrx..' thru '..(first_matrx+index-1)..' /nc /nu'
    local line8 = 'Delete macro '..macro_num..' /nc /nu'
    C('Store macro '..macro_num..'.1 thru 9 /o /nu')
    macros_pool[macro_num]:Set('name','Delete ALL ['..name_prefix:gsub('_','')..']')
    macros_pool[macro_num][1]:Set('Command', condition_string)
    macros_pool[macro_num][1]:Set('Wait', 'Go')
    macros_pool[macro_num][2]:Set('Command', line1)
    macros_pool[macro_num][3]:Set('Command', line2)
    macros_pool[macro_num][4]:Set('Command', line3)
    macros_pool[macro_num][5]:Set('Command', line4)
    macros_pool[macro_num][6]:Set('Command', line5)
    macros_pool[macro_num][7]:Set('Command', line6)
    macros_pool[macro_num][8]:Set('Command', line7)
    macros_pool[macro_num][9]:Set('Command', line8)
end

function POS_EFFECTS_ENGINE_CREATOR.create_layout(start_pos_x,start_pos_y,gap_x,gap_y,size_x,size_y,first_macro,first_sequence,groups,mpe_layout,first_appear,first_preset,first_matrick,index,name_prefix,DP)
    local layout_pool = ShowData().datapools[DP].Layouts
    local groups_pool = ShowData().DataPools[DP].Groups
    local amount_of_groups = #groups
    local pos_x = start_pos_x
    local pos_y = start_pos_y
    -- align sequences -----
    local object_type = 'sequence'
    local pool_obj_num = first_sequence
    local last_pool_obj = first_sequence
    local col_num = 1
    local obj_index = #layout_pool[mpe_layout] + 1
    local x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
    layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
    layout_pool[mpe_layout][obj_index]:Set('action',14)
    layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
    col_num = col_num + 1
    obj_index = obj_index + 1
    -- align matricks -----
    pos_x = start_pos_x + math.floor(gap_x*1.2)
    object_type = 'matricks'
    pool_obj_num = first_matrick
    last_pool_obj = first_matrick
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
    layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
    layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityid',false)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
    col_num = col_num + 1
    obj_index = obj_index + 1
    -- align group activation macros ----- 
    pos_x = start_pos_x
    pos_y = start_pos_y - gap_y*2
    object_type = 'macro'
    pool_obj_num = first_macro
    last_pool_obj = first_macro + amount_of_groups - 1
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    local group_index = 1
    while pool_obj_num <= last_pool_obj do
        for col=1,2 do
            if layout_pool[mpe_layout][obj_index] then
                layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
                layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
                layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
                layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
                layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
                layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
                local name = groups_pool[groups[group_index]].name
                layout_pool[mpe_layout][obj_index]:Set('CUSTOMTEXTTEXT',name)
                layout_pool[mpe_layout][obj_index]:Set('CUSTOMTEXTSIZE',12)
                layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
                layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
                pos_x = pos_x + gap_x
                obj_index = obj_index + 1
                pool_obj_num = pool_obj_num + 1
                group_index = group_index + 1
            end
        end
        pos_x = start_pos_x
        pos_y = pos_y - gap_y
    end
    -- align forms macros -----
    pos_x = start_pos_x + gap_x*3
    pos_y = start_pos_y
    object_type = 'macro'
    pool_obj_num = first_macro + amount_of_groups
    last_pool_obj = pool_obj_num + 4 - 1
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    for i=1,4 do -- 4 for 4 forms macros
        layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
        layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
        layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
        pos_x = pos_x + math.floor(gap_x*1.34)
        col_num = col_num + 1
        obj_index = obj_index + 1
    end
    -- align selection order macros -----
    pos_x = start_pos_x + gap_x*3
    pos_y = start_pos_y - gap_y
    object_type = 'macro'
    pool_obj_num = first_macro + amount_of_groups + 4 -- 4 for 4 form macros
    last_pool_obj = pool_obj_num + 2 - 1
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    for i=1,2 do -- 2 for 2 shuffle macros
        layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
        layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
        layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
        pos_x = pos_x + gap_x
        col_num = col_num + 1
        obj_index = obj_index + 1
    end
    -- align mirror macros -----
    pos_x = start_pos_x + gap_x*6
    pos_y = start_pos_y - gap_y
    object_type = 'macro'
    pool_obj_num = first_macro + amount_of_groups + 4 + 2 -- 4 for 4 form macros, 2 for 2 selection order macros
    last_pool_obj = pool_obj_num + 2 - 1
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    for i=1,2 do -- 2 for 2 shuffle macros
        layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
        layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
        layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
        pos_x = pos_x + gap_x
        col_num = col_num + 1
        obj_index = obj_index + 1
    end
    -- align matricks and timing macros -----
    pos_x = start_pos_x + gap_x*3
    pos_y = start_pos_y - gap_y*2
    object_type = 'macro'
    pool_obj_num = first_macro + amount_of_groups + 4 + 2 + 2-- 4 for 4 form macros, 2 for 2 selection order macros, 2 for 2 mirror macros
    last_pool_obj = pool_obj_num + 5*6 - 1
    col_num = 1
    x_count = index
    local y_count = 6 -- 6 for 6 rows
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    for y_i=1,y_count do
        for i=1,5 do -- 5 for 5 columns
            layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
            layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
            layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
            layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
            layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
            layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
            layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
            layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            obj_index = obj_index + 1
        end
        pos_y = pos_y - gap_y
        pos_x = start_pos_x + gap_x*3
    end
    ---- align reset macro
    pos_x = start_pos_x
    pos_y = start_pos_y - math.floor(gap_y*0.9)
    object_type = 'macro'
    pool_obj_num = first_macro + amount_of_groups + 4 + 2 + 2 + 5*6 -- 4 for 4 form macros, 2 for 2 selection order macros, 2 for 2 mirror macros, 1 for reset macro
    last_pool_obj = pool_obj_num
    col_num = 1
    x_count = index
    C('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..mpe_layout..' /nu')
    layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
    layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
    layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',true)
    layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
    layout_pool[mpe_layout][obj_index]:Set('visibilityid',false)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x*2+gap_x-size_x)
    col_num = col_num + 1
    obj_index = obj_index + 1
    -- create and aligh lyout labelling elements
    local labelling_names = {'Phase','Group','Blocks','Fade','Delay From','Delay To'}
    pos_x = start_pos_x + gap_x*2
    pos_y = start_pos_y - gap_y*2
    pool_obj_num = obj_index
    last_pool_obj = pool_obj_num + 6 - 1
    col_num = 1
    x_count = index
    y_count = 6
    C('store layout '..mpe_layout..'.'..pool_obj_num..' thru '..last_pool_obj..' /nu')
    for i=1,6 do -- 6 for 6 labels
        layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
        layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
        layout_pool[mpe_layout][obj_index]:Set('visibilityobjectname',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityindicatorbar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilitybar',false)
        layout_pool[mpe_layout][obj_index]:Set('visibilityborder',false)
        local name = labelling_names[i]..' >>>'
        layout_pool[mpe_layout][obj_index]:Set('CUSTOMTEXTTEXT',name)
        layout_pool[mpe_layout][obj_index]:Set('CUSTOMTEXTSIZE',20)
        layout_pool[mpe_layout][obj_index]:Set('VISIBILITYBORDER',false)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',size_y)
        layout_pool[mpe_layout][obj_index]:Set('POSITIONW',size_x)
        pos_y = pos_y - gap_y
        col_num = col_num + 1
        obj_index = obj_index + 1
    end
    -- create frame
    pos_x = start_pos_x - math.floor(gap_x*0.2)
    if #groups < 12 then
        pos_y = start_pos_y - math.floor(gap_y*7.2)
    else
        pos_y = start_pos_y - math.floor(gap_y*math.ceil(#groups/2)+gap_y*1.2)
    end
    pool_obj_num = obj_index
    last_pool_obj = pool_obj_num
    col_num = 1
    x_count = index
    y_count = 6
    C('store layout '..mpe_layout..'.'..pool_obj_num..' thru '..last_pool_obj..' /nu')
    layout_pool[mpe_layout][obj_index]:Set('posx',65536+pos_x)
    layout_pool[mpe_layout][obj_index]:Set('posy',pos_y)
    layout_pool[mpe_layout][obj_index]:Set('visibilityborder',true)
    layout_pool[mpe_layout][obj_index]:Set('POSITIONW',math.floor(gap_x*8.3))
    if #groups < 12 then
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',math.floor(gap_y*8.3))
    else
        layout_pool[mpe_layout][obj_index]:Set('POSITIONH',math.floor(gap_y*math.ceil(#groups/2)+gap_y*2.2))
    end
    pos_y = pos_y - gap_y
    col_num = col_num + 1
    obj_index = obj_index + 1
end

function POS_EFFECTS_ENGINE_CREATOR.get_free_page(DP)
    local pages_pool = ShowData().DataPools[DP].pages
    local result
    local page = 0
    repeat
        page = page + 1
    until not pages_pool[page] or #pages_pool[page]:Children() == 0
    result = page
    return result
end

function POS_EFFECTS_ENGINE_CREATOR.main_function_movement_phaser_engines()
    -- require 'gma3_debug'()
    local data_pool
    local gl_first_appear
    local gl_first_sequence
    local gl_first_phaser_preset
    local gl_first_matricks
    local gl_first_macro
    local gl_first_symbol
    local number_of_position_phasers = 4
    local groups_selected
    local number_of_groups
    local mpe_layout_number
    local generated
    local symbols_file_names
    local gl_name_prefix
    data_pool = tonumber(DataPool().no)
    local macro_pool = ShowData().datapools[data_pool].Macros
    local all1_presets_pool = ShowData().datapools[data_pool].PresetPools[21]
    local appearances_pool = ShowData().Appearances
    local matricks_pool = ShowData().DataPools[data_pool].MAtricks
    local groups_pool = ShowData().DataPools[data_pool].Groups
    local layouts_pool = ShowData().datapools[data_pool].Layouts
    local sequence_pool = ShowData().datapools[data_pool].Sequences
    local symbols_pool = ShowData().MediaPools.Symbols
    local pos_x_index_gap = math.floor(gl_gap_x*8.5)
    local engines_amount = 2
    local selected_page = POS_EFFECTS_ENGINE_CREATOR.get_free_page(data_pool)
    local suggested
    local amount
    --------------- getting user input --------------
    groups_selected = POS_EFFECTS_ENGINE_CREATOR.get_groups(data_pool)
    local amount_of_macros = #groups_selected +4+2+2+5*6 + 1 -- amount of macros !!!!!!per engine!!!  -- 4 for forms, 2  for order, 2 for shuffle, 5*6 for matricks, 1 for reset macro 
    if #groups_selected ~= 0 then
        ------------- getting first preset number
        amount = 4 -- 4 phaser presets
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(amount,all1_presets_pool)
        gl_first_phaser_preset = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('first Phaser Preset',suggested,amount,all1_presets_pool)
        ----------------------------- getting first sequence number
        amount = 1*engines_amount -- 1 sequence for engine
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(amount,sequence_pool)
        gl_first_sequence = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('first Sequence',suggested,amount,sequence_pool)
        ------------------- getting layout number
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(1,layouts_pool)
        mpe_layout_number = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('Layout number',suggested,1,layouts_pool)
        ------------------------- getting first appearance 
        amount = 2 + 2 + 4*2 + 2*2 + 2*2 + 5*2*6 + 1  ------------------------ 2 for group symbols, 2 for switch symbol, 4*2 for forms symbols, 2*2 for selection order symbols, 2*2 for mirror symbols, 5*2*6 for matricks settings symbols, 1 is for one additional appearance for macro
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(amount,appearances_pool)
        gl_first_appear = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('first Appearance',suggested,amount,appearances_pool)
        ------------------------------- getting first matricks
        amount = 1*engines_amount
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(amount,matricks_pool)
        gl_first_matricks = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('first MAtricks',suggested,amount,matricks_pool)
        ----------------------- getting first macro 
        amount = amount_of_macros*engines_amount + 1 -- number of groups, 4 for forms, 2 for selection order, 2 for mirror, 5*6 for matricks settings, 1 for delete macro        
        suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(amount,macro_pool)
        gl_first_macro = POS_EFFECTS_ENGINE_CREATOR.check_selected_pool_num('first Macro',suggested,amount,macro_pool)
        
        ------------------- getting symbol number
        -- suggested = POS_EFFECTS_ENGINE_CREATOR.get_first_pool_num(17,symbols_pool) ------------- 17 - amount of symbol filenames
        -- gl_first_symbol = pp_check_selected_pool_num('first Symbol',suggested,17,symbols_pool)
        ---------------------------[[ Plugin started ]]-------------------------
        C('cleara /nu')
        local declared_timings = POS_EFFECTS_ENGINE_CREATOR.declare_timing_values()
        gl_name_prefix = POS_EFFECTS_ENGINE_CREATOR.create_name_prefix(data_pool)
        local start_pos_x = gl_start_pos_x
        local start_pos_y = gl_start_pos_y
        C('store layout '..mpe_layout_number..' "'..gl_name_prefix..'layout" /nu')
        C('select layout '..mpe_layout_number..' /nu')
        C('store page '..selected_page..' /nu')
        POS_EFFECTS_ENGINE_CREATOR.create_appearances(0,gl_first_appear,0,declared_timings,0,gl_name_prefix,0,data_pool)
        POS_EFFECTS_ENGINE_CREATOR.import_predefined_phasers(all1_presets_pool,gl_first_phaser_preset,gl_name_prefix)
        local first_loop_matricks = gl_first_matricks
        local first_loop_macro = gl_first_macro
        local first_loop_squence = gl_first_sequence
        for index=1, engines_amount do
            POS_EFFECTS_ENGINE_CREATOR.create_matricks(first_loop_matricks,gl_name_prefix,index)
            POS_EFFECTS_ENGINE_CREATOR.create_sequence(first_loop_squence,#groups_selected,gl_first_appear,gl_first_phaser_preset,first_loop_matricks,sequence_pool,selected_page,gl_name_prefix,index,data_pool)
            POS_EFFECTS_ENGINE_CREATOR.create_macros(groups_selected,first_loop_macro,first_loop_squence,first_loop_matricks,gl_first_appear,gl_first_phaser_preset,declared_timings,gl_name_prefix,index,data_pool)
            POS_EFFECTS_ENGINE_CREATOR.create_layout(start_pos_x,start_pos_y,gl_gap_x,gl_gap_y,gl_size_x,gl_size_y,first_loop_macro,first_loop_squence,groups_selected,mpe_layout_number,gl_first_appear,gl_first_phaser_preset,first_loop_matricks,index,gl_name_prefix,data_pool)
            first_loop_matricks = first_loop_matricks + 1
            first_loop_macro = first_loop_macro + amount_of_macros
            first_loop_squence = first_loop_squence + 1
            start_pos_x = start_pos_x + pos_x_index_gap
            C('go macro '..first_loop_macro-1)
            coroutine.yield(0.5)
        end
        POS_EFFECTS_ENGINE_CREATOR.create_delete_macro(gl_first_macro,0,gl_first_sequence,number_of_position_phasers,#groups_selected,mpe_layout_number,gl_first_appear,0,gl_first_phaser_preset,gl_first_matricks,1,1,engines_amount,gl_name_prefix,data_pool)
    else
        Confirm('No groups selected')
    end
end

return POS_EFFECTS_ENGINE_CREATOR.main_function_movement_phaser_engines