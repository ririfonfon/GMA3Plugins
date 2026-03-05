--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]
function Message_End(message)
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 100, 400
    local mybutton = dialog:Append('Button')
    mybutton.Text = message

    -- local AppearObject = Root().ShowData.Appearances
    -- local myicon = dialog:Append('AppearancePreview')
    -- myicon.Appearance = AppearObject[955]
    -- -- myicon.Appearance = GetObject('Image 3.1')
    -- myicon.BackColor, myicon.W = 'Global.Transparent', 60
    -- myicon.Interactive = 'No'
end

function Check_Size_Pool(id, PoolObject)
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

function Build_MAtricks()
    local MAtricksNum = 1
    local Construct_Pool = 43
    local MAtricksObject = Root().ShowData.DataPools[Construct_Pool].MAtricks
    local i = MAtricksNum

    Check_Size_Pool(i, MAtricksObject)
    MAtricksObject:Create(i)
    MAtricksObject[i]:Set('Name', 'TR_INPUT')
end

function Check_DataPool(Construct_Pool)
    local PoolObject = Root().ShowData.DataPools
    if PoolObject[Construct_Pool] == nil then
        PoolObject:Create(Construct_Pool)
        Printf('Create')
        coroutine.yield(0.1)
    end

    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences:Children() or nil
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros:Children() or nil
    local Size_Seq, Size_Macro = 0, 0

    if SequenceObject ~= nil then
        for S in pairs(SequenceObject) do
            Size_Seq = S
        end
    end
    if MacroObject ~= nil then
        for S in pairs(MacroObject) do
            Size_Macro = S
        end
    end

    Printf('seq ' .. Size_Seq .. ' macro ' .. Size_Macro)
end
