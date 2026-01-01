--[[
    Releases:
    * 0.0.0.2

    Created by Richard Fontaine "RIRI", july 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local A_TR_Solo, B_TR_Solo, C_TR_Solo, D_TR_Solo, E_TR_Solo, F_TR_Solo, G_TR_Solo, H_TR_Solo

    if GetVar(Select, "A_TR_Solo") then
        A_TR_Solo = GetVar(Select, "A_TR_Solo")
        Printf("A_TR_Solo: %i", A_TR_Solo)
    else
        SetVar(Select, "A_TR_Solo", 0)
        A_TR_Solo = "0"
        Printf("A_TR_Solo not set, defaulting to: %s", A_TR_Solo)
    end
    if GetVar(Select, "A_TR_Plus") then
        A_TR_Solo = mfloor(tonumber(A_TR_Solo) + 1)
        Printf("A_TR_Solo incremented to: %i", A_TR_Solo)
    end
    if GetVar(Select, "A_TR_Moins") then
        A_TR_Solo = mfloor(tonumber(A_TR_Solo) - 1)
        Printf("A_TR_Solo decremented to: %i", A_TR_Solo)
    end
    SetVar(Select, "A_TR_Solo", A_TR_Solo)
    if A_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "a_NO_SOLO"')
        SetVar(Select, "A_TR_Solo", 0)
        Printf("A_TR_Solo is 0.")
    end


    if GetVar(Select, "B_TR_Solo") then
        B_TR_Solo = GetVar(Select, "B_TR_Solo")
        Printf("B_TR_Solo: %i", B_TR_Solo)
    else
        SetVar(Select, "B_TR_Solo", 0)
        B_TR_Solo = "0"
        Printf("B_TR_Solo not set, defaulting to: %s", B_TR_Solo)
    end
    if GetVar(Select, "B_TR_Plus") then
        B_TR_Solo = mfloor(tonumber(B_TR_Solo) + 1)
        Printf("B_TR_Solo incremented to: %i", B_TR_Solo)
    end
    if GetVar(Select, "B_TR_Moins") then
        B_TR_Solo = mfloor(tonumber(B_TR_Solo) - 1)
        Printf("B_TR_Solo decremented to: %i", B_TR_Solo)
    end
    SetVar(Select, "B_TR_Solo", B_TR_Solo)
    if B_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "b_NO_SOLO"')
        SetVar(Select, "B_TR_Solo", 0)
        Printf("B_TR_Solo is 0.")
    end


    if GetVar(Select, "C_TR_Solo") then
        C_TR_Solo = GetVar(Select, "C_TR_Solo")
        Printf("C_TR_Solo: %i", C_TR_Solo)
    else
        SetVar(Select, "C_TR_Solo", 0)
        C_TR_Solo = "0"
        Printf("C_TR_Solo not set, defaulting to: %s", C_TR_Solo)
    end
    if GetVar(Select, "C_TR_Plus") then
        C_TR_Solo = mfloor(tonumber(C_TR_Solo) + 1)
        Printf("C_TR_Solo incremented to: %i", C_TR_Solo)
    end
    if GetVar(Select, "C_TR_Moins") then
        C_TR_Solo = mfloor(tonumber(C_TR_Solo) - 1)
        Printf("C_TR_Solo decremented to: %i", C_TR_Solo)
    end
    SetVar(Select, "C_TR_Solo", C_TR_Solo)
    if C_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "c_NO_SOLO"')
        SetVar(Select, "C_TR_Solo", 0)
        Printf("C_TR_Solo is 0.")
    end


    if GetVar(Select, "D_TR_Solo") then
        D_TR_Solo = GetVar(Select, "D_TR_Solo")
        Printf("D_TR_Solo: %i", D_TR_Solo)
    else
        SetVar(Select, "D_TR_Solo", 0)
        D_TR_Solo = "0"
        Printf("D_TR_Solo not set, defaulting to: %s", D_TR_Solo)
    end
    if GetVar(Select, "D_TR_Plus") then
        D_TR_Solo = mfloor(tonumber(D_TR_Solo) + 1)
        Printf("D_TR_Solo incremented to: %i", D_TR_Solo)
    end
    if GetVar(Select, "D_TR_Moins") then
        D_TR_Solo = mfloor(tonumber(D_TR_Solo) - 1)
        Printf("D_TR_Solo decremented to: %i", D_TR_Solo)
    end
    SetVar(Select, "D_TR_Solo", D_TR_Solo)
    if D_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "d_NO_SOLO"')
        SetVar(Select, "D_TR_Solo", 0)
        Printf("D_TR_Solo is 0.")
    end


    if GetVar(Select, "E_TR_Solo") then
        E_TR_Solo = GetVar(Select, "E_TR_Solo")
        Printf("E_TR_Solo: %i", E_TR_Solo)
    else
        SetVar(Select, "E_TR_Solo", 0)
        E_TR_Solo = "0"
        Printf("E_TR_Solo not set, defaulting to: %s", E_TR_Solo)
    end
    if GetVar(Select, "E_TR_Plus") then
        E_TR_Solo = mfloor(tonumber(E_TR_Solo) + 1)
        Printf("E_TR_Solo incremented to: %i", E_TR_Solo)
    end
    if GetVar(Select, "E_TR_Moins") then
        E_TR_Solo = mfloor(tonumber(E_TR_Solo) - 1)
        Printf("E_TR_Solo decremented to: %i", E_TR_Solo)
    end
    SetVar(Select, "E_TR_Solo", E_TR_Solo)
    if E_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "e_NO_SOLO"')
        SetVar(Select, "E_TR_Solo", 0)
        Printf("E_TR_Solo is 0.")
    end


    if GetVar(Select, "F_TR_Solo") then
        F_TR_Solo = GetVar(Select, "F_TR_Solo")
        Printf("F_TR_Solo: %i", F_TR_Solo)
    else
        SetVar(Select, "F_TR_Solo", 0)
        F_TR_Solo = "0"
        Printf("F_TR_Solo not set, defaulting to: %s", F_TR_Solo)
    end
    if GetVar(Select, "F_TR_Plus") then
        F_TR_Solo = mfloor(tonumber(F_TR_Solo) + 1)
        Printf("F_TR_Solo incremented to: %i", F_TR_Solo)
    end
    if GetVar(Select, "F_TR_Moins") then
        F_TR_Solo = mfloor(tonumber(F_TR_Solo) - 1)
        Printf("F_TR_Solo decremented to: %i", F_TR_Solo)
    end
    SetVar(Select, "F_TR_Solo", F_TR_Solo)
    if F_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "f_NO_SOLO"')
        SetVar(Select, "F_TR_Solo", 0)
        Printf("F_TR_Solo is 0.")
    end


    if GetVar(Select, "G_TR_Solo") then
        G_TR_Solo = GetVar(Select, "G_TR_Solo")
        Printf("G_TR_Solo: %i", G_TR_Solo)
    else
        SetVar(Select, "G_TR_Solo", 0)
        G_TR_Solo = "0"
        Printf("G_TR_Solo not set, defaulting to: %s", G_TR_Solo)
    end
    if GetVar(Select, "G_TR_Plus") then
        G_TR_Solo = mfloor(tonumber(G_TR_Solo) + 1)
        Printf("G_TR_Solo incremented to: %i", G_TR_Solo)
    end
    if GetVar(Select, "G_TR_Moins") then
        G_TR_Solo = mfloor(tonumber(G_TR_Solo) - 1)
        Printf("G_TR_Solo decremented to: %i", G_TR_Solo)
    end
    SetVar(Select, "G_TR_Solo", G_TR_Solo)
    if G_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "g_NO_SOLO"')
        SetVar(Select, "G_TR_Solo", 0)
        Printf("G_TR_Solo is 0.")
    end


    if GetVar(Select, "H_TR_Solo") then
        H_TR_Solo = GetVar(Select, "H_TR_Solo")
        Printf("H_TR_Solo: %i", H_TR_Solo)
    else
        SetVar(Select, "H_TR_Solo", 0)
        H_TR_Solo = "0"
        Printf("H_TR_Solo not set, defaulting to: %s", H_TR_Solo)
    end
    if GetVar(Select, "H_TR_Plus") then
        H_TR_Solo = mfloor(tonumber(H_TR_Solo) + 1)
        Printf("H_TR_Solo incremented to: %i", H_TR_Solo)
    end
    if GetVar(Select, "H_TR_Moins") then
        H_TR_Solo = mfloor(tonumber(H_TR_Solo) - 1)
        Printf("H_TR_Solo decremented to: %i", H_TR_Solo)
    end
    SetVar(Select, "H_TR_Solo", H_TR_Solo)
    if H_TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "h_NO_SOLO"')
        SetVar(Select, "H_TR_Solo", 0)
        Printf("H_TR_Solo is 0.")
    end

    DelVar(Select, "A_TR_Plus")
    DelVar(Select, "A_TR_Moins")
    DelVar(Select, "B_TR_Plus")
    DelVar(Select, "B_TR_Moins")
    DelVar(Select, "C_TR_Plus")
    DelVar(Select, "C_TR_Moins")
    DelVar(Select, "D_TR_Plus")
    DelVar(Select, "D_TR_Moins")
    DelVar(Select, "E_TR_Plus")
    DelVar(Select, "E_TR_Moins")
    DelVar(Select, "F_TR_Plus")
    DelVar(Select, "F_TR_Moins")
    DelVar(Select, "G_TR_Plus")
    DelVar(Select, "G_TR_Moins")
    DelVar(Select, "H_TR_Plus")
    DelVar(Select, "H_TR_Moins")
end


return main
