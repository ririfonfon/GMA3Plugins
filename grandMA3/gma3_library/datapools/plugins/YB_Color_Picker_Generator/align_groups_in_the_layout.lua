local c = Cmd
local ti = TextInput

function cp_layout_align_groups(last_obj, size_x, size_y,gap_x,gap_y,start_pos_x,start_pos_y,groups,cp_layout,progress_bar_time,DP)
    local progHandle = StartProgress("Aligning Groups")
    local pos_x = start_pos_x - math.floor(gap_x * 1.4) -- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local object_type = 'group'
    local obj_num = last_obj -- number of the object assigned to layout
    local line_num = 1
    local group_i = 1
    local pool_obj_num = groups[group_i] -- pool number of the first object
    local obj_count = #groups -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local layout_pool = ShowData().datapools[DP].Layouts
    local y_count = obj_count -- number pf rows
    local color_layout = cp_layout -- layout in the layout pool
    -- define the range of the progress bar:
	SetProgressRange(progHandle, pool_obj_num, last_pool_obj)
    for i = 1, #groups do
        c('assign '..object_type..' '..groups[i]..' at layout '..color_layout..' /nu')
    end
    while line_num <= y_count do
        layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
        layout_pool[color_layout][obj_num]:Set('posy',pos_y)
        layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
        layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
        layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
        obj_num = obj_num + 1
        SetProgress(progHandle, obj_num)
        coroutine.yield(progress_bar_time)
        line_num = line_num + 1
        pos_y = pos_y - gap_y
        group_i = group_i + 1
        pool_obj_num = groups[group_i]
    end    
    StopProgress(progHandle)
    return (obj_num)
end