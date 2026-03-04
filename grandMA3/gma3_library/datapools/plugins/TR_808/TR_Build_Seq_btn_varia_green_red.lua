--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

-- local function getTags(obj)
--     local tbl = {}
--     for a, b in obj:Get('Tags', Enums.Roles.Edit):gmatch('([^:,]+):([^,]+)') do
--         tbl[StrToHandle(a)] = tonumber(b)
--         Printf(a .. ' - ' .. tbl[StrToHandle(a)])
--     end
--     return tbl
-- end

-- local function setTags(obj, tbl)
--     local str = ''
--     for a, b in pairs(tbl) do
--         str = str .. HandleToStr(a) .. ':' .. b .. ','
--     end
--     obj:Set('Tags', str)
-- end

function Build_Seq_Varia_G_R()
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- local taglist, myobj
    local SeqNum = 18
    local SeqEnd = SeqNum + 7
    local VariaSel = 1

    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools
    local TagObject = Root().ShowData.Tags
    local App_btn_green_red = {
        '[[17_btn_a_low_png]]', '[[38_btn_a_next_png]]', '[[17_btn_a_high_png]]',
        '[[16_btn_b_low_png]]', '[[37_btn_b_next_png]]', '[[16_btn_b_high_png]]',
        '[[15_btn_c_low_png]]', '[[36_btn_c_next_png]]', '[[15_btn_c_high_png]]',
        '[[14_btn_d_low_png]]', '[[35_btn_d_next_png]]', '[[14_btn_d_high_png]]',
        '[[13_btn_e_low_png]]', '[[34_btn_e_next_png]]', '[[13_btn_e_high_png]]',
        '[[12_btn_f_low_png]]', '[[33_btn_f_next_png]]', '[[12_btn_f_high_png]]',
        '[[11_btn_g_low_png]]', '[[32_btn_g_next_png]]', '[[11_btn_g_high_png]]',
        '[[10_btn_h_low_png]]', '[[31_btn_h_next_png]]', '[[10_btn_h_high_png]]',
        '[[25_btn_red_a_low_png]]', '[[25_btn_red_a_high_png]]',
        '[[24_btn_red_b_low_png]]', '[[24_btn_red_b_high_png]]',
        '[[23_btn_red_c_low_png]]', '[[23_btn_red_c_high_png]]',
        '[[22_btn_red_d_low_png]]', '[[22_btn_red_d_high_png]]',
        '[[21_btn_red_e_low_png]]', '[[21_btn_red_e_high_png]]',
        '[[20_btn_red_f_low_png]]', '[[20_btn_red_f_high_png]]',
        '[[19_btn_red_g_low_png]]', '[[19_btn_red_g_high_png]]',
        '[[18_btn_red_h_low_png]]', '[[18_btn_red_h_high_png]]',
    }

    local number = 1
    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', 'btn_' .. varia_min[VariaSel] .. '_green')
        SequenceObject[i]:Set('Appearance', App_btn_green_red[number])
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', App_btn_green_red[number + 1])
        SequenceObject[i][3][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'  Macro 'Varia_" .. varia_mag[VariaSel] .. "'")
        SequenceObject[i]:Insert()
        SequenceObject[i][4]:Set('No', 2)
        SequenceObject[i][4]:Create(1)
        SequenceObject[i][4][1]:Set('Appearance', App_btn_green_red[number + 2])
        SequenceObject[i]:Insert()
        SequenceObject[i][5]:Set('No', 3)
        SequenceObject[i][5]:Create(1)
        SequenceObject[i][5][1]:Set('Appearance', App_btn_green_red[number])
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'Variation_Play'")

        -- myobj = SequenceObject[i]
        -- taglist = getTags(myobj)
        -- taglist[TagObject[21]] = '0' -- Variation_Play
        -- setTags(myobj, taglist)

        VariaSel = VariaSel + 1
        number = number + 3
    end

    SeqNum = SeqEnd + 1
    SeqEnd = SeqNum + 7
    VariaSel = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', "Varia_" .. varia_mag[VariaSel] .. "")
        SequenceObject[i]:Set('Appearance', App_btn_green_red[number])
        SequenceObject[i]:Set('PreferCueAppearance', 1)
        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Set('Appearance', App_btn_green_red[number + 1])
        SequenceObject[i][3][1]:Set('Command',
            " Go+ DataPool '" .. PoolObject[Construct_Pool].Name .. "'  Macro 'Edit_Varia_" .. varia_mag[VariaSel] .. "'")
        Cmd("Assign DataPool '" .. PoolObject[Construct_Pool].Name .. "' Sequence " ..
            i .. " At Tag 'Variation'")

        -- myobj = SequenceObject[i]
        -- taglist = getTags(myobj)
        -- taglist[TagObject[22]] = '0' -- Variation
        -- setTags(myobj, taglist)

        VariaSel = VariaSel + 1
        number = number + 2
    end
end
