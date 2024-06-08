--[[ Color Picker Generator v 2.0.1
Created by Yury Belousov ]]

local gl_start_pos_x = -500 -- starting x point for layout elements
local gl_start_pos_y = 300 -- starting y point for layout elements
local gl_gap_x = 50 -- x-gap between layout elements
local gl_gap_y = 50 -- y-gap between layout elements
local gl_size_x = 50 -- height of layout elements
local gl_size_y = 50 -- width of layout elements
local gl_progress_bar_time = 0 -- time for every progress bar status update
--------------------------------------------------------------------
------------- Don't change anything below this line ----------------
--------------------------------------------------------------------
local c = Cmd
local ti = TextInput
local data_pool
local gl_first_appear
local gl_first_sequence
local gl_matricks_first
local gl_first_macro
local gl_first_symbol
local gl_name_prefix
local fades_delays_05_timing = false

local function color_picker_generator_main()
    data_pool = tonumber(DataPool().no)
    local color_presets = {}
    local presets_colors_R = {}
    local presets_colors_G = {}
    local presets_colors_B = {}
    local macro_pool = ShowData().datapools[data_pool].Macros
    local color_presets_pool = ShowData().datapools[data_pool].PresetPools[4]
    local appearances_pool = ShowData().Appearances
    local matricks_pool = ShowData().DataPools[data_pool].MAtricks
    local groups_pool = ShowData().DataPools[data_pool].Groups
    local layouts_pool = ShowData().datapools[data_pool].Layouts
    local sequence_pool = ShowData().datapools[data_pool].Sequences
    local symbols_pool = ShowData().MediaPools.Symbols
    local generated_presets_amount = 15
    local number_of_color_presets
    local first_color_preset
    local groups_selected
    local number_of_groups
    local layout_number
    local generated
    local symbols_file_names
    local suggested
    local amount
    ----------------------------------------------------------
    generated = 0
    groups_selected = cp_get_groups(data_pool)
    if #groups_selected ~= 0 then
        c('clearall /nu')
        local use_existing_presets = Confirm('Do you want to create new (OK) or use existing presets (Cancel)?')
        if not use_existing_presets then
            local get_color_presets_return = {cp_get_color_presets(data_pool)}
            color_presets = get_color_presets_return[1]
            number_of_color_presets = #color_presets
            first_color_preset = color_presets[1]
            presets_colors_R = get_color_presets_return[2]
            presets_colors_G = get_color_presets_return[3]
            presets_colors_B = get_color_presets_return[4]
        else
            number_of_color_presets = 'gen'
        end
        number_of_groups = #groups_selected
        local presets_selection_exist = true
        ---------------------------- geting first color preset to generate --------------------
        if number_of_color_presets == 'gen' then
            suggested = cp_get_first_pool_num(generated_presets_amount,color_presets_pool)
            first_color_preset = cp_check_selected_pool_num('first Color Preset',suggested,generated_presets_amount,color_presets_pool)
            generated = 1
        elseif number_of_color_presets == 0 then
            presets_selection_exist = false
        end
        if presets_selection_exist then
            ----------------------------- getting first sequence number -------------------
            if generated == 1 then
                amount = generated_presets_amount*number_of_groups
            else
                amount = number_of_color_presets*number_of_groups
            end
            suggested = cp_get_first_pool_num(amount,sequence_pool)
            gl_first_sequence = cp_check_selected_pool_num('first Sequence',suggested,amount,sequence_pool)
            ------------------- getting layout number --------------------
            suggested = cp_get_first_pool_num(1,layouts_pool)
            layout_number = cp_check_selected_pool_num('Layout number',suggested,1,layouts_pool)
            ------------------------- getting first appearance ------------------------
            if generated == 1 then
                amount = generated_presets_amount*3+25*2+1+2  ------------------------ 1 is for one additional appearance for macro, 2 is for 2 favourites appearances, 25 for the amount of timing macros
            else
                amount = number_of_color_presets*3+25*2+1+2
            end
            suggested = cp_get_first_pool_num(amount,appearances_pool)
            gl_first_appear = cp_check_selected_pool_num('first Appearance',suggested,amount,appearances_pool)
            ------------------------------- getting first matricks -----------------------
            amount = number_of_groups
            suggested = cp_get_first_pool_num(amount,matricks_pool)
            gl_matricks_first = cp_check_selected_pool_num('first MAtricks',suggested,amount,matricks_pool)
            ----------------------- getting first macro ---------------------------
            if generated == 1 then
                amount = generated_presets_amount+25+2+17
                suggested = cp_get_first_pool_num((generated_presets_amount+25+2+17),macro_pool) ------------------------ 2 is for two additional macros, 25 for the amount of timing macros, 17 for favourite macros
            else
                amount = number_of_color_presets+25+2
                suggested = cp_get_first_pool_num((number_of_color_presets+25+2+17),macro_pool) ------------------------ 2 is for two additional macros, 25 for the amount of timing macros, 17 for favourite macros
            end
            suggested = cp_get_first_pool_num(amount,macro_pool)
            gl_first_macro = cp_check_selected_pool_num('first Macro',suggested,amount,macro_pool)          
            ------------------- getting symbol number
            -- suggested = cp_get_first_pool_num(17,symbols_pool) ------------- 17 - amount of symbol filenames
            -- gl_first_symbol = cp_check_selected_pool_num('first Symbol',suggested,17,symbols_pool)
            ---------------------------[[ Genereation started ]]-------------------------
            c('clearall /nu')
            local progtime = MasterPool()['Grand']['ProgramTime'].faderenabled
            if progtime then
                c('off master 2.8')
            end
            gl_name_prefix = cp_create_name_prefix(data_pool)
            -- symbols_file_names = cp_import_symbols(gl_first_symbol)
            if number_of_color_presets == 'gen' then
                number_of_color_presets = 15
                color_presets = generate_uinv_col_preset(first_color_preset,number_of_color_presets,groups_selected,gl_name_prefix,gl_progress_bar_time,data_pool)
                number_of_color_presets = #color_presets
                presets_colors_R = {}
                presets_colors_G = {}
                presets_colors_B = {}
            end
            c('store layout '..layout_number..' /nu')
            c('label layout '..layout_number..' "Color Picker '..gl_name_prefix:gsub('%D*','')..'" /nu')
            c('select layout '..layout_number..' /nu')
            local declared_timings = {cp_declare_timing_values(fades_delays_05_timing)}
            local progHandle = StartProgress("Generating Color Picker")
                SetProgressRange(progHandle, 1, 16)
            local last_appearance_num = cp_create_appearances(color_presets, presets_colors_R, presets_colors_G, presets_colors_B, gl_first_appear, declared_timings,fades_delays_05_timing, gl_name_prefix, gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 2)
                coroutine.yield(gl_progress_bar_time)
            create_cp_matricks(gl_matricks_first, groups_selected,gl_name_prefix,data_pool)
            local create_timing_macros_return = {cp_create_timing_macros(gl_first_macro,declared_timings,gl_name_prefix,gl_progress_bar_time,data_pool)}
            local last_macro_num = create_timing_macros_return[1]
            local timing_macros_amount = create_timing_macros_return[2]
                SetProgress(progHandle, 3)
                coroutine.yield(gl_progress_bar_time)
            create_color_sequences(gl_first_sequence,groups_selected,gl_matricks_first,color_presets,gl_first_appear,gl_name_prefix,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 4)
                coroutine.yield(gl_progress_bar_time)
            local last_layout_obj_num = cp_sequences_layout_align(number_of_color_presets, number_of_groups, gl_size_x, gl_size_y, gl_gap_x, gl_gap_y, gl_start_pos_x, gl_start_pos_y, gl_first_sequence, layout_number,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 5)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_layout_align_groups(last_layout_obj_num, gl_size_x, gl_size_y,gl_gap_x,gl_gap_y, gl_start_pos_x, gl_start_pos_y,groups_selected,layout_number,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 6)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_layout_align_matrx(last_layout_obj_num, gl_size_x, gl_size_y,gl_gap_x,gl_gap_y,gl_start_pos_x,gl_start_pos_y,gl_matricks_first,number_of_color_presets,number_of_groups,layout_number,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 7)
                coroutine.yield(gl_progress_bar_time)
            last_macro_num = cp_create_all_groups_macros(last_macro_num,color_presets,gl_first_appear,gl_name_prefix,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 8)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_layout_align_all_groups_macros(last_layout_obj_num,last_macro_num, gl_size_x, gl_size_y, gl_gap_x, gl_gap_y,gl_start_pos_x,gl_start_pos_y,number_of_color_presets,layout_number,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 9)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_layout_align_timing_macros(last_layout_obj_num,timing_macros_amount,gl_first_macro, gl_size_x, gl_size_y,gl_gap_x,gl_gap_y,gl_start_pos_x,gl_start_pos_y,number_of_groups,layout_number,gl_name_prefix,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 10)
                coroutine.yield(gl_progress_bar_time)
            last_macro_num = cp_create_off_macro(last_macro_num,last_appearance_num,gl_name_prefix,data_pool)
                SetProgress(progHandle, 11)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_layout_aligh_off_macro(last_layout_obj_num, gl_size_x, gl_size_y, gl_gap_x, gl_gap_y, gl_start_pos_x, gl_start_pos_y, last_macro_num, number_of_groups, layout_number,data_pool)
                SetProgress(progHandle, 12)
                coroutine.yield(gl_progress_bar_time)            
            last_macro_num = cp_store_favourite_macro(gl_name_prefix,last_macro_num,layout_number,data_pool)
                SetProgress(progHandle, 13)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_favourites_layout_align(last_layout_obj_num, last_macro_num, gl_size_x, gl_size_y,gl_gap_x,gl_gap_y,gl_start_pos_x,gl_start_pos_y,number_of_color_presets,layout_number,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 14)
                coroutine.yield(gl_progress_bar_time)
            cp_create_delete_macro(gl_first_macro,last_macro_num,gl_first_sequence,number_of_color_presets,number_of_groups,layout_number,gl_first_appear,last_appearance_num,color_presets[1],gl_matricks_first,generated,gl_name_prefix,data_pool)
                SetProgress(progHandle, 15)
                coroutine.yield(gl_progress_bar_time)
            last_layout_obj_num = cp_labelling_objects_layout(last_layout_obj_num, gl_size_x, gl_size_y,gl_gap_x,gl_gap_y,gl_start_pos_x,gl_start_pos_y,layout_number,number_of_groups,color_presets,declared_timings,gl_name_prefix,gl_progress_bar_time,data_pool)
                SetProgress(progHandle, 16)
                coroutine.yield(gl_progress_bar_time)
            StopProgress(progHandle)
            if progtime then
                c('on master 2.8')
            end
        else
            Confirm('No presets selected')
        end
    else
        Confirm('No groups selected')
    end

end

return color_picker_generator_main