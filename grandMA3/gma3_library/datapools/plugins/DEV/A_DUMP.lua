return function()
    -- local Dump_Object = Root().ShowData.ShowSettings.MidiSettings:Children()
    -- local Dump_Object = Root().ShowData.ShowSettings.MidiSettings:Children()
    -- local Dump_Object = Root().StationSettings:Children()
    -- local Dump_Object = ShowData().OSCBase:Children()
    local Dump_Object = DataPool().Groups[1]:Children()


    for i, content in pairs(Dump_Object) do
        Echo(i)
        if content then
            Echo('No ' .. content.No)
        end
    end
    -- Dump_Object:Dump()
end
