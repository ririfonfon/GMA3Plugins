local function SelectedSeq()
    local Current_Seq_Name, last_Current_Seq_Name
    local Select = UserVars()
    if not Current_Seq_Name then
        Current_Seq_Name = SelectedSequence().name
        last_Current_Seq_Name = Current_Seq_Name
        SetVar(Select, "jp_select", Current_Seq_Name)
        Printf("first Selected Sequence: %s", Current_Seq_Name)
    end
    while true do
        Current_Seq_Name = SelectedSequence().name
        if last_Current_Seq_Name ~= Current_Seq_Name then
            last_Current_Seq_Name = Current_Seq_Name
            SetVar(Select, "jp_select", Current_Seq_Name)
            Printf("Set jpselect to : %s", Current_Seq_Name)
        end
    end
end


return SelectedSeq
