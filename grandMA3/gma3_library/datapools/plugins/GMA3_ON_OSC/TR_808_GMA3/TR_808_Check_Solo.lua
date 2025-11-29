--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", july 2025.

--]]
local Printf, Echo, GetExecutor, Cmd, ipairs, mfloor = Printf, Echo, GetExecutor, Cmd, ipairs, math.floor


local function main()
    local Select = UserVars()
    local TR_Solo
    if GetVar(Select, "TR_SOLO") then
        TR_Solo = GetVar(Select, "TR_SOLO")
        Printf("TR_Solo: %i", TR_Solo)
    else
        TR_Solo = "0"
        Printf("TR_Solo not set, defaulting to: %s", TR_Solo)
    end
    if GetVar(Select, "TR_PLUS") then
        TR_Solo = mfloor(tonumber(TR_Solo) + 1)
        Printf("TR_Solo incremented to: %i", TR_Solo)
    end
    if GetVar(Select, "TR_MOINS") then
        TR_Solo = mfloor(tonumber(TR_Solo) - 1)
        Printf("TR_Solo decremented to: %i", TR_Solo)
    end
    SetVar(Select, "TR_SOLO", TR_Solo)
    if TR_Solo < 1 then
        Cmd('Go+ DataPool "TR_808_GMA3" Macro "NO_SOLO"')
        Printf("TR_Solo is 0.")
    end

    DelVar(Select, "TR_PLUS")
    DelVar(Select, "TR_MOINS")
end


return main
