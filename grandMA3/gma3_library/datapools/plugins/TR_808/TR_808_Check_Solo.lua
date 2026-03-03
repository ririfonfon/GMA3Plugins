--[[
    Releases:
    * 0.0.0.3

    Created by Richard Fontaine "RIRI", july 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local P_A_TR_Solo, P_B_TR_Solo, P_C_TR_Solo, P_D_TR_Solo, P_E_TR_Solo, P_F_TR_Solo, P_G_TR_Solo, P_H_TR_Solo, P_Order

    if GetVar(Select, "Order") then
        P_Order = GetVar(Select, "Order")
        Printf("Order: %s", P_Order)
    end

    if P_Order == "A" then
        if GetVar(Select, "A_TR_Solo") then
            P_A_TR_Solo = GetVar(Select, "A_TR_Solo")
            Printf("A_TR_Solo: %i", P_A_TR_Solo)
        else
            SetVar(Select, "A_TR_Solo", 0)
            P_A_TR_Solo = "0"
            Printf("A_TR_Solo not set, defaulting to: %s", P_A_TR_Solo)
        end
        if GetVar(Select, "math_a") == "plus" then
            P_A_TR_Solo = P_A_TR_Solo + 1
        elseif GetVar(Select, "math_a") == "minus" then
            P_A_TR_Solo = P_A_TR_Solo - 1
        end

        if P_A_TR_Solo < 1 then
            P_A_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "a_NO_SOLO"')
            Printf("A_TR_Solo is 0.")
        end

        SetVar(Select, "A_TR_Solo", P_A_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_a", "none")
    elseif P_Order == "B" then
        if GetVar(Select, "B_TR_Solo") then
            P_B_TR_Solo = GetVar(Select, "B_TR_Solo")
            Printf("B_TR_Solo: %i", P_B_TR_Solo)
        else
            SetVar(Select, "B_TR_Solo", 0)
            P_B_TR_Solo = "0"
            Printf("B_TR_Solo not set, defaulting to: %s", P_B_TR_Solo)
        end
        if GetVar(Select, "math_b") == "plus" then
            P_B_TR_Solo = P_B_TR_Solo + 1
        elseif GetVar(Select, "math_b") == "minus" then
            P_B_TR_Solo = P_B_TR_Solo - 1
        end

        if P_B_TR_Solo < 1 then
            P_B_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "b_NO_SOLO"')
            Printf("B_TR_Solo is 0.")
        end

        SetVar(Select, "B_TR_Solo", P_B_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_b", "none")
    elseif P_Order == "C" then
        if GetVar(Select, "C_TR_Solo") then
            P_C_TR_Solo = GetVar(Select, "C_TR_Solo")
            Printf("C_TR_Solo: %i", P_C_TR_Solo)
        else
            SetVar(Select, "C_TR_Solo", 0)
            P_C_TR_Solo = "0"
            Printf("C_TR_Solo not set, defaulting to: %s", P_C_TR_Solo)
        end
        if GetVar(Select, "math_c") == "plus" then
            P_C_TR_Solo = P_C_TR_Solo + 1
        elseif GetVar(Select, "math_c") == "minus" then
            P_C_TR_Solo = P_C_TR_Solo - 1
        end
        
        if P_C_TR_Solo < 1 then
            P_C_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "c_NO_SOLO"')
            Printf("C_TR_Solo is 0.")
        end
        
        SetVar(Select, "C_TR_Solo", P_C_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_c", "none")
    elseif P_Order == "D" then
        if GetVar(Select, "D_TR_Solo") then
            P_D_TR_Solo = GetVar(Select, "D_TR_Solo")
            Printf("D_TR_Solo: %i", P_D_TR_Solo)
        else
            SetVar(Select, "D_TR_Solo", 0)
            P_D_TR_Solo = "0"
            Printf("D_TR_Solo not set, defaulting to: %s", P_D_TR_Solo)
        end
        if GetVar(Select, "math_d") == "plus" then
            P_D_TR_Solo = P_D_TR_Solo + 1
        elseif GetVar(Select, "math_d") == "minus" then
            P_D_TR_Solo = P_D_TR_Solo - 1
        end

        if P_D_TR_Solo < 1 then
            P_D_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "d_NO_SOLO"')
            Printf("D_TR_Solo is 0.")
        end
        
        SetVar(Select, "D_TR_Solo", P_D_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_d", "none")
    elseif P_Order == "E" then
        if GetVar(Select, "E_TR_Solo") then
            P_E_TR_Solo = GetVar(Select, "E_TR_Solo")
            Printf("E_TR_Solo: %i", P_E_TR_Solo)
        else
            SetVar(Select, "E_TR_Solo", 0)
            P_E_TR_Solo = "0"
            Printf("E_TR_Solo not set, defaulting to: %s", P_E_TR_Solo)
        end
        if GetVar(Select, "math_e") == "plus" then
            P_E_TR_Solo = P_E_TR_Solo + 1
        elseif GetVar(Select, "math_e") == "minus" then
            P_E_TR_Solo = P_E_TR_Solo - 1
        end

        if P_E_TR_Solo < 1 then
            P_E_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "e_NO_SOLO"')
            Printf("E_TR_Solo is 0.")
        end
        
        SetVar(Select, "E_TR_Solo", P_E_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_e", "none")
    elseif P_Order == "F" then
        if GetVar(Select, "F_TR_Solo") then
            P_F_TR_Solo = GetVar(Select, "F_TR_Solo")
            Printf("F_TR_Solo: %i", P_F_TR_Solo)
        else
            SetVar(Select, "F_TR_Solo", 0)
            P_F_TR_Solo = "0"
            Printf("F_TR_Solo not set, defaulting to: %s", P_F_TR_Solo)
        end
        if GetVar(Select, "math_f") == "plus" then
            P_F_TR_Solo = P_F_TR_Solo + 1
        elseif GetVar(Select, "math_f") == "minus" then
            P_F_TR_Solo = P_F_TR_Solo - 1
        end

        if P_F_TR_Solo < 1 then
            P_F_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "f_NO_SOLO"')
            Printf("F_TR_Solo is 0.")
        end
        
        SetVar(Select, "F_TR_Solo", P_F_TR_Solo)
        SetVar(Select, "Order", "Z")
    elseif P_Order == "G" then
        if GetVar(Select, "G_TR_Solo") then
            P_G_TR_Solo = GetVar(Select, "G_TR_Solo")
            Printf("G_TR_Solo: %i", P_G_TR_Solo)
        else
            SetVar(Select, "G_TR_Solo", 0)
            P_G_TR_Solo = "0"
            Printf("G_TR_Solo not set, defaulting to: %s", P_G_TR_Solo)
        end
        if GetVar(Select, "math_g") == "plus" then
            P_G_TR_Solo = P_G_TR_Solo + 1
        elseif GetVar(Select, "math_g") == "minus" then
            P_G_TR_Solo = P_G_TR_Solo - 1
        end

        if P_G_TR_Solo < 1 then
            P_G_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "g_NO_SOLO"')
            Printf("G_TR_Solo is 0.")
        end
        
        SetVar(Select, "G_TR_Solo", P_G_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_g", "none")
    elseif P_Order == "H" then
        if GetVar(Select, "H_TR_Solo") then
            P_H_TR_Solo = GetVar(Select, "H_TR_Solo")
            Printf("H_TR_Solo: %i", P_H_TR_Solo)
        else
            SetVar(Select, "H_TR_Solo", 0)
            P_H_TR_Solo = "0"
            Printf("H_TR_Solo not set, defaulting to: %s", P_H_TR_Solo)
        end
        if GetVar(Select, "math_h") == "plus" then
            P_H_TR_Solo = P_H_TR_Solo + 1
        elseif GetVar(Select, "math_h") == "minus" then
            P_H_TR_Solo = P_H_TR_Solo - 1
        end

        if P_H_TR_Solo < 1 then
            P_H_TR_Solo = 0
            Cmd('Go+ DataPool "TR_808_GMA3" Macro "h_NO_SOLO"')
            Printf("H_TR_Solo is 0.")
        end
        
        SetVar(Select, "H_TR_Solo", P_H_TR_Solo)
        SetVar(Select, "Order", "Z")
        SetVar(Select, "math_h", "none")
    end
end


return main
