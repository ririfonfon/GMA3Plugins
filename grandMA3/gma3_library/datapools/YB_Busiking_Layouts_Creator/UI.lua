--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local YB_GMA3_CP_GEN,thiscomponent = select(3,...)

local function calculate_first_pool_objects(selected_groups,selected_presets,generate,picker_type,position_preset_names)

    local function get_first_pool_num(object_amount,pool)
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

    local macro_pool = DataPool().Macros
    local preset_pools = DataPool().PresetPools
    local appearances_pool = ShowData().Appearances
    local matricks_pool = DataPool().MAtricks
    local layouts_pool = DataPool().Layouts
    local sequence_pool = DataPool().Sequences
    local tag_pool = ShowData().tags
    local amount_of_generated_presets
    local amount_of_timing_macros = 20 -- 5 x {fade,delayto,group,wings}
    local amount_of_favourites_macros = 17 -- 2 x 8 + 1 for store macro
    local amount_of_additional_macros = 2 -- "all off" and "delete all"
    local amount_of_sequence_appearance_types
    local amount_of_timing_macros_appearance_types = 2 -- active, inactive
    local amount_of_favourite_macros_appearance_types = 2 -- star, black
    local amount_of_all_off_appearances = 1
    local amount_of_delay_direction_appearances = 2 -- arrows left and right
    local amount_of_delay_direction_macros = 1
    local amount_of_arrow_appearances_for_position_picker = 1
    local amount_of_user_presets = #selected_presets
    local amount_of_presets
    local generate_presets = generate
    local groups_selected = selected_groups
    local amount
    local first_preset
    local first_tag
    local layout_number
    local first_appear
    local first_sequence
    local first_matrick
    local first_macro
    local object_amounts = {}
    if picker_type == '2' then
        amount_of_sequence_appearance_types = 2
        picker_type = 'position'
        amount_of_generated_presets = #position_preset_names
    elseif picker_type == '4' then
        picker_type = 'color'
        amount_of_sequence_appearance_types = 3
        amount_of_generated_presets = 15  -- if generated - CTO, CTB + 13 MA gels
    end
    ---------------------------- geting first preset to generate --------------------
    if generate_presets then
        first_preset = get_first_pool_num(amount_of_generated_presets,preset_pools[picker_type])
    end
    if generate_presets then
        amount_of_presets = amount_of_generated_presets
    else
        amount_of_presets = amount_of_user_presets
    end
    object_amounts.presets = amount_of_presets
    ----------------------------- getting first sequence number -------------------
    amount = amount_of_presets*#groups_selected
    first_sequence = get_first_pool_num(amount,sequence_pool)
    object_amounts.sequences = amount
    ------------------- getting layout number --------------------
    amount = 1
    layout_number = get_first_pool_num(amount,layouts_pool)
    object_amounts.layout = amount
    ------------------------- getting first appearance ------------------------
    amount =
    amount_of_presets*amount_of_sequence_appearance_types +
    amount_of_timing_macros*amount_of_timing_macros_appearance_types +
    amount_of_all_off_appearances +
    amount_of_favourite_macros_appearance_types +
    amount_of_delay_direction_appearances
    if picker_type == 'position' then
        amount = amount + amount_of_arrow_appearances_for_position_picker
    end
    first_appear = get_first_pool_num(amount,appearances_pool)
    object_amounts.appearances = amount
    ------------------------------- getting first matricks -----------------------
    amount = #groups_selected
    first_matrick = get_first_pool_num(amount,matricks_pool)
    object_amounts.matricks = amount
    ----------------------- getting first macro ---------------------------
    amount =
    amount_of_presets +
    amount_of_timing_macros +
    amount_of_additional_macros +
    amount_of_favourites_macros +
    amount_of_delay_direction_macros
    first_macro = get_first_pool_num(amount,macro_pool)
    object_amounts.macros = amount
    ----------------------- getting first tag ---------------------------
    amount = #groups_selected
    first_tag = get_first_pool_num(amount,tag_pool)
    object_amounts.tags = amount

    return {
        generate_presets=generate_presets,
        amount_of_generated_presets=amount_of_generated_presets,
        presets_obj=selected_presets,
        groups_selected=selected_groups,
        presets={first_index=first_preset,amount=object_amounts.presets,pool=preset_pools[picker_type]},
        layout={first_index=layout_number,amount=object_amounts.layout,pool=layouts_pool},
        appearances={first_index=first_appear,amount=object_amounts.appearances,pool=appearances_pool},
        matricks={first_index=first_matrick,amount=object_amounts.matricks,pool=matricks_pool},
        macros={first_index=first_macro,amount=object_amounts.macros,pool=macro_pool},
        tags={first_index=first_tag,amount=object_amounts.tags,pool=tag_pool},
        sequences={first_index=first_sequence,amount=object_amounts.sequences,pool=sequence_pool},
        picker_type=picker_type,
    }
end

local function check_if_multistep_preset(preset)
    local preset_data = GetPresetData(preset,false,false)
    for _,uichannel_data in pairs(preset_data) do
        if type(uichannel_data) == "table" then
            if #uichannel_data > 1 then
                return true
            end
        end
    end
    return false
end

local function check_if_moving_fixture(group)
    local groupselectiondata = group.selectiondata
    if #groupselectiondata == 0 then
        return false
    else
        for i=1, #groupselectiondata do
            local subfixtureindex = groupselectiondata[i].sf_index
            local uichannels = GetUIChannels(GetSubfixture(subfixtureindex),true)
            for ind=1,#uichannels do
                local subattribute = uichannels[ind].subattribute
                if subattribute == 'Pan' then return true end
                if subattribute == 'Tilt' then return true end
            end
        end
    end
    return false
end

function YB_GMA3_CP_GEN.new_ui (display,position_preset_names)
    local function create_ui_object(parent,class,properties)
        local element = parent:Append(class)
        for k, v in pairs(properties) do
            element[k] = v
        end
        return element, element[1], element[2]
    end
    local suggested_pool_numbers
    local plugin_title = 'YB Busking Layouts Creator'
    local result = {}
    local continue = false
    local base_input,base_input_rows = create_ui_object(GetFocusDisplay().ScreenOverlay,'ShadedOverlay',{
        alignmenth = 'Center',
        alignmentv = 'Center',
        -- H = 500,
        W = 750,
        rows = 2,
        AutoClose = false,
        -- WantsModal = true
    })
    -- base_input_rows[1].sizepolicy = 'Fixed'
    -- base_input_rows[1].size = 60
    base_input_rows[2].sizepolicy = 'Content'

    local titleBar,title_bar_rows,title_bar_columns = create_ui_object(base_input,'TitleBar',{
        -- Columns = 2,
        Columns = 1,
        Rows = 1,
        Anchors = '0,0',
        Texture = 'corner2'
    })
    -- title_bar_columns[2].SizePolicy = 'Fixed'
    -- title_bar_columns[2].Size = '50'

    local title_bar_icon = create_ui_object(titleBar,'TitleButton',{
        Text = plugin_title,
        -- Texture = 'corner1',
        icon = 'logo_small',
        Texture = 'corner3',
        Anchors = '0,0'
    })

    -- local title_bar_close_button = create_ui_object(titleBar,'CloseButton',{
    --     Anchors = '1,0',
    --     Texture = 'corner2',
    -- })

    local dlg_frame,dlg_frame_rows = create_ui_object(base_input,'DialogFrame',{
        -- h=400,
        -- Padding='10,10,10,20',
        Anchors = '0,1'
    })
    dlg_frame_rows[1].sizepolicy = 'Content'

    local dialog,dialog_rows = create_ui_object(dlg_frame,'UILayoutGrid',{
        h=950,
       Anchors = '0,0',
       rows = 5
      })
    dialog_rows[1].SizePolicy = 'fixed'
    dialog_rows[1].Size = '50'
    dialog_rows[2].SizePolicy = 'fixed'
    dialog_rows[2].Size = '200'
    dialog_rows[3].SizePolicy = 'fixed'
    dialog_rows[3].Size = '200'
    dialog_rows[4].SizePolicy = 'fixed'
    dialog_rows[4].Size = '250'
    dialog_rows[5].SizePolicy = 'fixed'
    dialog_rows[5].Size = '50'

    local label = create_ui_object(dialog,'UIObject',{
        BackColor = Root().ColorTheme.ColorGroups.Global.Transparent,
        anchors = '0,0',
        text = 'Select type, used groups and presets and specify starting\nindexes for the pool objects',
        hashover = false,
    })

    local main_section,main_section_rows,main_section_columns = create_ui_object(dialog,'UILayoutGrid',{
        -- text = 'this is a main section',
        anchors = '0,1',
        Columns = 4,
        rows = 4,
        padding={
            top=5,
            bottom=5,
            left=5,
            right=5
        },
    })

    local picker_types = {'Color','Position'}
    local type_radio_selector = create_ui_object(main_section,'RadioButtonList',{
        Anchors = '0,0,3,0',
        name = 'picker_type',
        type = 'Horizontal',
        padding = '5,5,5,5',
        OnSelectedItem = 'radio_button_selected',
        PluginComponent = thiscomponent
    })

    type_radio_selector:WaitInit()
    type_radio_selector.itemsize = math.floor((main_section.absrect.w-main_section.padding.left-main_section.padding.right-type_radio_selector.padding.left-type_radio_selector.padding.right)/#picker_types)-1

    for i,button_name in ipairs(picker_types) do
        type_radio_selector:AddListStringItem(button_name,i)
    end

    type_radio_selector[1]:WaitChildren(2)

    for _,button in ipairs(type_radio_selector[1]:UIChildren()) do
        button.focus = 'Never'
    end

    local selected_grops_label = create_ui_object(main_section,'UIObject',{
        anchors = '0,1,0,1',
        text = 'Groups  ',
        texture = 'corner5',
        focus = 'never',
        TextalignmentH = 'Right',
    })
    local selected_grops_input = create_ui_object(main_section,'LineEdit',{
        Anchors = '1,1,3,1',
        name = 'groups_input',
        keyup = 'key_up',
        textchanged = 'on_text_changed',
        texture = 'corner10',
        PluginComponent = thiscomponent
    })


    local preset_options = {'Create presets','Use existing presets'}
    local presets_radio_selector = create_ui_object(main_section,'RadioButtonList',{
        Anchors = '0,2,3,2',
        name = 'presets_type',
        type = 'Horizontal',
        padding = '5,5,5,5',
        OnSelectedItem = 'radio_button_selected',
        PluginComponent = thiscomponent
    })

    presets_radio_selector:WaitInit()
    presets_radio_selector.itemsize = math.floor((main_section.absrect.w-main_section.padding.left-main_section.padding.right-presets_radio_selector.padding.left-presets_radio_selector.padding.right)/#preset_options)-1

    for i,button_name in ipairs(preset_options) do
        presets_radio_selector:AddListStringItem(button_name,i)
    end

    presets_radio_selector[1]:WaitChildren(2)

    for _,button in ipairs(presets_radio_selector[1]:UIChildren()) do
        button.focus = 'Never'
    end

    local selected_presets_label = create_ui_object(main_section,'UIObject',{
        anchors = '0,3,0,3',
        text = 'Presets  ',
        texture = 'corner5',
        focus = 'never',
        enabled = false,
        TextalignmentH = 'Right',
    })
    local selected_presets_input = create_ui_object(main_section,'LineEdit',{
        Anchors = '1,3,3,3',
        name = 'presets_input',
        -- content = 5,
        -- Filter = '0123456789',
        -- maxTextLength = 3,
        keyup = 'key_up',
        textchanged = 'on_text_changed',
        texture = 'corner10',
        PluginComponent = thiscomponent,
        enabled = false
    })

    local input_fields_names = {{'First preset','presets'},{'Layout','layout'},{'First Sequence','sequences'},{'First Appearance','appearances'},{'First MAtrick','matricks'},{'First Macro','macros'},{'First Tag','tags'},}
    local input_fields_section = create_ui_object(dialog,'UILayoutGrid',{
        anchors = '0,2',
        Columns = 4,
        rows=4,
        enabled = false,
        padding={
            top=0,
            bottom=5,
            left=5,
            right=5
        },
    })

    local label_index = 1

    local name = input_fields_names[label_index]
    local input_label = create_ui_object(input_fields_section,'UIObject',{
        anchors = {
            left=0,
            right=0,
            top=0,
            bottom=0
        },
        name = name[2]..'_label',
        text = name[1]..'  ',
        texture = 'corner1',
        hashover = false,
        TextalignmentH = 'Right',
    })
    local input_field = create_ui_object(input_fields_section,'LineEdit',{
        Anchors = {
            left=1,
            right=3,
            top=0,
            bottom=0
        },
        name = name[2]..'_input',
        keyup = 'key_up',
        focusget = 'focus_get',
        focuslost = 'pool_inputs_focus_lost',
        PluginComponent = thiscomponent,
        texture = 'corner2'
    })
    label_index = label_index + 1
    for row=1,3 do
        for col=0,2,2 do
            name = input_fields_names[label_index]
            input_label = create_ui_object(input_fields_section,'UIObject',{
                anchors = {
                    left=col,
                    right=col,
                    top=row,
                    bottom=row
                },
                name = name[2]..'_label',
                text = name[1]..'  ',
                hashover = false,
                TextalignmentH = 'Right',
            })
            input_field = create_ui_object(input_fields_section,'LineEdit',{
                Anchors = {
                    left=col + 1,
                    right=col + 1,
                    top=row,
                    bottom=row
                },
                name = name[2]..'_input',
                keyup = 'key_up',
                focusget = 'focus_get',
                focuslost = 'pool_inputs_focus_lost',
                PluginComponent = thiscomponent,
            })
                if row == 3 and col == 0 then
                    input_label.texture = 'corner4'
                end
                if row == 3 and col == 2 then
                    input_field.texture = 'corner8'
                end
            -- if i == 1 then
            --     input_label.texture = 'corner1'
            --     input_field.texture = 'corner2'
            -- elseif i == #input_fields_names then
            --     input_label.texture = 'corner4'
            --     input_field.texture = 'corner8'
            -- end
            label_index = label_index + 1
        end
    end

    local summary_field_names = {'Groups','presets','Layout','Sequences','Appearances','MAtricks','Macros','Tags'}

    local summary_section = create_ui_object(dialog,'UILayoutGrid',{
        anchors = '0,3',
        Columns = 4,
        rows=5,
        padding={
            top=0,
            bottom=5,
            left=5,
            right=5
        },
    })

        local summary_label = create_ui_object(summary_section,'UIObject',{
            anchors='0,0,3,0',
            -- TextalignmentH = 'Left',
            text='Objects to be used / created:',
            -- texture = 'corner3',
            hashover = false,
            BackColor = Root().ColorTheme.ColorGroups.Global.Transparent

        })
        label_index = 1
        for row=1,4 do
            for col=0,2,2 do
                local field_name = summary_field_names[label_index]
                local label_text = field_name
                if field_name == 'presets' then
                    if type_radio_selector.SelectedItemValueStr == '1' then
                        label_text = 'Color '..field_name
                    elseif type_radio_selector.SelectedItemValueStr == '2' then
                        label_text = 'Position '..field_name
                    end
                end
                local field_label = create_ui_object(summary_section,'UIObject',{
                    anchors = {
                        top=row,
                        bottom=row,
                        left=col,
                        right=col,
                    },
                    BackColor = Root().ColorTheme.ColorGroups.Global.Transparent,
                    text = label_text..':  ',
                    name = field_name:lower()..'_label',
                    hashover = false,
                    TextalignmentH = 'Right',
                })
                local field_info = create_ui_object(summary_section,'UIObject',{
                    anchors = {
                        top=row,
                        bottom=row,
                        left=col+1,
                        right=col+1,
                    },
                    BackColor = Root().ColorTheme.ColorGroups.Global.Transparent,
                    name = field_name:lower()..'_info',
                    hashover = false,
                    TextalignmentH = 'Left',
                })
                -- if row == 4 and col == 0 then
                --     field_label.texture = 'corner4'
                -- end
                -- if row == 4 and col == 2 then
                --     field_info.texture = 'corner8'
                -- end
                label_index = label_index + 1
            end
        end

    local buttons_section = create_ui_object(dialog,'UILayoutGrid',{
        -- text = 'this is a button section',
        anchors = '0,4',
        Columns = 2,
        rows=1
    })

        local button1 = create_ui_object(buttons_section,'Button',{
            Anchors = '0,0',
            text = 'Create Layout',
            clicked = 'ok_cancel_clicked',
            keyup = 'key_up',
            -- backcolor = red_background,
            PluginComponent = thiscomponent,
            WantsNumericRedirect = true
        })

        local button2 = create_ui_object(buttons_section,'Button',{
            Anchors = '1,0',
            text = 'Cancel',
            clicked = 'ok_cancel_clicked',
            keyup = 'key_up',
            PluginComponent = thiscomponent,
            WantsNumericRedirect = true
        })


    FindBestFocus(selected_grops_input)

    local function update_summary(picker_type,suggested)
        local summary_string = ''
        local selected_groups = ObjectList('group '..selected_grops_input.content)
        local selected_presets = ObjectList('preset '..picker_type..'.'..(selected_presets_input.content or 1))
        if selected_groups[1]:GetClass() == 'Group' then
            for _,group in ipairs(selected_groups) do
                summary_string = summary_string..group.no..' ; '
            end
            summary_section.groups_info.text = summary_string:sub(1,-3)
        else
            summary_section.groups_info.text = ''
        end
        summary_string = ''
        if suggested.generate_presets then
            local first_index = input_fields_section.presets_input.content
            local last_index = tonumber(first_index) + suggested.presets.amount - 1
            -- Echo(last_index)
            summary_string = first_index..' Thru ' .. last_index
            summary_section.presets_info.text = summary_string
        else
            if selected_presets[1]:GetClass() == 'Preset' then
                for _,preset in ipairs(selected_presets) do
                    summary_string = summary_string..preset.no..' ; '
                end
                summary_section.presets_info.text = summary_string:sub(1,-3)
            else
                summary_section.presets_info.text = ''
            end
        end
        if picker_type == '2' then
            summary_section.presets_label.text = 'Position presets:  '
        elseif picker_type == '4' then
            summary_section.presets_label.text = 'Color presets:  '
        end
        for i,summary_field in ipairs(summary_section:UIChildren()) do
            if i > 5 then
                if summary_field.name:find('_info') then
                    summary_string = ''
                    local field_name = summary_field.name:match('(.*)_info')
                    if field_name == 'layout' then
                        summary_field.text = input_fields_section[field_name..'_input'].content
                    else
                        local first_index = input_fields_section[field_name..'_input'].content
                        local last_index = tonumber(first_index) + suggested[field_name].amount - 1
                        summary_string = first_index ..' Thru ' .. last_index
                        summary_field.text = summary_string
                    end
                end
            end
        end
    end

    local function update_field_content(field,suggested,amount,pool)
        field.content = suggested
    end

    local function fill_in_pool_inputs(suggested)
        for _,in_field in ipairs(input_fields_section:UIChildren()) do
            if in_field.name:find('_input') then
                local input_name = in_field.name:match('(.*)_input')
                -- Echo(input_name)
                update_field_content(in_field,suggested[input_name].first_index,suggested[input_name].amount,suggested[input_name].pool)
            end
        end
    end

    local function can_fit_objects(first_index, amount, pool)
        local function range_free(start_idx)
            if not start_idx then return false end
            local end_idx = start_idx + amount - 1
            for i = start_idx, end_idx do
                if pool[i] ~= nil then
                    return false
                end
            end
            return true
        end

        local fits = range_free(first_index)

        local suggested = first_index or 1
        if not fits then
            while not range_free(suggested) do
                suggested = suggested + 1
            end
        else
            suggested = first_index
        end
        return fits, suggested
    end

    local function check_groups_and_presets(caller)
        local generate_or_user = presets_radio_selector.SelectedItemValueStr == '1' and true or false
        local groups_exist
        local presets_exist
        local picker_type
        suggested_pool_numbers = {}
        if type_radio_selector.SelectedItemValueStr == '1' then
            picker_type = '4'
        elseif type_radio_selector.SelectedItemValueStr == '2' then
            picker_type = '2'
        end
        local groups = ObjectList('group '..selected_grops_input.content)
        if groups and #groups > 0 and groups[1]:GetClass() == 'Group' then
            groups_exist = true
        else
            groups_exist = false
        end
        -- Echo('preset '..picker_type..'.'..selected_presets_input.content)
        local presets = ObjectList('preset '..picker_type..'.'..selected_presets_input.content)
        if generate_or_user or (selected_presets_input.content ~= '' and presets and #presets > 0 and presets[1]:GetClass() == 'Preset') then
            presets_exist = true
        else
            presets_exist = false
        end
        -- Echo(presets_exist)
        -- Echo(groups_exist)
        if groups_exist and presets_exist then
            input_fields_section.enabled = true
            -- grey_area.visible = false
            if generate_or_user then
                input_fields_section:FindRecursive('presets_label').enabled = true
                input_fields_section:FindRecursive('presets_input').enabled = true
                -- first_preset_grey_overlay.visible = false
            else
                input_fields_section:FindRecursive('presets_label').enabled = false
                input_fields_section:FindRecursive('presets_input').enabled = false
                -- first_preset_grey_overlay.visible = true
            end
            suggested_pool_numbers = calculate_first_pool_objects(groups,presets,generate_or_user,picker_type,position_preset_names)
            fill_in_pool_inputs(suggested_pool_numbers)
            update_summary(picker_type,suggested_pool_numbers)
        else
            input_fields_section.enabled = false
            -- grey_area.visible = true

            input_fields_section:FindRecursive('presets_label').enabled = true
            input_fields_section:FindRecursive('presets_input').enabled = true
            -- first_preset_grey_overlay.visible = false
        end
    end

    function YB_GMA3_CP_GEN.focus_get(caller)
        caller.SelectAll()
    end

    function YB_GMA3_CP_GEN.pool_inputs_focus_lost(caller)
        local current_text_color = caller.textcolor
        local content = caller.content
        local input_name = caller.name:match('(.*)_input')
        -- Echo(input_name)
        local amount = suggested_pool_numbers[input_name].amount
        local pool = suggested_pool_numbers[input_name].pool
        local fits,new_suggested = can_fit_objects(tonumber(content),amount,pool)
        if not fits then
            caller.textcolor = 'Global.ErrorText'
            caller.content = 'Wrong input/\nno space'
            Timer(
                    function ()
                        caller.content = new_suggested
                        caller.textcolor = current_text_color
                        update_summary(suggested_pool_numbers.picker_type,suggested_pool_numbers)
                    end
                ,0.5,1)
        else
            update_summary(suggested_pool_numbers.picker_type,suggested_pool_numbers)
        end
        caller.DeSelect()
    end

    function YB_GMA3_CP_GEN.radio_button_selected(caller)
        if caller.name == 'presets_type' then
            if caller.SelectedItemValueStr == '1' then
                selected_presets_label.enabled = false
                selected_presets_input.enabled = false
            else
                selected_presets_label.enabled = true
                selected_presets_input.enabled = true
            end
            selected_presets_label:Changed()
            selected_presets_input:Changed()
        end
        check_groups_and_presets()
        -- YB_GMA3_CP_GEN.on_text_changed(caller)
    end

    function YB_GMA3_CP_GEN.on_text_changed(caller)
        check_groups_and_presets(caller)
    end

    function YB_GMA3_CP_GEN.key_up(caller,dummy,key_code)
        if key_code == Enums.KeyboardCodes.Enter then
            FindNextFocus()
        end
    end

    local function check_user_input_complete(groups,presets,generate)
        if #groups < 1 then
            return false
        end
        if not generate and #presets < 1 then
            return false
        end
        for _,info_field in ipairs(summary_section:UIChildren()) do
            if info_field.text == '' then
                return false
            end
        end
        return true
    end

    function YB_GMA3_CP_GEN.ok_cancel_clicked(caller)
        if caller.text == 'Create Layout' then
            local input_complete = true
            local picker_type
            if type_radio_selector.SelectedItemValueStr == '1' then
                picker_type = 'color'
            elseif type_radio_selector.SelectedItemValueStr == '2' then
                picker_type = 'position'
            end
            local selected_groups = ObjectList('group '..selected_grops_input.content)
            if #selected_groups < 1 or selected_groups[1]:GetClass() == 'Groups' then
                selected_groups = {}
            end
            local generate_presets = presets_radio_selector.SelectedItemValueStr == '1' and true or false
            local user_presets = ObjectList('preset '..picker_type..'.'..selected_presets_input.content)            
            if #user_presets < 1 or user_presets[1]:GetClass() == 'Presets' then
                user_presets = {}
            end
            local checked_goups = {}
            local checked_presets = {}
            local wrong_preset_detected
            local non_moving_detected
            local expected_preset_data
            if picker_type == 'position' then
                expected_preset_data = 'Selective'
                for _,group in ipairs(selected_groups) do
                    if check_if_moving_fixture(group) then
                        table.insert(checked_goups,group)
                    else
                        non_moving_detected = true
                    end
                end
            elseif picker_type == 'color' then
                expected_preset_data = 'Universal'
                checked_goups = selected_groups
            end
            if type(user_presets) == 'table' then
                for _,preset in ipairs(user_presets) do
                    if preset.storeddata == expected_preset_data and not check_if_multistep_preset(preset) then
                        table.insert(checked_presets,preset)
                    else
                        wrong_preset_detected = true
                    end
                end
            end
            if non_moving_detected then
                Confirm('','One ore more Groups from the range are empty or not all fixtures in these Groups have Pan or Tilt. Groups were deleted from the range.',nil,false)
            end
            if wrong_preset_detected then
                Confirm('','Non-'..expected_preset_data:lower()..' and/or multistep preset(s) deleted from the range',nil,false)
            end
            input_complete = check_user_input_complete(checked_goups,checked_presets,generate_presets)
            if input_complete then
                result = {
                    amount_of_generated_presets=suggested_pool_numbers.amount_of_generated_presets,
                    picker_type=picker_type,
                    groups_selected=checked_goups,
                    generate_presets=generate_presets,
                    presets_obj=checked_presets,
                    first_preset=tonumber(input_fields_section.presets_input.content),
                    layout_number=tonumber(input_fields_section.layout_input.content),
                    first_appear=tonumber(input_fields_section.appearances_input.content),
                    first_matrick=tonumber(input_fields_section.matricks_input.content),
                    first_macro=tonumber(input_fields_section.macros_input.content),
                    first_tag=tonumber(input_fields_section.tags_input.content),
                    first_sequence=tonumber(input_fields_section.sequences_input.content)
                }
                continue = true
            end
        else
            continue = true
        end
    end

    function YB_GMA3_CP_GEN.window_closed(caller,token)
        -- Echo(token)
        continue = true
    end

    buttons_section:WaitInit()
    buttons_section:Changed()
    base_input:OverlaySetCloseCallback('window_closed')
    while not continue do
        coroutine.yield(0.1)
    end

    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
    coroutine.yield({ui=3})
    return result

end

-- return function (display)
--     YB_GMA3_CP_GEN.new_ui(display,{1,2,3,4,5,6,7,8})
-- end