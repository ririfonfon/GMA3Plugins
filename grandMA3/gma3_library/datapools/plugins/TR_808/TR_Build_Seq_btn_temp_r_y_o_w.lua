--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function Build_Seq_R_Y_O(Construct_Pool)
    local count, nr = 1, 1
    local color_btn = { 'red', 'red', 'or', 'or', 'yel', 'yel', 'whit', 'whit' }
    local app_btn_r_o_y_w = {
        '[[05_btn_orange_off_png]]', '[[05_btn_orange_on_png]]',
        '[[06_btn_light_orange_off_png]]', '[[06_btn_light_orange_on_png]]',
        '[[03_btn_yellow_off_png]]', '[[03_btn_yellow_on_png]]',
        '[[04_btn_white_off_png]]', '[[04_btn_white_on_png]]', }
    local SeqNum = 1
    local SeqEnd = SeqNum + 3

    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]

    for e = 1, 4, 1 do
        for i = SeqNum, SeqEnd, 1 do
            Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', 'btn_temp_' .. color_btn[count] .. "_" .. nr)
            Sequence_Defo(SequenceObject, i)
            SequenceObject[i]:Set('Appearance', app_btn_r_o_y_w[count]) --off state
            SequenceObject[i]:Insert()
            SequenceObject[i][3]:Set('No', 1)
            SequenceObject[i][3]:Create(1)
            SequenceObject[i][3][1]:Set('Appearance', app_btn_r_o_y_w[count + 1]) --on state
            SequenceObject[i][3][1]:Set('Command', "Set DataPool '" .. Build_Pool.Name ..
                "' Sequence 'Varia_Check' Cue " .. nr .. " Property 'CommandEnabled' 1")
            SequenceObject[i]:Insert()
            SequenceObject[i][4]:Set('No', 2)
            SequenceObject[i][4]:Create(1)
            SequenceObject[i][4][1]:Set('Appearance', app_btn_r_o_y_w[count]) --off state
            SequenceObject[i][4][1]:Set('Command', "Set DataPool '" .. Build_Pool.Name ..
                "' Sequence 'Varia_Check' Cue " .. nr .. " Property 'CommandEnabled' 0")
            nr = nr + 1
        end
        count = count + 2
        SeqNum = SeqEnd + 1
        SeqEnd = SeqNum + 3
    end
end
