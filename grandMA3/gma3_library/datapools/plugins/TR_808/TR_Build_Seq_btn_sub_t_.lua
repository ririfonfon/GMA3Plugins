--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Seq_Btn_Sub(Construct_Pool)
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local SeqNum = 766
    local SeqEnd = SeqNum + 15
    local VariaSel = 1
    local subSel = 1

    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]
    local app_btn_sub = { '[[02_btn_grid_off_png]]', '[[02_btn_grid_on_png]]' }
    for v = 1, 8 do
        for e = 1, 12, 1 do
            for i = SeqNum, SeqEnd, 1 do
                Check_Size_Pool(i, SequenceObject)
                SequenceObject:Create(i)
                SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_sub_' .. subSel .. '_t_' .. count)
                Sequence_Defo(SequenceObject, i)
                SequenceObject[i]:Set('Appearance', app_btn_sub[1]) --off state
                SequenceObject[i]:Insert()
                SequenceObject[i][3]:Set('No', 1)
                SequenceObject[i][3]:Create(1)
                SequenceObject[i][3][1]:Set('Appearance', app_btn_sub[2]) --on state
                SequenceObject[i][3][1]:Set('Command', "Set DataPool '" .. Build_Pool.Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 1; Set DataPool '" .. Build_Pool.Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "'." .. count .. " 'Enabled' 1")
                SequenceObject[i]:Insert()
                SequenceObject[i][4]:Set('No', 2)
                SequenceObject[i][4]:Create(1)
                SequenceObject[i][4][1]:Set('Appearance', app_btn_sub[1]) --off state
                SequenceObject[i][4][1]:Set('Command', "Set DataPool '" .. Build_Pool.Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 0; Set DataPool '" .. Build_Pool.Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub_#" .. subSel .. "'." .. count .. " 'Enabled' 0")
                Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
                    i .. " At Tag '" .. varia_min[VariaSel] .. "_btn_sub_#" .. subSel .. "'")
                count = count + 1
            end
            SeqNum = SeqEnd + 2
            SeqEnd = SeqNum + 15
            count = 1
            subSel = subSel + 1
        end
        SeqNum = SeqEnd + 2
        SeqEnd = SeqNum + 15
        VariaSel = VariaSel + 1
        subSel = 1
    end

    local Quant_Name = { 'None', 'Ronde', 'Blanche', 'Noir', 'Croche', 'double' }
    local Quant_Seq = { '', '1', '1 + 9', '1 + 5 + 9 + 13', '1 + 3 + 5 + 7 + 9 + 11 + 13 + 15', '1 Thru 16' }
    count = 1
    SeqEnd = SeqNum + 5

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', Quant_Name[count])
        Sequence_Defo(SequenceObject, i)
        SequenceObject[i]:Set('Appearance', app_btn_sub[1]) --off state
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', app_btn_sub[2]) --on state
        SequenceObject[i][3][1]:Set('Command', "Goto DataPool '" .. Build_Pool.Name ..
            "' Sequence 1 Thru 16 Cue 2 ; Goto DataPool '" ..
            Build_Pool.Name .. "' Sequence " .. Quant_Seq[count] .. " Cue 1")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Appearance', app_btn_sub[1]) --off state
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'Quant'")
        count = count + 1
    end
end
