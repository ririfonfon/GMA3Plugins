local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

fonction Create_Appear_Seq(tln,nl,sgn,mcl,rx,ly,lh,ac,an,sao)

local TLayNr = tln
local NaLay = nl
local TCol
local SelectedGelNr = sgn
local MaxColLgn = mcl
local LayX
local RefX = rx
local col_count
local LayY = ly
local LayH = lh
local AppCrea = ac
local AppNr = an
local StAppOn = sao

    -- Create new Layout View
     Cmd("Store Layout " .. TLayNr .. " \"" .. NaLay .. "")
     -- end

     TCol = ColPath:Children()[SelectedGelNr]
     MaxColLgn = tonumber(MaxColLgn)

     for g in ipairs(SelectedGrp) do

         LayX = RefX
         col_count = 0
         LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

         if (AppCrea == 0) then
             AppNr = Maf(AppNr);
             Cmd("Store App " .. AppNr .. " \"Label\" Appearance=" .. StAppOn .. " color=\"0,0,0,1\"")
         end

         NrAppear = Maf(AppNr + 1)
         NrNeed = Maf(AppNr + 1)

         Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
         Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Action=0 Appearance=" .. AppNr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0")

         LayNr = Maf(LayNr + 1)
         LayX = Maf(LayX + LayW + 20)

         for col in ipairs(TCol) do
             col_count = col_count + 1
             StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
             StColName = TCol[col].name
             StringColName = string.gsub( StColName," ","_" )
             ColNr = SelectedGelNr .. "." .. TCol[col].no

             -- Cretae Appearances only 1 times
             if (AppCrea == 0) then
                 StAppNameOn = "\"" .. StringColName .. " on\""
                 StAppNameOff = "\"" .. StringColName .. " off\""
                 Cmd("Store App " .. NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
                 NrAppear = Maf(NrAppear + 1);
                 Cmd("Store App " .. NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
                 NrAppear = Maf(NrAppear + 1);
             end
             -- end Appearances
             E("NrAppear ")
             E(NrAppear)

             -- Create Sequences
             GrpNo = SelectedGrpNo[g]
             GrpNo = string.gsub( GrpNo,"'","" )
             Cmd("clearall")
             Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .. "")
             Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
             Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
             Cmd("Assign Group " .. GrpNo .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
             -- Add Cmd to Squence
             Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed .. "\"")
             Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
             Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
             Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
             Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
             Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
             Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
             Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
             -- end Sequences

             -- Add Squences to Layout
             Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
             Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

             NrNeed = Maf(NrNeed + 2); -- Set App Nr to next color

             if (col_count ~= MaxColLgn) then
                 LayX = Maf(LayX + LayW + 20)
             else
                 LayX = RefX
                 LayX = Maf(LayX + LayW + 20)
                 LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
                 LayY = Maf(LayY - LayH)
                 col_count = 0
             end

             LayNr = Maf(LayNr + 1)
             CurrentSeqNr = Maf(CurrentSeqNr + 1)
         end
         -- end Squences to Layout

         AppCrea = 1
         LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
     end
end