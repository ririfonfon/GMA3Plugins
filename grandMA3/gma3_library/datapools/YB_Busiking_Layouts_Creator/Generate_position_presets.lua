--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local C = Cmd
local YB_GMA3_CP_GEN = select(3,...)

function YB_GMA3_CP_GEN.generate_position_presets(DP,user_input,names,prefix,smart)
    -- require 'gma3_debug'()
    local selected_groups = user_input.groups_selected
    local preset_offset = user_input.first_preset
    -- ShowData().LivePatch.Stages[1].Fixtures[GetSubfixture(ShowData().DataPools[1].Groups[4].selectiondata[1].sf_index).name].rotz
    local position_preset_pool = ShowData().DataPools[DP].presetpools.position
    -- fixtures[GetSubfixture[groups_pool[].]]
    local center = {'Attribute "xyz_x" At absolute 50','Attribute "xyz_y" At absolute 50','Attribute "xyz_z" At absolute 1'}
    local straight = {'Attribute "Tilt" At Absolute Physical -50'}
    local fan_in = {'Attribute "tilt" at absolute physical -50','attribute "pan" at absolute physical 30 thru -30'}
    local fan_out = {'Attribute "tilt" at absolute physical -50','attribute "pan" at absolute physical -30 thru 30'}
    local cross_down = {'attribute "tilt" at absolute physical -50','set selection property "xgroup" 2','next','attribute "pan" at absolute physical -30','next','attribute "pan" at absolute physical 30','reset selection'}
    local straight_up = {'Attribute "Tilt" At Absolute Physical -105'}
    local fan_in_up = {'Attribute "tilt" at absolute physical -105','attribute "pan" at absolute physical 30 thru -30'}
    local fan_out_up = {'Attribute "tilt" at absolute physical -105','attribute "pan" at absolute physical -30 thru 30'}
    local cross_up = {'attribute "tilt" at absolute physical -105','set selection property "xgroup" 2','next','attribute "pan" at absolute physical -30','next','attribute "pan" at absolute physical 30','reset selection'}
    -- local positions = {center,straight,fan_in,fan_out,cross_down,straight_up,fan_in_up,fan_out_up,cross_up}
    local positions = {straight,fan_in,fan_out,cross_down,straight_up,fan_in_up,fan_out_up,cross_up}
    -- local position_preset_names = {'Center','Straight Down', 'Fan In Down', 'Fan Out Down', 'Cross Down', 'Straight Up', 'Fan In Up', 'Fan Out Up', 'Cross Up'}
    local position_preset_names = names
    -- local groups_pool = DataPool().Groups
    local presets = {}
    local rot_x
    local rot_z
    local pan_min
    local pan_max
    local pan_zero
    local tilt_up
    local tilt_down
    local abs_tilt_down
    local rot_z_avg
    local rot_x_avg
    local offset = preset_offset - 1
    local amount_of_presets = #positions
    local preset_i = 1
    local preset_num = 1
    local progress = preset_num
    local progHandle = StartProgress("Generating position presets")
    SetProgressRange(progHandle, preset_num, (#positions*#selected_groups))
    -- C('Clearall'..' /nu')
    for _,group in ipairs(selected_groups) do
        if smart then
            -- rot_x = math.floor(GetSubfixture(group.selectiondata[1].sf_index).fixture.rotx)
            -- rot_z = math.floor(fixtures[GetSubfixture(group.selectiondata[1].sf_index).name].rotz)
            local sumz = 0
            local sumx = 0
            local selection = group.selectiondata
            for k = 1, #selection do
                -- local val = math.floor(fixtures[GetSubfixture(group.selectiondata[k].sf_index).name].rotz)
                local val = math.floor(GetSubfixture(group.selectiondata[k].sf_index).fixture.rotz)
                if val < 0 then
                    val = val + 1
                end
                -- Echo(val)
                sumz = sumz + val
            end
            for k = 1, #selection do
                local val = math.floor(GetSubfixture(group.selectiondata[k].sf_index).fixture.rotx)
                if val < 0 then
                    val = val + 1
                end
                -- Echo(val)
                sumx = sumx + val
            end
            rot_z_avg = math.floor(sumz/#selection)
            rot_x_avg = math.floor(sumx/#selection)
            -- Echo('Group '..groups[group_i]..' avg rot-z is '..rot_z_avg)
            abs_tilt_down = 50
            if rot_x_avg >= (180-125+40+abs_tilt_down) then
                tilt_down =  (180-rot_x_avg+40+abs_tilt_down)
                tilt_up = tilt_down - 30
                pan_min = rot_z_avg - 15
                pan_max = rot_z_avg + 15
            elseif rot_x_avg >= (-60 - abs_tilt_down) and rot_x_avg <= (85 - abs_tilt_down) then
                tilt_down = -(abs_tilt_down + rot_x_avg)
                tilt_up = tilt_down - 40
                pan_max = rot_z_avg - 30
                pan_min = rot_z_avg + 30
            elseif  rot_x_avg < (-60 - abs_tilt_down) then
                tilt_down =  -(90 + rot_x_avg)
                tilt_up = tilt_down - 30
                pan_min = rot_z_avg - 15
                pan_max = rot_z_avg + 15
            else
                tilt_down = 0
                tilt_up = 0
                pan_min = 0
                pan_max = 0
            end
            pan_zero = rot_z_avg
            if rot_z_avg > 90  then
                tilt_down = -tilt_down
                tilt_up = -tilt_up
                pan_zero = rot_z_avg - 180
                pan_max = pan_max - 180
                pan_min = pan_min - 180
            elseif rot_z_avg < (-90) then
                tilt_down = -tilt_down
                tilt_up = -tilt_up
                pan_zero = rot_z_avg + 180
                pan_max = pan_max + 180
                pan_min = pan_min + 180
            end
            straight = {'Attribute "Tilt" At Absolute Physical '..tilt_down,'attribute "pan" at absolute physical '..pan_zero}
            fan_in = {'Attribute "tilt" at absolute physical '..tilt_down,'attribute "pan" at absolute physical '..pan_min..' thru '..pan_max}
            fan_out = {'Attribute "tilt" at absolute physical '..tilt_down,'attribute "pan" at absolute physical '..pan_max..' thru '..pan_min}
            cross_down = {'attribute "tilt" at absolute physical '..tilt_down,'set selection property "xgroup" 2','next','attribute "pan" at absolute physical '..pan_max,'next','attribute "pan" at absolute physical '..pan_min,'reset selection'}
            straight_up = {'Attribute "Tilt" At Absolute Physical '..tilt_up,'attribute "pan" at absolute physical '..pan_zero}
            fan_in_up = {'Attribute "tilt" at absolute physical '..tilt_up,'attribute "pan" at absolute physical '..pan_min..' thru '..pan_max}
            fan_out_up = {'Attribute "tilt" at absolute physical '..tilt_up,'attribute "pan" at absolute physical '..pan_max..' thru '..pan_min}
            cross_up = {'attribute "tilt" at absolute physical '..tilt_up,'set selection property "xgroup" 2','next','attribute "pan" at absolute physical '..pan_max,'next','attribute "pan" at absolute physical '..pan_min,'reset selection'}
            positions = {straight,fan_in,fan_out,cross_down,straight_up,fan_in_up,fan_out_up,cross_up}
        end
        for _, position in ipairs(positions) do 
            C(group..' /nu')
            -- Echo('group '..groups[group_i])
            for _,command in ipairs(position) do
                C(command..' /m'..' /nu')
                -- Echo(v[i])
            end
            C('store preset 2.'..preset_num+offset..' /m'..' /nu')
            -- C('label preset 2.'..preset_num+offset..' "'..prefix..position_preset_names[preset_i]..'" /nu')
            position_preset_pool[preset_num+offset]:Set('name',prefix..position_preset_names[preset_i])
            preset_i = preset_i + 1
            preset_num = preset_num + 1
            progress = progress + 1
            IncProgress(progHandle,1)
            coroutine.yield(0)
            C('clearall'..' /nu')
        end
        preset_i = 1
        preset_num = 1
    end
        for it = 1, amount_of_presets do 
            table.insert(presets,position_preset_pool[preset_offset + it - 1])
        end
    StopProgress(progHandle)
    return presets
end