--[[
    Releases:
    * 2.1.1.2

    Created by Richard Fontaine "RIRI", June 2024.
    --]]

function Create_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Data_Pool_Nr, Favourite_Nr)
    local macro_num = CurrentMacroNr + 1
    CurrentMacroNr = macro_num + Favourite_Nr
    local macropool = ShowData().DataPools[Data_Pool_Nr].Macros
    CmdIndirectWait('Store Macro ' .. macro_num .. '.1 Thru 8' .. ' /nu')
    CmdIndirectWait('Store Macro ' .. (macro_num + 1) .. ' Thru ' .. CurrentMacroNr .. ' /nu')
    macropool[macro_num]:Set('name', prefix .. ' Store Favo ')
    macropool[macro_num][1]:Set('Command',
        'Set DataPool ' .. Data_Pool_Nr .. ' Macro ' .. macro_num .. ' Property "Appearance" "LC_Red"')
    macropool[macro_num][2]:Set('Command', 'SetUserVariable "LC_Favourites" "')
    macropool[macro_num][2]:Set('execute', false)
    macropool[macro_num][2]:Set('addtocmdline', true)
    macropool[macro_num][3]:Set('Command', 'SetUserVariable "LC_Fonction" 10')
    macropool[macro_num][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    macropool[macro_num][5]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Data_Pool_Nr .. '')
    macropool[macro_num][6]:Set('Command', 'SetUserVariable "LC_Prefix" ' .. prefix .. '')
    macropool[macro_num][7]:Set('Command', 'SetUserVariable "LC_Macro" ' .. macro_num .. '')
    macropool[macro_num][8]:Set('Command', 'Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View"')
    macropool[macro_num]:Set('Appearance', 'LC_Black')
    for i = macro_num + 1, CurrentMacroNr do
        macropool[i]:Set('Appearance', 'LC_Favo')
    end
    return CurrentMacroNr, macro_num
end

function Create_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Data_Pool_Nr, Ligne_Inc, Favourite_Nr)
    local LayX = 0 - 80 -- position of te first object by x-axis
    -- local LayX = 0 -- position of te first object by x-axis
    local LayY = 700    -- position of te first0 object by y-axis
    if Ligne_Inc then
        LayY = 800
    end
    local object_type = 'Macro'
    local line_num = 1
    local pool_obj_num = CurrentMacroNr - Favourite_Nr -- pool number of the first object
    Printf('pool object ' .. pool_obj_num)
    local obj_count = Favourite_Nr                     -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count     -- last object of the pool to be aligned
    local layout_pool = ShowData().datapools[Data_Pool_Nr].Layouts
    CmdIndirectWait('assign ' .. object_type .. ' ' .. pool_obj_num .. ' at Layout ' .. TLayNr .. ' /nu')
    layout_pool[TLayNr][LayNr]:Set('posx', LayX)
    layout_pool[TLayNr][LayNr]:Set('posy', LayY)
    layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
    layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
    layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW * 2)
    layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
    LayNr = LayNr + 1
    pool_obj_num = pool_obj_num + 1
    CmdIndirectWait('assign ' .. object_type .. ' ' .. pool_obj_num .. ' Thru ' .. last_pool_obj .. ' at Layout ' .. TLayNr .. ' /nu')
    LayX = 160
    while line_num <= Favourite_Nr do
        layout_pool[TLayNr][LayNr]:Set('posx', LayX)
        layout_pool[TLayNr][LayNr]:Set('posy', LayY)
        layout_pool[TLayNr][LayNr]:Set('POSITIONH', LayH)
        layout_pool[TLayNr][LayNr]:Set('POSITIONW', LayW)
        layout_pool[TLayNr][LayNr]:Set('VisibilityBar', false)
        layout_pool[TLayNr][LayNr]:Set('visibilityindicatorbar', false)
        layout_pool[TLayNr][LayNr]:Set('visibilityobjectname', false)
        layout_pool[TLayNr][LayNr]:Set('visibilityborder', false)
        LayX = LayX + 120
        LayNr = LayNr + 1
        line_num = line_num + 1
        Printf(line_num .. ' <= ' .. Favourite_Nr)
    end
    return LayNr
end

-- end LC_Favourites.lua
