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

    local infade, outfade, name, number , pre_infade, pre_outfade , post_infade, post_outfade

    infade = SelectedSequence().currentcue[1]:Get('cueinfade', Enums.Roles.Display)
    outfade = SelectedSequence().currentcue[1]:Get('cueoutfade', Enums.Roles.Display)
    name = SelectedSequence().currentcue[1].name
    for key, value in ipairs(SelectedSequence():Children()) do
        if value.No then
            Echo("Cue # %f is named %s", value.No / 1000, value.Name)
            if value.Name == name then
                number = value.No / 1000
            end
        end
    end
    Echo(infade .. ' ' .. outfade)
    Echo('name : ' .. name)
    Echo('number : ' .. number)
end

return main
