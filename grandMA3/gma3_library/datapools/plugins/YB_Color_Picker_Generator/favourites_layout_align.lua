local c = Cmd
local ti = TextInput

function cp_favourites_layout_align(last_obj, last_macro, size_x, size_y,gap_x,gap_y,start_pos_x,start_pos_y,number_of_presets,cp_layout,progress_bar_time,DP)
    local progHandle = StartProgress("Aligning Favourites Macros")
    local pos_x = start_pos_x - gap_x*4 - gap_x*2-- position of te first object by x-axis
    local pos_y = start_pos_y - math.floor(gap_y * 0.5) -- position of te first object by y-axis
    local object_type = 'macro'
    local obj_num = last_obj -- number of the object assigned to layout
    local col_num = 1
    local line_num = 1
    local pool_obj_num = last_macro - 17 + 1 -- pool number of the first object (17 - number of favoutite macros)
    local obj_count = 17 -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local x_count = 4 -- number of columns
    local y_count = 4 -- number of rows
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    -- define the range of the progress bar:
	SetProgressRange(progHandle, col_num, x_count)
    c('assign '..object_type..' '..pool_obj_num..' at layout '..color_layout..' /nu')
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x+gap_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y-gap_y*4.5)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y*2)
    layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
    obj_num = obj_num + 1
    pool_obj_num = pool_obj_num + 1
    c('assign '..object_type..' '..pool_obj_num..' thru '..last_pool_obj..' at layout '..color_layout..' /nu')
    while line_num <= y_count do
        while col_num <= x_count do
            layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
            layout_pool[color_layout][obj_num]:Set('posy',pos_y)
            layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
            layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
            layout_pool[color_layout][obj_num]:Set('VisibilityBar',false)
            layout_pool[color_layout][obj_num]:Set('visibilityindicatorbar',false)
            layout_pool[color_layout][obj_num]:Set('visibilityobjectname',false)
            layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
            pos_x = pos_x + gap_x
            SetProgress(progHandle, col_num)
            coroutine.yield(progress_bar_time)
            col_num = col_num + 1
            obj_num = obj_num + 1
        end
        line_num = line_num + 1
        col_num = 1
        pos_x = start_pos_x - gap_x*4 - gap_x*2
        pos_y = pos_y  - gap_y
    end
    StopProgress(progHandle)
    return obj_num
end