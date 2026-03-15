--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local function Set_Def(L_N, N, Obj)
    Obj[L_N][N.No]:Set('visibilitybar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityobjectname', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilitycid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityvalue', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityicon', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityindicatorbar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityselectionrelevance', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityborder', 'Hidden')
    Obj[L_N][N.No]:Set('fullresolution', 'Yes')
end

function Build_Layout(Construct_Pool, Name_Layout)
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]
    local Layout_Nr = 1
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local object_start = { 0, 34, 17, 25, 51, 30, 1635, 1618, 82, 99,

        765, 782, 799, 816, 833, 850, 867, 884, 901, 918, 935, 952, -- A 11-33
        68, 85, 105, 122, 139,
        102, 116, 190, 207, 189, 206,

        986, 1003, 1020, 1037, 1054, 1071, 1088, 1105, 1122, 1139, 1156, 1173, -- B 34-56
        136, 153, 292, 309, 326,
        170, 184, 377, 394, 376, 393,

        1207, 1224, 1241, 1258, 1275, 1292, 1309, 1326, 1343, 1360, 1377, 1394, -- C 57-79
        204, 221, 479, 496, 513,
        238, 252, 564, 581, 563, 580,

        1428, 1445, 1462, 1479, 1496, 1513, 1530, 1547, 1564, 1581, 1598, 1615, -- D 80-102
        272, 289, 666, 683, 700,
        306, 320, 751, 768, 750, 767,

        1649, 1666, 1683, 1700, 1717, 1734, 1751, 1768, 1785, 1802, 1819, 1836, -- E 103-125
        340, 357, 853, 870, 887,
        374, 388, 938, 955, 937, 954,

        1870, 1887, 1904, 1921, 1938, 1955, 1972, 1989, 2006, 2023, 2040, 2057, -- F 126-148
        408, 425, 1040, 1057, 1074,
        442, 456, 1125, 1142, 1124, 1141,

        2091, 2108, 2125, 2142, 2159, 2176, 2193, 2210, 2227, 2244, 2261, 2278, -- G 149-171
        476, 493, 1227, 1244, 1261,
        510, 524, 1312, 1329, 1311, 1328,

        2312, 2329, 2346, 2363, 2380, 2397, 2414, 2431, 2448, 2465, 2482, 2499, -- H 172-194
        544, 561, 1414, 1431, 1448,
        578, 592, 1499, 1516, 1498, 1515,

    }


    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Nr
    local App_Panel_Name = { '[[panelBaseGma3_png]]', '[[01_panel_scale_2_png]]', '[[01_panel_scale_3_png]]',
        '[[01_panel_scale_4_png]]', '[[02_btn_grid_off_png]]',
    }
    local Addr_Nat_Panel = { 0, 0, 0, 0, 0 }
    local App_Panel_Height = { 1205, 800, 800, 800 }
    local App_Panel_Width = { 2000, 2000, 2000, 2000 }
    local App_Panel_PosY = { 0, -434, -434, -434 }
    local App_Panel_Visibility = { 'Visible', 'Hidden', 'Visible', 'Hidden' }
    local btn_temp_x = { 524, 612, 702, 791, 881, 971, 1060, 1150, 1240, 1329, 1418, 1508, 1598, 1688, 1776, 1866 }
    local btn_green_x = { 76, 185, 292, 400, 76, 185, 292, 400 }
    local btn_green_y = { 563, 563, 563, 563, 513, 513, 513, 513 }
    local varia_x = { 76, 156, 235, 315, 76, 156, 235, 315 }
    local varia_y = { 277, 277, 277, 277, 232, 232, 232, 232 }
    local temps_x = { 669, 750, 829, 909, 989, 1068, 1149, 1227, 1307, 1388, 1468, 1547, 1627, 1706, 1786, 1865 }
    local btn_sub_x = { 675, 755, 835, 914, 994, 1074, 1154, 1234, 1313, 1393, 1473, 1553, 1633, 1712, 1792, 1872 }
    local btn_sub_y = { 115, 72, 28, -16, -59, -103, -146, -189, -233, -276, -320, -364 }
    local btn_mute_solo_all_none_x = { 459, 496, 579, 627 }
    local btn_mute_solo_all_none_y = { 135, 92, 49, 5, -38, -82, -126, -169, -212, -256, -300, -343 }
    local Select_Value_Matricks_x = { 49, 153, 256, 360, 403 }
    local Select_Value_Matricks_y = { 132, 90, 46, 2, -40, -84, -128, -172, -215, -259, -302, -346 }
    local S_V_M_Color = { 'FF00FFFF', '00FFFFFF', 'FFFF00FF', '00FF00FF', 'FF0000FF', '0000FFFF', 'FF0000FF' }
    local S_V_M_Text = { 'Group', 'Value', 'Matricks', 'None/None', 'None/None', 'Inv', 'None' }

    for k in pairs(App_Panel_Name) do
        for i in pairs(AppearanceObject) do
            if AppearanceObject[i].Name ~= nil then
                if AppearanceObject[i].Name == App_Panel_Name[k] then
                    Addr_Nat_Panel[k] = AppearanceObject[i]:AddrNative()
                end
            end
        end
    end


    Check_Size_Pool(Layout_Nr, Layout_Object)
    Layout_Object:Create(Layout_Nr)
    Layout_Object[Layout_Nr]:Set('Name', Name_Layout)
    Layout_Object[Layout_Nr]:Set('ViewPosX', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosY', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosActive', 'Yes')

    -- Panel
    for i = 1, 4 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Name', App_Panel_Name[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', 0)
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', App_Panel_PosY[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', App_Panel_Width[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('height', App_Panel_Height[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', App_Panel_Visibility[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityid', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilitycid', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityvalue', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityicon', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Hidden')
        Layout_Object[Layout_Nr][Nr.No]:Set('fullresolution', 'Yes')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    end

    -- btn_temp
    for i = 1, 16 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[1] + i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_temp_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', 445)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 111)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    -- btn_start_stop
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[2]])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 184)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 417)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 175)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 67)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    -- btn_ _green
    for i = 1, 8 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[3] + i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_green_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_green_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 66)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    -- Varia_
    for i = 1, 8 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[4] + i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', varia_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', varia_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 66)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    -- temps_#
    for i = 1, 16 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[5] + i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', temps_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', -350)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 80)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 520)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', '')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    -- Varia_Current
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[object_start[6]])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[5])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 411)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 277)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    -- all_sub_# & none_sub_#
    for y = 1, 2 do
        for i = 1, 12 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i + object_start[6 + y]])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_mute_solo_all_none_x[y + 2])
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_mute_solo_all_none_y[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'all_none_FOND')
            Set_Def(Layout_Nr, Nr, Layout_Object)
            Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
            Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
            Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[y + 5])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[y + 5])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        end
    end

    -- mute_all_none
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[9]])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 459)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'all_none_FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    -- solo_all_none
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[10]])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 496)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'all_none_FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)


    ---------------------------------
    ---------- ABCDEFGH -------------
    ---------------------------------
    local inc, inc_var = 0, 1
    for t = 1, 8 do
        Printf(inc)
        --- btn_sub
        for y = 1, 12 do
            for i = 1, 16 do
                Nr = Layout_Object[Layout_Nr]:Acquire()
                Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + object_start[10 + y + inc]])
                Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_sub_x[i])
                Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_sub_y[y])
                Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
                Layout_Object[Layout_Nr][Nr.No]:Set('height', 70)
                Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
                Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
                Set_Def(Layout_Nr, Nr, Layout_Object)
            end
        end

        --- btn_mute & solo
        for y = 1, 2 do
            for i = 1, 12 do
                Nr = Layout_Object[Layout_Nr]:Acquire()
                Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + object_start[22 + y + inc]])
                Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_mute_solo_all_none_x[y])
                Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_mute_solo_all_none_y[i])
                Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
                Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
                Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
                Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
                Set_Def(Layout_Nr, Nr, Layout_Object)
            end
        end

        --- Select_sub & Value_sub & Matricks_sub ******************
        for y = 1, 3 do
            for i = 1, 12 do
                Nr = Layout_Object[Layout_Nr]:Acquire()
                Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i + object_start[24 + y + inc]])
                Layout_Object[Layout_Nr][Nr.No]:Set('posx', Select_Value_Matricks_x[y])
                Layout_Object[Layout_Nr][Nr.No]:Set('posy', Select_Value_Matricks_y[i])
                Layout_Object[Layout_Nr][Nr.No]:Set('width', 100)
                Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
                Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
                Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
                Set_Def(Layout_Nr, Nr, Layout_Object)
                Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
                Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
                Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[y])
                Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[y])
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 18)
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
                MacroObject[i + object_start[24 + y + inc]][4]:Set('Command',
                    "SetUserVariable 'TR_Layout' '" .. Layout_Nr .. "_" .. Nr.No .. "'")
            end
        end

        --- select
        for i = 1, 12 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + object_start[28 + inc]])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', 538)
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_mute_solo_all_none_y[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
            Set_Def(Layout_Nr, Nr, Layout_Object)
        end

        --- select_all
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[object_start[29 + inc]])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', 538)
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
        Set_Def(Layout_Nr, Nr, Layout_Object)

        --- fade & delay ***********************
        for y = 1, 2 do
            for i = 1, 12 do
                Nr = Layout_Object[Layout_Nr]:Acquire()
                Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i + object_start[29 + y + inc]])
                Layout_Object[Layout_Nr][Nr.No]:Set('posx', Select_Value_Matricks_x[y + 3])
                Layout_Object[Layout_Nr][Nr.No]:Set('posy', Select_Value_Matricks_y[i])
                Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
                Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
                Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
                Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
                Set_Def(Layout_Nr, Nr, Layout_Object)
                Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
                Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
                Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[y + 3])
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[y + 3])
                Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[y + 3])
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
                Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
                MacroObject[i + object_start[29 + y + inc]][5]:Set('Command',
                    "SetUserVariable 'TR_Layout' '" .. Layout_Nr .. "_" .. Nr.No .. "'")
                Printf(Nr.No ..
                    '  ' .. i + object_start[29 + y + inc] .. ' = ' .. MacroObject[i + object_start[29 + y + inc]].Name)
            end
        end

        --- Edit_Fade_TR_INPUT
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[object_start[32 + inc]])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', 360)
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
        Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[4])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[4])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', 'Fade')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')

        --- Edit_Delay_TR_INPUT
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[object_start[33 + inc]])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', 403)
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', varia_mag[inc_var])
        Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[5])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[5])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', 'Delay')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')

        inc = inc + 23
        inc_var = inc_var + 1
    end

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[1676])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 579)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'all_none_FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
    Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[6])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[6])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')

    Cmd ("Go+ Cue 2 DataPool '" .. Build_Pool.Name .. "' Sequence 'btn_a_green'")
    Cmd ("Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'Varia_A'")
end
