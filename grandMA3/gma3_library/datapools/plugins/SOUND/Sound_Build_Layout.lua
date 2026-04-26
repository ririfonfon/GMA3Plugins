--[[
    Releases:
    * 0.0.0.91
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function SOUND_Set_Def(L_N, N, Obj)
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

function SOUND_Build_Layout(Construct_Pool, Name_Layout, Layout_Nr, MacroNrStart, Seq_On_Off, prefix)
    -- local Layout_Nr      = 1
    local Sound_Type     = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }
    local Layout_Object  = Root().ShowData.DataPools[Construct_Pool].Layouts
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local MacroObject    = Root().ShowData.DataPools[Construct_Pool].Macros
    local Nr

    local titre_x        = {
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200
    }
    local titre_y        = {
        100, 50, 0, 150, 150, 150,
        -100, -150, -200, -50, -50, -50,
        -300, -350, -400, -250, -250, -250,
        -500, -550, -600, -450, -450
    }
    local titre_w        = {
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500
    }
    local texte          = {
        'P1', 'P2', 'P3', 'Sound All', 'Sound Bass', 'Sound Mid',
        'P1', 'P2', 'P3', 'Sound High', 'Sound Band 1', 'Sound Band 2',
        'P1', 'P2', 'P3', 'Sound Band 3', 'Sound Band 4', 'Sound Band 5',
        'P1', 'P2', 'P3', 'Sound Band 6', 'Sound Band 7'
    }

    local macro_x        = {
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        750, 850, 950, 1050, 1150,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        -350, -250, -150, -50, 50,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        200, 300, 400, 500, 600,
        0, 550, 1100,
        0, 550, 1100,
        0, 550, 1100,
        0, 550,
        150, 700,
    }
    local macro_y        = {
        100, 100, 100, 100, 100,
        50, 50, 50, 50, 50,
        0, 0, 0, 0, 0,
        100, 100, 100, 100, 100,
        50, 50, 50, 50, 50,
        0, 0, 0, 0, 0,
        100, 100, 100, 100, 100,
        50, 50, 50, 50, 50,
        0, 0, 0, 0, 0,
        -100, -100, -100, -100, -100,
        -150, -150, -150, -150, -150,
        -200, -200, -200, -200, -200,
        -100, -100, -100, -100, -100,
        -150, -150, -150, -150, -150,
        -200, -200, -200, -200, -200,
        -100, -100, -100, -100, -100,
        -150, -150, -150, -150, -150,
        -200, -200, -200, -200, -200,
        -300, -300, -300, -300, -300,
        -350, -350, -350, -350, -350,
        -400, -400, -400, -400, -400,
        -300, -300, -300, -300, -300,
        -350, -350, -350, -350, -350,
        -400, -400, -400, -400, -400,
        -300, -300, -300, -300, -300,
        -350, -350, -350, -350, -350,
        -400, -400, -400, -400, -400,
        -500, -500, -500, -500, -500,
        -550, -550, -550, -550, -550,
        -600, -600, -600, -600, -600,
        -500, -500, -500, -500, -500,
        -550, -550, -550, -550, -550,
        -600, -600, -600, -600, -600,
        152, 152, 152,
        -48, -48, -48,
        -248, -248, -248,
        -448, -448,
        150, 150,
    }
    local mem_x          = {
        750, 750, 750, 925, 925, 925, 1100, 1100, 1100,
        850, 850, 850, 1025, 1025, 1025, 1200, 1200, 1200,
        800, 800, 800, 975, 975, 975, 1150, 1150, 1150,

    }
    local mem_y          = {
        -500, -550, -600, -500, -550, -600, -500, -550, -600,
        -500, -550, -600, -500, -550, -600, -500, -550, -600,
        -500, -550, -600, -500, -550, -600, -500, -550, -600,
    }

    local mem_Color      = { '80FF80FF', 'FF8080FF', '808080FF' }
    local mem_Text       = { 'Load ', 'Save ', '' }
    local S_V_M_Color    = { '8080FFFF', 'FF0080FF', 'FFFF80FF', '00FF00FF', 'FF8000FF' }
    local S_V_M_Text     = { 'Group', 'Value', 'Matricks', 'None/None', 'None/None' }

    if prefix == 'B' then
        Layout_Nr = Layout_Nr + 1
    end

    SOUND_Check_Size_Pool(Layout_Nr, Layout_Object)
    Layout_Object:Create(Layout_Nr)
    Layout_Object[Layout_Nr]:Set('Name', prefix .. Name_Layout)
    Layout_Object[Layout_Nr]:Set('ViewPosX', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosY', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosActive', 'Yes')


    -- on_off
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[Seq_On_Off])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', -400)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 150)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'On&Off')
    SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)

    -- titre
    for i = 1, 23 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', titre_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', titre_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', titre_w[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Titre')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', texte[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('Name', texte[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 2)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
    end

    -- MacroObject
    local count = 1
    for i = MacroNrStart, MacroNrStart + 164 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', macro_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', macro_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 100)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Macro')
        SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[count])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[count])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
        count = count + 1
        if count > 5 then
            count = 1
        end
    end
    -- Master
    for i = MacroNrStart + 165, MacroNrStart + 175 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', macro_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', macro_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 100)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 46)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Master')
        SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', 'FFFFFFFF')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', '100%')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
    end

    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Addr_Nat_Panel
    for i in pairs(AppearanceObject) do
        if AppearanceObject[i].Name ~= nil then
            if AppearanceObject[i].Name == 'p_htp_png' then
                Addr_Nat_Panel = AppearanceObject[i]:AddrNative()
            end
        end
    end
    -- Prority
    local i = MacroNrStart + 176
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', macro_x[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', macro_y[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Prority')
    SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
    Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', '808080FF')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel)
    i = i + 1
    -- Reset
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', macro_x[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', macro_y[i])
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Reset')
    SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
    Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', '808080FF')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', 'Reset')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
    -- load mem
    local inc, inc_n = 1, 1
    for o = MacroNrStart + 178, MacroNrStart + 186 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[o])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', mem_x[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', mem_y[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Mem')
        SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', mem_Color[1])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', mem_Color[1])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', mem_Text[1] .. inc_n)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
        inc = inc + 1
        inc_n = inc_n + 1
    end
    -- save mem
    inc_n = 1
    for o = MacroNrStart + 187, MacroNrStart + 195 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[o])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', mem_x[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', mem_y[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Mem')
        SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', mem_Color[2])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextcolor', mem_Color[2])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', mem_Text[2] .. inc_n)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
        inc = inc + 1
        inc_n = inc_n + 1
    end
    -- label mem
    for o = MacroNrStart + 196, MacroNrStart + 204 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[o])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', mem_x[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', mem_y[inc])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Mem')
        SOUND_Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', 'None')
        inc = inc + 1
    end
    Sound_Dialog_End('ALL Good Sound By Riri Finish')
end
