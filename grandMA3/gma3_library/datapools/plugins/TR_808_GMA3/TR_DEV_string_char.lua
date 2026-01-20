local function main()
    for i = 0, 254, 1 do
        local char_i = string.char(i)
        Printf("Value: %i Char: %s", i, char_i)
    end
end

return main