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

function Sequence_Defo(SequenceObject, i)
    SequenceObject[i]:Set('AUTOSTART', 'Yes')
    SequenceObject[i]:Set('AUTOSTOP', 'Yes')
    SequenceObject[i]:Set('AUTOFIX', 'No')
    SequenceObject[i]:Set('RELEASEFIRSTCUE', 'Yes')
    SequenceObject[i]:Set('SOFTLTP', 'Yes')
    SequenceObject[i]:Set('CUECOMMAND', 'Enabled')
    SequenceObject[i]:Set('XFADEMODE', 'AB')
    SequenceObject[i]:Set('XFADERELOAD', 'No')
    SequenceObject[i]:Set('SWAPPROTECT', 'Yes')
    SequenceObject[i]:Set('KILLPROTECT', 'Yes')
    SequenceObject[i]:Set('USEEXECUTORTIME', 'No')
    SequenceObject[i]:Set('OFFWHENOVERRIDDEN', 'No')
    SequenceObject[i]:Set('SEQUMIB', 'Enabled')
    SequenceObject[i]:Set('SEQUMIBMODE', 'None')
    SequenceObject[i]:Set('AUTOPREPOS', 'No')
    SequenceObject[i]:Set('WRAPAROUND', 'Yes')
    SequenceObject[i]:Set('RESTARTMODE', 'First Cue')
    SequenceObject[i]:Set('MASTERGOMODE', 'None')
    SequenceObject[i]:Set('SPEEDFROMRATE', 'No')
    SequenceObject[i]:Set('TRACKING', 'Yes')
    SequenceObject[i]:Set('INCLUDELINKLASTGO', 'Yes')
    SequenceObject[i]:Set('PRIORITY', 'LTP')
    SequenceObject[i]:Set('PLAYBACKMASTER', 'None')
    SequenceObject[i]:Set('RATEMASTER', 'None')
    SequenceObject[i]:Set('SPEEDMASTER', 'None')
    SequenceObject[i]:Set('RATESCALE', 'One')
    SequenceObject[i]:Set('SPEEDSCALE', 'One')
    SequenceObject[i]:Set('INPUTFILTER', '')
    SequenceObject[i]:Set('OUTPUTFILTER', '')
    SequenceObject[i]:Set('PREFERCUEAPPEARANCE', 'Yes')
    SequenceObject[i]:Set('EXECUTORDISPLAYMODE', 'Both')
    SequenceObject[i]:Set('CUEZEROMODE', 'Off')
    SequenceObject[i]:Set('ACTION', 'Pool Default')
    SequenceObject[i]:Set('TIMINGGOTO', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACK', 'Default')
    SequenceObject[i]:Set('TIMINGGOFAST', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACKFAST', 'Default')
end

function Build_MAtricks(Construct_Pool)
    local MAtricksNum = 1
    local MAtricksObject = Root().ShowData.DataPools[Construct_Pool].MAtricks
    Check_Size_Pool(MAtricksNum, MAtricksObject)
    MAtricksObject:Create(MAtricksNum)
    MAtricksObject[MAtricksNum]:Set('Name', 'TR_INPUT')
end

function Check_DataPool(Construct_Pool, Name_Construct_Pool)
    local PoolObject = Root().ShowData.DataPools
    if PoolObject[Construct_Pool] == nil then
        PoolObject:Create(Construct_Pool)
        Printf('Create')
        coroutine.yield(0.1)
    end
    PoolObject[Construct_Pool]:Set('Name', Name_Construct_Pool)

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
end
