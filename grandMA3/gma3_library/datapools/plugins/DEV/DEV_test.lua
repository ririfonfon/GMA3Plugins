local function main()
    local pool_construct = 42
    local Preset25 = Root().ShowData.DataPools[pool_construct].PresetPools:Children()
    local Preset25Object = Root().ShowData.DataPools[pool_construct].PresetPools[25]
    local ColPath = Root().ShowData.GelPools
    local ColGels = ColPath:Children()
    local SelectedGelNr = 1
    local TCol = ColPath:Children()[SelectedGelNr] -- ma gel
    local All_5_Current = 1
    local prefix = "test "
    local value
    local StColName
    local StringColName
    local All_5_NrEnd

    -- for k in ipairs(Preset25) do
        --     if Preset25[k].Name == 'All 5' then
            --         Preset25[k]:Set('PresetMode', 'Universal')
            --     end
    -- end

    -- Preset25Object[1]:Acquire() -- make recipe ?
    -- local preset_data = GetPresetData(TCol[2])
    -- local preset_data = GetPresetData(Preset25Object[1])
    -- local color_R = 2.55*preset_data[3][1].absolute
    -- Printf(color_R)
    -- Preset25Object:Create(1) -- create preset
    -- Preset25Object[1]:Set('Name','test') -- label preset
    -- Preset25Object[1]:Insert(1) -- recipe 1
    -- Preset25Object[1][1]:Set('Name','testrecipe') -- label recipe 1
    -- Preset25Object[1][1]:Set('FadeFromX', 1) -- set 1 FadeFromX

    -- Preset25Object[1]:Set(FadeFromX, 2) --
    -- local ob = Preset25Object[1]
    

    -- Preset25Object:Create(1)
    -- Preset25Object[1]:Set('Name', 'test')
    
    -- Preset25Object:Set('PresetMode', 'Universal')
    -- -- CmdIndirectWait('Set Preset 25 Property PresetMode "Universal"')
    -- CmdIndirectWait("ClearAll /nu")
    -- CmdIndirectWait('Fixture Thru')
    -- for col in ipairs(TCol) do
    --     local StColName = TCol[col].name
    --     local StringColName = string.gsub(StColName, " ", "_")
    --     local convert = prefix .. StringColName
    --     local Name = string.gsub(convert , " ","_")
    --     CmdIndirectWait('At Gel ' .. SelectedGelNr .. "." .. col .. '')
    --     CmdIndirectWait('Store DataPool ' .. pool_construct ..' Preset 25.' .. All_5_Current .. '')
    --     CmdIndirectWait('Label DataPool ' .. pool_construct ..' Preset 25.' .. All_5_Current .. " " .. Name .. " ")
    --     local All_5_NrEnd = All_5_Current
    --     All_5_Current = math.floor(All_5_Current + 1)
    -- end

    -- Create Preset 25
    All_5_NrEnd, All_5_Current = Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd,
        All_5_Current, pool_construct)
    -- endCreate Preset 25
end
return main
