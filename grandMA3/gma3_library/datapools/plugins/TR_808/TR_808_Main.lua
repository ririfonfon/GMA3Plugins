--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local function main()
    local Select = UserVars()
    local Call = false
    if GetVar(Select, "TR_Layout") then
        Retour_Recepie()
        Call = true
    end
    if GetVar(Select, "Order") then
        Check_Solo()
        Call = true
    end
    if GetVar(Select, "TR_Tag") then
        Edit_Tag()
        Call = true
    end

    if Call == false then
        Printf('call false')
    elseif Call == true then
        Printf('call true')
    end
end
return main
