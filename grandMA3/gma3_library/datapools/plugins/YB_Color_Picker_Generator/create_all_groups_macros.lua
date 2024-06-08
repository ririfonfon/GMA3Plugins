local c = Cmd
local ti = TextInput

function cp_create_all_groups_macros(starting_macro,presets,first_appear,name_prefix,progress_bar_time,DP)
    local progHandle = StartProgress("Generating OFF macros")
    local first_macro = starting_macro
    local macro_amount = #presets
    local last_macro = first_macro + macro_amount - 1
    local appearance_num = first_appear
    local macro_num = first_macro
    local ColorPresetPool = ShowData().datapools[DP].PresetPools[4]
    local preset_i = 1
    local preset_num = presets[preset_i]
    local macros_pool = ShowData().datapools[DP].Macros
    SetProgressRange(progHandle, first_macro, last_macro)
    while macro_num <= last_macro do
        c('store macro '..macro_num..'.1 /nu')
        macros_pool[macro_num][1]:Set('Command', 'go sequence "'..name_prefix..'*['..ColorPresetPool[presets[preset_i]].name..']')
        macros_pool[macro_num]:Set('appearance',ColorPresetPool[presets[preset_i]].name..' [arrow]')
        macros_pool[macro_num]:Set('name', name_prefix..'ALL ['..tostring(ColorPresetPool[presets[preset_i]].name):gsub('CP%d+_','')..']')
        -- macros_pool[macro_num]:Set('appearance',appearance_num)
        macro_num = macro_num + 1
        preset_num = preset_num + 1
        preset_i = preset_i + 1
        appearance_num = appearance_num + 1
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
    end
    StopProgress(progHandle)
    return macro_num
end