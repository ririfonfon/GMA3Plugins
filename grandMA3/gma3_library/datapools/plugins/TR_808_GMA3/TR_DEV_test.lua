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
    local Construct_Pool = 43
    local Layout_Nr = 1
    local Layout_Object = Root().ShowData.DataPools[Construct_Pool].Layouts
    -- local Layout_Object_C = Root().ShowData.DataPools[Construct_Pool].Layouts:Children()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local PoolObject = Root().ShowData.DataPools
    local AppearanceObject = Root().ShowData.Appearances:Children()
    local AppearanceName = { '[[LOGO_psd]]', '[[panelBaseGma3_png]]', '[[01_panel_scale_2_png]]',
        '[[01_panel_scale_3_png]]', '[[01_panel_scale_4_png]]', '[[17_btn_a_low_png]]', '[[17_btn_a_high_png]]',
        '[[16_btn_b_low_png]]', '[[16_btn_b_high_png]]', '[[15_btn_c_low_png]]', '[[15_btn_c_high_png]]',
        '[[14_btn_d_low_png]]', '[[14_btn_d_high_png]]', '[[13_btn_e_low_png]]', '[[13_btn_e_high_png]]',
        '[[12_btn_f_low_png]]', '[[12_btn_f_high_png]]', '[[11_btn_g_low_png]]', '[[11_btn_g_high_png]]',
        '[[10_btn_h_low_png]]', '[[10_btn_h_high_png]]', '[[38_btn_a_next_png]]', '[[37_btn_b_next_png]]',
        '[[36_btn_c_next_png]]', '[[35_btn_d_next_png]]', '[[34_btn_e_next_png]]', '[[33_btn_f_next_png]]',
        '[[32_btn_g_next_png]]', '[[31_btn_h_next_png]]', '[[05_btn_orange_off_png]]', '[[05_btn_orange_on_png]]',
        '[[06_btn_light_orange_off_png]]', '[[06_btn_light_orange_on_png]]', '[[03_btn_yellow_off_png]]',
        '[[03_btn_yellow_on_png]]', '[[04_btn_white_off_png]]', '[[04_btn_white_on_png]]', '[[07_btn_start_off_png]]',
        '[[07_btn_start_on_png]]', '[[25_btn_red_a_low_png]]', '[[25_btn_red_a_high_png]]', '[[24_btn_red_b_low_png]]',
        '[[24_btn_red_b_high_png]]', '[[23_btn_red_c_low_png]]', '[[23_btn_red_c_high_png]]', '[[22_btn_red_d_low_png]]',
        '[[22_btn_red_d_high_png]]', '[[21_btn_red_e_low_png]]', '[[21_btn_red_e_high_png]]', '[[20_btn_red_f_low_png]]',
        '[[20_btn_red_f_high_png]]', '[[19_btn_red_g_low_png]]', '[[19_btn_red_g_high_png]]', '[[18_btn_red_h_low_png]]',
        '[[18_btn_red_h_high_png]]', '[[02_btn_grid_off_png]]', '[[02_btn_grid_on_png]]', '[[27_btn_mute_low_png]]',
        '[[27_btn_mute_high_png]]', '[[26_btn_solo_low_png]]', '[[26_btn_solo_high_png]]', '[[29_btn_select_low_png]]',
        '[[30_btn_solo_high_png]]' }
    local AppearanceAddress = {}
    for k in pairs(AppearanceName) do
        AppearanceAddress[k] = false
        Printf(k)
    end
        AppearanceAddress[64] = false

    for v in pairs(AppearanceName) do
        for k in pairs(AppearanceObject) do
            if AppearanceName[v] == AppearanceObject[k].Name then
                AppearanceAddress[v] = AppearanceObject[k]:AddrNative()
                break
            end
        end
    end
    for k in pairs(AppearanceAddress) do
        if AppearanceAddress[k] == false then
            error('Appearance not found : ' .. AppearanceName[k])
        else
            Printf(AppearanceName[k] .. ' = ' .. AppearanceAddress[k])
        end
    end
    Printf('Appearance Address Count: %d', #AppearanceAddress)
end

return main
