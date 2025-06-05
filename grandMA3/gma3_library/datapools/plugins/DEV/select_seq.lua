local function SelectedSeq()
    local Current_Seq_Name, last_Current_Seq_Name, Current_Cue_Name, Last_Current_Cue_Name, Current_Part
    local Select = UserVars()
    if not Current_Seq_Name then
        Current_Seq_Name = SelectedSequence().name
        Current_Cue_Name = SelectedSequence().currentcue.name
        last_Current_Seq_Name = Current_Seq_Name
        Last_Current_Cue_Name = Current_Cue_Name
        Cmd('Set Layout 12.57 Property CustomTextText=\' ' .. Current_Seq_Name .. ' \'')
        Cmd('Set Layout 12.58 Property CustomTextText=\' ' .. Current_Cue_Name .. ' \'')
    end
    while true do
        Current_Seq_Name = SelectedSequence().name
        Current_Cue_Name = SelectedSequence().currentcue.name


        local currentCue = GetCurrentCue()
        local cueParts = currentCue:Children()
        local targetPartIndex = 1
        local targetRecipeLineIndex = 1
        local part = cueParts[targetPartIndex]
        local recipeLines = part:Children()
        local recipeLine = recipeLines[targetRecipeLineIndex]

        if recipeLines then
            for rang, ppart in ipairs(recipeLines) do
                if ppart ~= nil then
                    Printf(ppart.values.name)
                    Printf(ppart.MAtricks.name)
                end
            end
        end

        if last_Current_Seq_Name ~= Current_Seq_Name then
            last_Current_Seq_Name = Current_Seq_Name
            Cmd('Set Layout 12.57 Property CustomTextText=\' ' .. Current_Seq_Name .. ' \'')
        end

        if Last_Current_Cue_Name ~= Current_Cue_Name then
            Last_Current_Cue_Name = Current_Cue_Name
            Cmd('Set Layout 12.58 Property CustomTextText=\' ' .. Current_Cue_Name .. ' \'')
        end
    end
end


return SelectedSeq
