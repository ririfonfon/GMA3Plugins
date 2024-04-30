--[[
Releases:
* 0.0.0.1

Created by Richard Fontaine "RIRI", April 2024.
--]]
local function arrayLength(arr)
    local length = 0
    for _ in pairs(arr) do
        length = length + 1
    end
    return length
end

return function(display)
  local select_wheel = {}
  local select_wheel_index = 0
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
  for i, wheel in ipairs(ObjectList('FixtureType ' .. Ft.No .. '.Wheels.*')) do
    local itemname = string.format('%s %s (%i)', wheel:Parent():Parent().ShortName, wheel.Name, wheel:Count())
    popupitems[i] = { 'handle', name = wheel.Name, state = false }
  end
  -- local _, wheel = PopupInput {
  --   title = 'wheel to create Apperances from',
  --   caller = display, items = popupitems, add_args = { FilterSupport = "Yes" }
  -- }
  local wheel = MessageBox(
    {
      title = "Wheel Select",
      message = "Select your Wheel",
      message_align_h = Enums.AlignmentH.Left,
      message_align_v = Enums.AlignmentV.Top,
      commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
      states = popupitems,
      icon = "logo_small",
      titleTextColor = "Global.AlertText",
      messageTextColor = "Global.Text"
    }
  )
  Printf("Success = " .. tostring(wheel.success))
  Printf("Result = " .. wheel.result)
  for k, v in pairs(wheel.states) do
    if (v == true) then
      select_wheel_index = select_wheel_index + 1
      select_wheel[select_wheel_index] = k
      Printf("Select '%s'", k)
    end
  end

  local popu = {}
  for i = 1, arrayLength(select_wheel), 1 do
    for u, wheels in ipairs(ObjectList('FixtureType ' .. Ft.No .. '.Wheels.'.. select_wheel[i])) do
    popu[u] = { 'handle', name = wheels.Name, state = false}
    end
    local Sub_wheels = MessageBox(
      {
        title = "SLot Select",
        message = "Select your Slot",
        message_align_h = Enums.AlignmentH.Left,
        message_align_v = Enums.AlignmentV.Top,
        commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
        states = popu,
        icon = "logo_small",
        titleTextColor = "Global.AlertText",
        messageTextColor = "Global.Text"
      }
    )
  end

  -- if not wheel then
  --   return
  -- else
  --   wheel = StrToHandle(wheel)
  -- end

  -- Echo('***************')
  -- Echo(wheel.Name)
  -- Echo(wheel:Count())
  -- Echo(wheel:Parent():Parent().ShortName)
  -- Echo(wheel:Parent():Parent().Name)
  -- Echo(wheel:Parent():Parent().No)
  -- -- Echo(wheel.Attribute().No)

  -- local Fixt_Type = tonumber(wheel:Parent():Parent().No)
  -- local Fixt_Name = wheel:Parent():Parent().Name

  -- Cmd('FixtureType ' .. Fixt_Type .. ' At ' .. wheel:Parent().No)

  -- for _, slot in ipairs(wheel:Children()) do
  --   Echo(slot.Name)
  --   -- Echo(slot.Attribute())
  --   local obj = ShowData().Appearances:Aquire()
  --   obj.Name = string.format('Active %s', slot.Name)
  --   for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
  --     obj[prop] = slot[prop]
  --   end
  -- end
  -- for _, slot in ipairs(wheel:Children()) do
  --   local obj = ShowData().Appearances:Aquire()
  --   obj.Name = string.format('%s', slot.Name)
  --   for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
  --     obj[prop] = slot[prop]
  --     if prop == 'ImageR' then
  --       obj[prop] = 0
  --     end
  --     if prop == 'ImageB' then
  --       obj[prop] = 0
  --     end
  --   end
  -- end

  -- for _, slot in ipairs(wheel:Children()) do
  --   local obj = ShowData().Appearances:Aquire()
  --   obj.Name = string.format('%s %s',Fixt_Name, slot.Name)
  --   for _, prop in ipairs{'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance'} do
  --       obj[prop] = slot[prop]
  --   end
  -- end
end

-- end gobolist.lua alors ca marche
