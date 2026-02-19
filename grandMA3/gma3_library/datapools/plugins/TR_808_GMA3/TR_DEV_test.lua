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
    local Nr, deb
    local App_Panel_Name = { '[[panelBaseGma3_png]]', '[[01_panel_scale_2_png]]', '[[01_panel_scale_3_png]]',
        '[[01_panel_scale_4_png]]',
    }
    local Addr_Nat_Panel = { 0, 0, 0, 0 }
    local App_Panel_Height = { 1205, 800, 800, 800 }
    local App_Panel_Width = { 2000, 2000, 2000, 2000 }

    for k in pairs(App_Panel_Name) do
        for i in pairs(AppearanceObject) do
            if AppearanceObject[i].Name ~= nil then
                if AppearanceObject[i].Name == App_Panel_Name[k] then
                    Printf('AppearanceObject ' .. i .. ' = ' .. AppearanceObject[i].Name)
                    Addr_Nat_Panel[k] = AppearanceObject[i]:AddrNative()
                    Printf('Addr_Nat_Panel ' .. k .. ' = ' .. Addr_Nat_Panel[k])
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
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Printf('Nr = ' .. Nr.No)
    Layout_Object[Layout_Nr][Nr.No]:Set('Name', App_Panel_Name[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 0)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', 0)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', App_Panel_Width[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('height', App_Panel_Height[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitybar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitycid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityvalue', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityicon', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityidicatorbar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityselectionrelevance', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('fullresolution', 'Yes')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Printf('Nr = ' .. Nr.No)
    Layout_Object[Layout_Nr][Nr.No]:Set('Name', App_Panel_Name[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 0)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -434)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', App_Panel_Width[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('height', App_Panel_Height[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitybar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitycid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityvalue', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityicon', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityidicatorbar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityselectionrelevance', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('fullresolution', 'Yes')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Printf('Nr = ' .. Nr.No)
    Layout_Object[Layout_Nr][Nr.No]:Set('Name', App_Panel_Name[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 0)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -434)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', App_Panel_Width[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('height', App_Panel_Height[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', 'Visible')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitybar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitycid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityvalue', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityicon', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityidicatorbar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityselectionrelevance', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('fullresolution', 'Yes')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')
    Nr = Layout_Object[Layout_Nr]:Acquire()
    Printf('Nr = ' .. Nr.No)
   Layout_Object[Layout_Nr][Nr.No]:Set('Name', App_Panel_Name[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('Appearance', Addr_Nat_Panel[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('posx', 0)
    Layout_Object[Layout_Nr][Nr.No]:Set('posy', -434)
    Layout_Object[Layout_Nr][Nr.No]:Set('width', App_Panel_Width[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('height', App_Panel_Height[Nr.No])
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityelement', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitybar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityobjectname', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilitycid', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityvalue', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityicon', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityidicatorbar', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityselectionrelevance', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('visibilityborder', 'Hidden')
    Layout_Object[Layout_Nr][Nr.No]:Set('fullresolution', 'Yes')
    Layout_Object[Layout_Nr][Nr.No]:Set('Note', 'FOND')






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
