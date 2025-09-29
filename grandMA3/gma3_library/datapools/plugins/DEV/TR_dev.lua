local function seq()
    
    local Current_Seq_Name, last_Current_Seq_Name, Current_Cue_Name, Last_Current_Cue_Name
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
return seq