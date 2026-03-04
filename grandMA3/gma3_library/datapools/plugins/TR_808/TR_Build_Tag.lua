
local function Build_Tag()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local TR_TAGS_CHECKS = {}
    local TR_TAGS = { 'temps_01', 'temps_02', 'temps_03', 'temps_04', 'temps_05', 'temps_06', 'temps_07', 'temps_08',
        'temps_09', 'temps_10', 'temps_11', 'temps_12', 'temps_13', 'temps_14', 'temps_15', 'temps_16', 'temps',
        'off_temps', 'tempo', 'Variation_Play', 'Variation', 'Varia_A', 'Varia_B', 'Varia_C', 'Varia_D', 'Varia_E',
        'Varia_F', 'Varia_G', 'Varia_H', 'Select_A', 'Select_B', 'Select_C', 'Select_D', 'Select_E', 'Select_F',
        'Select_G', 'Select_H', 'Selected_A', 'Selected_B', 'Selected_C', 'Selected_D', 'Selected_E', 'Selected_F',
        'Selected_G', 'Selected_H', 'PLAY_SUB', 'OLD_SUB', 'NEXT_SUB', 'SUB_#1', 'SUB_#2', 'SUB_#3', 'SUB_#4', 'SUB_#5',
        'SUB_#6', 'SUB_#7', 'SUB_#8', 'SUB_#9', 'SUB_#10', 'SUB_#11', 'SUB_#12', 'a_btn_sub_#1', 'a_btn_sub_#2',
        'a_btn_sub_#3', 'a_btn_sub_#4', 'a_btn_sub_#5', 'a_btn_sub_#6', 'a_btn_sub_#7', 'a_btn_sub_#8', 'a_btn_sub_#9',
        'a_btn_sub_#10', 'a_btn_sub_#11', 'a_btn_sub_#12', 'b_btn_sub_#1', 'b_btn_sub_#2', 'b_btn_sub_#3', 'b_btn_sub_#4',
        'b_btn_sub_#5', 'b_btn_sub_#6', 'b_btn_sub_#7', 'b_btn_sub_#8', 'b_btn_sub_#9', 'b_btn_sub_#10', 'b_btn_sub_#11',
        'b_btn_sub_#12', 'c_btn_sub_#1', 'c_btn_sub_#2', 'c_btn_sub_#3', 'c_btn_sub_#4', 'c_btn_sub_#5', 'c_btn_sub_#6',
        'c_btn_sub_#7', 'c_btn_sub_#8', 'c_btn_sub_#9', 'c_btn_sub_#10', 'c_btn_sub_#11', 'c_btn_sub_#12', 'd_btn_sub_#1',
        'd_btn_sub_#2', 'd_btn_sub_#3', 'd_btn_sub_#4', 'd_btn_sub_#5', 'd_btn_sub_#6', 'd_btn_sub_#7', 'd_btn_sub_#8',
        'd_btn_sub_#9', 'd_btn_sub_#10', 'd_btn_sub_#11', 'd_btn_sub_#12', 'e_btn_sub_#1', 'e_btn_sub_#2', 'e_btn_sub_#3',
        'e_btn_sub_#4', 'e_btn_sub_#5', 'e_btn_sub_#6', 'e_btn_sub_#7', 'e_btn_sub_#8', 'e_btn_sub_#9', 'e_btn_sub_#10',
        'e_btn_sub_#11', 'e_btn_sub_#12', 'f_btn_sub_#1', 'f_btn_sub_#2', 'f_btn_sub_#3', 'f_btn_sub_#4', 'f_btn_sub_#5',
        'f_btn_sub_#6', 'f_btn_sub_#7', 'f_btn_sub_#8', 'f_btn_sub_#9', 'f_btn_sub_#10', 'f_btn_sub_#11', 'f_btn_sub_#12',
        'g_btn_sub_#1', 'g_btn_sub_#2', 'g_btn_sub_#3', 'g_btn_sub_#4', 'g_btn_sub_#5', 'g_btn_sub_#6', 'g_btn_sub_#7',
        'g_btn_sub_#8', 'g_btn_sub_#9', 'g_btn_sub_#10', 'g_btn_sub_#11', 'g_btn_sub_#12', 'h_btn_sub_#1', 'h_btn_sub_#2',
        'h_btn_sub_#3', 'h_btn_sub_#4', 'h_btn_sub_#5', 'h_btn_sub_#6', 'h_btn_sub_#7', 'h_btn_sub_#8', 'h_btn_sub_#9',
        'h_btn_sub_#10', 'h_btn_sub_#11', 'h_btn_sub_#12', 'Select_Mute_A', 'Select_Mute_B', 'Select_Mute_C',
        'Select_Mute_D', 'Select_Mute_E', 'Select_Mute_F', 'Select_Mute_G', 'Select_Mute_H', 'Select_Solo_A',
        'Select_Solo_B', 'Select_Solo_C', 'Select_Solo_D', 'Select_Solo_E', 'Select_Solo_F', 'Select_Solo_G',
        'Select_Solo_H' }
        local Tag_Locateur = {}
    for i = 1, #TR_TAGS, 1 do
        TR_TAGS_CHECKS[i] = false
    end

    for v in pairs(TR_TAGS) do
        for k in pairs(TagObject_C) do
            if TR_TAGS[v] == TagObject_C[k].Name then
                TR_TAGS_CHECKS[v] = true
                break
            end
        end
    end
    for k in pairs(TR_TAGS_CHECKS) do
        if TR_TAGS_CHECKS[k] == false then
            local nr = TagObject:Acquire()
            TagObject[nr.No]:Set('Name', TR_TAGS[k])
        end
    end
    for k in pairs(TagObject_C) do
        Tag_Locateur[k] = TagObject_C[k].Name
    end
end

return Build_Tag
