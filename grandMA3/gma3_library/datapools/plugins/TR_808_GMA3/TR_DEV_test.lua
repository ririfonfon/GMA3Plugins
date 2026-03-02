local function main()
    local Select = UserVars()
    local Call = false
    if GetVar(Select, "TR_Fonction") then
        TR_Fonction = tonumber((GetVar(Select, "TR_Fonction")))
        Call = true
    end

    if Call == false then
        Printf('call false')
    elseif Call == true then
        Printf('call true')
    end
end
return main
