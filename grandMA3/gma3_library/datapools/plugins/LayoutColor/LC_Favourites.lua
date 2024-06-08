--[[
    Releases:
    * 2.0.0.9

    Created by Richard Fontaine "RIRI", June 2024.
    --]]
function Create_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Data_Pool_Nr)
    local macro_num = CurrentMacroNr + 1
    CurrentMacroNr = macro_num + 16
    local macropool = ShowData().DataPools[Data_Pool_Nr].Macros
    Cmd('store macro ' .. macro_num .. '.1 thru 3' .. ' /nu')
    Cmd('store macro ' .. (macro_num + 1) .. ' thru ' .. CurrentMacroNr .. ' /nu')
    macropool[macro_num]:Set('name',  prefix .. ' Store favourite state')
    local command = [[local sequences = ObjectList('sequence '..string.char(34)..']] ..
    prefix .. [[*'..string.char(34)..'')
        local macropool = ShowData().DataPools[]] .. Data_Pool_Nr .. [[].Macros
        local layoutspool = ShowData().DataPools[]] .. Data_Pool_Nr .. [[].Layouts
        local activeseq = {}
        local macronum = GetVar(UserVars(),']] .. prefix .. [[favouritemacro')
        macronum = macronum:gsub(' Macro','')
        macronum = tonumber(macronum)
        for i=1,#sequences do
            if sequences[i]:HasActivePlayback() then
                table.insert(activeseq,i)
            end
        end
        if #macropool[macronum] == 0 then
            layoutspool[]] .. TLayNr .. [[]['Macro '..macronum]:Set('visibilityobjectname',true)
        end
        Cmd('label macro '..macronum..' '..string.char(34)..']] ..
        prefix .. [[ Favourite'..string.char(34)..' /o')
        if #macropool[macronum] > 0 then
            Cmd('delete macro '..macronum..'.1 thru')
        end
        Cmd('store macro '..macronum..'.1 thru'..#activeseq..' /o')
        for i=1,#activeseq do
            local seqnumber = activeseq[i]
            macropool[macronum][i]:Set('command','go sequence '..string.char(34)..''..sequences[seqnumber].name..''..string.char(34)..'')
        end]]
    command = command:gsub('\n', ' ')
    if Version() == '1.8.8.2' then
        macropool[macro_num][1]:Set('command', 'setuservar "' .. prefix .. 'favouritemacro" "')
    else
        macropool[macro_num][1]:Set('command', 'setuservariable "' .. prefix .. 'favouritemacro" "')
    end
    macropool[macro_num][1]:Set('execute', false)
    macropool[macro_num][1]:Set('addtocmdline', true)
    macropool[macro_num][2]:Set('command', 'Lua "' .. command .. '"')
    if Version() == '1.8.8.2' then
        macropool[macro_num][3]:Set('command', 'deluservar "' .. prefix .. 'favouritemacro"')
    else
        macropool[macro_num][3]:Set('command', 'deleteuservariable "' .. prefix .. 'favouritemacro"')
    end
    -- macropool[macro_num]:Set('appearance', prefix .. 'Black Back')
    for i = macro_num + 1, CurrentMacroNr do
        -- macropool[i]:Set('name',prefix..' ')
        -- macropool[i]:Set('name',prefix..' Favourite '..(i-macro_num))
        -- macropool[i]:Set('appearance', prefix .. 'Favourites')
    end
    return CurrentMacroNr
end

function Create_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Data_Pool_Nr)
    -- local progHandle = StartProgress("Aligning Favourites Macros")
    local pos_x = -400 -- position of te first object by x-axis
    local pos_y = 1000  -- position of te first0 object by y-axis
    local object_type = 'macro'
    local col_num = 1
    local line_num = 1
    local pool_obj_num = CurrentMacroNr - 17 + 1       -- pool number of the first object (17 - number of favoutite macros)
    local obj_count = 17                               -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
    local x_count = 4                                  -- number of columns
    local y_count = 4                                  -- number of rows
    local layout_pool = ShowData().datapools[Data_Pool_Nr].Layouts
    -- define the range of the progress bar:
    -- SetProgressRange(progHandle, col_num, x_count)
    Cmd('assign ' .. object_type .. ' ' .. pool_obj_num .. ' at Layout ' .. TLayNr .. ' /nu')
    layout_pool[TLayNr][LayNr]:Set('posx', pos_x)
    layout_pool[TLayNr][LayNr]:Set('posy', pos_y)
    layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
    layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
    layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW * 2)
    layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
    LayNr = LayNr + 1
    pool_obj_num = pool_obj_num + 1
    Cmd('assign ' .. object_type .. ' ' .. pool_obj_num .. ' thru ' .. last_pool_obj .. ' at Layout ' .. TLayNr .. ' /nu')
    pos_y = pos_y - 120
    while line_num <= y_count do
        while col_num <= x_count do
            layout_pool[TLayNr][LayNr]:Set('posx', pos_x)
            layout_pool[TLayNr][LayNr]:Set('posy', pos_y)
            layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
            layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW)
            layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
            layout_pool[TLayNr][LayNr]:Set('visibilityindicatorbar', false)
            layout_pool[TLayNr][LayNr]:Set('visibilityobjectname', false)
            layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
            pos_x = pos_x + 120
            -- SetProgress(progHandle, col_num)
            -- coroutine.yield(progress_bar_time)
            col_num = col_num + 1
            LayNr = LayNr + 1
        end
        line_num = line_num + 1
        col_num = 1
        -- pos_x = -400
        -- pos_y = pos_y - 50
    end
    -- StopProgress(progHandle)
    return LayNr
end

-- end LC_Favourites.lua
