

local function Main()
    
    local root = Root();
    local Maf = math.floor
    local E = Echo

    local ColPath = root.ShowData.GelPools
    local TCol
    local SelectedGelNr = 11
    
    local All_5_Nr = root.ShowData.DataPools.Default.PresetPools[25]:Children()
    local All_5_NrStart
    local All_5_NrEnd
    local All_5_Current
    for k in ipairs(All_5_Nr) do
        All_5_NrStart = Maf(All_5_Nr[k].NO)
    end
    if All_5_NrStart == nil then
        All_5_NrStart = 0
    end
    
    All_5_NrStart = Maf(All_5_NrStart + 1)
    All_5_Current = All_5_NrStart
    E(All_5_Nr)

    TCol = ColPath:Children()[SelectedGelNr]

    
    Cmd("ClearAll /nu")
    Cmd('Set Preset 25 Property PresetMode "Universal"')
    Cmd('Fixture Thru')
    for col in ipairs(TCol) do
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        Cmd('At Gel ' ..SelectedGelNr .. "."  .. col .. '')
        Cmd('Store Preset 25.' .. All_5_Current .. '')
        Cmd('Label Preset 25.' .. All_5_Current ..  " " .. StringColName .. " " )
        All_5_NrEnd = All_5_Current
        All_5_Current = Maf(All_5_Current + 1)
    end

end
return Main