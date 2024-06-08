local c = Cmd
local ti = TextInput

function cp_import_symbols(first_symbol)
    local path = GetPath(Enums.PathType.SymbolImageLibrary)
    local filenames = {'x_mark_white.png','number_0_black.png','number_0_white.png','question_mark_black.png','question_mark_white.png','number_1_black.png','number_1_white.png','number_2_black.png','number_2_white.png','number_3_black.png','number_3_white.png','number_4_black.png','number_4_white.png','number_6_black.png','number_6_white.png','calculator_black.png','calculator_white.png'}
    local sym_num = first_symbol
    for i=1, #filenames do
        -- c('Import Image 2.'..(i+sym_num-1)..' /File "'..filenames[i]..'.xml" /Path "'..path..'/symbols" /nu')
    end

    return filenames
end
