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

local function Build_Seq_Sub()

    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    local SeqNum = 613
    local SeqEnd = SeqNum + 11
    local VariaSel = 1
    local subSel = 1

    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools

    for e = 1, 8, 1 do
        for i = SeqNum, SeqEnd, 1 do
            Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', varia_min[VariaSel] .. '_Sub_#' .. subSel)
            for a = 3, 18, 1 do
                SequenceObject[i]:Insert()
                SequenceObject[i][a]:Set('No', a - 2)
                SequenceObject[i][a]:Create(1)
                SequenceObject[i][a][1]:Insert()
                SequenceObject[i][a][1]:Create(1)
                SequenceObject[i][a][1][1]:Set('SelectionMode', 'Strict')
                SequenceObject[i][a][1][1]:Set('Enabled', 'No')
            end


            Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
                i .. " At Tag 'off_temps'")
            Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
                i .. " At Tag 'Varia_" .. varia_mag[VariaSel] .. "'")
            Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
                i .. " At Tag 'Sub_#" .. subSel .. "'")

            subSel = subSel + 1
        end
        SeqNum = SeqEnd + 6
        SeqEnd = SeqNum + 11
        subSel = 1
        VariaSel = VariaSel + 1
    end
end

return Build_Seq_Sub
