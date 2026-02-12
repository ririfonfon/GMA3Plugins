--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local GL_START_POS_X = -500 -- starting x point for layout elements
local GL_START_POS_Y = 300 -- starting y point for layout elements
local GL_GAP_X = 50 -- x-gap between layout elements
local GL_GAP_Y = 50 -- y-gap between layout elements
local GL_SIZE_X = 50 -- height of layout elements
local GL_SIZE_Y = 50 -- width of layout elements
local smart_positions = true -- set to false if you don't want to use "Smart" positions generator
--------------------------------------------------------------------
------------- Don't change anything below this line ----------------
--------------------------------------------------------------------
local YB_GMA3_CP_GEN = select(3,...)
YB_GMA3_CP_GEN.progress_bars = {}
-- local fades_delays_05_timing = false
local C = Cmd
local layout_globals = {start_pos_x = GL_START_POS_X,start_pos_y = GL_START_POS_Y,gap_x = GL_GAP_X,gap_y = GL_GAP_Y,size_x = GL_SIZE_X,size_y = GL_SIZE_Y,}

function YB_GMA3_CP_GEN.declare_timing_values()
    local fades = {0,1,2,3,'(Picker Fade)'}
    local delays_to = {0,1,2,3,'(Picker Delay)'}
    local groups = {0,2,3,4,'(Picker Group)'}
    local wings = {0,2,4,6,'(Picker Wings)'}
    return {fades,delays_to,groups,wings}
end

function YB_GMA3_CP_GEN.pp_declare_filenames()
    local position_preset_names = {'Straight Down', 'Fan In Down', 'Fan Out Down', 'Cross Down', 'Straight Up', 'Fan In Up', 'Fan Out Up', 'Cross Up'}
    local filenames = {'pos_straight','pos_fan_in','pos_fan_out','pos_cross','pos_up_straight','pos_up_fan_in','pos_up_fan_out','pos_up_cross'}
    return filenames,position_preset_names
end

function YB_GMA3_CP_GEN.my_create(pool,index)
    local maxsize = pool:MaxCount()
    local poolsize = pool:Count()
    if index > poolsize then
        local newsize = math.min(maxsize, math.ceil(index/1000)*1000)
        pool:Resize(newsize)
    end
    return pool:Create(index)
end

function YB_GMA3_CP_GEN.create_tags(user_input,name_prefix)
    local first_tag = user_input.first_tag
    local groups = user_input.groups_selected
    local tags = ShowData().tags
    local created_tags = {}
    for i,group in ipairs(groups) do
        -- local tag = tags:Create(first_tag+i-1)
        local tag = YB_GMA3_CP_GEN.my_create(tags,first_tag+i-1)
        tag:Set('name',name_prefix..group.name)
        tag:Set('tagtype',Enums.TagType['Kill Delayed'])
        table.insert(created_tags,tag)
    end
    return created_tags
end

function YB_GMA3_CP_GEN.create_matricks(user_input,name_prefix,DP)
    local first_matrx = user_input.first_matrick
    local selected_groups = user_input.groups_selected
    local created_matricks = {}
    local matrx_num = first_matrx
    local mtrx_pool = ShowData().DataPools[DP].MAtricks
    for _,group in ipairs(selected_groups) do
        -- local matrick = mtrx_pool:Create(matrx_num)
        local matrick = YB_GMA3_CP_GEN.my_create(mtrx_pool,matrx_num)
        table.insert(created_matricks,matrick)
        matrick:Set('name',name_prefix..group.name)
        matrx_num = matrx_num + 1
    end
    return created_matricks
end

local function picker_generator_main(display)
    -- require 'gma3_debug'()
    local data_pool = tonumber(DataPool().no)
    local position_appearance_file_names,position_preset_names = YB_GMA3_CP_GEN.pp_declare_filenames()
    local layouts_pool = ShowData().datapools[data_pool].Layouts
    -- local user_input = YB_GMA3_CP_GEN.get_user_input()
    local user_input = YB_GMA3_CP_GEN.new_ui(display,position_preset_names)
    if not next(user_input) then return end
    local name_prefix = YB_GMA3_CP_GEN.create_name_prefix(user_input.picker_type,data_pool)
    local declared_timings = YB_GMA3_CP_GEN.declare_timing_values()
    ---------------------------[[ Genereation started ]]-------------------------
    C('clearall /nu')
    local progtime_master = MasterPool()['Grand']['ProgramTime']
    local progtime_enabled = progtime_master.faderenabled
    if progtime_enabled then
        C('off '..progtime_master)
    end
    if user_input.generate_presets then
        if user_input.picker_type == 'color' then
            user_input.presets_obj = YB_GMA3_CP_GEN.generate_uinv_col_preset(user_input,name_prefix,data_pool)
        elseif user_input.picker_type == 'position' then
            user_input.presets_obj = YB_GMA3_CP_GEN.generate_position_presets(data_pool,user_input,position_preset_names,name_prefix,smart_positions)
        end
    end
    local layout = layouts_pool:Create(user_input.layout_number)
    layout:Set('name',user_input.picker_type..' picker '..name_prefix:gsub('%D*','')..'')
    C('select layout '..user_input.layout_number..' /nu')
    coroutine.yield(0.1)

    local progHandle = StartProgress("Generating Color Picker")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    SetProgressRange(progHandle, 1, 6)
    local created_appearances = YB_GMA3_CP_GEN.create_appearances(user_input,position_appearance_file_names,position_preset_names, declared_timings, name_prefix)
    IncProgress(progHandle,1)
    local created_matricks = YB_GMA3_CP_GEN.create_matricks(user_input,name_prefix,data_pool)
    IncProgress(progHandle,1)
    local created_tags = YB_GMA3_CP_GEN.create_tags(user_input,name_prefix)
    IncProgress(progHandle,1)
    local created_sequences = YB_GMA3_CP_GEN.create_sequences(user_input,name_prefix,data_pool,created_tags)
    IncProgress(progHandle,1)
    local created_macros = YB_GMA3_CP_GEN.create_macros(user_input,declared_timings,created_appearances,created_sequences,created_matricks,created_tags,name_prefix,data_pool)
    IncProgress(progHandle,1)
    YB_GMA3_CP_GEN.fill_in_the_layout (declared_timings,user_input,created_sequences,created_matricks,created_macros,layout_globals,name_prefix,data_pool)
    IncProgress(progHandle,1)

    if progtime_enabled then
        C('on '..progtime_master)
    end
    StopProgress(progHandle)
end

local function cleanup()
    for _,progressbar in ipairs(YB_GMA3_CP_GEN.progress_bars) do
        if progressbar then
            StopProgress(progressbar)
        end
    end
end

return picker_generator_main,cleanup