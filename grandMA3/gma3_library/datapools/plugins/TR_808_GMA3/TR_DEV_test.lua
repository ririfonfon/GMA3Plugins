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
local function main()
    local Construct_Pool = 43
    local Layout_Nr = 1
    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    -- local Layout_Object_C = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local Nr

    -- Check_Size_Pool(Layout_Nr, Layout_Object)

    -- Layout_Object:Create(Layout_Nr)
    -- Layout_Object[Layout_Nr]:Set('Name', 'TR-808_Build')
    -- Nr = Layout_Object[Layout_Nr]:Acquire()
    -- Printf('Nr = ' .. Nr.No)
    -- -- Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', AppearanceObject[266])
    -- Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', '[[panelBaseGma3_png]]')
    -- Nr = Layout_Object[Layout_Nr]:Acquire()
    -- Printf('Nr = ' .. Nr.No)
    -- Layout_Object[Layout_Nr][Nr.No]:Set('posx', 10)
    -- Layout_Object[Layout_Nr][Nr.No]:Set('posy', 10)
    -- Nr = Layout_Object[Layout_Nr]:Acquire()
    -- Printf('Nr = ' .. Nr.No)
    -- Layout_Object[Layout_Nr][Nr.No]:Set('width', 2000)
    -- Layout_Object[Layout_Nr][Nr.No]:Set('height', 800)
    -- Nr = Layout_Object[Layout_Nr]:Acquire()
    -- Printf('Nr = ' .. Nr.No)
    -- Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', 'Hidden')
    -- for i in pairs (AppearanceObject) do
    --     Printf('AppearanceObject ' .. i .. ' = ' .. AppearanceObject[i].Name)
    -- end
    local deb = AppearanceObject[145]
    Printf('deb = ' .. deb)
    Printf('deb nr = ' .. deb.No)
    Printf('deb name = ' .. deb.Name)
    

    Nr = Layout_Object[Layout_Nr][1]:Get('Appearance')
    if Nr ~= nil then
        Printf('Nr = ' .. Nr)
    else
        Printf('Nr is nil')
    end
    Layout_Object[Layout_Nr][2]:Set('Appearance', Nr)
    Layout_Object[Layout_Nr][3]:Set('Appearance', deb:AddrNative())
end

return main
