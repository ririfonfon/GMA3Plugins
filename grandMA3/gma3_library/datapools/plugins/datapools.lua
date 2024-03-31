return function()
  for _, DataPool in ipairs(ShowData().DataPools:Children()) do
    Echo(DataPool.Name)
    for _, Group in ipairs(DataPool.Groups:Children()) do
      Echo('    ' .. Group.Name)
    end
  end
end










for i, Data in ipairs(ShowData().:Children()) do
  if popuplists[z].[i] == Data.NO then
    table.remove(popuplists[z]., i)
  end
end

for i, Data in ipairs(DataPool.:Children()) do
  if popuplists[z].[i] == Data.NO then
    table.remove(popuplists[z]., i)
  end
end
