local function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used : ' .. id) end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

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

local function main()
    local Construct_Pool = 43
    local Layout_Nr = 1
    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    -- local Layout_Object_C = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Nr, deb
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
    local btn_mute_solo_x = { 459, 496 }
    local btn_mute_solo_y = { 135, 92, 49, 5, -38, -82, -126, -169, -212, -256, -300, -343 }
    local Select_Value_Matricks_x = { 49, 153, 256, 360, 403 }
    local Select_Value_Matricks_y = { 132, 90, 46, 2, -40, -84, -128, -172, -215, -259, -302, -346 }
    local S_V_M_Color = { 'FF00FFFF', '00FFFFFF', 'FFFF00FF', '00FF00FF', 'FF0000FF' }
    local S_V_M_Text = { 'Group', 'Value', 'Matricks', 'None/None', 'None/None' }

    for k in pairs(App_Panel_Name) do
        for i in pairs(AppearanceObject) do
            if AppearanceObject[i].Name ~= nil then
                if AppearanceObject[i].Name == App_Panel_Name[k] then
                    -- Printf('AppearanceObject ' .. i .. ' = ' .. AppearanceObject[i].Name)
                    Addr_Nat_Panel[k] = AppearanceObject[i]:AddrNative()
                    -- Printf('Addr_Nat_Panel ' .. k .. ' = ' .. Addr_Nat_Panel[k])
                end
            end
        end
    end


    Check_Size_Pool(Layout_Nr, Layout_Object)
    Layout_Object:Create(Layout_Nr)
    Layout_Object[Layout_Nr]:Set('Name', 'TR-808_Build')
    Layout_Object[Layout_Nr]:Set('ViewPosX', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosY', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosActive', 'Yes')

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

    for i = 1, 16 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_temp_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', 445)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 111)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[34])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 184)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 417)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 175)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 67)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    for i = 1, 8 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + 17])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_green_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_green_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 66)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    for i = 1, 8 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + 25])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', varia_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', varia_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 66)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    for i = 1, 16 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + 51])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', temps_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', 350)
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 80)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 520)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', '')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[30])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[5])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 411)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 277)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    ---------- AAAAAAAAA
    ---


    local seq_start = 765
    for y = 1, 12 do
        for i = 1, 16 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + seq_start])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_sub_x[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_sub_y[y])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 70)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 70)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
            Set_Def(Layout_Nr, Nr, Layout_Object)
        end
        seq_start = seq_start + 17
    end

    seq_start = 68
    for y = 1, 2 do
        for i = 1, 12 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + seq_start])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', btn_mute_solo_x[y])
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_mute_solo_y[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
            Set_Def(Layout_Nr, Nr, Layout_Object)
        end
        seq_start = seq_start + 17
    end

    seq_start = 88
    for y = 1, 3 do
        for i = 1, 12 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i + seq_start])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', Select_Value_Matricks_x[y])
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', Select_Value_Matricks_y[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 100)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
            Set_Def(Layout_Nr, Nr, Layout_Object)
            Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
            Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
            Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[y])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[y])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 18)
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        end
        seq_start = seq_start + 17
    end

    seq_start = 102
    for i = 1, 12 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[i + seq_start])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', 538)
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', btn_mute_solo_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
        Set_Def(Layout_Nr, Nr, Layout_Object)
    end

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[116])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 538)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 30)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    seq_start = 190
    for y = 1, 2 do
        for i = 1, 12 do
            Nr = Layout_Object[Layout_Nr]:Acquire()
            Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i + seq_start])
            Layout_Object[Layout_Nr][Nr.No]:Set('posx', Select_Value_Matricks_x[y + 3])
            Layout_Object[Layout_Nr][Nr.No]:Set('posy', Select_Value_Matricks_y[i])
            Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
            Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
            Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
            Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
            Set_Def(Layout_Nr, Nr, Layout_Object)
            Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
            Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
            Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[y + 3])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[y + 3])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[y + 3])
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
            Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        end
        seq_start = seq_start + 17
    end

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[189])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 360)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
    Set_Def(Layout_Nr, Nr, Layout_Object)
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
    Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[4])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[4])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', 'Fade')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')

    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[206])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 403)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -386)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 40)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 34)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'A')
    Set_Def(Layout_Nr, Nr, Layout_Object)
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 1)
    Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[5])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', S_V_M_Color[5])
    Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', 'Delay')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 28)
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')



    -- Nr = Layout_Object[Layout_Nr][1]:Get('Appearance')
    -- if Nr ~= nil then
    --     Printf('Nr = ' .. Nr)
    -- else
    --     Printf('Nr is nil')
    -- end
    -- Layout_Object[Layout_Nr][2]:Set('Appearance', Nr)
    -- Layout_Object[Layout_Nr][4]:Set('Appearance', deb:AddrNative())
end

return main
