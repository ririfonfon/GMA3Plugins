local function main()

    local Preset25 = Root().ShowData.DataPools[42].PresetPools:Children()
    local Preset25Object = Root().ShowData.DataPools[42].PresetPools[25]:Children()
    local ColPath = Root().ShowData.GelPools
    local SelectedGelNr = 1
    local TCol = ColPath:Children()[SelectedGelNr]
    local All_5_Current = 1
    local prefix = 'test'

    local value
    for k in ipairs(Preset25) do
        if Preset25[k].Name == 'All 5' then
            Preset25[k]:Set('PresetMode' , 'Universal')
        end
    end

    -- Preset25Object:Create(1)
    -- Preset25Object[1]:Set('Name', 'test')

    CmdIndirectWait("ClearAll /nu")
    -- CmdIndirectWait('Set Preset 25 Property PresetMode "Universal"')
    CmdIndirectWait('Fixture Thru')
    for col in ipairs(TCol) do
        local StColName = TCol[col].name
        local StringColName = string.gsub(StColName, " ", "_")
        CmdIndirectWait('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        CmdIndirectWait('Store DataPool 42 Preset 25.' .. All_5_Current .. '')
        CmdIndirectWait('Label DataPool 42 Preset 25.' .. All_5_Current .. " " .. prefix .. StringColName .. " ")
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end

end
return main
