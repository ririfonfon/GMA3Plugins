--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local thiscomponent = select(4, ...)

function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        Dialog_End('Error : wrong argument expected integer got ' .. idtype)
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        Dialog_End('Error : id is already used : ' .. id)
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        Dialog_End('Error : id out of range')
        error('id out of range')
    end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function Build_Macro_Sub(Construct_Pool)
    local MacroNum    = 1
    local TypeSel     = 1
    local lay_object  = 22
    local Sound_Type  = { 'All', 'Bass', 'Mid', 'High', 'Band 1', 'Band 2', 'Band 3', 'Band 4', 'Band 5', 'Band 6',
        'Band 7' }

    local Build_Pool  = Root().ShowData.DataPools[Construct_Pool]
    local Call_Pool   = Build_Pool
    -- local Call_Pool   = thiscomponent:FindParent(DataPool():GetClass())
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros

    for b = 1, 11 do
        for PartSel = 1, 3 do
            Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', 'Grp part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 7 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'Selection'")
            MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Fonction' 1")
            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            MacroObject[MacroNum][4]:Set('Command',
                "SetUserVariable 'S_Seq' 'RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Layout' '1_" .. lay_object .. "'")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][7]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'Sound_Retour_Recepie'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', 'Values part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 7 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'Values'")
            MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Fonction' 2")
            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            MacroObject[MacroNum][4]:Set('Command',
                "SetUserVariable 'S_Seq' 'RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Layout' '1_" .. lay_object .. "'")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][7]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'Sound_Retour_Recepie'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', 'MAtricks part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 7 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'MAtricks'")
            MacroObject[MacroNum][2]:Set('Command', "SetUserVariable 'S_Fonction' 3")
            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Part' " .. PartSel)
            MacroObject[MacroNum][4]:Set('Command',
                "SetUserVariable 'S_Seq' 'RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][5]:Set('Command', "SetUserVariable 'S_Layout' '1_" .. lay_object .. "'")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][7]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'Sound_Retour_Recepie'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', 'Fade part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 8 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'FadeFromX'")
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'FadeToX'")
            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Fonction' 5")
            MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Part'" .. PartSel)
            MacroObject[MacroNum][5]:Set('Command',
                "SetUserVariable 'S_Seq' 'RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Layout' '1_" .. lay_object .. "'")
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][8]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'Sound_Retour_Recepie'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1

            Check_Size_Pool(MacroNum, MacroObject)
            MacroObject:Create(MacroNum)
            MacroObject[MacroNum]:Set('Name', 'Delay part 0' .. PartSel .. ' Sound ' .. Sound_Type[TypeSel])
            for a = 1, 8 do
                MacroObject[MacroNum]:Insert(a)
            end
            MacroObject[MacroNum][1]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayFromX'")
            MacroObject[MacroNum][2]:Set('Command',
                "Edit DataPool '" .. Build_Pool.Name .. "' Sequence 'RecepieSound " ..
                Sound_Type[TypeSel] .. "' Cue 1 Part 0." .. PartSel .. " Property 'DelayToX'")
            MacroObject[MacroNum][3]:Set('Command', "SetUserVariable 'S_Fonction' 6")
            MacroObject[MacroNum][4]:Set('Command', "SetUserVariable 'S_Part'" .. PartSel)
            MacroObject[MacroNum][5]:Set('Command',
                "SetUserVariable 'S_Seq' 'RecepieSound " .. Sound_Type[TypeSel] .. "'")
            MacroObject[MacroNum][6]:Set('Command', "SetUserVariable 'S_Layout' '1_" .. lay_object .. "'")
            MacroObject[MacroNum][7]:Set('Command', "SetUserVariable 'S_Pool' '" .. Build_Pool.Name .. "'")
            MacroObject[MacroNum][8]:Set('Command',
                "Call DataPool '" .. Call_Pool.Name .. "' Plugin 'Sound_Retour_Recepie'")

            lay_object = lay_object + 1
            MacroNum = MacroNum + 1
        end
        TypeSel = TypeSel + 1
    end
end

local function main()
    local Construct_Pool = 5
    Build_Macro_Sub(Construct_Pool)
end
return main
