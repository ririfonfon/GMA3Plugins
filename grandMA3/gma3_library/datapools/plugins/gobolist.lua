

-- Set Appearance 54 Property "Image" "ShowData.MediaPools.Gobos.[Clay Paky@00591102_png]"

-- return function(display)
--     local popupitems = {}
--     for i, wheel in ipairs(ObjectList('FixtureType *.Wheels.*')) do
--       local itemname = string.format('%s %s (%i)', wheel:Parent():Parent().ShortName, wheel.Name, wheel:Count())
--       popupitems[i] = {'handle', itemname, wheel}
--     end
--     local _, wheel = PopupInput{
--       title = 'wheel to create Apperances from',
--       caller = display, items = popupitems, add_args = {FilterSupport="Yes"}
--     }
--     if not wheel then return else wheel = StrToHandle(wheel) end
--     for _, slot in ipairs(wheel:Children()) do
--       local obj = ShowData().Appearances:Aquire()
--       obj.Name = string.format('FT %s %s %s', wheel:Parent():Parent().ShortName, wheel.Name, slot.Name)
--       for _, prop in ipairs{'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance'} do obj[prop] = slot[prop] end
--     end
--     Cmd('List Appearance "FT %s %s*" ', wheel:Parent():Parent().ShortName, wheel.Name)
--   end

return function(display)
    local popupitems = {}
    for i, wheel in ipairs(ObjectList('FixtureType *.Wheels.G*')) do
      local itemname = string.format('%s %s (%i)', wheel:Parent():Parent().ShortName, wheel.Name, wheel:Count())
      popupitems[i] = {'handle', itemname, wheel}
    end
    local _, wheel = PopupInput{
      title = 'wheel to create Apperances from',
      caller = display, items = popupitems, add_args = {FilterSupport="Yes"}
    }
    if not wheel then 
        return else wheel = StrToHandle(wheel) 
    end

    for _, slot in ipairs(wheel:Children()) do
      local obj = ShowData().Appearances:Aquire()
      obj.Name = string.format('Active %s', slot.Name)
      for _, prop in ipairs{'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance'} do 
          obj[prop] = slot[prop] 
      end
    end
    for _, slot in ipairs(wheel:Children()) do
      local obj = ShowData().Appearances:Aquire()
      obj.Name = string.format('%s', slot.Name)
      for _, prop in ipairs{ 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance'} do 
         obj[prop] = slot[prop]
         if prop == 'ImageR' then
            obj[prop] = 0
         end
         if prop == 'ImageB' then
            obj[prop] = 0
         end
      end
    end
end

-- return function(display)
--     local popupitems = {}
--     for i, wheel in ipairs(ObjectList('FixtureType *')) do
--       local itemname = string.format('%s', wheel.Name)
--       popupitems[i] = {'handle', itemname, wheel}
--     end
--     local _, wheel = PopupInput{
--       title = 'Select Fixture Type',
--       caller = display, items = popupitems, add_args = {FilterSupport="Yes"}
--     }
--     if not wheel then 
--         return else wheel = StrToHandle(wheel) 
--     end  
-- end