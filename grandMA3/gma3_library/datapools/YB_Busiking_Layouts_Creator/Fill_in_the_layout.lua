--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local YB_GMA3_CP_GEN = select(3,...)

local function arrange_sequences(generate_presets,picker_type,x_count, y_count, layout_globals,sequences,  color_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x -- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local obj_count = x_count * y_count -- amout of objects to be aligned
    local obj_index = 1
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning Sequences")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
	SetProgressRange(progHandle, 1, obj_count)
    for line_num = 1, y_count do
        for col_num = 1, x_count do
            local element = layout:Acquire()
            element:Set('object',sequences[obj_index])
            element:Set('posx',65536+pos_x)
            element:Set('posy',pos_y)
            element:Set('action',14)
            element:Set('visibilityobjectname',false)
            element:Set('visibilityindicatorbar',false)
            if not generate_presets and picker_type == 'position' then
                element:Set('visibilitybar',true)
            else
                element:Set('visibilitybar',false)
            end
            element:Set('POSITIONH',size_x)
            element:Set('POSITIONW',size_y)
            element:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            IncProgress(progHandle,1)
            obj_index = obj_index + 1
        end
        pos_x = start_pos_x
        pos_y = pos_y - gap_y
    end
    StopProgress(progHandle)
end

local function arrange_groups( layout_globals,groups,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x - math.floor(gap_x * 1.4) -- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local layout_pool = ShowData().datapools[DP].Layouts
    local color_layout = cp_layout -- layout in the layout pool
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning Groups")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
	SetProgressRange(progHandle, 1, #groups)
    for _,group in ipairs(groups) do
        local element = layout:Acquire()
        element:Set('object',group)
        element:Set('posx',65536+pos_x)
        element:Set('posy',pos_y)
        element:Set('POSITIONH',size_x)
        element:Set('POSITIONW',size_y)
        element:Set('visibilityborder',false)
        IncProgress(progHandle,1)
        pos_y = pos_y - gap_y
    end    
    StopProgress(progHandle)
end

local function arrange_matricks(layout_globals,matricks,number_of_presets,amount_of_groups,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x + gap_x * number_of_presets + math.floor(gap_x * 0.2)-- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local obj_index = 1
    local line_num = 1
    local y_count = amount_of_groups -- number pf rows
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning MATricks")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
	SetProgressRange(progHandle, 1, y_count-line_num)
    while line_num <= y_count do
        local element = layout:Acquire()
        element:Set('object',matricks[obj_index])
        element:Set('posx',65536+pos_x)
        element:Set('posy',pos_y)
        element:Set('VisibilityID',false)
        element:Set('POSITIONH',size_x)
        element:Set('POSITIONW',size_y)
        element:Set('visibilityborder',false)
        IncProgress(progHandle,1)
        obj_index = obj_index + 1
        line_num = line_num + 1
        pos_y = pos_y - gap_y
    end    
    StopProgress(progHandle)
end

local function arrange_all_groups_macros(macros, layout_globals,number_of_presets,picker_type,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x -- position of te first object by x-axis
    local pos_y = start_pos_y + math.floor(gap_y * 1.2) -- position of te first object by y-axis
    local pool_obj_num = macros[1]:Index() -- pool number of the first object
    local x_count = number_of_presets -- number of columns
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning OFF Macros")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
	SetProgressRange(progHandle, 1, x_count)
        for _,macro in ipairs(macros) do
            local element = layout:Acquire()
            element:Set('object',macro)
            element:Set('posx',65536+pos_x)
            element:Set('posy',pos_y)
            element:Set('POSITIONH',size_x)
            element:Set('POSITIONW',size_y)
            element:Set('visibilityobjectname',false)
            element:Set('visibilityborder',false)
            if picker_type == 'color' then
                element:Set('visibilityindicatorbar',true)
            elseif picker_type == 'position' then
                element:Set('visibilityindicatorbar',false)
            end
            pos_x = pos_x + gap_x
            IncProgress(progHandle,1)
            pool_obj_num = pool_obj_num + 1
        end
    StopProgress(progHandle)
end

local function arrange_timing_macros( created_macros, layout_globals,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning Timing Macros")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    SetProgressRange(progHandle, 1, #created_macros)
    start_pos_y = start_pos_y + math.floor(gap_y * 0.7) + gap_y * 5
    -- start_pos_y = start_pos_y - math.floor(gap_y * 0.4) - gap_y * amount_of_groups
    ------------------------------------------------------------------------
    local layout_positions = {
        -- {pos_x = start_pos_x,pos_y = start_pos_y},
        {pos_x = start_pos_x,pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2)},
        {pos_x = start_pos_x + gap_x * #created_macros[3] + gap_x + math.floor(gap_x * 0.4),pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2)},
        {pos_x = start_pos_x, pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2) - gap_y - math.floor(gap_y * 0.2)},
        {pos_x = start_pos_x + gap_x * #created_macros[4] + gap_x + math.floor(gap_x * 0.4),pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2) - gap_y - math.floor(gap_y * 0.2)},
    }
    -- local layout_positions = {
    --     {pos_x = start_pos_x,pos_y = start_pos_y},
    --     {pos_x = start_pos_x,pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2)},
    --     {pos_x = start_pos_x + gap_x * #created_macros[3] + gap_x + math.floor(gap_x * 0.4),pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2)},
    --     {pos_x = start_pos_x, pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2) - gap_y - math.floor(gap_y * 0.2)},
    --     {pos_x = start_pos_x + gap_x * #created_macros[4] + gap_x + math.floor(gap_x * 0.4),pos_y = start_pos_y - gap_y - math.floor(gap_y * 0.2) - gap_y - math.floor(gap_y * 0.2)},
    -- }
    for subgroup_index,created_macros_subgroup in pairs(created_macros) do
        local pos_x = layout_positions[subgroup_index].pos_x -- position of te first object by x-axis
        local pos_y = layout_positions[subgroup_index].pos_y -- position of te first object by y-axis
            for _,created_macro in ipairs(created_macros_subgroup) do
                local element = layout:Acquire()
                element:Set('object',created_macro)
                element:Set('posx',65536+pos_x)
                element:Set('posy',pos_y)
                element:Set('visibilityobjectname',false)
                element:Set('visibilityindicatorbar',false)
                element:Set('visibilitybar',false)
                element:Set('POSITIONH',size_x)
                element:Set('POSITIONW',size_y)
                element:Set('visibilityborder',false)
                if created_macro.name:find('%[INPUT%]') then
                    element:Set('customTextAlignmentV',Enums.LayoutElementAlignmentV.Center)
                    element:Set('customTextSize','20')
                    element:Set('customTextColor',created_macro.appearance.imagergba)
                end
                pos_x = pos_x + gap_x
                IncProgress(progHandle,1)
            end
    end
    StopProgress(progHandle)
end

local function arrange_off_macro(layout_globals,macro,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x + gap_x * 13 -- position of te first object by x-axis
    local pos_y = start_pos_y + gap_y * 4 -- position of te first object by y-axis
    -- local pos_y = start_pos_y - gap_y * amount_of_groups - math.floor(gap_y * 2) -- position of te first object by y-axis
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local element = layout:Acquire()
    element:Set('object',macro)
    element:Set('posx',65536+pos_x)
    element:Set('posy',pos_y)
    element:Set('VisibilityBar',true)
    element:Set('POSITIONH',size_x*2)
    element:Set('POSITIONW',size_y*2)
    element:Set('visibilityborder',false)
end

local function arrange_favourites( macros, layout_globals,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x - gap_x*4 -- position of the first object by x-axis
    -- local pos_y = start_pos_y - math.floor(gap_y * 0.5) -- position of te first object by y-axis
    local pos_y = start_pos_y + size_y*4.5 -- position of te first object by y-axis
    local object_type = macros[1]:GetClass()
    local col_num = 1
    local line_num = 1
    local pool_obj_num = macros[1]:Index() -- pool number of the first object (17 - number of favoutite macros)
    local x_count = 2 -- number of columns
    local y_count = 8 -- number of rows
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local progHandle = StartProgress("Aligning Favourites Macros")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
	SetProgressRange(progHandle, 0, x_count-col_num)
    local element = layout:Acquire()
    element:Set('object',GetObject(object_type..' '..pool_obj_num))
    element:Set('posx',math.floor(65536+pos_x))
    element:Set('posy',math.floor(pos_y-gap_y*8.5))
    element:Set('VisibilityBar',false)
    element:Set('POSITIONH',size_x)
    element:Set('POSITIONW',size_y*2)
    element:Set('visibilityborder',false)
    element:Set('visibilityindicatorbar',true)
    pool_obj_num = pool_obj_num + 1
    while line_num <= y_count do
        while col_num <= x_count do
            element = layout:Acquire()
            element:Set('object',GetObject(object_type..' '..pool_obj_num))
            element:Set('posx',math.floor(65536+pos_x))
            element:Set('posy',math.floor(pos_y))
            element:Set('POSITIONH',size_x)
            element:Set('POSITIONW',size_y)
            element:Set('VisibilityBar',false)
            element:Set('visibilityindicatorbar',false)
            element:Set('visibilityobjectname',false)
            element:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            IncProgress(progHandle,1)
            col_num = col_num + 1
            pool_obj_num = pool_obj_num + 1
        end
        line_num = line_num + 1
        col_num = 1
        pos_x = start_pos_x - gap_x*4
        pos_y = pos_y  - gap_y
    end
    StopProgress(progHandle)
end

local function arrange_labelling_elements(layout_globals,presets,in_declared_timings,created_timing_macros,naming_prefix,cp_layout,DP)
    local start_pos_x = layout_globals.start_pos_x
    local start_pos_y = layout_globals.start_pos_y
    local size_x = layout_globals.size_x
    local size_y = layout_globals.size_y
    local gap_x = layout_globals.gap_x
    local gap_y = layout_globals.gap_y
    local pos_x = start_pos_x - math.floor(gap_x * 1.2) -- position of te first object by x-axis
    local pos_y = start_pos_y + math.floor(gap_y * 0.7) + gap_y * 5 -- position of te first object by y-axis
    -- local pos_y = start_pos_y - math.floor(gap_y * 0.4) - gap_y * amount_of_groups
    local element_amount = #presets + 5
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local layout = layout_pool[color_layout]
    local col_num = 1
    local preset_i = 1
    local progHandle = StartProgress("Creating labelling elements")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    SetProgressRange(progHandle, 0, element_amount)
    --------------------------------------------------------------------------
    -- timing labels
    local positions = {
        -- {pos_x=pos_x,pos_y=pos_y},
        {pos_x=pos_x,pos_y=pos_y - gap_y - math.floor(gap_y * 0.2)},
        {pos_x=pos_x + gap_x * #in_declared_timings[2] + gap_x + math.floor(gap_x * 0.4),pos_y=pos_y - gap_y - math.floor(gap_y * 0.2)},
        {pos_x=start_pos_x - math.floor(gap_x * 1.2),pos_y=pos_y - gap_y*2 - math.floor(gap_y * 0.2)*2},
        {pos_x=pos_x + gap_x * #in_declared_timings[4] + gap_x + math.floor(gap_x * 0.4),pos_y=pos_y - gap_y*2 - math.floor(gap_y * 0.2)*2},
    }
    -- local positions = {
    --     {pos_x=pos_x,pos_y=pos_y},
    --     {pos_x=pos_x,pos_y=pos_y - gap_y - math.floor(gap_y * 0.2)},
    --     {pos_x=pos_x + gap_x * #in_declared_timings[3] + gap_x + math.floor(gap_x * 0.4),pos_y=pos_y - gap_y - math.floor(gap_y * 0.2)},
    --     {pos_x=start_pos_x - math.floor(gap_x * 1.2),pos_y=pos_y - gap_y*2 - math.floor(gap_y * 0.2)*2},
    --     {pos_x=pos_x + gap_x * #in_declared_timings[5] + gap_x + math.floor(gap_x * 0.4),pos_y=pos_y - gap_y*2 - math.floor(gap_y * 0.2)*2},
    -- }
    for subgroup_index,subgroup_data in ipairs(created_timing_macros )do
        local el_pos_x = positions[subgroup_index].pos_x
        local el_pos_y = positions[subgroup_index].pos_y
        local subgroup_name = subgroup_data.subgroup_name
        local element = layout:Acquire()
        element:Set('posx',65536+el_pos_x)
        element:Set('posy',el_pos_y)
        element:Set('POSITIONH',size_x)
        element:Set('POSITIONW',size_y)
        element:Set('CUSTOMTEXTTEXT',subgroup_name..' >>')
        element:Set('CUSTOMTEXTSIZE',20)
        element:Set('VISIBILITYBORDER',false)
        element:Set('POSITIONH',size_x)
        element:Set('POSITIONW',size_y)
        IncProgress(progHandle,1)
        -- coroutine.yield(progress_bar_time)
    end
    -------------------- Color Labels --------------
    pos_x = start_pos_x
    pos_y = start_pos_y + gap_y + math.floor(gap_y * 1.2)
    for _,preset in ipairs(presets) do
        local element = layout:Acquire()
        element:Set('posx',65536+pos_x)
        element:Set('posy',pos_y)
        -- element:Set('VisibilityBar',true)    
        element:Set('POSITIONH',size_x)
        element:Set('POSITIONW',size_y)
        element:Set('CUSTOMTEXTTEXT',preset.name:gsub(naming_prefix,''))
        element:Set('CUSTOMTEXTSIZE',20)
        element:Set('CUSTOMTEXTALIGNMENTV','Bottom')
        element:Set('VISIBILITYBORDER',false)
        pos_x = pos_x + gap_x
        preset_i = preset_i + 1
        col_num = col_num + 1
        IncProgress(progHandle,1)
    end
    StopProgress(progHandle)
end

function YB_GMA3_CP_GEN.fill_in_the_layout (declared_timings,user_input,sequences,matricks,macros,layout_globals,naming_prefix,DP)
    local presets = user_input.presets_obj
    local groups = user_input.groups_selected
    local layout = user_input.layout_number
    local picker_type = user_input.picker_type
    local generate_presets = user_input.generate_presets
    arrange_sequences(generate_presets,picker_type,#presets, #groups, layout_globals, sequences, layout,DP)
    arrange_groups(layout_globals,groups,layout,DP)
    arrange_matricks(layout_globals,matricks,#presets,#groups,layout,DP)
    arrange_all_groups_macros(macros.all_groups_macros, layout_globals,#presets,picker_type,layout,DP)
    arrange_timing_macros(macros.timing_macros, layout_globals,layout,DP)
    arrange_off_macro(layout_globals,macros.off_macro,layout,DP)
    arrange_favourites( macros.favourite_macros, layout_globals,layout,DP)
    arrange_labelling_elements(layout_globals,presets,declared_timings,macros.timing_macros,naming_prefix,layout,DP)
end