--[[
Releases:
* 2.3.2.0

Version:
* 2.2.0.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]

function LC_Check_Size_Pool(id, PoolObject)
    if not id then
        Printf('Acquire')
        return PoolObject:Acquire()
    end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then
        LC_Dialog_End('Error : wrong argument expected integer got ' .. idtype)
        error('wrong argument expected integer got ' .. idtype)
    end
    if IsObjectValid(PoolObject[id]) then
        LC_Dialog_End('Error : id is already used : ' .. id)
        error('id is already used : ' .. id)
    end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then
        LC_Dialog_End('Error : id out of range')
        error('id out of range')
    end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function LC_CheckSymbols(Img, ImgImp, check, add_check, long_imgimp, ImgNr)
    for k in pairs(Img) do
        for q in pairs(ImgImp) do
            if ('"' .. Img[k].name .. '"' == ImgImp[q].Name) then
                check[q] = 1
                add_check = math.floor(add_check + 1)
            end
            long_imgimp = q
        end
    end

    if (long_imgimp == add_check) then
        Echo("file exist")
    else
        -- Select a disk
        local drives = Root().Temp.DriveCollect
        local selectedDrive     -- users selected drive
        local options = {}      -- popup options
        local PopTableDisk = {} --
        -- grab a list of connected drives
        for i = 1, drives.count, 1 do
            table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
        end
        -- present a popup for the user choose (Internal may not work)
        PopTableDisk = {
            title = "Select a disk to import on & Off symbols",
            caller = displayHandle,
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
        CmdIndirectWait("select Drive " .. selectedDrive .. "")

        -- Import Symbols
        for k in pairs(ImgImp) do
            if (check[k] == nil) then
                ImgNr = math.floor(ImgNr + 1);
                CmdIndirectWait("Store Image 2." .. ImgNr .. " " .. ImgImp[k].Name .. " Filename=" ..
                    ImgImp[k].FileName .. " filepath=" .. ImgImp[k].Filepath .. "")
            end
        end
    end
end -- end LC_CheckSymbols

function LC_Command_Ext_Suite(CurrentSeqNr, SequenceObject)
    -- Echo('Call LC_Command_Ext_Suite ' .. CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('prefercueappearance', 'on')
    SequenceObject[CurrentSeqNr]:Set('AutoStart', '1')
    SequenceObject[CurrentSeqNr]:Set('AutoStop', '1')
    SequenceObject[CurrentSeqNr]:Set('MasterGoMode', 'None')
    SequenceObject[CurrentSeqNr]:Set('AutoFix', '0')
    SequenceObject[CurrentSeqNr]:Set('AutoStomp', '0')
    SequenceObject[CurrentSeqNr]:Set('Tracking', '0')
    SequenceObject[CurrentSeqNr]:Set('WrapAround', '1')
    SequenceObject[CurrentSeqNr]:Set('ReleaseFirstCue', '0')
    SequenceObject[CurrentSeqNr]:Set('RestartMode', '1')
    SequenceObject[CurrentSeqNr]:Set('CueCommand', '0')
    SequenceObject[CurrentSeqNr]:Set('XFadeReload', '0')
    SequenceObject[CurrentSeqNr]:Set('OutputFilter', '')
    SequenceObject[CurrentSeqNr]:Set('Priority', '0')
    SequenceObject[CurrentSeqNr]:Set('SoftLTP', '1')
    SequenceObject[CurrentSeqNr]:Set('PlaybackMaster', '')
    SequenceObject[CurrentSeqNr]:Set('XfadeMode', '0')
    SequenceObject[CurrentSeqNr]:Set('RateMaster', '')
    SequenceObject[CurrentSeqNr]:Set('RateScale', '0')
    SequenceObject[CurrentSeqNr]:Set('SpeedMaster', '')
    SequenceObject[CurrentSeqNr]:Set('SpeedScale', '0')
    SequenceObject[CurrentSeqNr]:Set('SpeedfromRate', '0')
    SequenceObject[CurrentSeqNr]:Set('InputFilter', '')
    SequenceObject[CurrentSeqNr]:Set('SwapProtect', '0')
    SequenceObject[CurrentSeqNr]:Set('KillProtect', '0')
    SequenceObject[CurrentSeqNr]:Set('IncludeLinkLastGo', '1')
    SequenceObject[CurrentSeqNr]:Set('UseExecutorTime', '0')
    SequenceObject[CurrentSeqNr]:Set('OffwhenOverridden', '0')
    SequenceObject[CurrentSeqNr]:Set('Lock', '0')
    SequenceObject[CurrentSeqNr]:Set('SequMIB', '0')
    SequenceObject[CurrentSeqNr]:Set('SequMIBMode', '1')
end -- end function LC_Command_Ext_Suite(...)

function LC_Set_Def(L_N, N, Obj)
    Obj[L_N][N.No]:Set('visibilitybar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityobjectname', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilitycid', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityvalue', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityicon', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityindicatorbar', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityselectionrelevance', 'Hidden')
    Obj[L_N][N.No]:Set('visibilityborder', 'Hidden')
    Obj[L_N][N.No]:Set('fullresolution', 'Yes')
end -- end function LC_Set_Def(L_N, N, Obj)

function LC_Sequence_Defo(SequenceObject, i)
    SequenceObject[i]:Set('PREFERCUEAPPEARANCE', 'Yes')
    SequenceObject[i]:Set('AUTOSTART', 'Yes')
    SequenceObject[i]:Set('AUTOSTOP', 'Yes')
    SequenceObject[i]:Set('MASTERGOMODE', 'None')
    SequenceObject[i]:Set('AUTOFIX', 'No')
    SequenceObject[i]:Set('AUTOSTOMP', 'No')
    SequenceObject[i]:Set('TRACKING', 'No')
    SequenceObject[i]:Set('WRAPAROUND', 'Yes')
    SequenceObject[i]:Set('RELEASEFIRSTCUE', 'No')
    SequenceObject[i]:Set('RESTARTMODE', 'First Cue')
    SequenceObject[i]:Set('CUECOMMAND', 'Enabled')
    SequenceObject[i]:Set('XFADERELOAD', 'No')
    SequenceObject[i]:Set('OUTPUTFILTER', '')
    SequenceObject[i]:Set('PRIORITY', 'LTP')
    SequenceObject[i]:Set('SOFTLTP', 'Yes')
    SequenceObject[i]:Set('PLAYBACKMASTER', 'None')
    SequenceObject[i]:Set('XFADEMODE', 'AB')
    SequenceObject[i]:Set('RATEMASTER', 'None')
    SequenceObject[i]:Set('RATESCALE', 'One')
    SequenceObject[i]:Set('SPEEDFROMRATE', 'No')
    SequenceObject[i]:Set('INPUTFILTER', '')
    SequenceObject[i]:Set('SWAPPROTECT', 'Yes')
    SequenceObject[i]:Set('KILLPROTECT', 'Yes')
    SequenceObject[i]:Set('INCLUDELINKLASTGO', 'Yes')
    SequenceObject[i]:Set('USEEXECUTORTIME', 'No')
    SequenceObject[i]:Set('OFFWHENOVERRIDDEN', 'No')
    SequenceObject[i]:Set('LOCK', 'No')
    SequenceObject[i]:Set('SEQUMIB', 'Enabled')
    SequenceObject[i]:Set('SEQUMIBMODE', 'None')

    SequenceObject[i]:Set('AUTOPREPOS', 'No')
    SequenceObject[i]:Set('SPEEDMASTER', 'None')
    SequenceObject[i]:Set('SPEEDSCALE', 'One')
    SequenceObject[i]:Set('EXECUTORDISPLAYMODE', 'Both')
    SequenceObject[i]:Set('CUEZEROMODE', 'Off')
    SequenceObject[i]:Set('ACTION', 'Pool Default')
    SequenceObject[i]:Set('TIMINGGOTO', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACK', 'Default')
    SequenceObject[i]:Set('TIMINGGOFAST', 'Default')
    SequenceObject[i]:Set('TIMINGGOBACKFAST', 'Default')
end -- end function LC_Sequence_Defo(SequenceObject, i)

function LC_Dialog_End(message)
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 800, 800
    local mybutton = dialog:Append('Button')
    mybutton.Font = 1
    mybutton.TextAutoAdjust = "Yes"
    mybutton.Text = message
end -- end function LC_Dialog_End(message)

