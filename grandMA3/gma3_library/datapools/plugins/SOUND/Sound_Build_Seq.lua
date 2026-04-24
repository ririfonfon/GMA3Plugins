--[[
    Releases:
    * 0.0.0.1
    Created by Richard Fontaine "RIRI", April 2026.
--]]

function SOUND_Sequence_Defo(SequenceObject, i)
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

function SOUND_Build_Seq(Construct_Pool, SeqNum, All_4_NrStart, Grp_Start, Fid, prefix)
    local Sound_Type     = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }
    local TypeSel        = 1
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local Preset4Object  = Root().ShowData.DataPools[Construct_Pool].PresetPools[24]
    local GroupObject    = Root().ShowData.DataPools[Construct_Pool].Groups
    if prefix == 'B' then
        Grp_Start = Grp_Start + 13
        Fid = Fid + 11
        All_4_NrStart = All_4_NrStart + 12
        SeqNum = SeqNum + 123
    end
    local SeqEnd         = SeqNum + 10
    local inc = 0
    for i = Grp_Start, Grp_Start + 10 do
        GroupObject:Create(i)
        GroupObject[i]:Set('Name', prefix .. 'Sound ' .. Sound_Type[TypeSel])
        Cmd("AutoCreate Fixture " ..
            Fid + inc .. " At DataPool " .. Construct_Pool .. " Group " .. i .. " /All /NoConfirmation ")
        GroupObject[i]:Set('Mode', 'Positive')
        TypeSel = TypeSel + 1
        inc = inc + 1
    end
    GroupObject:Create(Grp_Start + 11)
    Cmd("AutoCreate Fixture " ..
        Fid ..
        "Thru" .. Fid + 10 .. "At DataPool " .. Construct_Pool .. " Group " .. Grp_Start + 11 .. " /All /NoConfirmation ")
    GroupObject[Grp_Start + 11]:Set('Mode', 'Negative')
    GroupObject[Grp_Start + 11]:Set('Name', prefix .. 'MASTER ALL SOUND')
    TypeSel = 1

    for i = All_4_NrStart, All_4_NrStart + 10 do
        Preset4Object:Create(i)
        Preset4Object[i]:Set('Name', prefix .. 'Sound ' .. Sound_Type[TypeSel])
        Cmd("SelectFixtures DataPool " .. Construct_Pool .. " Group " .. GroupObject[i].No)
        Cmd(" Attribute 'Dimmer' At SoundChannel '" .. Sound_Type[TypeSel] .. "'")
        Cmd("Store " .. Preset4Object[i] .. " /Merge")
        TypeSel = TypeSel + 1
    end
    Cmd("ClearAll")
    TypeSel = 1

    for i = SeqNum, SeqEnd, 1 do
        SOUND_Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', 'Sound ' .. Sound_Type[TypeSel])
        SOUND_Sequence_Defo(SequenceObject, i)
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

    SOUND_Check_Size_Pool(SeqEnd + 1, SequenceObject)
    SequenceObject:Create(SeqEnd + 1)
    local Seq_On_Off = SeqEnd + 1
    SequenceObject[SeqEnd + 1]:Set('Name', prefix .. 'On_Off Sound ')
    SequenceObject[SeqEnd + 1]:Set('Appearance', '[[Switch_Off_png]]')
    SOUND_Sequence_Defo(SequenceObject, SeqEnd + 1)
    SequenceObject[SeqEnd + 1]:Set('AUTOSTART', 'No')
    SequenceObject[SeqEnd + 1]:Set('AUTOSTOP', 'No')
    SequenceObject[SeqEnd + 1]:Set('TRACKING', 'No')
    SequenceObject[SeqEnd + 1]:Set('PRIORITY', 'HTP')
    SequenceObject[SeqEnd + 1]:Set('SOFTLTP', 'No')

    SequenceObject[SeqEnd + 1]:Insert()
    SequenceObject[SeqEnd + 1][3]:Set('No', 1)
    SequenceObject[SeqEnd + 1][3]:Create(1)
    SequenceObject[SeqEnd + 1][3][1]:Set('Appearance', '[[switch_On_png]]')
    SequenceObject[SeqEnd + 1][3][1]:Set('Command', "Go+ DataPool " .. Construct_Pool .. " Sequence 'Sound*'")
    SequenceObject[SeqEnd + 1]:Insert()
    SequenceObject[SeqEnd + 1][4]:Set('No', 2)
    SequenceObject[SeqEnd + 1][4]:Create(1)
    SequenceObject[SeqEnd + 1][4][1]:Set('Appearance', '[[Switch_Off_png]]')
    SequenceObject[SeqEnd + 1][4][1]:Set('Command', "Off DataPool " .. Construct_Pool .. " Sequence 'Sound*'")

    SeqNum = SeqEnd + 2
    SeqEnd = SeqNum + 10
    TypeSel = 1

    for i = SeqNum, SeqEnd, 1 do
        SOUND_Check_Size_Pool(i, SequenceObject)
        SequenceObject:Create(i)
        SequenceObject[i]:Set('Name', prefix .. 'RecepieSound ' .. Sound_Type[TypeSel])
        SOUND_Sequence_Defo(SequenceObject, i)
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
    for k = 1, 9, 1 do
        SeqNum = SeqEnd + 1
        SeqEnd = SeqNum + 10
        TypeSel = 1
        for i = SeqNum, SeqEnd, 1 do
            SOUND_Check_Size_Pool(i, SequenceObject)
            SequenceObject:Create(i)
            SequenceObject[i]:Set('Name', prefix .. "MEM_" .. k .. "_RecepieSound " .. Sound_Type[TypeSel])
            SOUND_Sequence_Defo(SequenceObject, i)
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
    end
    return Seq_On_Off
end
