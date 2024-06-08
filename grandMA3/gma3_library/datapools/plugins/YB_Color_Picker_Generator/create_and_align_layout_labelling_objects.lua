local c = Cmd
local ti = TextInput

function cp_labelling_objects_layout(last_obj,size_x,size_y,gap_x,gap_y,start_pos_x,start_pos_y,cp_layout,amount_of_groups,presets,in_declared_timings,naming_prefix,progress_bar_time,DP)
    local pos_x = start_pos_x - math.floor(gap_x * 1.2) -- position of te first object by x-axis
    local pos_y = start_pos_y - math.floor(gap_y * 0.4) - gap_y * amount_of_groups -- position of te first object by y-axis
    local obj_num = last_obj -- number of the object assigned to layout
    local last_element = obj_num + #presets + 5 - 1 ------- 5 for 5 groups of timing macros
    local color_layout = cp_layout -- layout in the layout pool
    local layout_pool = ShowData().datapools[DP].Layouts
    local custom_text_key
    local custom_text_alignment_v
    local x_count = #presets
    local col_num = 1
    local custom_text_size_key
    local preset_i = 1
    local ColorPresetPool = ShowData().datapools[DP].PresetPools[4]
    local progHandle = StartProgress("Creating labelling elements")
        SetProgressRange(progHandle, obj_num, last_element)
    if Version() == '1.8.8.2' then
        custom_text_key = 'CUSTOMTEXT'
        custom_text_size_key = 'FONTSIZE'
        custom_text_alignment_v = 'TEXTALIGNMENTV'
    else
        custom_text_key = 'CUSTOMTEXTTEXT'
        custom_text_size_key = 'CUSTOMTEXTSIZE'
        custom_text_alignment_v = 'CUSTOMTEXTALIGNMENTV'
    end
    c('store layout '..cp_layout..'.'..last_obj..' thru '..last_element..' /nu')
    ------------------ Fade label -------------------
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    layout_pool[color_layout][obj_num]:Set(custom_text_key,'Fade >>')
    layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
    layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    SetProgress(progHandle, obj_num)
    coroutine.yield(progress_bar_time)
    obj_num = obj_num + 1
    ------------------ DelayFrom label -----------------
    pos_y = pos_y - gap_y - math.floor(gap_y * 0.2) -- position of te first object by y-axis
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)    
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    layout_pool[color_layout][obj_num]:Set(custom_text_key,'Delay From >>')
    layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
    layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    SetProgress(progHandle, obj_num)
    coroutine.yield(progress_bar_time)
    obj_num = obj_num + 1
    ------------------ DelayTo label -------------------
    pos_x = pos_x + gap_x * #in_declared_timings[3] + gap_x + math.floor(gap_x * 0.4) -- position of te first object by x-axis
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)    
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    layout_pool[color_layout][obj_num]:Set(custom_text_key,'Delay To >>')
    layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
    layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    SetProgress(progHandle, obj_num)
    coroutine.yield(progress_bar_time)
    obj_num = obj_num + 1
    ------------------ Groups label --------------------
    pos_x = start_pos_x - math.floor(gap_x * 1.2) -- position of te first object by x-axis
    pos_y = pos_y - gap_y - math.floor(gap_y * 0.2)-- position of te first object by y-axis
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)    
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    layout_pool[color_layout][obj_num]:Set(custom_text_key,'XGroups >>')
    layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
    layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    SetProgress(progHandle, obj_num)
    coroutine.yield(progress_bar_time)
    obj_num = obj_num + 1
    ------------------ Wings label ---------------------
    pos_x = pos_x + gap_x * #in_declared_timings[5] + gap_x + math.floor(gap_x * 0.4) -- position of te first object by x-axis
    layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
    layout_pool[color_layout][obj_num]:Set('posy',pos_y)
    layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)    
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    layout_pool[color_layout][obj_num]:Set(custom_text_key,'XWings >>')
    layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
    layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
    layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
    layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
    SetProgress(progHandle, obj_num)
    coroutine.yield(progress_bar_time)
    obj_num = obj_num + 1
    -------------------- Color Labels --------------
    pos_x = start_pos_x
    pos_y = start_pos_y + gap_y + math.floor(gap_y * 1.2)
    while col_num <= x_count do
        layout_pool[color_layout][obj_num]:Set('posx',65536+pos_x)
        layout_pool[color_layout][obj_num]:Set('posy',pos_y)
        layout_pool[color_layout][obj_num]:Set('VisibilityBar',true)    
        layout_pool[color_layout][obj_num]:Set('POSITIONH',size_x)
        layout_pool[color_layout][obj_num]:Set('POSITIONW',size_y)
        layout_pool[color_layout][obj_num]:Set(custom_text_key,ColorPresetPool[presets[preset_i]].name:gsub(naming_prefix,''))
        layout_pool[color_layout][obj_num]:Set(custom_text_size_key,20)
        layout_pool[color_layout][obj_num]:Set(custom_text_alignment_v,'Bottom')
        layout_pool[color_layout][obj_num]:Set('VISIBILITYBORDER',false)
        pos_x = pos_x + gap_x
        preset_i = preset_i + 1
        col_num = col_num + 1
        SetProgress(progHandle, obj_num)
        coroutine.yield(progress_bar_time)
        obj_num = obj_num + 1
    end
    StopProgress(progHandle)
    return obj_num
end