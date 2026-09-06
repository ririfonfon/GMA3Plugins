return function()
    for key, value in ipairs(GetObjApiDescriptor()) do
        if value[1] ~= nil then
            Printf("Api " .. key .. " is " .. value[1])
        end
        if value[2] ~= nil then
            Printf("Arguments: " .. value[2])
        end
        if value[3] ~= nil then
            Printf("Returns: " .. value[3])
        end
        Printf(" ")
    end
end
