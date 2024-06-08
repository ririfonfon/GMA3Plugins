local c = Cmd
local ti = TextInput

function cp_declare_timing_values(half_second)
    local fades = {}
    local delays_from = {}
    local delays_to = {}
    if half_second then
        fades[1] = 0
        fades[2] = 0.5
        fades[3] = 1
        fades[4] = 2
        fades[5] = '(Color Picker X Fade)'
    -------------------------
        delays_from[1] = 0
        delays_from[2] = 0.5
        delays_from[3] = 1
        delays_from[4] = 2
        delays_from[5] = '(Color Picker X Delay-from)'
    -------------------------
        delays_to[1] = 0
        delays_to[2] = 0.5
        delays_to[3] = 1
        delays_to[4] = 2
        delays_to[5] = '(Color Picker X Delay-to)'
    else
        fades[1] = 0
        fades[2] = 1
        fades[3] = 2
        fades[4] = 3
        fades[5] = '(Color Picker X Fade)'
    -------------------------
        delays_from[1] = 0
        delays_from[2] = 1
        delays_from[3] = 2
        delays_from[4] = 3
        delays_from[5] = '(Color Picker X Delay-from)'
    -------------------------
        delays_to[1] = 0
        delays_to[2] = 1
        delays_to[3] = 2
        delays_to[4] = 3
        delays_to[5] = '(Color Picker X Delay-to)'
    end
    local groups = {}
        groups[1] = 0
        groups[2] = 2
        groups[3] = 3
        groups[4] = 4
        groups[5] = '(Color Picker X Groups)'
    local wings = {}
        wings[1] = 0
        wings[2] = 2
        wings[3] = 4
        wings[4] = 6
        wings[5] = '(Color Picker X Wings)'
    return fades,delays_from,delays_to,groups,wings
end