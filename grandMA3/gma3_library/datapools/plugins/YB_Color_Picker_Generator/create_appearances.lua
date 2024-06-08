local c = Cmd
local ti = TextInput

function cp_create_appearances(selected_presets, presets_R, presets_G, presets_B, first_appear,in_declared_timings,half_second,naming_prefix,progress_bar_time,DP)
    --[[
        Function to create appearances
    ]]--
    local GPD = GetPresetData
    local ColorPresetPool = ShowData().DataPools[DP].PresetPools[4]
    local colors_R = presets_R -- Table for Red values for appearances
    local colors_G = presets_G -- Table for Green values for appearances
    local colors_B = presets_B -- Table for Blue values for appearances
    local fade_filenames_active
    local fade_filenames
    local color_presets_for_appearances = selected_presets
    if #colors_R == 0 then
        color_presets_for_appearances = selected_presets
        local GelPools = ShowData().GelPools
        -----------------------------------------------------------------
        colors_R[1] = math.floor(255*GelPools[1][1].R)
        -- colors_R[2] = math.floor(255*GelPools[6][137].R)
        colors_R[2] = 255*GPD(ColorPresetPool[color_presets_for_appearances[2]])[3][1].absolute/100
        -- colors_R[3] = math.floor(255*GelPools[4][2].R)
        colors_R[3] = 255*GPD(ColorPresetPool[color_presets_for_appearances[3]])[3][1].absolute/100
        local i = 2
        repeat
            colors_R[i+2] = math.floor(255*GelPools[1][i].R)
            i = i + 1
        until GelPools[1][i] == nil
        colors_G[1] = math.floor(255*GelPools[1][1].G)
        -- colors_G[2] = math.floor(255*GelPools[6][137].G)
        colors_G[2] = 255*GPD(ColorPresetPool[color_presets_for_appearances[2]])[4][1].absolute/100
        -- colors_G[3] = math.floor(255*GelPools[4][2].G)
        colors_G[3] = 255*GPD(ColorPresetPool[color_presets_for_appearances[3]])[4][1].absolute/100
        i = 2
        repeat
            colors_G[i+2] = math.floor(255*GelPools[1][i].G)
            i = i + 1
        until GelPools[1][i] == nil
        colors_B[1] = math.floor(255*GelPools[1][1].B)
        -- colors_B[2] = math.floor(255*GelPools[6][137].B)
        colors_B[2] = 255*GPD(ColorPresetPool[color_presets_for_appearances[2]])[5][1].absolute/100
        -- colors_B[3] = math.floor(255*GelPools[4][2].B)
        colors_B[3] = 255*GPD(ColorPresetPool[color_presets_for_appearances[3]])[5][1].absolute/100
        i = 2
        repeat
            colors_B[i+2] = math.floor(255*GelPools[1][i].B)
            i = i + 1
        until GelPools[1][i] == nil
    end
    -------------------------------------------------------------------------------------
    local appear_num = first_appear -- ID of the first appearance in the pool
    local appear_amount = #colors_B
    local last_appear_no_mark = appear_num + appear_amount - 1
    local last_appear = appear_amount * 2 + appear_num - 1
    local total_appear_amount = appear_amount * 3 + #in_declared_timings[1]*2 + #in_declared_timings[2]*2 + #in_declared_timings[3]*2 + #in_declared_timings[4]*2 + #in_declared_timings[5]*2
    local last_appear_bar = total_appear_amount + appear_num - 1
    local first_appear_mark = appear_num + appear_amount
    local first_appear_arrow = appear_amount*2 + appear_num
    c('store appearance '..appear_num..' thru '..last_appear_no_mark..' /nu') -- create appearances -- 
    local progHandle = StartProgress("Creating Appearances")
    local appearances = ShowData().Appearances
    local progress = appear_num - 1
    -- local ColorPresetPool = ShowData().datapools[DP].PresetPools[4]
    SetProgressRange(progHandle, appear_num, last_appear_bar)
    for i = 1, #colors_R do
        appearances[appear_num]:Set("backr", colors_R[i])
        appearances[appear_num]:Set("imager", colors_R[i])
        appearances[appear_num]:Set("backg", colors_G[i])
        appearances[appear_num]:Set("imageg", colors_G[i])
        appearances[appear_num]:Set("backb", colors_B[i])
        appearances[appear_num]:Set("imageb", colors_B[i])
        appearances[appear_num]:Set("backalpha", 255)
        appearances[appear_num]:Set("name",ColorPresetPool[color_presets_for_appearances[i]].name)
        appear_num = appear_num + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appear_num = first_appear
    ----------------------------------------------------------
    c('copy appearance '..appear_num..' thru '..last_appear_no_mark..' at '..first_appear_mark..' /nu') -- create appearance with marker
    local i = 1
    while first_appear_mark <= last_appear do
        appearances[first_appear_mark]:Set('mediafilename','SYMBOL/symbols/x_mark_white.png')
        appearances[first_appear_mark]:Set("name",ColorPresetPool[color_presets_for_appearances[i]].name..' [active]')
        first_appear_mark = first_appear_mark + 1
        progress = progress + 1
        i = i + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appear_num = first_appear
    last_appear = appear_amount*3 + appear_num - 1
    c('copy appearance '..appear_num..' thru '..last_appear_no_mark..' at '..first_appear_arrow..' /nu') -- create appearance with arrow
    i = 1
    while first_appear_arrow <= last_appear do
        appearances[first_appear_arrow]:Set('mediafilename','SYMBOL/symbols/arrow_down.png')
        appearances[first_appear_arrow]:Set("name",ColorPresetPool[color_presets_for_appearances[i]].name..' [arrow]')
        appearances[first_appear_arrow]:Set("imager",0)
        appearances[first_appear_arrow]:Set("imageg",0)
        appearances[first_appear_arrow]:Set("imageb",0)
        appearances[first_appear_arrow]:Set("imagemode",'Crop')
        first_appear_arrow = first_appear_arrow + 1
        progress = progress + 1
        i = i + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    last_appear = last_appear + 1  -----------------------
    --------------------------------------------------------------------
    ------------------------- create appearances for tming macros ---------------------
    local fades = in_declared_timings[1]
    local delays_from = in_declared_timings[2]
    local delays_to = in_declared_timings[3]
    local xgroups = in_declared_timings[4]
    local xwings = in_declared_timings[5]
    ----------- appearances for fades ----------------
    local last_timing_appearance = last_appear + #fades*2
    c('store appearance '..last_appear..' thru '..last_timing_appearance..' /nu')
    if half_second then 
        fade_filenames_active = {'number_0_black.png','number_0.5_black.png','number_1_black.png','number_2_black.png','calculator_black.png'}
        fade_filenames = {'number_0_white.png','number_0.5_white.png','number_1_white.png','number_2_white.png','calculator_white.png'}
    else
        fade_filenames_active = {'number_0_black.png','number_1_black.png','number_2_black.png','number_3_black.png','calculator_black.png'}
        fade_filenames = {'number_0_white.png','number_1_white.png','number_2_white.png','number_3_white.png','calculator_white.png'}
    end
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",0)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",255)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'Fade ['..tostring(fades[ind]):gsub('%.','')..'] [active]')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..fade_filenames_active[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'Fade [INPUT] [active]')
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",0)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",255)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'Fade ['..tostring(fades[ind]):gsub('%.','')..']')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..fade_filenames[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'Fade [INPUT]')
    --------------------------------------------------------------
    ----------- appearances for delays_from ----------------
    last_timing_appearance = last_appear + #delays_from*2
    c('store appearance '..last_appear..' thru '..last_timing_appearance..' /nu')
    local delays_from_filenames_active = fade_filenames_active
    local delays_from_filenames = fade_filenames
    for ind = 1, #delays_from do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",127)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'DelayFrom ['..tostring(delays_from[ind]):gsub('%.','')..'] [active]')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..delays_from_filenames_active[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'DelayFrom [INPUT] [active]')
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",127)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'DelayFrom ['..tostring(delays_from[ind]):gsub('%.','')..']')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..delays_from_filenames[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'DelayFrom [INPUT]')
    --------------------------------------------------------------
    ----------- appearances for delays_to ----------------
    last_timing_appearance = last_appear + #delays_to*2
    c('store appearance '..last_appear..' thru '..last_timing_appearance..' /nu')
    local delays_to_filenames_active = fade_filenames_active
    local delays_to_filenames = fade_filenames
    for ind = 1, #delays_to do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",127)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'DelayTo ['..tostring(delays_to[ind]):gsub('%.','')..'] [active]')
        -- tostring(delays_to[ind]):gsub('%.','')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..delays_to_filenames_active[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'DelayTo [INPUT] [active]')
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",127)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'DelayTo ['..tostring(delays_to[ind]):gsub('%.','')..']')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..delays_to_filenames[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'DelayTo [INPUT]')
    --------------------------------------------------------------
    ----------- appearances for xgroups ----------------
    last_timing_appearance = last_appear + #xgroups*2
    c('store appearance '..last_appear..' thru '..last_timing_appearance..' /nu')
    local xgroups_filenames_active = {'number_0_black.png','number_2_black.png','number_3_black.png','number_4_black.png','calculator_black.png'}
    local xgroups_filenames = {'number_0_white.png','number_2_white.png','number_3_white.png','number_4_white.png','calculator_white.png'}
    for ind = 1, #xgroups do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",0)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'XGroups ['..xgroups[ind]..'] [active]')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..xgroups_filenames_active[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'XGroups [INPUT] [active]')
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",255)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",0)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",0)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'XGroups ['..xgroups[ind]..']')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..xgroups_filenames[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'XGroups [INPUT]')
    --------------------------------------------------------------
    ----------- appearances for xwings ----------------
    last_timing_appearance = last_appear + #xwings*2
    c('store appearance '..last_appear..' thru '..last_timing_appearance..' /nu')
    local xwings_filenames_active = {'number_0_black.png','number_2_black.png','number_4_black.png','number_6_black.png','calculator_black.png'}
    local xwings_filenames = {'number_0_white.png','number_2_white.png','number_4_white.png','number_6_white.png','calculator_white.png'}
    for ind = 1, #xwings do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",0)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",255)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",255)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'XWings ['..xwings[ind]..'] [active]')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..xwings_filenames_active[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'XWings [INPUT] [active]')
    for ind = 1, #fades do
        appearances[last_appear]:Set("backr",0)
        appearances[last_appear]:Set("imager",0)
        appearances[last_appear]:Set("backg",0)
        appearances[last_appear]:Set("imageg",255)
        appearances[last_appear]:Set("backb",0)
        appearances[last_appear]:Set("imageb",255)
        appearances[last_appear]:Set("backalpha", 0)
        appearances[last_appear]:Set("name",naming_prefix..'XWings ['..xwings[ind]..']')
        appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/'..xwings_filenames[ind])
        last_appear = last_appear + 1
        progress = progress + 1
        SetProgress(progHandle, progress)
        coroutine.yield(progress_bar_time)
    end
    appearances[last_appear-1]:Set("name",naming_prefix..'XWings [INPUT]')
    ----------------- appearance for Favourites ----------------------
    c('store appearance '..last_appear..' /nu')
    appearances[last_appear]:Set('mediafilename','SYMBOL/symbols/outline_star_white.png')
    appearances[last_appear]:Set("imager",255)
    appearances[last_appear]:Set("imageg",255)
    appearances[last_appear]:Set("imageb",255)
    appearances[last_appear]:Set("name", naming_prefix..'Favourites')
    last_appear = last_appear + 1

    c('store appearance '..last_appear..' /nu')
    appearances[last_appear]:Set("backr", 0)
    appearances[last_appear]:Set("backg", 0)
    appearances[last_appear]:Set("backb", 0)
    appearances[last_appear]:Set("backalpha", 255)
    appearances[last_appear]:Set("imager", 0)
    appearances[last_appear]:Set("imageg", 0)
    appearances[last_appear]:Set("imageb", 0)
    appearances[last_appear]:Set("imagealpha", 255)    
    appearances[last_appear]:Set("name", naming_prefix..'Black Back')
    last_appear = last_appear + 1
    ----------------------- Red Appearance ---------------------------------------
    c('store appearance '..last_appear..' /nu')
    appearances[last_appear]:Set("backr", 255)
    appearances[last_appear]:Set("backg", 0)
    appearances[last_appear]:Set("backb", 0)
    appearances[last_appear]:Set("backalpha", 120)
    appearances[last_appear]:Set("name", naming_prefix..'Red Back')
    StopProgress(progHandle)
    last_appear = last_appear + 1
    return last_appear
end 