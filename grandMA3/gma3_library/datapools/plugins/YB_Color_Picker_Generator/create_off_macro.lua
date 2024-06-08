local c = Cmd
local ti = TextInput


function cp_create_off_macro(last_macro,last_appear,name_prefix,DP)
    local macros_pool = ShowData().datapools[DP].Macros
    local macro_num = last_macro
    c('store macro '..macro_num..'.1 /nu')
    macros_pool[macro_num][1]:Set('Command', 'off sequence "'..name_prefix..'*"')
    macros_pool[macro_num]:Set('name', 'All Color OFF ['..name_prefix:gsub('_','')..']')
    macros_pool[macro_num]:Set('appearance',last_appear-1)
    return macro_num
end