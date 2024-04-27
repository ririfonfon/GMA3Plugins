--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", April 2024.
--]]

return function(display)
  local popupit = {}
  for i, ft in ipairs(ObjectList('FixtureType *')) do
    local itemnam = string.format(' %s (%i)', ft.Name, ft:Count())
    popupit[i] = { 'handle', itemnam, ft }
  end
  local _, Ft = PopupInput {
    title = 'wheel to create Apperances from',
    caller = display, items = popupit, add_args = { FilterSupport = "Yes" }
  }
  if not Ft then
    return
  else
    Ft = StrToHandle(Ft)
  end

  local popupitems = {}
  for i, wheel in ipairs(ObjectList('FixtureType ' .. Ft.No ..'.Wheels.G*')) do
    local itemname = string.format('%s %s (%i)', wheel:Parent():Parent().ShortName, wheel.Name, wheel:Count())
    popupitems[i] = { 'handle', itemname, wheel }
  end
  local _, wheel = PopupInput {
    title = 'wheel to create Apperances from',
    caller = display, items = popupitems, add_args = { FilterSupport = "Yes" }
  }
  if not wheel then
    return
  else
    wheel = StrToHandle(wheel)
  end

  Echo('***************')
  Echo(wheel.Name)
  Echo(wheel:Count())
  Echo(wheel:Parent():Parent().ShortName)
  Echo(wheel:Parent():Parent().Name)
  Echo(wheel:Parent():Parent().No)
  Echo(wheel.Attribute)

  local Fixt_Type = tonumber(wheel:Parent():Parent().No)
  local Fixt_Name = wheel:Parent():Parent().Name

  Cmd('FixtureType ' .. Fixt_Type .. ' At ' .. wheel:Parent().No)

  for _, slot in ipairs(wheel:Children()) do
    Echo(slot.Name)
    Echo(slot.Attribute)
    local obj = ShowData().Appearances:Aquire()
    obj.Name = string.format('Active %s', slot.Name)
    for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
      obj[prop] = slot[prop]
    end
  end
  for _, slot in ipairs(wheel:Children()) do
    local obj = ShowData().Appearances:Aquire()
    obj.Name = string.format('%s', slot.Name)
    for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
      obj[prop] = slot[prop]
      if prop == 'ImageR' then
        obj[prop] = 0
      end
      if prop == 'ImageB' then
        obj[prop] = 0
      end
    end
  end

  -- for _, slot in ipairs(wheel:Children()) do
  --   local obj = ShowData().Appearances:Aquire()
  --   obj.Name = string.format('%s %s',Fixt_Name, slot.Name)
  --   for _, prop in ipairs{'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance'} do
  --       obj[prop] = slot[prop]
  --   end
  -- end
end

-- end gobolist.lua alors ca marche
