local c = Cmd
local ti = TextInput

function cp_create_name_prefix(DP)
    local macro_pool = ShowData().datapools[DP].Macros
    local color_presets_pool = ShowData().datapools[DP].PresetPools[4]
    local appearances_pool = ShowData().Appearances
    local matricks_pool = ShowData().DataPools[DP].MAtricks
    local groups_pool = ShowData().DataPools[DP].Groups
    local layouts_pool = ShowData().datapools[DP].Layouts
    local sequence_pool = ShowData().datapools[DP].Sequences
    local pools = {macro_pool,color_presets_pool,appearances_pool,matricks_pool,layouts_pool,sequence_pool}
    local prefix_index = 1
    local prefix = 'CP'..tostring(prefix_index)..'_'
    local obj_i = 1
    local pools_i = 1
    local detected = false
    -- for pools_i = 1,#pools do
    repeat
        repeat
            if #pools[pools_i]:Children() ~= 0 and string.match(pools[pools_i]:Children()[obj_i].name,prefix) then
                prefix_index = prefix_index + 1
                detected = true
                prefix = 'CP'..tostring(prefix_index)..'_'
                obj_i = 1
            end
            obj_i = obj_i + 1
        until pools[pools_i]:Children()[obj_i] == nil
        obj_i = 1
        if detected then
            pools_i = 1
            detected = false
        else
            pools_i = pools_i + 1
        end
    until pools[pools_i] == nil
        -- Echo(prefix)
    return prefix
end