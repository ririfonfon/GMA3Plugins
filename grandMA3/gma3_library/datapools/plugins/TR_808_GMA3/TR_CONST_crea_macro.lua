local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
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
    local inputs = {
        { name = "macro Number",      value = "1704", whiteFilter = "0123456789" },
        { name = "lay object Number", value = "271",  whiteFilter = "0123456789" },
    }
    local selectors = {
        { name = "Varia Selector", selectedValue = 1, values = { ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4, ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8 },                                                   type = 1 },
        { name = "Sub Selector",   selectedValue = 1, values = { ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["11"] = 11, ["12"] = 12 }, type = 1 }
    }

    local MacroNum, VariaSel, MacroEnd, subSel, lay_object
    local count = 1
    local varia_min = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' }
    local varia_mag = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' }
    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "create macro for TR-808",
                message = "Please enter the macro number.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                inputs = inputs,
                selectors = selectors,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    -- print results:

    for k, v in pairs(resultTable.inputs) do
        Printf("Input '%s' = '%s'", k, v)
        if k == "lay object Number" then
            lay_object = tonumber(v)
        elseif k == "macro Number" then
            MacroNum = tonumber(v)
            MacroEnd = MacroNum + 11
        end
    end
    for k, v in pairs(resultTable.selectors) do
        Printf("Selector '%s' = '%d'", k, v)
        if k == "Varia Selector" then
            VariaSel = v
        elseif k == "Sub Selector" then
            subSel = v
        end
    end

    local MacroObject = Root().ShowData.DataPools[41].Macros


    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Select_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'Selection'")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' 41")
        MacroObject[i]:Acquire()
        MacroObject[i][6]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Value_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'Values'")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 2")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' 41")
        MacroObject[i]:Acquire()
        MacroObject[i][6]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_MAtricks_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'MAtricks'")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "SetUserVariable 'TR_Fonction' 3")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Pool' 41")
        MacroObject[i]:Acquire()
        MacroObject[i][6]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Tag_Sub_#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] at #[Tag 'Selected_" .. varia_mag[VariaSel] .. "']")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_mute_#" .. subSel .. "'] at #[Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "']")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "Assign #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_solo_#" .. subSel .. "'] at #[Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "']")
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Off_Tag_Sub_#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] at #[Tag 'Selected_" .. varia_mag[VariaSel] .. "']")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_mute_#" .. subSel .. "'] at #[Tag 'Select_Mute_" .. varia_mag[VariaSel] .. "']")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "Assign Off #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_btn_solo_#" .. subSel .. "'] at #[Tag 'Select_Solo_" .. varia_mag[VariaSel] .. "']")
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 4

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_edit_fade_TR_INPUT')
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'FadeFromX'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][2]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'FadeToX'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'TR_Fonction' 1")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'TR_Pool' 'TR_808_GMA3'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][6]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Edit_Tag']")

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1
    lay_object = lay_object + 13

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Fade_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'FadeFromX'")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'FadeToX'")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Fonction' 5")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][6]:Set('Command', "SetUserVariable 'TR_Pool' 41")
        MacroObject[i]:Acquire()
        MacroObject[i][7]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 4

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_edit_delay_TR_INPUT')
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'DelayFromX'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][2]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'MAtricks'.'TR_INPUT'] Property 'DelayToX'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'TR_Fonction' 2")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'TR_Pool' 'TR_808_GMA3'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'TR_Tag' 'Selected_" .. varia_mag[VariaSel] .. "'")
    MacroObject[MacroNum]:Acquire()
    MacroObject[MacroNum][6]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Edit_Tag']")

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Delay_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'DelayFromX'")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Edit #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'] Cue 1 Thru 16 Part 0.1 Property 'DelayToX'")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "SetUserVariable 'TR_Fonction' 6")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "SetUserVariable 'TR_Sub' '" .. varia_min[VariaSel] .. "_Sub_#" .. subSel .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "SetUserVariable 'TR_Layout' '1_" .. lay_object .. "'")
        MacroObject[i]:Acquire()
        MacroObject[i][6]:Set('Command', "SetUserVariable 'TR_Pool' 41")
        MacroObject[i]:Acquire()
        MacroObject[i][7]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_Retour_Recipie']")
        subSel = subSel + 1
        lay_object = lay_object + 1
    end

    MacroNum = MacroEnd + 4

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_SOLO')

    for j = 1, 12, 1 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][j]:Set('Command', "Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
            varia_min[VariaSel] .. "_Sub_#" .. j .. "'] Cue 1 Thru 16 Part 0.1 Property 'Enabled' 0")
    end


    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Rec_Sub#' .. subSel)
        for j = 1, 16, 1 do
            MacroObject[i]:Acquire()
            MacroObject[i][j]:Set('Command', "Set #[DataPool 'TR_808_GMA3'.'Sequences'.'" ..
                varia_min[VariaSel] .. "_Sub_#" ..
                subSel .. "'] Cue " .. j .. " Part 0.1 Property 'Enabled' 0")
            MacroObject[i][j]:Set('Enabled', 0)
        end
        subSel = subSel + 1
    end

    MacroNum = MacroEnd + 4

    Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', varia_min[VariaSel] .. '_NO_SOLO')

    for j = 1, 12, 1 do
        MacroObject[MacroNum]:Acquire()
        MacroObject[MacroNum][j]:Set('Command', "Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" ..
            varia_min[VariaSel] .. "_Rec_Sub#" .. j .. "']")
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_On_Solo_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "SetUserVariable '" .. varia_mag[VariaSel] .. "_TR_PLUS' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Set #[DataPool 'TR_808_GMA3'.'Macros'.'" .. varia_min[VariaSel] ..
            "_SOLO']." .. count .. " 'Enabled' 0")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" .. varia_min[VariaSel] .. "_SOLO']")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" .. varia_min[VariaSel] ..
            "_Rec_Sub#" .. count .. "']")
        MacroObject[i]:Acquire()
        MacroObject[i][5]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        lay_object = lay_object + 1
        count = count + 1
    end

    MacroNum = MacroEnd + 6
    MacroEnd = MacroNum + 11
    subSel = 1

    for i = MacroNum, MacroEnd, 1 do
        Check_Size_Pool(i, MacroObject)
        MacroObject:Create(i)
        MacroObject[i]:Set('Name', varia_min[VariaSel] .. '_Off_Solo_Sub#' .. subSel)
        MacroObject[i]:Acquire()
        MacroObject[i][1]:Set('Command', "SetUserVariable '" .. varia_mag[VariaSel] .. "_TR_MOINS' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][2]:Set('Command', "Set #[DataPool 'TR_808_GMA3'.'Macros'.'" .. varia_min[VariaSel] .. "_SOLO']."
            .. count .. " 'Enabled' 1")
        MacroObject[i]:Acquire()
        MacroObject[i][3]:Set('Command', "Go+ #[DataPool 'TR_808_GMA3'.'Macros'.'" .. varia_min[VariaSel] .. "_SOLO']")
        MacroObject[i]:Acquire()
        MacroObject[i][4]:Set('Command', "Call #[DataPool 'TR_808_GMA3'.'Plugins'.'TR_808_CHECK_SOLO']")
        subSel = subSel + 1
        lay_object = lay_object + 1
        count = count + 1
    end

end

return main
