local c = Cmd
local ti = TextInput

local function table_copy(t)
    local u = {}
    for _, v in pairs(t) do table.insert(u,v) end
    return u
end

function cp_create_timing_macros(first_macro,in_declared_timings,name_prefix,progress_bar_time,DP)
    local macro_pool = ShowData().datapools[DP].Macros
    -- Create progress bar
    local progHandle = StartProgress("Creating Timig Macros")
    local macro_num = first_macro
    -- local last_appear_num = last_appear
    local fades = in_declared_timings[1]
        local fades_names = table_copy(fades)
        fades_names[5] = 'INPUT'
    local delays_from = in_declared_timings[2]
        local delays_from_names = table_copy(delays_from)
        delays_from_names[5] = 'INPUT'
    local delays_to = in_declared_timings[3]
        local delays_to_names = table_copy(delays_to)
        delays_to_names[5] = 'INPUT'
    local groups = in_declared_timings[4]
        local groups_names = table_copy(groups)
        groups_names[5] = 'INPUT'
    local wings = in_declared_timings[5]
        local wings_names = table_copy(wings)
        wings_names[5] = 'INPUT'
    local numer_of_timing_macros = #fades + #delays_from + #delays_to + #groups + #wings
    local last_macro = first_macro + numer_of_timing_macros - 1
    SetProgressRange(progHandle, first_macro, last_macro)
    -- fade macros
    local line6 = 'assign appearance "'..name_prefix..'Fade ['..fades_names[1]..']" at macro "'..name_prefix..'FadeX ['..fades_names[1]..']" /nu; assign appearance "'..name_prefix..'Fade ['..tostring(fades_names[2]):gsub('%.','')..']" at macro "'..name_prefix..'FadeX ['..tostring(fades_names[2]):gsub('%.','')..']" /nu; assign appearance "'..name_prefix..'Fade ['..fades_names[3]..']" at macro "'..name_prefix..'FadeX ['..fades_names[3]..']" /nu; assign appearance "'..name_prefix..'Fade ['..fades_names[4]..']" at macro "'..name_prefix..'FadeX ['..fades_names[4]..']" /nu; assign appearance "'..name_prefix..'Fade ['..fades_names[5]..']" at macro "'..name_prefix..'FadeX ['..fades_names[5]..']" /nu'
    for i = 1, #fades do
        c('store macro '..macro_num..'.1 thru 7 /nu')
        macro_pool[macro_num]:Set('appearance',name_prefix..'Fade ['..tostring(fades_names[i]):gsub('%.','')..']')
		macro_pool[macro_num]:Set('Name',name_prefix..'FadeX '..'['..tostring(fades_names[i]):gsub('%.','')..']')
		macro_pool[macro_num][1]:Set('Command', 'SetUserVar "ColorFadeX" '..fades[i]..' /nu')
		macro_pool[macro_num][2]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "FadefromX" $ColorFadeX /nu')
		macro_pool[macro_num][3]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "FadetoX" $ColorFadeX /nu')
		macro_pool[macro_num][5]:Set('Command', 'Set Sequence "'..name_prefix..'*" Cue "offcue" CueFade $ColorFadeX /nu')
        macro_pool[macro_num][6]:Set('Command',line6)
        macro_pool[macro_num][7]:Set('Command','assign appearance "'..name_prefix..'Fade ['..tostring(fades_names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..'FadeX ['..tostring(fades_names[i]):gsub('%.','')..']" /nu')
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
        macro_num = macro_num + 1
    end
		macro_pool[macro_num-1]:Set('Name',name_prefix..'FadeX [INPUT]')
    -- delay from macros
    line6 = 'assign appearance "'..name_prefix..'DelayFrom ['..delays_from_names[1]..']" at macro "'..name_prefix..'DelayFromX ['..delays_from_names[1]..']" /nu; assign appearance "'..name_prefix..'DelayFrom ['..tostring(delays_from_names[2]):gsub('%.','')..']" at macro "'..name_prefix..'DelayFromX ['..tostring(delays_from_names[2]):gsub('%.','')..']" /nu; assign appearance "'..name_prefix..'DelayFrom ['..delays_from_names[3]..']" at macro "'..name_prefix..'DelayFromX ['..delays_from_names[3]..']" /nu; assign appearance "'..name_prefix..'DelayFrom ['..delays_from_names[4]..']" at macro "'..name_prefix..'DelayFromX ['..delays_from_names[4]..']" /nu; assign appearance "'..name_prefix..'DelayFrom ['..delays_from_names[5]..']" at macro "'..name_prefix..'DelayFromX ['..delays_from_names[5]..']" /nu'
    for i = 1, #delays_from do
        c('store macro '..macro_num..'.1 thru 5 /nu')
        macro_pool[macro_num]:Set('appearance',name_prefix..'DelayFrom ['..tostring(delays_from_names[i]):gsub('%.','')..']')
		macro_pool[macro_num]:Set('Name',name_prefix..'DelayFromX '..'['..tostring(delays_from_names[i]):gsub('%.','')..']')
		macro_pool[macro_num][1]:Set('Command', 'SetUserVar "ColorDelayFromX" '..delays_from[i]..' /nu')
		macro_pool[macro_num][2]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "delayfromX" $ColorDelayFromX /nu')
        macro_pool[macro_num][4]:Set('Command',line6)
        macro_pool[macro_num][5]:Set('Command','assign appearance "'..name_prefix..'DelayFrom ['..tostring(delays_from_names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..'DelayFromX ['..tostring(delays_from_names[i]):gsub('%.','')..']" /nu')
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
        macro_num = macro_num + 1
    end
		macro_pool[macro_num-1]:Set('Name',name_prefix..'DelayFromX [INPUT]')
    -- delay to macros
    line6 = 'assign appearance "'..name_prefix..'DelayTo ['..delays_to_names[1]..']" at macro "'..name_prefix..'DelayToX ['..delays_to_names[1]..']" /nu; assign appearance "'..name_prefix..'DelayTo ['..tostring(delays_to_names[2]):gsub('%.','')..']" at macro "'..name_prefix..'DelayToX ['..tostring(delays_to_names[2]):gsub('%.','')..']" /nu; assign appearance "'..name_prefix..'DelayTo ['..delays_to_names[3]..']" at macro "'..name_prefix..'DelayToX ['..delays_to_names[3]..']" /nu; assign appearance "'..name_prefix..'DelayTo ['..delays_to_names[4]..']" at macro "'..name_prefix..'DelayToX ['..delays_to_names[4]..']" /nu; assign appearance "'..name_prefix..'DelayTo ['..delays_to_names[5]..']" at macro "'..name_prefix..'DelayToX ['..delays_to_names[5]..']" /nu'
    for i = 1, #delays_to do
        c('store macro '..macro_num..'.1 thru 5 /nu')
        macro_pool[macro_num]:Set('appearance',name_prefix..'DelayTo ['..tostring(delays_to_names[i]):gsub('%.','')..']')
		macro_pool[macro_num]:Set('Name', name_prefix..'DelayToX '..'['..tostring(delays_to_names[i]):gsub('%.','')..']')
		macro_pool[macro_num][1]:Set('Command', 'SetUserVar "ColorDelayToX" '..delays_to[i]..' /nu')
		macro_pool[macro_num][2]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "delaytoX" $ColorDelayToX /nu')
        macro_pool[macro_num][4]:Set('Command',line6)
        macro_pool[macro_num][5]:Set('Command','assign appearance "'..name_prefix..'DelayTo ['..tostring(delays_to_names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..'DelayToX ['..tostring(delays_from_names[i]):gsub('%.','')..']" /nu')
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
        macro_num = macro_num + 1
    end
		macro_pool[macro_num-1]:Set('Name', name_prefix..'DelayToX [INPUT]')
    -- groups macros
    line6 = 'assign appearance "'..name_prefix..'XGroups ['..groups_names[1]..']" at macro "'..name_prefix..'XGroup ['..groups_names[1]..']" /nu; assign appearance "'..name_prefix..'XGroups ['..tostring(groups_names[2]):gsub('%.','')..']" at macro "'..name_prefix..'XGroup ['..tostring(groups_names[2]):gsub('%.','')..']" /nu; assign appearance "'..name_prefix..'XGroups ['..groups_names[3]..']" at macro "'..name_prefix..'XGroup ['..groups_names[3]..']" /nu; assign appearance "'..name_prefix..'XGroups ['..groups_names[4]..']" at macro "'..name_prefix..'XGroup ['..groups_names[4]..']" /nu; assign appearance "'..name_prefix..'XGroups ['..groups_names[5]..']" at macro "'..name_prefix..'XGroup ['..groups_names[5]..']" /nu'
    for i = 1, #groups do
        c('store macro '..macro_num..'.1 thru 5 /nu')
        macro_pool[macro_num]:Set('appearance',name_prefix..'XGroups ['..tostring(groups_names[i]):gsub('%.','')..']')
		macro_pool[macro_num]:Set('Name', name_prefix..'XGroup '..'['..groups[i]..']')
		macro_pool[macro_num][1]:Set('Command', 'SetUserVar "ColorGroupX" '..groups[i]..' /nu')
		macro_pool[macro_num][2]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "XGroup" $ColorGroupX /nu')
        macro_pool[macro_num][4]:Set('Command',line6)
        macro_pool[macro_num][5]:Set('Command','assign appearance "'..name_prefix..'XGroups ['..tostring(groups_names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..'XGroup ['..tostring(groups_names[i]):gsub('%.','')..']" /nu')
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
        macro_num = macro_num + 1
    end
		macro_pool[macro_num-1]:Set('Name', name_prefix..'XGroup [INPUT]')
    -- wings macros
    line6 = 'assign appearance "'..name_prefix..'XWings ['..wings_names[1]..']" at macro "'..name_prefix..'XWings ['..wings_names[1]..']" /nu; assign appearance "'..name_prefix..'XWings ['..tostring(wings_names[2]):gsub('%.','')..']" at macro "'..name_prefix..'XWings ['..tostring(wings_names[2]):gsub('%.','')..']" /nu; assign appearance "'..name_prefix..'XWings ['..wings_names[3]..']" at macro "'..name_prefix..'XWings ['..wings_names[3]..']" /nu; assign appearance "'..name_prefix..'XWings ['..wings_names[4]..']" at macro "'..name_prefix..'XWings ['..wings_names[4]..']" /nu; assign appearance "'..name_prefix..'XWings ['..wings_names[5]..']" at macro "'..name_prefix..'XWings ['..wings_names[5]..']" /nu'
    for i = 1, #wings do
        c('store macro '..macro_num..'.1 thru 5 /nu')
        macro_pool[macro_num]:Set('appearance',name_prefix..'XWings ['..tostring(wings_names[i]):gsub('%.','')..']')
		macro_pool[macro_num]:Set('Name', name_prefix..'XWings '..'['..wings[i]..']')
		macro_pool[macro_num][1]:Set('Command', 'SetUserVar "ColorWingsX" '..wings[i]..' /nu')
		macro_pool[macro_num][2]:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "XWings" $ColorWingsX /nu')
        macro_pool[macro_num][4]:Set('Command',line6)
        macro_pool[macro_num][5]:Set('Command','assign appearance "'..name_prefix..'XWings ['..tostring(wings_names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..'XWings ['..tostring(wings_names[i]):gsub('%.','')..']" /nu')
        SetProgress(progHandle, macro_num)
        coroutine.yield(progress_bar_time)
        macro_num = macro_num + 1
    end
	macro_pool[macro_num-1]:Set('Name',name_prefix..'XWings [INPUT]')
    StopProgress(progHandle)
    return macro_num, numer_of_timing_macros
end