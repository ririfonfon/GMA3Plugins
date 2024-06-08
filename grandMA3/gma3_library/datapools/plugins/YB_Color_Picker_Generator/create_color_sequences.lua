local c = Cmd
local ti = TextInput

function create_color_sequences(first_sequence,groups,first_mtrx,presets,first_appear,name_prefix,progress_bar_time,DP)
    local progHandle = StartProgress("Generating Sequences")
    local group_amount = #groups
    local group_i = 1
    local preset_i = 1
    local group_num = groups[group_i]
    local seq_per_group_num = 1
    local matrx_num = first_mtrx
    local preset_amount = #presets
    local preset_num = presets[preset_i]
    local seq_num = first_sequence
    local sequence_amount = group_amount * preset_amount
    local sequence_end_num = first_sequence + sequence_amount - 1
    local appearance_num = first_appear
    local appearance_mark = appearance_num + preset_amount
    local GroupPool = ShowData().datapools[DP].Groups
    local ColorPresetPool = ShowData().datapools[DP].PresetPools[4]
    local sequence_pool = ShowData().datapools[DP].Sequences
    SetProgressRange(progHandle, first_sequence, sequence_end_num)
    c('store sequence '..first_sequence..' thru '..sequence_end_num..' /nu')
    while group_num ~= nil do
        while seq_per_group_num <= preset_amount do
            c('assign group '..group_num..' at cue 1 part 0.1 sequence '..seq_num..' /nu')
            c('assign preset 4.'..preset_num..' at cue 1 part 0.1 sequence '..seq_num..' /nu')            
            c('assign matricks '..matrx_num..' at cue 1 part 0.1 sequence '..seq_num..' /nu')
            sequence_pool[seq_num]:Set('appearance',appearance_num)
            sequence_pool[seq_num][3][1]:Set('appearance',appearance_mark)
            sequence_pool[seq_num]:Set('name',''..name_prefix..''..GroupPool[group_num].name..' ['..ColorPresetPool[preset_num].name..']')
            sequence_pool[seq_num]:Set('prefercueappearance','true')
            sequence_pool[seq_num]:Set('offwhenoverridden','true')
            SetProgress(progHandle, seq_num)
            coroutine.yield(progress_bar_time)
            seq_num = seq_num + 1
            seq_per_group_num = seq_per_group_num + 1
            preset_i = preset_i + 1
            preset_num = presets[preset_i]
            appearance_num = appearance_num + 1
            appearance_mark = appearance_mark + 1
        end
        preset_i = 1
        preset_num = presets[preset_i]
        appearance_num = first_appear
        appearance_mark = appearance_num + preset_amount
        group_i = group_i + 1
        group_num = groups[group_i]
        seq_per_group_num = 1
        matrx_num = matrx_num + 1
    end 
    StopProgress(progHandle)
end 