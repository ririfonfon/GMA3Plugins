--[[
    Releases:
    * 0.0.0.2

    Created by Richard Fontaine "RIRI", july 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local P_A_TR_Solo, P_B_TR_Solo, P_C_TR_Solo, P_D_TR_Solo, P_E_TR_Solo, P_F_TR_Solo, P_G_TR_Solo, P_H_TR_Solo

    if GetVar(Select, "A_TR_Solo") then
        P_A_TR_Solo = GetVar(Select, "A_TR_Solo")
        Printf("A_TR_Solo: %i", P_A_TR_Solo)
    end

    if GetVar(Select, "B_TR_Solo") then
        P_B_TR_Solo = GetVar(Select, "B_TR_Solo")
        Printf("B_TR_Solo: %i", P_B_TR_Solo)
    end

    if GetVar(Select, "C_TR_Solo") then
        P_C_TR_Solo = GetVar(Select, "C_TR_Solo")
        Printf("C_TR_Solo: %i", P_C_TR_Solo)
    end

    if GetVar(Select, "D_TR_Solo") then
        P_D_TR_Solo = GetVar(Select, "D_TR_Solo")
        Printf("D_TR_Solo: %i", P_D_TR_Solo)
    end

    if GetVar(Select, "E_TR_Solo") then
        P_E_TR_Solo = GetVar(Select, "E_TR_Solo")
        Printf("E_TR_Solo: %i", P_E_TR_Solo)
    end

    if GetVar(Select, "F_TR_Solo") then
        P_F_TR_Solo = GetVar(Select, "F_TR_Solo")
        Printf("F_TR_Solo: %i", P_F_TR_Solo)
    end

    if GetVar(Select, "G_TR_Solo") then
        P_G_TR_Solo = GetVar(Select, "G_TR_Solo")
        Printf("G_TR_Solo: %i", P_G_TR_Solo)
    end

    if GetVar(Select, "H_TR_Solo") then
        P_H_TR_Solo = GetVar(Select, "H_TR_Solo")
        Printf("H_TR_Solo: %i", P_H_TR_Solo)
    end
end


return main
