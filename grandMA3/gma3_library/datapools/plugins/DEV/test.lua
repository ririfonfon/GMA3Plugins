local h_page = nil
local function main()
    -- local infade, outfade, name, number , id_seq, pre_outfade , post_infade, post_outfade

    -- infade = SelectedSequence().currentcue[1]:Get('cueinfade', Enums.Roles.Display)
    -- outfade = SelectedSequence().currentcue[1]:Get('cueoutfade', Enums.Roles.Display)
    -- name = SelectedSequence().currentcue[1].name
    -- id_seq = SelectedSequence().No
    -- Echo('id_seq ' .. id_seq)
    -- for key, value in ipairs(SelectedSequence():Children()) do
    --     if value.No then
    --         Echo("Cue # %f is named %s", value.No / 1000, value.Name)
    --         if value.Name == name then
    --             number = value.No / 1000
    --         end
    --     end
    -- end
    -- Echo(infade .. ' ' .. outfade)
    -- Echo('name : ' .. name)
    -- Echo('number : ' .. number)

    -- local osc_config = 1
    -- local osc_template = 'SendOSC %i "/%s%i,i,%i"'

    -- local function send_osc(etype, exec_no, value)
    --     Cmd(osc_template:format(osc_config, etype, exec_no, value))
    -- end
    -- local color_r = 127
    -- local color_g = 0
    -- local color_b = 200
    -- local enable = true

    -- while enable do
        
        
    --     send_osc('PageCurrent/Fader_Color_R', 201, color_r)
    --     send_osc('PageCurrent/Fader_Color_G', 201, color_g)
    --     send_osc('PageCurrent/Fader_Color_B', 201, color_b)

    --     color_r = color_r + 1
    --     if color_r > 255 then
    --         color_r = 0
    --     end

    --     color_g = color_g + 1
    --     if color_g > 255 then
    --         color_g = 0
    --     end

    --     color_b = color_b + 1
    --     if color_b > 255 then
    --         color_b = 0
    --     end
        
    -- end
    local exec = GetExecutor(111)

    for __, value in pairs(exec:Children()) do
        Echo(value)
    end
end

return main
