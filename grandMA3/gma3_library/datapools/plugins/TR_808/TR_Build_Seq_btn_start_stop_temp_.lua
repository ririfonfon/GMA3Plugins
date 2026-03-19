--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]


function Build_Seq_Start_Stop(Construct_Pool, Name_Speed)
    local SeqEnd
    local count = 1
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local Tempo_Count = { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16' }
    local SeqNum = 34
    local VariaSel = 1

    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Build_Pool = Root().ShowData.DataPools[Construct_Pool]
    local app_start_stop = { '[[07_btn_start_off_png]]', '[[07_btn_start_on_png]]', 'Temps_#' }

    Check_Size_Pool(SeqNum, SequenceObject)
    SequenceObject:Create(SeqNum)
    SequenceObject[SeqNum]:Set('Name', 'btn_start_stop')
    Sequence_Defo(SequenceObject, SeqNum)
    SequenceObject[SeqNum]:Set('Appearance', app_start_stop[1]) --off state
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][3]:Set('No', 1)
    SequenceObject[SeqNum][3]:Create(1)
    SequenceObject[SeqNum][3][1]:Set('Appearance', app_start_stop[2]) --on state
    SequenceObject[SeqNum][3][1]:Set('Command',
        " Go+ DataPool '" .. Build_Pool.Name .. "'  Macro 'Start_Varia_Play'")
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][4]:Set('No', 2)
    SequenceObject[SeqNum][4]:Create(1)
    SequenceObject[SeqNum][4][1]:Set('Appearance', app_start_stop[1]) --off state
    SequenceObject[SeqNum][4][1]:Set('Command',
        " Off DataPool '" .. Build_Pool.Name .. "'  Sequence Thru If Tag 'off_temps'")

    Check_Size_Pool(SeqNum + 2, SequenceObject)
    SequenceObject:Create(SeqNum + 2)
    SequenceObject[SeqNum + 2]:Set('Name', 'Varia_Check')
    Sequence_Defo(SequenceObject, SeqNum + 2)
    for a = 3, 19 do
        SequenceObject[SeqNum + 2]:Insert()
        SequenceObject[SeqNum + 2][a]:Set('No', a - 2)
        SequenceObject[SeqNum + 2][a]:Create(1)
        SequenceObject[SeqNum + 2][a][1]:Set('Command',
            "Go+ DataPool '" .. Build_Pool.Name .. "' Macro 'Varia_Call'")
        SequenceObject[SeqNum + 2][a][1]:Set('CommandEnabled', 0)
    end

    SeqNum = SeqNum + 4
    SeqEnd = SeqNum + 7
    VariaSel = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', varia_mag[VariaSel] .. '_Tempo')

        Sequence_Defo(SequenceObject, i)
        SequenceObject[i]:Set('RATEMASTER', Name_Speed)
        SequenceObject[i]:Set('RATESCALE', 'Mul4')

        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#1'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 1 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 1")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#2'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 2 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 2")
        SequenceObject[i]:Insert()
        SequenceObject[i][5]:Set('No', 3)
        SequenceObject[i][5]:Create(1)
        SequenceObject[i][5][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#3'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 3 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 3")
        SequenceObject[i]:Insert()
        SequenceObject[i][6]:Set('No', 4)
        SequenceObject[i][6]:Create(1)
        SequenceObject[i][6][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#4'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 4 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 4")
        SequenceObject[i]:Insert()
        SequenceObject[i][7]:Set('No', 5)
        SequenceObject[i][7]:Create(1)
        SequenceObject[i][7][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#5'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 5 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 5")
        SequenceObject[i]:Insert()
        SequenceObject[i][8]:Set('No', 6)
        SequenceObject[i][8]:Create(1)
        SequenceObject[i][8][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#6'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 6 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 6")
        SequenceObject[i]:Insert()
        SequenceObject[i][9]:Set('No', 7)
        SequenceObject[i][9]:Create(1)
        SequenceObject[i][9][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#7'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 7 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 7")
        SequenceObject[i]:Insert()
        SequenceObject[i][10]:Set('No', 8)
        SequenceObject[i][10]:Create(1)
        SequenceObject[i][10][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#8'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 8 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 8")
        SequenceObject[i]:Insert()
        SequenceObject[i][11]:Set('No', 9)
        SequenceObject[i][11]:Create(1)
        SequenceObject[i][11][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#9'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 9 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 9")
        SequenceObject[i]:Insert()
        SequenceObject[i][12]:Set('No', 10)
        SequenceObject[i][12]:Create(1)
        SequenceObject[i][12][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#10'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 10 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 10")
        SequenceObject[i]:Insert()
        SequenceObject[i][13]:Set('No', 11)
        SequenceObject[i][13]:Create(1)
        SequenceObject[i][13][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#11'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 11 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 11")
        SequenceObject[i]:Insert()
        SequenceObject[i][14]:Set('No', 12)
        SequenceObject[i][14]:Create(1)
        SequenceObject[i][14][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#12'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 12 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 12")
        SequenceObject[i]:Insert()
        SequenceObject[i][15]:Set('No', 13)
        SequenceObject[i][15]:Create(1)
        SequenceObject[i][15][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#13'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 13 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 13")
        SequenceObject[i]:Insert()
        SequenceObject[i][16]:Set('No', 14)
        SequenceObject[i][16]:Create(1)
        SequenceObject[i][16][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#14'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 14 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 14")
        SequenceObject[i]:Insert()
        SequenceObject[i][17]:Set('No', 15)
        SequenceObject[i][17]:Create(1)
        SequenceObject[i][17][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#15'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 15 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 15")
        SequenceObject[i]:Insert()
        SequenceObject[i][18]:Set('No', 16)
        SequenceObject[i][18]:Create(1)
        SequenceObject[i][18][1]:Set('Command',
            " Go+ DataPool '" .. Build_Pool.Name .. "' Sequence 'temps_#16'; Go+ DataPool '" ..
            Build_Pool.Name .. "' Cue 16 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. Build_Pool.Name ..
            "' Sequence 'Varia_Check' Cue 16")
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'off_temps'")
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'tempo'")
        VariaSel = VariaSel + 1
        for b = 1, 16 do
            Cmd("Set " .. SequenceObject[i] .. " Cue " .. b .. " Property 'TrigType' 'Follow'")
            Cmd("Set " .. SequenceObject[i] .. " Cue " .. b .. " Property 'CueFade' '1'")
        end
    end

    SeqNum = SeqEnd + 7
    SeqEnd = SeqNum + 15
    count = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', 'temps_#' .. count)
        Sequence_Defo(SequenceObject, i)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', app_start_stop[3])
        SequenceObject[i][3][1]:Set('Command', "SetUserVariable 'TR_Temps' " .. count .. "")
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'off_temps'")
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'temps'")
        Cmd("Assign DataPool '" .. Build_Pool.Name .. "' Sequence " ..
            i .. " At Tag 'temps_" .. Tempo_Count[count] .. "'")
        count = count + 1
    end
end
