local c = Cmd
local ti = TextInput

function generate_uinv_col_preset(first_preset,number_of_presets,groups,name_prefix,progress_bar_time,DP)
    --[[
        Function to create universal color presets
    ]]--
    local presets = {}
    local preset_num = first_preset
    local preset_pool = ShowData().DataPools[DP].PresetPools[4]
    local progHandle = StartProgress("Creating color Presets")
    SetProgressRange(progHandle, 1, number_of_presets)
    local MAGelPool = ShowData().GelPools[1]
    preset_pool:Set('presetmode',3)
    c("Universal 1  /nu")
    for i=1,#groups do
        c('Group '..groups[i])
    end
    c("At Gel 1.1; Store Preset 4." .. preset_num..' /nu')
    preset_pool[preset_num]:Set('name',name_prefix..MAGelPool[1].name)
    SetProgress(progHandle, 1)
    coroutine.yield(progress_bar_time)
    -- c('At Gel 5.76; Store Preset 4.' .. 1+preset_num..' /nu')
    c('At Gel 7.114; Store Preset 4.' .. 1+preset_num..' /nu')
    preset_pool[1+preset_num]:Set('name',name_prefix..'CTB')
    SetProgress(progHandle, 2)
    coroutine.yield(progress_bar_time)
    -- c('At Gel 4.2; Store Preset 4.' .. 2+preset_num..' /nu')
    c('At Gel 7.117; Store Preset 4.' .. 2+preset_num..' /nu')
    preset_pool[2+preset_num]:Set('name',name_prefix..'CTO')
    SetProgress(progHandle, 3)
    coroutine.yield(progress_bar_time)
    for i = 2, 13 do
        c("At Gel 1." .. i .. "; Store Preset 4." .. i+1+preset_num..'  /nu')
        preset_pool[i+1+preset_num]:Set('name',name_prefix..MAGelPool[i].name)
        SetProgress(progHandle, i+2)
        coroutine.yield(progress_bar_time)
    end
    c("ClearAll  /nu")
    preset_pool:Set('presetmode',2)
    StopProgress(progHandle)
    for i = 1, number_of_presets do 
        presets[i] = first_preset + i - 1
    end
    return presets
end