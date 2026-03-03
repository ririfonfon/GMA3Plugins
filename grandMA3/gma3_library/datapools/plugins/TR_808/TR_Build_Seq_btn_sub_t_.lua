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
local function Build_Seq_Btn_Sub()

    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local SeqNum = 766
    local SeqEnd = SeqNum + 15
    local VariaSel = 1
    local subSel = 1

    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local app_btn_sub = { '[[02_btn_grid_off_png]]', '[[02_btn_grid_on_png]]' }
    for v = 1, 8 do
        for e = 1, 12, 1 do
            for i = SeqNum, SeqEnd, 1 do
                Check_Size_Pool(i, SequenceObject)
                SequenceObject:Create(i)
                SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_btn_sub_' .. subSel .. '_t_' .. count)
                SequenceObject[i]:Set('Appearance', app_btn_sub[1]) --off state
                SequenceObject[i]:Set('PreferCueAppearance', 1)
                SequenceObject[i]:Insert()
                SequenceObject[i][3]:Set('No', 1)
                SequenceObject[i][3]:Create(1)
                SequenceObject[i][3][1]:Set('Appearance', app_btn_sub[2]) --on state
                SequenceObject[i][3][1]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 1; Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub#" .. subSel .. "'." .. count .. " 'Enabled' 1")
                SequenceObject[i]:Insert()
                SequenceObject[i][4]:Set('No', 2)
                SequenceObject[i][4]:Create(1)
                SequenceObject[i][4][1]:Set('Appearance', app_btn_sub[1]) --off state
                SequenceObject[i][4][1]:Set('Command', "Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Sequence '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "' Cue " ..
                    count .. " Part 0.1 Property 'Enabled' 0; Set DataPool '" .. PoolObject[Construct_Pool].Name ..
                    "' Macro '" .. varia_min[VariaSel] .. "_Rec_Sub#" .. subSel .. "'." .. count .. " 'Enabled' 0")
                Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
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
end

return Build_Seq_Btn_Sub
