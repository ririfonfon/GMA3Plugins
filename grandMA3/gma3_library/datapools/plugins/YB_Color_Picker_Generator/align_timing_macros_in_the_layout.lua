local c = Cmd
local ti = TextInput

function cp_layout_align_timing_macros(last_obj, timing_macros_amount_lay,first_macro, size_x, size_y,gap_x,gap_y,start_pos_x,start_pos_y,amount_of_groups,cp_layout,name_prefix,progress_bar_time,DP)
    local macros = ShowData().DataPools[DP].Macros
    -- create table with all fade macros
    local fade_macros = {}
    local delayfrom_macros = {}
    local delayto_macros = {}
    local xgroup_macros = {}
    local xwings_macros = {}
    local macro_num = first_macro
    local last_macro = first_macro + timing_macros_amount_lay - 1
    local i = 1
    while macro_num <= last_macro do
        if string.find(macros[macro_num].name, name_prefix..'Fade') then
            fade_macros[i] = macros[macro_num].no
            i = i + 1
        else
        end
    macro_num = macro_num + 1
    end
    i = 1
    macro_num = first_macro
    while macro_num <= last_macro do
        if string.find(macros[macro_num].name, name_prefix..'DelayFrom') then
            delayfrom_macros[i] = macros[macro_num].no
            i = i + 1
        else
        end
    macro_num = macro_num + 1
    end
    i = 1
    macro_num = first_macro
    while macro_num <= last_macro do
        if string.find(macros[macro_num].name, name_prefix..'DelayTo') then
            delayto_macros[i] = macros[macro_num].no
            i = i + 1
        else
        end
    macro_num = macro_num + 1
    end
    i = 1
    macro_num = first_macro
    while macro_num <= last_macro do
        if string.find(macros[macro_num].name, name_prefix..'XGroup') then
            xgroup_macros[i] = macros[macro_num].no
            i = i + 1
        else
        end
    macro_num = macro_num + 1
    end
    i = 1
    macro_num = first_macro
    while macro_num <= last_macro do
        if string.find(macros[macro_num].name, name_prefix..'XWings') then
            xwings_macros[i] = macros[macro_num].no
            i = i + 1
        else
        end
    macro_num = macro_num + 1
    end
    -------------------------------------------------------------------------
    local progHandle = StartProgress("Aligning Timing Macros")
    -- align fade macros
    local pos_x = start_pos_x -- position of te first object by x-axis
    local pos_y = start_pos_y - math.floor(gap_y * 0.4) - gap_y * amount_of_groups -- position of te first object by y-axis
    local object_type = 'macro'
    local obj_num = last_obj -- number of the object assigned to layout
    local col_num = 1
    local pool_obj_num = fade_macros[1] -- pool number of the first object
    local obj_count = #fade_macros -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local x_count = #fade_macros -- number of columns
    local last_layout_obj_num = obj_num + timing_macros_amount_lay - 1
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    -- define the range of the progress bar:
	SetProgressRange(progHandle, last_obj, last_layout_obj_num)
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilitybar',false)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            SetProgress(progHandle, obj_num)
            coroutine.yield(progress_bar_time)
            obj_num = obj_num + 1
        end
    -- align delay-from macros
    pos_x = start_pos_x -- position of te first object by x-axis
    pos_y = pos_y - gap_y - math.floor(gap_y * 0.2) -- position of te first object by y-axis
    object_type = 'macro'
    col_num = 1
    pool_obj_num = delayfrom_macros[1] -- pool number of the first object
    obj_count = #delayfrom_macros -- amout of objects to be aligned
    last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    x_count = #delayfrom_macros -- number of columns
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilitybar',false)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            SetProgress(progHandle, obj_num)
            coroutine.yield(progress_bar_time)
            obj_num = obj_num + 1
        end
    -- align delay-to macros
    pos_x = start_pos_x + gap_x * #delayfrom_macros + gap_x + math.floor(gap_x * 0.4) -- position of te first object by x-axis
    object_type = 'macro'
    col_num = 1
    pool_obj_num = delayto_macros[1] -- pool number of the first object
    obj_count = #delayto_macros -- amout of objects to be aligned
    last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    x_count = #delayto_macros -- number of columns
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilitybar',false)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            SetProgress(progHandle, obj_num)
            coroutine.yield(progress_bar_time)
            obj_num = obj_num + 1
        end
    -- align xgroup macros
    pos_x = start_pos_x -- position of te first object by x-axis
    pos_y = pos_y - gap_y - math.floor(gap_y * 0.2) -- position of te first object by y-axis
    object_type = 'macro'
    col_num = 1
    pool_obj_num = xgroup_macros[1] -- pool number of the first object
    obj_count = #xgroup_macros -- amout of objects to be aligned
    last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    x_count = #xgroup_macros -- number of columns
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilitybar',false)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            SetProgress(progHandle, obj_num)
            coroutine.yield(progress_bar_time)
            obj_num = obj_num + 1
        end
    -- align xwings macros
    pos_x = start_pos_x + gap_x * #xgroup_macros + gap_x + math.floor(gap_x * 0.4) -- position of te first object by x-axis
    object_type = 'macro'
    col_num = 1
    pool_obj_num = xwings_macros[1] -- pool number of the first object
    obj_count = #xwings_macros -- amout of objects to be aligned
    last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    x_count = #xwings_macros -- number of columns
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilitybar',false)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            col_num = col_num + 1
            SetProgress(progHandle, obj_num)
            coroutine.yield(progress_bar_time)
            obj_num = obj_num + 1
        end
    StopProgress(progHandle)
    return obj_num
end