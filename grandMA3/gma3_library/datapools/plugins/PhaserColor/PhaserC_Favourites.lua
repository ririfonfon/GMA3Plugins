--[[
Releases:
* 2.4.2.2

Version:
* 2.0.0.0

Created by Richard Fontaine "RIRI", July 2026.
--]]

function Create_PC_Favourite_Macro(prefix, CurrentMacroNr, TLayNr, Construct_Pool, Favourite_Nr, Call_Pool)
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)
    local macro_num = CurrentMacroNr + 1
    CurrentMacroNr = macro_num + Favourite_Nr

    PC_Check_Size_Pool(macro_num, MacroObject)
    MacroObject:Create(macro_num)
    for i = 1, 8 do
        MacroObject[macro_num]:Insert(i)
    end
    MacroObject[macro_num]:Set('name', prefix .. ' Store Favo ')
    MacroObject[macro_num][1]:Set('Command',
        'Set DataPool ' .. Construct_Pool .. ' Macro ' .. macro_num .. ' Property "Appearance" "LC_Red"')
    MacroObject[macro_num][2]:Set('Command', 'SetUserVariable "PC_Favourites" "')
    MacroObject[macro_num][2]:Set('execute', false)
    MacroObject[macro_num][2]:Set('addtocmdline', true)
    MacroObject[macro_num][3]:Set('Command', 'SetUserVariable "PC_Fonction" 2')
    MacroObject[macro_num][4]:Set('Command', 'SetUserVariable "PC_Layout" ' .. TLayNr)
    MacroObject[macro_num][5]:Set('Command', 'SetUserVariable "PC_Data_Pool" ' .. Construct_Pool)
    MacroObject[macro_num][6]:Set('Command', 'SetUserVariable "PC_Prefix" ' .. prefix)
    MacroObject[macro_num][7]:Set('Command', 'SetUserVariable "PC_Macro" ' .. macro_num)
    MacroObject[macro_num][8]:Set('Command',
        "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'PhaserColor_V2_4'.'PC_View'")
    MacroObject[macro_num]:Set('Appearance', 'LC_Black')

    for i = macro_num + 1, CurrentMacroNr do
        PC_Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Appearance', 'LC_Favo')
    end
    return CurrentMacroNr, macro_num
end

function Create_PC_Favourite_Layout(LayNr, CurrentMacroNr, LayH, LayW, TLayNr, Construct_Pool, Ligne_Inc, Favourite_Nr,
                                    LayX)
    local DEBUG = false
    local MacroObject, SequenceObject, Layout_Object, Preset25Object,
    MatrickObject, AppObject, Nr = PC_Get_Object(Construct_Pool)
    LayX = LayX + 120
    local LayY = 560 -- position of te first0 object by y-axis
    if Ligne_Inc then
        LayY = 560
    end
    local line_num = 1
    local pool_obj_num = CurrentMacroNr - Favourite_Nr -- pool number of the first object
    if DEBUG then Echo('pool object ' .. pool_obj_num) end

    local ref_pool_obj
    for i in pairs(MacroObject:Children()) do
        if MacroObject[i] ~= nil then
            if DEBUG then
                Echo('i ' .. i .. ' macro no ' .. MacroObject[i].No ..
                    ' name ' .. MacroObject[i].Name .. ' poolobj ' .. pool_obj_num)
            end
            if MacroObject[i].No == pool_obj_num then
                ref_pool_obj = i
            end
        end
    end
    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[ref_pool_obj])
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
    Layout_Object[TLayNr][Nr.No]:Set('VisibilityBar', false)
    Layout_Object[TLayNr][Nr.No]:Set('POSITIONH', LayH)
    Layout_Object[TLayNr][Nr.No]:Set('POSITIONW', LayW * 2)
    Layout_Object[TLayNr][Nr.No]:Set('visibilityborder', false)
    LayNr = LayNr + 1
    ref_pool_obj = ref_pool_obj + 1
    LayX = LayX + 240
    while line_num <= Favourite_Nr do
        if DEBUG then Echo(line_num .. ' <= ' .. Favourite_Nr) end
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[ref_pool_obj])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('POSITIONH', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('POSITIONW', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('VisibilityBar', false)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityindicatorbar', false)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityobjectname', false)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityborder', false)
        LayX = LayX + 120
        LayNr = LayNr + 1
        line_num = line_num + 1
        ref_pool_obj = ref_pool_obj + 1
    end
    return 
end

-- end PhaserC_Favourites.lua
