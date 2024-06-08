local c = Cmd
local ti = TextInput

function cp_create_delete_macro(first_macro,last_macro,first_sequence,number_of_presets,amount_of_groups,cp_layout,first_appear,last_appear,first_preset,first_matrx,choise,name_prefix,DP)
    local macros_pool = ShowData().datapools[DP].Macros
    -- local last_symbol = first_symbol + symbols_amount - 1
    local macro_num = last_macro + 1
    local line1 = 'Delete Sequence '..first_sequence..' thru '..(first_sequence+number_of_presets*amount_of_groups-1)..' /nc /nu'
    local line2 = 'Delete Macro '..first_macro..' thru '..last_macro..' /nc /nu'
    -- local line3 = 'Delete image 2.'..first_symbol..' thru '..last_symbol..' /nc /nu'
    local line3 = ''
    local line4 = 'Delete Layout '..cp_layout..' /nc /nu'
    local line5 = 'Delete Appearance '..first_appear..' thru '..(last_appear-1)..' /nc /nu'
    local line6 = ''
    local condition_string = "Lua 'if Confirm(\"Delete Color Picker "..name_prefix:gsub('%D*','').."?\") then; Cmd(\"Go macro "..macro_num.."\"); else Cmd(\"Off macro "..macro_num.."\"); end'"..' /nu'
    if choise == 1 then
        line6 = 'Delete Preset 4.'..first_preset..' thru '..(first_preset+number_of_presets-1)..' /nc /nu'
        else
        line6 = ''
    end
    local line7 = 'Delete Matricks '..first_matrx..' thru '..(first_matrx+amount_of_groups-1)..' /nc /nu'
    local line8 = 'Delete macro '..macro_num..' /nc /nu'
    c('Store macro '..macro_num..'.1 thru 9 /nu')
    macros_pool[macro_num]:Set('name','Delete ALL ['..name_prefix:gsub('_','')..']')
    macros_pool[macro_num][1]:Set('Command', condition_string)
    macros_pool[macro_num][1]:Set('Wait', 'Go')
    macros_pool[macro_num][2]:Set('Command', line1)
    macros_pool[macro_num][3]:Set('Command', line2)
    macros_pool[macro_num][4]:Set('Command', line3)
    macros_pool[macro_num][5]:Set('Command', line4)
    macros_pool[macro_num][6]:Set('Command', line5)
    macros_pool[macro_num][7]:Set('Command', line6)
    macros_pool[macro_num][8]:Set('Command', line7)
    macros_pool[macro_num][9]:Set('Command', line8)
end