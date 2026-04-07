--[[
    Releases:
    * 0.0.0.91
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        Dialog_End('Error : wrong argument expected integer got ' .. idtype)
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        Dialog_End('Error : id is already used : ' .. id)
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        Dialog_End('Error : id out of range')
        error('id out of range')
    end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function Set_Def(L_N, N, Obj)
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
    local Layout_Nr  = 1
    local Sound_Type = { 'All', 'Bass', 'Mid', 'High', 'Band 1', 'Band 2', 'Band 3', 'Band 4', 'Band 5', 'Band 6',
        'Band 7' }
    local incr       = 0


    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local Nr

    local titre_x = {
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200, 750,
        -400, -400, -400, -350, 200
    }
    local titre_y = {
        100, 50, 0, 150, 150, 150,
        -100, -150, -200, -50, -50, -50,
        -300, -350, -400, -250, -250, -250,
        -500, -550, -600, -450, -450
    }
    local titre_w = {
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500, 500,
        50, 50, 50, 500, 500
    }
    local texte = {
        'P1', 'P2', 'P3', 'Sound All', 'Sound Bass', 'Sound Mid',
        'P1', 'P2', 'P3', 'Sound High', 'Sound Band 1', 'Sound Band 2',
        'P1', 'P2', 'P3', 'Sound Band 3', 'Sound Band 4', 'Sound Band 5',
        'P1', 'P2', 'P3', 'Sound Band 6', 'Sound Band 7'
    }

    local macro_x = {
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
    }
    local macro_y = {
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
    }

    local S_V_M_Color = { '8080FFFF', '80F80FFF', 'FF8080FF', '80FFFFFF', 'FFFF80FF' }
    local S_V_M_Text = { 'Group', 'Value', 'Matricks', 'None/None', 'None/None' }





    Check_Size_Pool(Layout_Nr, Layout_Object)
    Layout_Object:Create(Layout_Nr)
    Layout_Object[Layout_Nr]:Set('Name', Name_Layout)
    Layout_Object[Layout_Nr]:Set('ViewPosX', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosY', 0)
    Layout_Object[Layout_Nr]:Set('ViewPosActive', 'Yes')





    -- btn_start_stop
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Layout_Object[Layout_Nr][Nr.No]:Set('Object', SequenceObject[12])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', -400)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 150)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
    Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Set_Def(Layout_Nr, Nr, Layout_Object)

    -- titre
    for i = 1, 23 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', titre_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', titre_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', titre_w[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', texte[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('Name', texte[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 2)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
    end

    -- MacroObject
    local count = 1
    for i = 1, 165 do
        Nr = Layout_Object[Layout_Nr]:Acquire()
        Layout_Object[Layout_Nr][Nr.No]:Set('Object', MacroObject[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posx', macro_x[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('posy', macro_y[i])
        Layout_Object[Layout_Nr][Nr.No]:Set('width', 100)
        Layout_Object[Layout_Nr][Nr.No]:Set('height', 50)
        Layout_Object[Layout_Nr][Nr.No]:Set('action', 'Go+')
        Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'Macro')
        Set_Def(Layout_Nr, Nr, Layout_Object)
        Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Visible')
        Layout_Object[Layout_Nr][Nr.No]:Set('bordersize', 3)
        Layout_Object[Layout_Nr][Nr.No]:Set('bordercolor', S_V_M_Color[count])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtexttext', S_V_M_Text[count])
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextsize', 16)
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmenth', 'Center')
        Layout_Object[Layout_Nr][Nr.No]:Set('customtextalignmentv', 'Center')
        count = count + 1
        if count > 5 then
            count = 1
        end
    end
end

local function main()
    local Construct_Pool = 5
    local Name_Layout = "Sound Test"
    Build_Layout(Construct_Pool, Name_Layout)
end
return main
