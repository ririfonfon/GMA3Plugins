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

function AddAllColor(TCol,CurrentSeqNr,prefix,TLayNr,LayNr,NrNeed,LayX,LayY,LayW,LayH,SelectedGelNr)
    local col_count = 0
    for col in ipairs(TCol) do
        col_count = col_count + 1
        local StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        local StColName = TCol[col].name
        local StringColName = string.gsub( StColName," ","_" )
        local ColNr = SelectedGelNr .. "." .. TCol[col].no

        -- Create Sequences
        Cmd("ClearAll /nu")
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        -- Add Cmd to Squence
        Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. prefix .. 'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\'Go+ Sequence \'' .. prefix .. StringColName ..  '*')
        Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Command_Ext_Suite(CurrentSeqNr)
        
        -- end Sequences

        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
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
end

function CheckSymbols(Img,ImgImp,check,add_check,long_imgimp,ImgNr)
    for k in pairs(Img) do
        for q in pairs(ImgImp) do
            if ('"' .. Img[k].name .. '"' == ImgImp[q].Name) then
                check[q] =  1
                add_check = Maf(add_check + 1)
            end
            long_imgimp = q
        end
    end
    
    if (long_imgimp == add_check) then    
        E("file exist")
    else
        E("file NOT exist")
        -- Select a disk
        local drives = Root().Temp.DriveCollect
        local selectedDrive -- users selected drive
        local options = {} -- popup options
        local PopTableDisk = {} -- 
        -- grab a list of connected drives
        for i = 1, drives.count, 1 do
            table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
        end
        -- present a popup for the user choose (Internal may not work)
        PopTableDisk = {
            title = "Select a disk to import on & off symbols",
            caller = display_Handle,
            items = options,
            selectedValue = "",
            add_args = {
                FilterSupport = "Yes"
            }
        }
        selectedDrive = PopupInput(PopTableDisk)
        selectedDrive = selectedDrive + 1

        -- if the user cancled then exit the plugin
        if selectedDrive == nil then
            return
        end
            
        -- grab the export path for the selected drive and append the file name
        E("selectedDrive = %s", tostring(selectedDrive))
        Cmd("select Drive " .. selectedDrive .. "")
            
        -- Import Symbols      
        for k in pairs(ImgImp) do
            
            if(check[k] == nil) then
                ImgNr = Maf(ImgNr + 1);
                E(ImgNr)
                E(k)
                Cmd("Store Image 2." .. ImgNr .. " " .. ImgImp[k].Name .. " Filename=" .. ImgImp[k].FileName .. " filepath=" .. ImgImp[k].Filepath .. "")
            end
        end
    end
end