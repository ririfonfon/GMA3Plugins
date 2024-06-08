local c = Cmd
local ti = TextInput

function cp_layout_align_matrx(last_obj, size_x, size_y,gap_x,gap_y,start_pos_x,start_pos_y,first_mtrx,number_of_presets,amount_of_groups,cp_layout,progress_bar_time,DP)
    local progHandle = StartProgress("Aligning MATricks")
    local pos_x = start_pos_x + gap_x * number_of_presets + math.floor(gap_x * 0.2)-- position of te first object by x-axis
    local pos_y = start_pos_y -- position of te first object by y-axis
    local object_type = 'matricks'
    local obj_num = last_obj -- number of the object assigned to layout
    local line_num = 1
    local col_num = 1
    local pool_obj_num = first_mtrx -- pool number of the first object
    local obj_count = amount_of_groups -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local x_count = number_of_presets -- number of columns
    local y_count = amount_of_groups -- number pf rows
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    -- define the range of the progress bar:
	SetProgressRange(progHandle, line_num, y_count)
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
    while line_num <= y_count do
        layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
        layout_pool[color_layout][obj_num]:Set('posy',pos_y)
        layout_pool[color_layout][obj_num]:Set('VisibilityID',false)
        layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
        layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
        layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
        obj_num = obj_num + 1
        SetProgress(progHandle, line_num)
        coroutine.yield(progress_bar_time)
        line_num = line_num + 1
        pos_y = pos_y - gap_y
    end    
    StopProgress(progHandle)
    return (obj_num)
end