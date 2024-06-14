--[[
    Releases:
    * 2.0.1.0

    Created by Richard Fontaine "RIRI", June 2024.
    --]]
    function Create_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Data_Pool_Nr)
        local macro_num = CurrentMacroNr + 1
        CurrentMacroNr = macro_num + 16
        local macropool = ShowData().DataPools[Data_Pool_Nr].Macros
        Cmd('Store Macro ' .. macro_num .. '.1 Thru 6' .. ' /nu')
        Cmd('Store Macro ' .. (macro_num + 1) .. ' Thru ' .. CurrentMacroNr .. ' /nu')
        macropool[macro_num]:Set('name', prefix .. ' Store Favo ')
        macropool[macro_num][1]:Set('Command', 'SetUserVariable "LC_Favourites" "')
        macropool[macro_num][1]:Set('execute', false)
        macropool[macro_num][1]:Set('addtocmdline', true)
        macropool[macro_num][2]:Set('Command', 'SetUserVariable "LC_Fonction" 10')
        macropool[macro_num][3]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
        macropool[macro_num][4]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Data_Pool_Nr .. '')
        macropool[macro_num][5]:Set('Command', 'SetUserVariable "LC_Prefix" ' .. prefix .. '')
        macropool[macro_num][6]:Set('Command', 'Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View"')
        macropool[macro_num]:Set('Appearance', 'LC_Black')
        for i = macro_num + 1, CurrentMacroNr do
            macropool[i]:Set('Appearance', 'LC_Favo')
        end
        return CurrentMacroNr, macro_num
    end
    
    function Create_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Data_Pool_Nr, Ligne_Inc)
        -- local progHandle = StartProgress("Aligning Favourites Macros")
        local LayX = -80 -- position of te first object by x-axis
        local LayY = 700 -- position of te first0 object by y-axis
        if Ligne_Inc then
            LayY = 800
        end
        local object_type = 'Macro'
        local col_num = 1
        local line_num = 1
        local pool_obj_num = CurrentMacroNr - 17 +
            1                                              -- pool number of the first object (17 - number of favoutite macros)
        local obj_count = 17                               -- amout of objects to be aligned
        local last_pool_obj = pool_obj_num + obj_count - 1 -- last object of the pool to be aligned
        local x_count = 4                                  -- number of columns
        local y_count = 4                                  -- number of rows
        local layout_pool = ShowData().datapools[Data_Pool_Nr].Layouts
        -- define the range of the progress bar:
        -- SetProgressRange(progHandle, col_num, x_count)
        Cmd('assign ' .. object_type .. ' ' .. pool_obj_num .. ' at Layout ' .. TLayNr .. ' /nu')
        layout_pool[TLayNr][LayNr]:Set('posx', LayX)
        layout_pool[TLayNr][LayNr]:Set('posy', LayY)
        layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
        layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
        layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW * 2)
        layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
        LayNr = LayNr + 1
        pool_obj_num = pool_obj_num + 1
        Cmd('assign ' .. object_type .. ' ' .. pool_obj_num .. ' Thru ' .. last_pool_obj .. ' at Layout ' .. TLayNr .. ' /nu')
        LayX = 160
        while line_num <= y_count do
            while col_num <= x_count do
                layout_pool[TLayNr][LayNr]:Set('posx', LayX)
                layout_pool[TLayNr][LayNr]:Set('posy', LayY)
                layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
                layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW)
                layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
                layout_pool[TLayNr][LayNr]:Set('visibilityindicatorbar', false)
                layout_pool[TLayNr][LayNr]:Set('visibilityobjectname', false)
                layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
                LayX = LayX + 120
                -- SetProgress(progHandle, col_num)
                -- coroutine.yield(progress_bar_time)
                col_num = col_num + 1
                LayNr = LayNr + 1
            end
            line_num = line_num + 1
            col_num = 1
            -- LayX = -400
            -- LayY = LayY - 50
        end
        -- StopProgress(progHandle)
        return LayNr
    end
    
    -- end LC_Favourites.lua