--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local YB_GMA3_CP_GEN = select(3,...)

local function table_copy(t)
    local result = {}
    for _, v in pairs(t) do table.insert(result,v) end
    return result
end

local function create_timing_macros(first_macro,created_macros,in_declared_timings,layout,name_prefix,DP)
    local macro_pool = ShowData().datapools[DP].Macros
    local progHandle = StartProgress("Creating Timig Macros")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    local timing_names = {}
    local created_timing_macros = {}
    local macro_num = first_macro
    local number_of_timing_macros = 0

    for _,subgroup_timings in ipairs(in_declared_timings) do
        number_of_timing_macros = number_of_timing_macros + #subgroup_timings
        local subgroup_names = table_copy(subgroup_timings)
        subgroup_names[5] = 'INPUT'
        table.insert(timing_names,subgroup_names)
    end

    local last_macro = first_macro + number_of_timing_macros - 1
    SetProgressRange(progHandle, 1, last_macro-first_macro)

    local macros_data = {
        {subgroup_name = 'Fade',property_name='FadeFromX'},
        -- {subgroup_name = 'DelayFrom',property_name='DelayFromX'},
        {subgroup_name = 'Delay',property_name='DelayToX'},
        {subgroup_name = 'Group',property_name='XGroup'},
        {subgroup_name = 'Wings',property_name='XWings'},
        
    }

    for index,subgroup_data in ipairs(macros_data) do
        local subgroup_name = subgroup_data.subgroup_name
        local created_subgroup_macros = {subgroup_name=subgroup_name}
        local names = timing_names[index]
        local timings = in_declared_timings[index]
        local property_name = subgroup_data.property_name
        local direction_straight = 'direction_straight'
        local direction_reverse = 'direction_reverse'
        local direction_macro_ending = ' Direction'
        local line6 = 
        'assign appearance "'..name_prefix..subgroup_name..' ['..names[1]..']" at macro "'..name_prefix..subgroup_name..' ['..names[1]..']" /nu; '..
        'assign appearance "'..name_prefix..subgroup_name..' ['..tostring(names[2]):gsub('%.','')..']" at macro "'..name_prefix..subgroup_name..' ['..tostring(names[2]):gsub('%.','')..']" /nu; '..
        'assign appearance "'..name_prefix..subgroup_name..' ['..names[3]..']" at macro "'..name_prefix..subgroup_name..' ['..names[3]..']" /nu; '..
        'assign appearance "'..name_prefix..subgroup_name..' ['..names[4]..']" at macro "'..name_prefix..subgroup_name..' ['..names[4]..']" /nu; '..
        'assign appearance "'..name_prefix..subgroup_name..' ['..names[5]..']" at macro "'..name_prefix..subgroup_name..' ['..names[5]..']" /nu'
        for i = 1, #timings do
            -- local macro = macro_pool:Create(macro_num)
            local macro = YB_GMA3_CP_GEN.my_create(macro_pool,macro_num)
            table.insert(created_subgroup_macros,macro)
            macro:Set('appearance',name_prefix..subgroup_name..' ['..tostring(names[i]):gsub('%.','')..']')
            macro:Set('Name',name_prefix..subgroup_name..' '..'['..tostring(names[i]):gsub('%.','')..']')
            local line = macro:Acquire()
            line:Set('Command', 'SetUserVar "Color'..subgroup_name..'" '..timings[i]..' /nu')
            line = macro:Acquire()
            if subgroup_name == 'Delay' then
                line:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "DelayFromX" 0'..'; Set MAtricks "'..name_prefix..'*" property "'..property_name..'" $Color'..subgroup_name..' /nu')
            else
                line:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "'..property_name..'" $Color'..subgroup_name..' /nu')
            end
            if subgroup_name == 'Fade' then
                line = macro:Acquire()
                line:Set('Command', 'Set Sequence "'..name_prefix..'*" Cue "offcue" Cue'..subgroup_name..' $Color'..subgroup_name..' /nu')
            end
            if subgroup_name == 'Delay' then
                line = macro:Acquire()
                line:Set('Command', 'Assign Appearance "'..name_prefix..subgroup_name..' '..direction_straight..'" At Macro "'..name_prefix..subgroup_name..direction_macro_ending..'" /nu')
                -- Assign Appearance 'CP1_DelayTo direction_straight' At Macro 'CP1_DelayTo Direction'
            end
            line = macro:Acquire()
            line:Set('Command',line6)
            line = macro:Acquire()
            line:Set('Command','assign appearance "'..name_prefix..subgroup_name..' ['..tostring(names[i]):gsub('%.','')..'] [active]"  at macro "'..name_prefix..subgroup_name..' ['..tostring(names[i]):gsub('%.','')..']" /nu')            
            -- Lua "GetObject('layout 2.\'CP1_Fade [INPUT]'\'):Set('customtexttext',tostring(GetVar(UserVars(),'ColorFade')))"
            local custom_input_label_command
            if type(names[i]) == 'string' then
                custom_input_label_command = [[Lua "GetObject('layout ]]..layout..[[.\']]..name_prefix..subgroup_name..' '..'['..tostring(names[5])..']'..[[\''):Set('customtexttext',tostring(GetVar(UserVars(),'Color]]..subgroup_name..[[')))"]]
            else
                custom_input_label_command = [[Lua "GetObject('layout ]]..layout..[[.\']]..name_prefix..subgroup_name..' '..'['..tostring(names[5])..']'..[[\''):Set('customtexttext','')"]]
            end
            line = macro:Acquire()
            line:Set('Command',custom_input_label_command)
    

            macro_num = macro_num + 1
            IncProgress(progHandle,1)
            -- coroutine.yield(progress_bar_time)
        end
        -- macro_pool[macro_num-1]:Set('Name',name_prefix..subgroup_name..' [INPUT]')
        if subgroup_name == 'Delay' then
            local macro = macro_pool:Create(macro_num)
            table.insert(created_subgroup_macros,macro)           
            macro_num = macro_num + 1
            macro:Set('appearance',name_prefix..subgroup_name..' '..direction_straight)
            macro:Set('Name',name_prefix..subgroup_name..direction_macro_ending)
            local line = macro:Acquire()
            line:Set('Command', 'Set MAtricks "'..name_prefix..'*" property "'..property_name..'" "Swap Delay"')
            local straight_appearance_name = name_prefix..subgroup_name..' '..direction_straight
            local reverse_appearance_name = name_prefix..subgroup_name..' '..direction_reverse
            -- Lua "local macro = GetObject('CP1_DelayTo Direction') if macro.appearance.name:find('direction_straight') then "
            local lua_command = [[
                Lua "
                local macro = GetObject('macro \']]..macro.name..[[\'')
                local macro_appearance = macro.appearance
                if macro_appearance.name:find('straight') then
                    Cmd('Assign Appearance \']]..reverse_appearance_name..[[\' at macro \']]..macro.name..[[\'')
                elseif macro_appearance.name:find('reverse') then
                    Cmd('Assign Appearance \']]..straight_appearance_name..[[\' at macro \']]..macro.name..[[\'')
                end
                "
                ]]
                
            lua_command = lua_command:gsub('\n%s+',' ')
            line = macro:Acquire()
            line:Set('Command', lua_command)
        end
        table.insert(created_timing_macros,created_subgroup_macros)
    end
    StopProgress(progHandle)
    created_macros.timing_macros = created_timing_macros
    return created_macros,macro_num
end

local function create_all_groups_macros(starting_macro,created_macros,presets,appearances,picker_type,name_prefix,DP)
    local progHandle = StartProgress("Generating ALL macros")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    local created_all_groups_macros = {}
    local first_macro = starting_macro
    local macro_amount = #presets
    -- local last_macro = first_macro + macro_amount - 1
    local appearance_num = appearances[1]:Index()
    local macro_num = first_macro
    local preset_i = 1
    local macros_pool = ShowData().datapools[DP].Macros
    SetProgressRange(progHandle, 0, macro_amount)
    for _,preset in ipairs(presets) do
        local macro = macros_pool:Create(macro_num)
        table.insert(created_all_groups_macros,macro)
        local line = macro:Acquire()
        line:Set('Command', 'go sequence "'..name_prefix..'*['..preset.name..']')
        if picker_type == 'color' then
            macro:Set('appearance',preset.name..' [arrow]')
        elseif picker_type == 'position' then
            macro:Set('appearance',name_prefix..'ALL')
        end
        macro:Set('name', name_prefix..'ALL ['..tostring(preset.name):gsub('CP%d+_','')..']')
        macro_num = macro_num + 1
        preset_i = preset_i + 1
        appearance_num = appearance_num + 1
        SetProgress(progHandle, macro_num)
        -- coroutine.yield(progress_bar_time)
    end
    StopProgress(progHandle)
    created_macros.all_groups_macros = created_all_groups_macros
    return created_macros,macro_num
end

local function create_off_macro(picker_type,last_macro,created_macros,appearances,name_prefix,DP)
    local macros_pool = ShowData().datapools[DP].Macros
    local macro_num = last_macro
    local macro = macros_pool:Create(macro_num)
    macro:Set('name', 'All '..picker_type..' OFF ['..name_prefix:gsub('_','')..']')
    macro:Set('appearance',appearances[#appearances]:Index())
    local line = macro:Acquire()
    line:Set('Command', 'off sequence "'..name_prefix..'*"')
    created_macros.off_macro = macro
    return created_macros,macro_num
end

local function create_favourite_macro(first_macro,created_macros,layout,prefix,DP)
    local created_favourite_macros = {}
    local macro_num = first_macro + 1
    local last_macro = macro_num + 16
    local macropool = ShowData().DataPools[DP].Macros
    local store_favourite_macro = macropool:Create(macro_num)
    table.insert(created_favourite_macros,store_favourite_macro)
    -- c('store macro '..macro_num..'.1 thru 3'..' /nu')
    store_favourite_macro:Set('name','Store favourite '..prefix:gsub('_','')..' state')
    for i=1,16 do
        local macro = macropool:Create(macro_num+i)
        table.insert(created_favourite_macros,macro)
    end
    -- c('store macro '..(macro_num+1)..' thru '..last_macro..' /nu')
    local command = [[local sequences = ObjectList('sequence '..string.char(34)..']]..prefix..[[*'..string.char(34)..'')
        local macropool = ShowData().DataPools[]]..DP..[[].Macros
        local layoutspool = ShowData().DataPools[]]..DP..[[].Layouts
        local activeseq = {}        
        local macronum = GetVar(UserVars(),']]..prefix..[[favouritemacro')
        macronum = macronum:gsub(' Macro','')
        macronum = tonumber(macronum)
        for i=1,#sequences do
            if sequences[i]:HasActivePlayback() then
                table.insert(activeseq,i)
            end
        end
        if #macropool[macronum] == 0 then
            layoutspool[]]..layout..[[]['Macro '..macronum]:Set('visibilityobjectname',true)
        end
        Cmd('label macro '..macronum..' '..string.char(34)..']]..prefix:gsub('_','')..[[ Favourite'..string.char(34)..' /o')
        if #macropool[macronum] > 0 then
            Cmd('delete macro '..macronum..'.1 thru')
        end
        Cmd('store macro '..macronum..'.1 thru'..#activeseq..' /o')
        for i=1,#activeseq do
            local seqnumber = activeseq[i]
            macropool[macronum][i]:Set('command','go sequence '..string.char(34)..''..sequences[seqnumber].name..''..string.char(34)..'')
        end]]
    command = command:gsub('\n%s+',' ')
    local line = store_favourite_macro:Acquire()
    line:Set('command','setuservariable "'..prefix..'favouritemacro" "')
    line:Set('execute',false)
    line:Set('addtocmdline',true)
    line = store_favourite_macro:Acquire()
    line:Set('command','Lua "'..command..'"') 
    line = store_favourite_macro:Acquire()
    line:Set('command','deleteuservariable "'..prefix..'favouritemacro"')
    store_favourite_macro:Set('appearance',prefix..'Black Back')
    for i=macro_num+1, last_macro do
        -- macropool[i]:Set('name',prefix..' Favourite '..(i-macro_num))
        macropool[i]:Set('appearance',prefix..'Favourites')
    end
    created_macros.favourite_macros = created_favourite_macros
    return created_macros,last_macro
end

local function create_delete_macro(picker_type,first_macro,last_macro,created_macros,created_sequences,cp_layout,created_appearances,presets,created_matricks,created_tags,generated,name_prefix,DP)
    local first_preset = presets[1]
    local macros_pool = ShowData().datapools[DP].Macros
    local macro_num = last_macro + 1
    local command_delete_sequences = 'Delete Sequence '..created_sequences[1]:Index()..' thru '..(created_sequences[#created_sequences]:Index())..' /nc /nu'
    local command_delete_macros = 'Delete Macro '..first_macro..' thru '..last_macro..' /nc /nu'
    local command_delete_layout = 'Delete Layout '..cp_layout..' /nc /nu'
    local command_delete_appearances = 'Delete Appearance '..created_appearances[1]:Index()..' thru '..(created_appearances[#created_appearances]:Index())..' /nc /nu'
    local command_confirm = "Lua 'if Confirm(\"Delete "..picker_type.." picker "..name_prefix:gsub('%D*','').."?\") then; Cmd(\"Go macro "..macro_num.."\"); else Cmd(\"Off macro "..macro_num.."\"); end'"..' /nu'
    local command_delete_matcricks = 'Delete '..created_matricks[1]:ToAddr()..' thru '..(created_matricks[#created_matricks]:Index())..' /nc /nu'
    local command_delete_tags = 'Delete tag '..created_tags[1]:Index()..' thru '..(created_tags[#created_tags]:Index())..' /nc /nu'
    local command_delete_delete_macro = 'Delete macro '..macro_num..' /nc /nu'
    local macro = macros_pool:Create(macro_num)
    macro:Set('name','Delete ALL ['..name_prefix:gsub('_','')..']')
    local line = macro:Acquire()
    line:Set('Command', command_confirm)
    line:Set('Wait', 'Go')
    line = macro:Acquire()
    line:Set('Command', command_delete_sequences)
    line = macro:Acquire()
    line:Set('Command', command_delete_macros)
    line = macro:Acquire()
    line:Set('Command', command_delete_layout)
    line = macro:Acquire()
    line:Set('Command', command_delete_appearances)
    if generated then
        line = macro:Acquire()
        local command_delete_presets = 'Delete '..first_preset:ToAddr()..' thru '..(presets[#presets]:Index())..' /nc /nu'
        line:Set('Command', command_delete_presets)
    end
    line = macro:Acquire()
    line:Set('Command', command_delete_matcricks)
    line = macro:Acquire()
    line:Set('Command', command_delete_tags)
    line = macro:Acquire()
    line:Set('Command', command_delete_delete_macro)
    created_macros.delete_macro = macro
    return created_macros
end

function YB_GMA3_CP_GEN.create_macros(user_input,declared_timings,created_appearances,created_sequences,created_matricks,created_tags,name_prefix,DP)
    local first_macro = user_input.first_macro
    local created_presets = user_input.presets_obj
    local generated = user_input.generate_presets
    local layout = user_input.layout_number
    local picker_type = user_input.picker_type
    local created_macros = {}
    local last_created_macro
    created_macros,last_created_macro = create_timing_macros(first_macro,created_macros,declared_timings,layout,name_prefix,DP)
    created_macros,last_created_macro = create_all_groups_macros(last_created_macro,created_macros,created_presets,created_appearances,picker_type,name_prefix,DP)
    created_macros,last_created_macro = create_off_macro(picker_type,last_created_macro,created_macros,created_appearances,name_prefix,DP)
    created_macros,last_created_macro = create_favourite_macro(last_created_macro,created_macros,layout,name_prefix,DP)
    created_macros,last_created_macro = create_delete_macro(picker_type,first_macro,last_created_macro,created_macros,created_sequences,layout,created_appearances,created_presets,created_matricks,created_tags,generated,name_prefix,DP)
    return created_macros
end