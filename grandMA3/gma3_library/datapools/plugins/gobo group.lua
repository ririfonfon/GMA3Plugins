local function dec24_to_dec8(dec24)
    return math.floor(dec24 * 255 / 16777215)
end

local function arrayLength(arr)
    local length = 0
    for _ in pairs(arr) do
        length = length + 1
    end
    return length
end

local function printTable(tbl)
    local indent = 0

    for key, value in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. key .. ": "
        if type(value) == "table" then
            Printf(formatting)
            printTable(value, indent + 1)
        else
            Printf(formatting .. tostring(value))
        end
    end
end

local function getpresetdmx(fixture)
    --not actually used in main, was for a different version
    local presetdmxvalue = {}
    local presetgobo = {}
    for i = 11, 24 do
        local my_preset_handle = DataPool().PresetPools[3][i]
        local content_table = GetPresetData(my_preset_handle)
        if content_table and content_table["by_fixtures"] and content_table["by_fixtures"][fixture]
            and content_table["by_fixtures"][fixture]["Gobo1"]
            and content_table["by_fixtures"][fixture]["Gobo1"][1]
            and content_table["by_fixtures"][fixture]["Gobo1"][1]["absolute_value"] then
            presetdmxvalue[i] = math.floor(content_table["by_fixtures"][fixture]["Gobo1"][1]["absolute_value"] / 255 /
            255)
            Printf("the preset dmx value of preset " .. i .. " is " .. presetdmxvalue[i] .. " and the wheel is gobo1")
            presetgobo[i] = "Gobo1"
        elseif content_table and content_table["by_fixtures"] and content_table["by_fixtures"][fixture]
            and content_table["by_fixtures"][fixture]["Gobo2"]
            and content_table["by_fixtures"][fixture]["Gobo2"][1]
            and content_table["by_fixtures"][fixture]["Gobo2"][1]["absolute_value"] then
            presetdmxvalue[i] = math.floor(content_table["by_fixtures"][fixture]["Gobo2"][1]["absolute_value"] / 255 /
            255)
            Printf("the preset dmx value of preset " .. i .. " is " .. presetdmxvalue[i] .. " and the wheel is gobo2")

            presetgobo[i] = "Gobo2"
        else
            Printf("No preset or nil value for fixture " .. fixture .. " at preset " .. i)
        end
    end
    return presetdmxvalue
    , presetgobo
end

local function getWheelName(ftype, attribut)
    Cmd("Blind On;Clearall")
    CmdIndirectWait("cd root")
    CmdIndirectWait("cd FixtureType '" .. ftype .. "'")

    CmdIndirectWait("cd DMXModes.1.DMXChannels.'*" .. attribut .. "'.1")
    Printf(CmdObj().Destination:Children()[1].Wheel.name)
    return CmdObj().Destination:Children()[1].Wheel.name
end

local function createAppearances(ft, att, j)
    -- thanks for andrea for this


    gobowheel = getWheelName(ft, att)
    Cmd("cd ft '" .. ft .. "'.Wheels.'" .. gobowheel .. "'")
    wheel = CmdObj().Destination
    CmdIndirectWait("delete appearance " .. j .. " thru " .. 99 + j .. " /nc")
    -- deleting existent appearances
    for _, slot in ipairs(wheel:Children()) do
        Cmd("Store appearance " .. j .. " 'Appearance " .. j .. "'")
        local objlist = ObjectList("appearance " .. tostring(j))
        j = j + 1
        obj = objlist[1]
        obj.Name = string.format('FT %s %s %s', wheel:Parent():Parent().ShortName, wheel.Name, slot.Name)
        for _, prop in ipairs { 'ImageR', 'ImageG', 'ImageB', 'ImageAlpha', 'Appearance' } do
            obj[prop] = slot[prop]
        end
    end
end




local function CreateLabelPresets(att, fixtureID, FirstPresetIndex)
    local handlefixture = ObjectList(fixtureID)[1]
    local presetnames = {}
    mode = handlefixture.MODEDIRECT.name
    ft = handlefixture.FIXTURETYPE.name

    CmdIndirectWait("delete preset 3." .. FirstPresetIndex .. " t " .. 49 + FirstPresetIndex .. " /nc") -- I have presets of group 3 between 301 and 350 for wheel 1 and 351 and 400 for wheel 2
    CmdIndirectWait("cd root")
    CmdIndirectWait("cd FixtureType '" .. ft .. "'")

    CmdIndirectWait("cd DMXModes.'*" .. mode .. "*'.DMXChannels")

    local GoboAttNum = 1

    while not string.find(CmdObj().Destination:Children()[GoboAttNum].Name, att) and GoboAttNum < #CmdObj().Destination:Children() do
        -- this loop is to find where attribute gobo is in the dmxchannels

        GoboAttNum = GoboAttNum + 1
    end
    if GoboAttNum == #CmdObj().Destination:Children() then
        Printf("Returning")
        return
    end
    -- this is to terminate the function if there is no gobo
    local DefaultP = dec24_to_dec8(CmdObj().Destination:Children()[GoboAttNum].Default)
    CmdIndirectWait("cd '*" .. att .. "'")
    CmdIndirectWait("cd '*" .. att .. "'")
    if CmdObj().Destination:Children()[1].DMXTO ~= nil then
        local i = 1
        while DefaultP > dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO) or DefaultP < dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM) do
            -- this is to find where is the static attributes of the gobo wheel
            i = i + 1
        end
        local MaxDmxForLoop = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO)
        Cmd("cd " .. i)
        -- changing destination to the not shaking, or revolving gobos
        local i = 1
        local PresetIndex = FirstPresetIndex
        while i <= #CmdObj().Destination:Children() do
            -- iterating over the gobos

            Printf("start of loop Dmx range of " ..
            PresetIndex ..
            " is " ..
            dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO) ..
            " to " .. dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM))
            local fromdmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXFROM)
            local todmx = dec24_to_dec8(CmdObj().Destination:Children()[i].DMXTO)
            local avgdmx = math.floor((fromdmx + todmx) / 2) -- so there is no problem of the conversion from decimal24 to deecimal8
            CmdIndirectWait(" Blind on; Clearall")
            CmdIndirectWait("Fixture " .. fixtureID .. " At Absolute Decimal8 " .. avgdmx .. " Attribute " .. att)
            CmdIndirect("store preset 3." .. PresetIndex .. " /merge")
            presetnames[PresetIndex] = CmdObj().Destination:Children()[i].Name
            -- geting the name of the gobo
            CmdIndirect("Label preset 3." .. PresetIndex .. " '" .. presetnames[PresetIndex] .. "'")
            Printf("preset " .. PresetIndex .. " is " .. presetnames[PresetIndex])
            Printf("End of loop")
            coroutine.yield(0.05) -- otherwise in the last loop information is lost
            PresetIndex = PresetIndex + 1
            i = i + 1
        end

        return presetnames
    else
        Printf("No " .. att .. " here")
    end
end

local function CreateSequence(SeqNameF, Preset_Name1F, Preset_Name2F, GroupNum)
    CmdIndirectWait("delete seq '" .. SeqNameF .. "' cue 2 t /nc") -- delete existing sequence except "open"
    CmdIndirectWait("assign preset 3." .. GroupNum * 100 + 1 .. " at seq '" .. SeqNameF .. "' cue 1 part 0.1")
    CmdIndirectWait("assign appearance 'Gobo Open' at seq '" .. SeqNameF .. "' cue 1")
    CmdIndirectWait([[set seq ']] ..
    SeqNameF ..
    [[' cue 1 property 'Command' 'SetUserVariable "g]] ..
    GroupNum .. [[gobo" 0; Go+ Macro "Set Focus Group ]] .. GroupNum .. [["]])
    -- something for me
    local length1 = arrayLength(Preset_Name1F)
    Cmd("Clearall; Group " .. GroupNum)
    local length2 = 1
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
        length2 = arrayLength(Preset_Name2F)
    end
    Printf("The length1 and 2 is " .. length1 .. " and " .. length2)
    Cmd("Clearall")
    CmdIndirectWait("store seq '" .. SeqNameF .. "' cue 2 t " .. length1 + length2 - 1 .. " /nc")
    -- the minus 1 is because i dont need the open gobo twwice
    for i = 2, length1, 1 do
        -- gobo1 loop from preset to sequence
        CmdIndirectWait("assign preset 3." ..
        GroupNum * 100 + i .. " at seq '" .. SeqNameF .. "' cue " .. i .. " part 0.1")
        CmdIndirectWait("assign appearance " .. 1000 + GroupNum * 100 + i .. " at seq '" .. SeqNameF .. "' cue " .. i)
        CmdIndirectWait([[set seq ']] ..
        SeqNameF ..
        [['  cue ]] ..
        i ..
        [[ property 'Command' 'SetUserVariable "g]] ..
        GroupNum .. [[gobo" 10; Go+ Macro "Set Focus Group ]] .. GroupNum .. [["]])

        CmdIndirectWait("label seq '" .. SeqNameF .. "'  cue " .. i .. " '" .. Preset_Name1F[GroupNum * 100 + i] .. "'")
        coroutine.yield(0.05)
    end
    local cuetinue = length1

    for i = 2, length2, 1 do
        -- gobo2 loop from preset to sequence, if there is no gobo2 length2 would be 1 and loop wont commited

        CmdIndirectWait("assign preset 3." ..
        GroupNum * 100 + 50 + i .. " at seq '" .. SeqNameF .. "' cue " .. cuetinue + i - 1 .. " part 0.1")
        CmdIndirectWait("assign appearance " ..
        1050 + GroupNum * 100 + i .. " at seq '" .. SeqNameF .. "' cue " .. cuetinue + i - 1)
        CmdIndirectWait([[set seq ']] ..
        SeqNameF ..
        [[' cue ]] ..
        cuetinue + i - 1 ..
        [[ property 'Command' 'SetUserVariable "g]] ..
        GroupNum .. [[gobo" 20; Go+ Macro "Set Focus Group ]] .. GroupNum .. [["]])
        CmdIndirectWait("label seq '" ..
        SeqNameF .. "'  cue " .. cuetinue + i - 1 .. " '" .. Preset_Name2F[GroupNum * 100 + 50 + i] .. "'")
        coroutine.yield(0.05)
    end
    CmdIndirectWait("assign group " .. GroupNum .. " at seq '" .. SeqNameF .. "' cue 1 t part 0.1")
end


local function main()
    local fixture = "101"
    local fixturenum = tonumber(fixture)
    -- local FixtureType = ObjectList(fixture)[1].FIXTURETYPE.name
    local FixtureType = ObjectList(fixture)[1].FIXTURETYPE.name
    local dmxValues = {}
    -- not usefull in this plugin
    local FirstPreset = 101
    local SeqName = "Gobo Group 1"
    local Preset_Name = {}

    Cmd("clearall; fixture " .. fixture)

    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) ~= nil then
        -- check if fixture has gobo1
        Preset_Name[1] = CreateLabelPresets("Gobo1", fixture, FirstPreset)
    end


    FirstPreset = FirstPreset + 50
    -- e.g gobo1 of group 4 is in preset 401 t 450 and gobo2 in preset 451 t 500
    Cmd("clearall; fixture " .. fixture)

    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) ~= nil then
        -- check if fixture has gobo2
        Preset_Name[2] = CreateLabelPresets("Gobo2", fixture, FirstPreset)
    end

    Cmd("cd root")

    Cmd("clearall; fixture " .. fixture)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo1')) then
        -- check if fixture has gobo1
        createAppearances(FixtureType, "Gobo1", 1000 + fixturenum)
    end
    Cmd("clearall; fixture " .. fixture)
    if GetUIChannelIndex(SelectionFirst(), GetAttributeIndex('Gobo2')) then
        -- check if fixture has gobo2
        createAppearances(FixtureType, "Gobo2", 1050 + fixturenum)
    end
    Cmd("cd root")

    -- printTable(Preset_Name[1])
    CreateSequence(SeqName, Preset_Name[1], Preset_Name[2], tostring(math.floor(fixturenum / 100)))
end
return main
