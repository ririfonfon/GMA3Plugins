local c = Cmd
local ti = TextInput

function create_cp_matricks(first_matrx, selected_groups,name_prefix,DP)
    local matrx_num = first_matrx
    local last_matrx = first_matrx + #selected_groups - 1
    local mtrx_pool = ShowData().DataPools[DP].MAtricks
    local GroupPool = ShowData().datapools[DP].Groups
    local group_i = 1
    local group_num = selected_groups[group_i]
    while matrx_num <= last_matrx do
        c('store matricks '..matrx_num..' /nu')
        mtrx_pool[matrx_num]:Set('name',name_prefix..GroupPool[group_num].name)
        matrx_num = matrx_num + 1
        group_i = group_i + 1
        group_num = selected_groups[group_i]
    end
end