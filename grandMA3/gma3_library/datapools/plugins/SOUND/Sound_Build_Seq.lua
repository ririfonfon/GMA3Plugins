--[[
    Releases:
    * 0.0.0.1
    Created by Richard Fontaine "RIRI", April 2026.
--]]

function Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        error('id out of range')
    end
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

function Build_Seq(Construct_Pool)
    local Sound_Type     = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }
    local SeqNum         = 41
    local SeqEnd         = SeqNum + 10
    local TypeSel        = 1

    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Preset4Object  = Root().ShowData.DataPools[Construct_Pool].PresetPools[24]
    local GroupObject    = Root().ShowData.DataPools[Construct_Pool].Groups
    local Build_Pool     = Root().ShowData.DataPools[Construct_Pool]

    for i = 1, 10 do
        GroupObject:Create(i)
        GroupObject[i]:Set('Name', 'Sound ' .. Sound_Type[TypeSel])
        Cmd("AutoCreate Fixture " ..
            900 + i .. " At DataPool " .. Construct_Pool .. " Group " .. i .. " /All /NoConfirmation ")
        TypeSel = TypeSel + 1
    end
    TypeSel = 1

    for i = 1, 10 do
        Preset4Object:Create(i)
        Preset4Object[i]:Set('Name', 'Sound ' .. Sound_Type[TypeSel])
        Cmd("SelectFixtures DataPool " .. Construct_Pool .. " Group " .. GroupObject[i].No)
        Cmd(" Attribute 'Dimmer' At SoundChannel '" .. Sound_Type[TypeSel] .. "'")
        Cmd("Store " .. Preset4Object[i] .. " /Merge")
        TypeSel = TypeSel + 1
    end
    Cmd("ClearAll")
    TypeSel = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', ' Sound ' .. Sound_Type[TypeSel])
        Sequence_Defo(SequenceObject, i)
        SequenceObject[i]:Set('AUTOSTART', 'No')
        SequenceObject[i]:Set('AUTOSTOP', 'No')
        SequenceObject[i]:Set('TRACKING', 'No')
        SequenceObject[i]:Set('PRIORITY', 'HTP')
        SequenceObject[i]:Set('SOFTLTP', 'No')

        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Insert()
        SequenceObject[i][3][1]:Create(1)
        SequenceObject[i][3][1][1]:Set('Selection', GroupObject[TypeSel])
        SequenceObject[i][3][1][1]:Set('Values', Preset4Object[TypeSel])
        SequenceObject[i][3][1][1]:Set('SelectionMode', 'Strict')
        SequenceObject[i][3][1][1]:Set('Enabled', 'Yes')


        TypeSel = TypeSel + 1
    end

    Check_Size_Pool(SeqEnd+1, SequenceObject)
        SequenceObject:Create(SeqEnd+1)
        SequenceObject[SeqEnd+1]:Set('Name', 'On_Off Sound ')
        SequenceObject[SeqEnd+1]:Set('Appearance', '[[Switch_Off_png]]')
        Sequence_Defo(SequenceObject, SeqEnd+1)
        SequenceObject[SeqEnd+1]:Set('AUTOSTART', 'No')
        SequenceObject[SeqEnd+1]:Set('AUTOSTOP', 'No')
        SequenceObject[SeqEnd+1]:Set('TRACKING', 'No')
        SequenceObject[SeqEnd+1]:Set('PRIORITY', 'HTP')
        SequenceObject[SeqEnd+1]:Set('SOFTLTP', 'No')

        SequenceObject[SeqEnd+1]:Insert()
        SequenceObject[SeqEnd+1][3]:Set('No', 1)
        SequenceObject[SeqEnd+1][3]:Create(1)
        SequenceObject[SeqEnd+1][3][1]:Set('Appearance' , '[[switch_On_png]]')
        SequenceObject[SeqEnd+1][3][1]:Set('Command' , "Go+ DataPool "..Construct_Pool.. " Sequence 'Sound*'" )
        SequenceObject[SeqEnd+1]:Insert()
        SequenceObject[SeqEnd+1][4]:Set('No', 2)
        SequenceObject[SeqEnd+1][4]:Create(1)
        SequenceObject[SeqEnd+1][4][1]:Set('Appearance' , '[[Switch_Off_png]]')
        SequenceObject[SeqEnd+1][4][1]:Set('Command' , "Off DataPool "..Construct_Pool.. " Sequence 'Sound*'" )

    SeqNum = SeqEnd + 5
    SeqEnd = SeqNum + 10
    TypeSel = 1

    for i = SeqNum, SeqEnd, 1 do
        Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', ' RecepieSound ' .. Sound_Type[TypeSel])
        Sequence_Defo(SequenceObject, i)
        SequenceObject[i]:Set('AUTOSTART', 'No')
        SequenceObject[i]:Set('AUTOSTOP', 'No')
        SequenceObject[i]:Set('TRACKING', 'No')
        SequenceObject[i]:Set('PRIORITY', 'HTP')
        SequenceObject[i]:Set('SOFTLTP', 'No')

        SequenceObject[i]:Insert()
        SequenceObject[i][3]:Set('No', 1)
        SequenceObject[i][3]:Create(1)
        SequenceObject[i][3][1]:Insert()
        SequenceObject[i][3][1]:Create(1)
        SequenceObject[i][3][1][1]:Set('SelectionMode', 'Strict')
        SequenceObject[i][3][1][1]:Set('Enabled', 'Yes')
        SequenceObject[i][3][1]:Insert()
        SequenceObject[i][3][1][2]:Set('SelectionMode', 'Strict')
        SequenceObject[i][3][1][2]:Set('Enabled', 'Yes')
        SequenceObject[i][3][1]:Insert()
        SequenceObject[i][3][1][3]:Set('SelectionMode', 'Strict')
        SequenceObject[i][3][1][3]:Set('Enabled', 'Yes')

        TypeSel = TypeSel + 1
    end
    SeqNum = SeqEnd + 6
    SeqEnd = SeqNum + 11
    TypeSel = 1
end

local function main()
    local Construct_Pool = 5
    Build_Seq(Construct_Pool)
end
return main
