local c = Cmd
local ti = TextInput

function cp_store_favourite_macro(prefix,first_macro,layout,DP)
    local macro_num = first_macro + 1
    local last_macro = macro_num + 16
    local macropool = ShowData().DataPools[DP].Macros
    c('store macro '..macro_num..'.1 thru 3'..' /nu')
    c('store macro '..(macro_num+1)..' thru '..last_macro..' /nu')
    macropool[macro_num]:Set('name','Store favourite '..prefix:gsub('_','')..' state')
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
    command = command:gsub('\n',' ')
    if Version() == '1.8.8.2' then
        macropool[macro_num][1]:Set('command','setuservar "'..prefix..'favouritemacro" "')
    else
        macropool[macro_num][1]:Set('command','setuservariable "'..prefix..'favouritemacro" "')
    end
    macropool[macro_num][1]:Set('execute',false)
    macropool[macro_num][1]:Set('addtocmdline',true)
    macropool[macro_num][2]:Set('command','Lua "'..command..'"') 
    if Version() == '1.8.8.2' then
        macropool[macro_num][3]:Set('command','deluservar "'..prefix..'favouritemacro"')
    else
        macropool[macro_num][3]:Set('command','deleteuservariable "'..prefix..'favouritemacro"')
    end
    macropool[macro_num]:Set('appearance',prefix..'Black Back')
    for i=macro_num+1, last_macro do
        -- macropool[i]:Set('name',prefix..' Favourite '..(i-macro_num))
        macropool[i]:Set('appearance',prefix..'Favourites')
    end
    return last_macro
end