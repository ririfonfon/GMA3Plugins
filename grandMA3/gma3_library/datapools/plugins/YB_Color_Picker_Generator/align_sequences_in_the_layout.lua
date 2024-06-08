local c = Cmd
local ti = TextInput

function cp_sequences_layout_align(x_count, y_count, size_x, size_y, gap_x, gap_y, start_pos_x, start_pos_y, pool_obj_num, color_layout,progress_bar_time,DP)
    --[[
        Function to place objects in layouts
    ]]--
    -- create the progress bar:
    local progHandle = StartProgress("Aligning Sequences")
    local pos_x = start_pos_x -- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local object_type = 'sequence'
    local obj_num = 1 -- number of the object assigned to layout
    local line_num = 1
    local col_num = 1
    local obj_count = x_count * y_count -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local layout_pool = ShowData().datapools[DP].Layouts
    -- define the range of the progress bar:
	SetProgressRange(progHandle, 1, obj_count)
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
    while line_num <= y_count do
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('action',14)
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
        line_num = line_num + 1
        col_num = 1
        pos_x = start_pos_x
        pos_y = pos_y - gap_y
    end    
    StopProgress(progHandle)
    return (obj_num)
end