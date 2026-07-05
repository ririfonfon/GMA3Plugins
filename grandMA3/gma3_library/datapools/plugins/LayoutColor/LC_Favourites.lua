--[[
Releases:
* 2.3.2.0

Version:
* 2.2.0.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]

function LC_Create_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Construct_Pool, Favourite_Nr, Call_Pool)
    local macro_num = CurrentMacroNr + 1
    CurrentMacroNr = macro_num + Favourite_Nr
    local macropool = ShowData().DataPools[Construct_Pool].Macros

    for c = macro_num + 1, CurrentMacroNr do
        macropool:Create(c)
    end
    macropool:Create(macro_num)
    macropool[macro_num]:Set('name', prefix .. ' Store Favo ')
    for b = 1, 8 do
        macropool[macro_num]:Insert(b)
    end
    macropool[macro_num][1]:Set('Command',
        'Set DataPool ' .. Construct_Pool .. ' Macro ' .. macro_num .. ' Property "Appearance" "LC_Red"')
    macropool[macro_num][2]:Set('Command', 'SetUserVariable "LC_Favourites" "')
    macropool[macro_num][2]:Set('execute', false)
    macropool[macro_num][2]:Set('addtocmdline', true)
    macropool[macro_num][3]:Set('Command', 'SetUserVariable "LC_Fonction" 10')
    macropool[macro_num][4]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    macropool[macro_num][5]:Set('Command', 'SetUserVariable "LC_DataPool" ' .. Construct_Pool .. '')
    macropool[macro_num][6]:Set('Command', 'SetUserVariable "LC_Prefix" ' .. prefix .. '')
    macropool[macro_num][7]:Set('Command', 'SetUserVariable "LC_Macro" ' .. macro_num .. '')
    macropool[macro_num][8]:Set('Command', 'Call ' .. Call_Pool .. ' Plugin "DEV_LC_View"')
    macropool[macro_num]:Set('Appearance', 'LC_Black')
    for i = macro_num + 1, CurrentMacroNr do
        macropool[i]:Set('Appearance', 'LC_Favo')
    end
    return CurrentMacroNr, macro_num
end

function LC_Create_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Construct_Pool, Ligne_Inc, Favourite_Nr)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local LayX = 0 - 80 -- position of te first object by x-axis
    local LayY = 700    -- position of te first0 object by y-axis
    if Ligne_Inc then
        LayY = 800
    end
    local object_type = 'Macro'
    local line_num = 1
    local pool_obj_num = CurrentMacroNr - Favourite_Nr -- pool number of the first object
    local obj_count = Favourite_Nr                     -- amout of objects to be aligned
    local last_pool_obj = pool_obj_num + obj_count     -- last object of the pool to be aligned
    local layout_pool = ShowData().datapools[Construct_Pool].Layouts
    Nr = Layout_Object[TLayNr]:Acquire()
    layout_pool[TLayNr][Nr.No]:Set('Object', MacroObject[pool_obj_num])
    layout_pool[TLayNr][Nr.No]:Set('posx', LayX)
    layout_pool[TLayNr][Nr.No]:Set('posy', LayY)
    layout_pool[TLayNr][Nr.No]:Set('VisibilityBar', false)
    layout_pool[TLayNr][Nr.No]:Set('POSITIONH', LayH)
    layout_pool[TLayNr][Nr.No]:Set('POSITIONW', LayW * 2)
    layout_pool[TLayNr][Nr.No]:Set('visibilityborder', false)
    LayNr = Nr.No + 1
    pool_obj_num = pool_obj_num + 1

    local inc = LayNr
    for d = pool_obj_num, last_pool_obj do
        Nr = Layout_Object[TLayNr]:Acquire()
        layout_pool[TLayNr][Nr.No]:Set('Object', MacroObject[d])
        inc = inc + 1
    end
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
    end
    return LayNr
end

-- end LC_Favourites.lua
