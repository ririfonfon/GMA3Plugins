local signalTable = select(3, ...)

function signalTable.touchUpdate(...)
    local y = select(5, ...)
    Echo("Y pos: " .. tostring(y))
end

local function main()
     local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    while true do
        dialog.TouchUpdate = ":touchUpdate"
    end
end
return main
