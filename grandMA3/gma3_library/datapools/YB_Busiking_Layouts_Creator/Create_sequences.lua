--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local C = Cmd
local YB_GMA3_CP_GEN = select(3,...)

local function compare_versions_new(version1, version2)
    local function split(str)
        local t = {}
        for num in str:gmatch("%d+") do
            table.insert(t, tonumber(num))
        end
        return t
    end

    local version1_parts = split(version1)
    local version2_parts = split(version2)

    for i = 1, 4 do
        if (version1_parts[i] or 0) < (version2_parts[i] or 0) then
            return -1 -- version1 is less than version2
        elseif (version1_parts[i] or 0) > (version2_parts[i] or 0) then
            return 1 -- version1 is greater than version2
        end
    end

    return 0 -- version1 is equal to version2
end 

function YB_GMA3_CP_GEN.create_sequences(user_input,name_prefix,DP,tags)
    local first_sequence = user_input.first_sequence
    local groups = user_input.groups_selected
    local first_mtrx = user_input.first_matrick
    local presets = user_input.presets_obj
    local first_appear = user_input.first_appear
    local picker_type = user_input.picker_type
    local generate_presets = user_input.generate_presets
    local version_same_or_higher
    if compare_versions_new(Version(),'2.3.106.0') >= 0 then
        version_same_or_higher = true
    else
        version_same_or_higher = false
    end
    local progHandle = StartProgress("Generating Sequences")
    table.insert(YB_GMA3_CP_GEN.progress_bars,progHandle)
    local group_amount = #groups
    local created_sequences = {}
    local group_i = 1
    local preset_i = 1
    -- local seq_per_group_num = 1
    local matrx_num = first_mtrx
    local preset_amount = #presets
    -- local preset_num = presets[preset_i]
    local seq_num = first_sequence
    local sequence_amount = group_amount * preset_amount
    local sequence_end_num = first_sequence + sequence_amount - 1
    local appearance_num = first_appear
    local appearance_mark = appearance_num + preset_amount
    local color_preset_pool = ShowData().datapools[DP].PresetPools[4]
    local sequence_pool = ShowData().datapools[DP].Sequences
    SetProgressRange(progHandle, 0, sequence_end_num - first_sequence)
    C('store sequence '..first_sequence..' thru '..sequence_end_num..' /nu')
    -- -- coroutine.yield(0.1)
    for group_ind,group in ipairs(groups) do
        for seq_per_group_num=1,preset_amount do
            local preset_appearance = presets[seq_per_group_num].appearance
            local sequence = sequence_pool[seq_num]
            table.insert(created_sequences,sequence)
            local recipe
            if version_same_or_higher then
                recipe = sequence[3][1]:Acquire('StandardRecipe')
            else
                recipe = sequence[3][1]:Acquire()
            end
            recipe:Set('selection',group)
            -- recipe:Set('values',GetObject('preset 4.'..preset_num))
            recipe:Set('values',presets[seq_per_group_num])
            recipe:Set('matricks',GetObject('matrick '..matrx_num))
            sequence:Set('appearance',appearance_num)
            sequence:Set('name',''..name_prefix..''..group.name..' ['..presets[seq_per_group_num].name..']')
            sequence:Set('prefercueappearance',true)
            sequence:Set('offwhenoverridden',false)
            sequence:Set('tags',tags[group_ind]:Index()..':0')
            sequence[3][1]:Set('appearance',appearance_mark)
            if generate_presets and not preset_appearance and picker_type == 'position' then
                presets[seq_per_group_num]:Set('appearance',appearance_num)
            elseif not generate_presets and preset_appearance and picker_type == 'position' then
                sequence[3][1]:Set('appearance',preset_appearance)
                sequence:Set('appearance',preset_appearance)
            end
            IncProgress(progHandle,1)
            seq_num = seq_num + 1
            preset_i = preset_i + 1
            appearance_num = appearance_num + 1
            appearance_mark = appearance_mark + 1
        end
        preset_i = 1
        appearance_num = first_appear
        appearance_mark = appearance_num + preset_amount
        group_i = group_i + 1
        matrx_num = matrx_num + 1
    end
    StopProgress(progHandle)
    return created_sequences
end