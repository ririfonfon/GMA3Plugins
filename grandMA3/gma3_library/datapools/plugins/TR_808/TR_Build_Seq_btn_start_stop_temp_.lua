local function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used : ' .. id) end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end
local function Build_Seq_Start_Stop()

    local SeqEnd
    local count = 1
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local Tempo_Count = { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16' }
    local SeqNum = 34
    local VariaSel = 1

    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local app_start_stop = { '[[07_btn_start_off_png]]', '[[07_btn_start_on_png]]', 'Temps_#' }

    Check_Size_Pool(SeqNum, SequenceObject)
    SequenceObject:Create(SeqNum)
    SequenceObject[SeqNum]:Set('Name', 'btn_start_stop')
    SequenceObject[SeqNum]:Set('Appearance', app_start_stop[1]) --off state
    SequenceObject[SeqNum]:Set('PreferCueAppearance', 1)
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][3]:Set('No', 1)
    SequenceObject[SeqNum][3]:Create(1)
    SequenceObject[SeqNum][3][1]:Set('Appearance', app_start_stop[2]) --on state
    SequenceObject[SeqNum][3][1]:Set('Command',
        " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'  Macro 'Varia_Play'")
    SequenceObject[SeqNum]:Insert()
    SequenceObject[SeqNum][4]:Set('No', 2)
    SequenceObject[SeqNum][4]:Create(1)
    SequenceObject[SeqNum][4][1]:Set('Appearance', app_start_stop[1]) --off state
    SequenceObject[SeqNum][4][1]:Set('Command',
        " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'  Sequence Thru If Tag 'off_temps'")

    SeqNum = SeqNum + 4
    SeqEnd = SeqNum + 7
    VariaSel = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', varia_mag[VariaSel] .. '_Tempo')
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#1'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 1 Sequence Thru If Tag 'Varia_" ..
            varia_mag[VariaSel] .. "'; Go+ DataPool '" .. PoolObject[Construct_Pool].Name ..
            "' Macro 'Varia_Call'")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#2'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 2 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][5]:Set('No', 3)
        SequenceObject[i][5]:Create(1)
        SequenceObject[i][5][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#3'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 3 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][6]:Set('No', 4)
        SequenceObject[i][6]:Create(1)
        SequenceObject[i][6][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#4'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 4 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][7]:Set('No', 5)
        SequenceObject[i][7]:Create(1)
        SequenceObject[i][7][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#5'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 5 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][8]:Set('No', 6)
        SequenceObject[i][8]:Create(1)
        SequenceObject[i][8][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#6'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 6 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][9]:Set('No', 7)
        SequenceObject[i][9]:Create(1)
        SequenceObject[i][9][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#7'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 7 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][10]:Set('No', 8)
        SequenceObject[i][10]:Create(1)
        SequenceObject[i][10][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#8'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 8 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][11]:Set('No', 9)
        SequenceObject[i][11]:Create(1)
        SequenceObject[i][11][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#9'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 9 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][12]:Set('No', 10)
        SequenceObject[i][12]:Create(1)
        SequenceObject[i][12][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#10'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 10 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][13]:Set('No', 11)
        SequenceObject[i][13]:Create(1)
        SequenceObject[i][13][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#11'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 11 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][14]:Set('No', 12)
        SequenceObject[i][14]:Create(1)
        SequenceObject[i][14][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#12'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 12 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][15]:Set('No', 13)
        SequenceObject[i][15]:Create(1)
        SequenceObject[i][15][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#13'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 13 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][16]:Set('No', 14)
        SequenceObject[i][16]:Create(1)
        SequenceObject[i][16][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#14'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 14 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][17]:Set('No', 15)
        SequenceObject[i][17]:Create(1)
        SequenceObject[i][17][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#15'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 15 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][18]:Set('No', 16)
        SequenceObject[i][18]:Create(1)
        SequenceObject[i][18][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence 'temps_#16'; Go+ DataPool '" ..
            PoolObject[Construct_Pool].Name .. "' Cue 16 Sequence Thru If Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'off_temps'")
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'tempo'")
        VariaSel = VariaSel + 1
    end

    SeqNum = SeqEnd + 7
    SeqEnd = SeqNum + 15
    count = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', 'temps_#' .. count)
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', app_start_stop[3])
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'off_temps'")
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'tempo'")
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'temps_" .. Tempo_Count[count] .. "'")
        count = count + 1
    end
end

return Build_Seq_Start_Stop
