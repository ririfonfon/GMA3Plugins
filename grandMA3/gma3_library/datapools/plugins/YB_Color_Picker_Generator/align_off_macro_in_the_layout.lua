local c = Cmd
local ti = TextInput

function cp_layout_aligh_off_macro(last_obj,size_x,size_y,gap_x,gap_y,start_pos_x,start_pos_y,last_macro,amount_of_groups,cp_layout,DP)
    local pos_x = start_pos_x + gap_x * 13 -- position of te first object by x-axis
    local pos_y = start_pos_y - gap_y * amount_of_groups - math.floor(gap_y * 2) -- position of te first object by y-axis
    local object_type = 'macro'
    local obj_num = last_obj -- number of the object assigned to layout
    local pool_obj_num = last_macro -- pool number of the first object
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    c('assign '..object_type..' '..pool_obj_num..' at layout '..color_layout..' /nu')
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x*2)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y*2)
    layout_pool[color_layout][obj_num]:Set('visibilityborder',false)
    obj_num = obj_num + 1
    return (obj_num)
end