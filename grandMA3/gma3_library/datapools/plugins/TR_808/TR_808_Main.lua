--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

local function main(displayHandle)
    local Select = UserVars()
    local Call = false
    if GetVar(Select, "TR_Layout") then
        Retour_Recepie()
        Call = true
    end
    if GetVar(Select, "Order") then
        if GetVar(Select, "Order") ~= "Z" then
            Check_Solo()
            Call = true
        end
    end
    if GetVar(Select, "TR_Tag") then
        Edit_Tag()
        Call = true
    end
    if Call == true then
        return
    end

    Cmd('Set UserProfile *.15 Property "keyboardshortcutsactive" false')
    

end
return main
