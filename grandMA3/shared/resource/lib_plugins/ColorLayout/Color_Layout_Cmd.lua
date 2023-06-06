local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

function Command_Ext_Suite(CurrentSeqNr)
    Cmd('set seq ' .. CurrentSeqNr .. ' AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' OutputFilter="" Priority=0 SoftLTP=1 PlaybackMaster="" XfadeMode=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' RateMaster="" RateScale=0 SpeedMaster="" SpeedScale=0 SpeedfromRate=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' InputFilter="" SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' SequMIB=0 SequMIBMode=1')
end

function Command_Title(title,LayNr,TLayNr,LayX,LayY,Pw,Ph)
    Cmd('Store Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\' '.. title ..' \'')
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'24')
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
    Cmd('Set Layout '  .. TLayNr .. '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. Pw .. ' PositionH ' .. Ph .. '')
end