--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", june 2025.

--]]

local function main()
    local Select = UserVars()
    local TR_Sub, TR_Layout, TR_Pool, TR_Fonction
    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber(GetVar(Select, "TR_Fonction"))
        Printf("TR_Fonction: %i", TR_Fonction)
    end
    if GetVar(Select, "TR_Sub") then
        TR_Sub = GetVar(Select, "TR_Sub")
        Printf("TR_Sub: %s", TR_Sub)
    end
    if GetVar(Select, "TR_Layout") then
        TR_Layout = GetVar(Select, "TR_Layout")
        Printf("TR_Layout: %s", TR_Layout)
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = tonumber(GetVar(Select, "TR_Pool"))
        Printf("TR_Pool: %i", TR_Pool)
    end

    if (TR_Fonction == 1) then
        -- local SeqNr = ShowData().DataPools.TR_808_GMA3.Sequences:Children()
        local SeqNr = ShowData().DataPools[TR_Pool].Sequences:Children()
        for k in ipairs(SeqNr) do
            Printf("Checking Sequence: %s", SeqNr[k].name)
            if TR_Sub == SeqNr[k].name then
                local grp_name = SeqNr[k][3][1][1].Groups.Name
                Printf("Group Name: %s", grp_name)
                Cmd('Set Layout ' .. TR_Layout .. ' Property CustomTextText=\' ' .. grp_name .. ' \'')
            end
        end
        Printf("no_group")
    elseif (TR_Fonction == 2) then

    elseif (TR_Fonction == 3) then

    end


    DelVar(Select, "TR_Sub")
    DelVar(Select, "TR_Layout")
    DelVar(Select, "TR_Pool")
    DelVar(Select, "TR_Fonction")
end


return main
