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
local function main()
    local inputs = {
        { name = "TAG Number", value = "230", whiteFilter = "0123456789" },
    }
    -- local selectors = {
    --     { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 }, type = 1 },
    -- }

    local TagNum, VariaSel, MacroEnd, subSel, lay_object, DataPoolNum
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "create Tags for TR-808",
                message = "Please enter Tags number.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                inputs = inputs,
                selectors = selectors,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    -- print results:

    for k, v in pairs(resultTable.inputs) do
        Printf("Input '%s' = '%s'", k, v)
        if k == "TAG Number" then
            TagNum = tonumber(v)
        end
    end
    -- for k, v in pairs(resultTable.selectors) do
    --     Printf("Selector '%s' = '%d'", k, v)
    --     if k == "Varia Selector" then
    --         VariaSel = v
    --     end
    -- end
    local TagObject = Root().ShowData.Tags
    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools

    -- Check_Size_Pool(TagNum, TagObject)
    -- TagObject:Create(TagNum)
    -- local nr = TagObject:Acquire()
    -- TagObject[nr.No]:Set('Name', 'test')
    -- TagObject[TagNum]:Set('Name', 'test')
    -- TagObject[TagNum]:Set('TagType', 'Kill Instant')
    -- TagObject[TagNum]:Set('TagType', 'Kill Delayed')
    -- TagObject[TagNum]:Set('TagType', 'None')
    -- TagObject[TagNum]:Insert(1)

    -- TagObject[TagNum][1]:Set('DATAPOOL',PoolObject)
    -- TagObject[TagNum][1]:Set('CLASS','Sequence')
    -- TagObject[TagNum][1]:Set('No',1)
    SequenceObject[1]:Set('Tags', TagObject[TagNum]:Index() .. ':0')
    SequenceObject[2]:Set('Tags', TagObject[TagNum]:Index() .. ':0')
    -- SequenceObject[2]:Set('tags', '0:0')

    
end

return main
