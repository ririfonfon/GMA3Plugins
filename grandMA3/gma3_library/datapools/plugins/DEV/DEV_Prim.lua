local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used') end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end
local function main()
    local pool_construct = 42

    -- local MatrickNrStart = 1001
    -- local MatrickObject = Root().ShowData.DataPools[pool_construct].Matricks
    -- Printf(MatrickObject:Count())
    -- Check_Size_Pool(MatrickNrStart, MatrickObject)
    -- MatrickObject:Acquire()
    -- Printf(MatrickObject:MaxCount())
    -- MatrickObject:Create(MatrickNrStart)
    -- MatrickObject[MatrickNrStart]:Set('Name', 'test')


    local AppObject = Root().ShowData.Appearances
    -- AppObject:Create(1002)
    -- AppObject[1002]:Set('Name','LC2_tricks_on')
    -- AppObject[1003]:Set('Appearance','Showdata.MediaPools.Symbols.[arrow_right_black_png]')

    local SelectedGrp = { 'PIXEL RGB', 'SPOT CONTRE', 'MEGA POINTE SOL', 'RIVALE UP', 'BMFL', 'FLOOR PLATE STRIKE' }
    local LayoutObject = Root().ShowData.DataPools[pool_construct].Layouts
    local GroupObject = Root().ShowData.DataPools[2].Groups
    -- Check_Size_Pool(2, LayoutObject)
    if LayoutObject[2]:Count() < 2 then
        LayoutObject[2]:Acquire()
    end
    -- work
    LayoutObject[2][2]:Set('Note', 'GroupObject[2]')
    LayoutObject[2][2]:Set('AppearanceRotation', '90°')
    LayoutObject[2][2]:Set('Mirror', 'Vertical')
    LayoutObject[2][2]:Set('Object', GroupObject[2])
    LayoutObject[2][2]:Set('Action', 'Layout') -- 0=None ,'<Layout>','Black' or 2,'Flash' or 1, 3 Object default
    LayoutObject[2][2]:Set('Selected', 'No')
    LayoutObject[2][2]:Set('PosX', 120)
    LayoutObject[2][2]:Set('PosY', 120)
    LayoutObject[2][2]:Set('Width', 100)
    LayoutObject[2][2]:Set('Height', 100)
    LayoutObject[2][2]:Set('VisibilityElement', 'Visible')
    LayoutObject[2][2]:Set('VisibilityBar', 'Visible')
    LayoutObject[2][2]:Set('VisibilityObjectName', 'Visible')
    LayoutObject[2][2]:Set('VisibilityID', 'Hidden')
    LayoutObject[2][2]:Set('VisibilityCID', 'Hidden')
    LayoutObject[2][2]:Set('VisibilityValue', 'Hidden')
    LayoutObject[2][2]:Set('VisibilityIcon', 'Hidden')
    LayoutObject[2][2]:Set('VisibilityIndicatorBar', 'Hidden')
    LayoutObject[2][2]:Set('VisibilitySelectionRelevance', 'Yes')
    LayoutObject[2][2]:Set('VisibilityBorder', 'Visible')
    LayoutObject[2][2]:Set('BorderSize', 2)
    LayoutObject[2][2]:Set('BorderColor', '808080FF')
    LayoutObject[2][2]:Set('Appearance', 'None')
    LayoutObject[2][2]:Set('Appearance', 'Default')
    -- not work
    LayoutObject[2][2]:Set('Tags', 'Solo')
    LayoutObject[2][2]:Set('Name', 'GroupObject[2]')
    -- LayoutObject[2][2]:Set('Appearance', AppObject[986])
    -- LayoutObject[2][2]:Set('Appearance', 23)


end
return main
