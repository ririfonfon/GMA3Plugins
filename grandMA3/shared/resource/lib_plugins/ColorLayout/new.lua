local ArgumentFade = {
    {name = 'ExecTime',   AppFade = AppImp[1].Nr,     UseExTime = 1,     FadeTime = 0},
    {name = 'Time 0',     AppFade = AppImp[3].Nr,     UseExTime = 0,     FadeTime = 0},
    {name = 'Time 1',     AppFade = AppImp[5].Nr,     UseExTime = 0,     FadeTime = 1},
    {name = 'Time 2',     AppFade = AppImp[7].Nr,     UseExTime = 0,     FadeTime = 2},
    {name = 'Time 4',     AppFade = AppImp[9].Nr,     UseExTime = 0,     FadeTime = 4},
    {name = 'Time Input', AppFade = AppImp[11].Nr,    UseExTime = 0,     FadeTime = 0}
}       
       
       
       
       -- Create Sequences 
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. Argument_Fade[k].name .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \"CueZero\' Property Command=\'Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. Argument_Fade[k].AppFade .. '\'')
        if k == 1 then
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. Argument_Fade[k].name .. '\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime='.. Argument_Fade[k].UseExTime .. '')
        elseif k == 6 then        
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. Argument_Fade[k].name .. '\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. Argument_Fade[k].name .. '\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime='.. Argument_Fade[k].UseExTime .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" '.. Argument_Fade[k].FadeTime ..' ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" '.. Argument_Fade[k].FadeTime ..'')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \"OffCue\' Property Command=\'Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Appearance=' .. Argument_Fade[k+1].AppFade .. '\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0')
        Cmd('set seq ' .. CurrentSeqNr .. ' Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0')
        Cmd('set seq ' .. CurrentSeqNr .. ' OutputFilter="" Priority=0 SoftLTP=1 PlaybackMaster="" XfadeMode=0')
        Cmd('set seq ' .. CurrentSeqNr .. ' RateMaster="" RateScale=0 SpeedMaster="" SpeedScale=0 SpeedfromRate=0')
        Cmd('set seq ' .. CurrentSeqNr .. ' InputFilter="" SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0')
        Cmd('set seq ' .. CurrentSeqNr .. ' SequMIB=0 SequMIBMode=1')
        -- end Sequences

        -- Add Squences to Layout
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' appearance=' .. Argument_Fade[k+1].AppFade .. ' PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. LayW .. ' PositionH ' .. LayH .. ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')

        LayX = Maf(LayX + LayW + 20)
        LayNr = Maf(LayNr + 1)
        CurrentSeqNr = Maf(CurrentSeqNr + 1)
        -- end Sequences