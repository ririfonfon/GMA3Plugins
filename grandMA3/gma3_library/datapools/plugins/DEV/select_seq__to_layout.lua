--[[
    Releases:
    * 0.0.0.1
    
    Created by Richard Fontaine "RIRI", june 2025.

    This script is used to display the currently selected sequence and its current cue name
    in the custom text properties of layouts 12.57 and 12.58.

    It continuously checks for changes in the selected sequence and updates the display accordingly.
--]]

local function SelectedSeq()
    local Current_Seq_Name, last_Current_Seq_Name, Current_Cue_Name, Last_Current_Cue_Name
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