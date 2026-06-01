--[[
Releases:
* 2.3.2.0

Version :
* 0.0.0.9

Created by Richard Fontaine "RIRI", April 2026.
--]]

local thiscomponent = select(4, ...)

function SOUND_Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        Sound_Dialog_End('Error : wrong argument expected integer got ' .. idtype)
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        Sound_Dialog_End('Error : id is already used : ' .. id)
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        Sound_Dialog_End('Error : id out of range')
        error('id out of range')
    end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function SOUND_Build_Macro(Construct_Pool, MacroNum, TLayNr, prefix)
    local TagObject_C = Root().ShowData.Tags:Children()
    local SOUND_TAGS = { 'S_solo', 'S_all', }
    local S_Tag_solo, S_Tag_all
    for v in pairs(SOUND_TAGS) do
        for k in pairs(TagObject_C) do
            if SOUND_TAGS[v] == TagObject_C[k].Name then
                if v == 1 then
                    S_Tag_solo = TagObject_C[k]
                elseif v == 2 then
                    S_Tag_all = TagObject_C[k]
                end
            end
        end
    end


    local TypeSel    = 1
    local lay_object = 25
    local Sound_Type = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }


    local Build_Pool  = Root().ShowData.DataPools[Construct_Pool]
    local Call_Pool   = thiscomponent:FindParent(DataPool():GetClass())
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local lay_select, lay_value, lay_matricks, lay_fade, lay_delay

    if prefix == "B" then
        MacroNum = MacroNum + 206
        TLayNr = TLayNr + 1
    end

    for b = 1, 11 do
        for PartSel = 1, 3 do
            if PartSel == 1 then
                lay_select = lay_object
            end
            SOUND_Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', prefix .. 'Grp part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 10 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'Selection'")
            Cmd("Assign " .. MacroObject[MacroNum][1] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0.1 Thru Part 0.3 Property 'Selection'")
            Cmd("Assign " .. MacroObject[MacroNum][2] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][2]:Set('Enabled', 0)

            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Fonction' 1")
            MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Part' 99")
            Cmd("Assign " .. MacroObject[MacroNum][4] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][4]:Set('Enabled', 0)

            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            Cmd("Assign " .. MacroObject[MacroNum][5] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][6]:Set('Command',
                "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][7] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][8]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_select .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][8] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][8]:Set('Enabled', 0)

            MacroObject[MacroNum][9]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][10]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            if PartSel == 1 then
                lay_value = lay_object
            end
            SOUND_Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', prefix .. 'Values part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 10 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'Values'")
            Cmd("Assign " .. MacroObject[MacroNum][1] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0.1 Thru Part 0.3 Property 'Values'")
            Cmd("Assign " .. MacroObject[MacroNum][2] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][2]:Set('Enabled', 0)

            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Fonction' 2")
            MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Part' 99")
            Cmd("Assign " .. MacroObject[MacroNum][4] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][4]:Set('Enabled', 0)

            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            Cmd("Assign " .. MacroObject[MacroNum][5] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][6]:Set('Command',
                "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][7] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][8]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_value .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][8] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][8]:Set('Enabled', 0)

            MacroObject[MacroNum][9]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][10]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            if PartSel == 1 then
                lay_matricks = lay_object
            end
            SOUND_Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', prefix .. 'MAtricks part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 10 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'MAtricks'")
            Cmd("Assign " .. MacroObject[MacroNum][1] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0.1 Thru Part 0.3 Property 'MAtricks'")
            Cmd("Assign " .. MacroObject[MacroNum][2] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][2]:Set('Enabled', 0)

            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Fonction' 3")
            MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Part' 99")
            Cmd("Assign " .. MacroObject[MacroNum][4] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][4]:Set('Enabled', 0)

            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            Cmd("Assign " .. MacroObject[MacroNum][5] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][6]:Set('Command',
                "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][7] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][8]:Set('Command',
                "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_matricks .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][8] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][8]:Set('Enabled', 0)

            MacroObject[MacroNum][9]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][10]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            if PartSel == 1 then
                lay_fade = lay_object
            end
            SOUND_Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', prefix .. 'Fade part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 12 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'FadeFromX'")
            Cmd("Assign " .. MacroObject[MacroNum][1] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'FadeToX'")
            Cmd("Assign " .. MacroObject[MacroNum][2] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][3]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0.1 Thru Part 0.3 Property 'FadeFromX'")
            Cmd("Assign " .. MacroObject[MacroNum][3] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][3]:Set('Enabled', 0)
            MacroObject[MacroNum][4]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0.1 Thru Part 0.3 Property 'FadeToX'")
            Cmd("Assign " .. MacroObject[MacroNum][4] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][4]:Set('Enabled', 0)

            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Fonction' 5")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Part' 99")
            Cmd("Assign " .. MacroObject[MacroNum][7] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][7]:Set('Enabled', 0)

            MacroObject[MacroNum][8]:Set('Command',
                "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][9]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][9] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][10]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_fade .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][10] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][10]:Set('Enabled', 0)

            MacroObject[MacroNum][11]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][12]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            if PartSel == 1 then
                lay_delay = lay_object
            end
            SOUND_Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', prefix .. 'Delay part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 12 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayFromX'")
            Cmd("Assign " .. MacroObject[MacroNum][1] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayToX'")
            Cmd("Assign " .. MacroObject[MacroNum][2] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][3]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayFromX'")
            Cmd("Assign " .. MacroObject[MacroNum][3] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][3]:Set('Enabled', 0)
            MacroObject[MacroNum][4]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayToX'")
            Cmd("Assign " .. MacroObject[MacroNum][4] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][4]:Set('Enabled', 0)

            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Fonction' 6")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            Cmd("Assign " .. MacroObject[MacroNum][6] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Part' 99")
            Cmd("Assign " .. MacroObject[MacroNum][7] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][7]:Set('Enabled', 0)

            MacroObject[MacroNum][8]:Set('Command',
                "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][9]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][9] .. " at " .. S_Tag_solo)
            MacroObject[MacroNum][10]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_delay .. "'")
            Cmd("Assign " .. MacroObject[MacroNum][10] .. " at " .. S_Tag_all)
            MacroObject[MacroNum][10]:Set('Enabled', 0)

            MacroObject[MacroNum][11]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][12]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1
        end
        TypeSel = TypeSel + 1
    end
    TypeSel = 1
    local Master = 1
    if prefix == "B" then
        Master = Master + 13
    end
    for k = Master, Master + 10, 1 do
        SOUND_Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', prefix .. 'Master_' .. Sound_Type[TypeSel])
        for a = 1, 5 do
            MacroObject[MacroNum]:Insert(a)
        end
        MacroObject[MacroNum][1]:Set('Command', "SetUserVariable 'S_Fonction' 4")
        MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Master' " .. k .. "'")
        MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
        MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
        MacroObject[MacroNum][5]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

        lay_object = lay_object + 1
        MacroNum = MacroNum + 1
        TypeSel = TypeSel + 1
    end
    SOUND_Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', prefix .. 'Sound_Priority')
    for a = 1, 6 do
        MacroObject[MacroNum]:Insert(a)
    end
    MacroObject[MacroNum][1]:Set('Command',
        "Edit DataPool '" .. Build_Pool.Name .. "' Sequence '" .. prefix .. "RecepieSound*'  Property 'priority'")
    MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Fonction' 10")
    MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Seq' '" .. prefix .. "RecepieSound All'")
    MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
    MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
    MacroObject[MacroNum][6]:Set('Command',
        "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")
    MacroNum = MacroNum + 1
    lay_object = lay_object + 1


    SOUND_Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', prefix .. 'Reset Recepie')
    for a = 1, 5 do
        MacroObject[MacroNum]:Insert(a)
    end
    MacroObject[MacroNum][1]:Set('Command', "SetUserVariable 'S_Fonction' 8")
    MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
    MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
    MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Prefix' '" .. prefix .. "'")
    MacroObject[MacroNum][5]:Set('Command',
        "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")
    MacroNum = MacroNum + 1
    lay_object = lay_object + 1

    TypeSel = 1
    for k = 1, 9, 1 do
        SOUND_Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', prefix .. 'Load_MEM_' .. k)
        for a = 1, 6 do
            MacroObject[MacroNum]:Insert(a)
        end
        MacroObject[MacroNum][1]:Set('Command', "SetUserVariable 'S_Fonction' 12")
        MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Mem' " .. k .. "'")
        MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
        MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
        MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Prefix' '" .. prefix .. "'")
        MacroObject[MacroNum][6]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

        lay_object = lay_object + 1
        MacroNum = MacroNum + 1
    end

    for k = 1, 9, 1 do
        SOUND_Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', prefix .. 'Save_MEM_' .. k)
        for a = 1, 6 do
            MacroObject[MacroNum]:Insert(a)
        end
        MacroObject[MacroNum][1]:Set('Command', "SetUserVariable 'S_Fonction' 11")
        MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Mem' " .. k .. "'")
        MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Layout' '" .. TLayNr .. "_" .. lay_object .. "'")
        MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
        MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Prefix' '" .. prefix .. "'")
        MacroObject[MacroNum][6]:Set('Command',
            "Call DataPool '" .. Call_Pool.Name .. "'.'Plugins'.'Sound by Riri'.'Sound_Retour_Recepie_lua'")

        lay_object = lay_object + 1
        MacroNum = MacroNum + 1
    end
    for k = 1, 9, 1 do
        SOUND_Check_Size_Pool(MacroNum, MacroObject)
        MacroObject:Create(MacroNum)
        MacroObject[MacroNum]:Set('Name', prefix .. 'Label_MEM_' .. k)
        MacroObject[MacroNum]:Insert(1)
        MacroObject[MacroNum][1]:Set('Command', "Label DataPool '" .. Build_Pool.Name .. "' Macro " .. MacroNum)

        lay_object = lay_object + 1
        MacroNum = MacroNum + 1
    end
end
