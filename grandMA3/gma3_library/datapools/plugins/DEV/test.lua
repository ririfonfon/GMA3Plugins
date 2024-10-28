local h_page = nil
local function main()
    -- local SeqNr = DataPool().Sequences:Children()
    -- local SeqNr = SelectedSequence():CurrentChild()
    -- local SeqNr = SelectedSequence()
    -- local cue = SeqNr:Children()
    -- local cue = SelectedSequence():CurrentChild()
    -- local cue = SelectedSequence():Children()
    -- for k in ipairs(cue) do
    --     -- Echo('cue : ' .. k .. ' name : ' .. cue[k].name .. ' ' .. cue[k].fade())
    --     Echo( k .. 'cue : ' .. cue[k].NO .. ' name : ' .. cue[k].name )
    --     Echo('next : ' )
    -- end

    local infade , outfade

    infade = SelectedSequence().currentcue[1]:Get('cueinfade',Enums.Roles.Display)
    outfade = SelectedSequence().currentcue[1]:Get('cueoutfade',Enums.Roles.Display)
    for key, value in ipairs(SelectedSequence():Children()) do
        if value.No then
            Echo("Cue # %f is named %s", value.No / 1000, value.Name)
        end
    end
    Echo(infade .. ' ' .. outfade)
end

return main
