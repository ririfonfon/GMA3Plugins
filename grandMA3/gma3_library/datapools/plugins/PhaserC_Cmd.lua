--[[
Releases:
* 1.1.8.1

Created by Richard Fontaine "RIRI", February 2024.
--]]

function Command_Ext_Suite(CurrentSeqNr)
    Cmd('set seq ' .. CurrentSeqNr .. ' property prefercueappearance=on')
    Cmd('set seq ' .. CurrentSeqNr .. ' AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0')
    Cmd('set seq ' ..
        CurrentSeqNr .. ' Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' OutputFilter="" Priority=0 SoftLTP=1 PlaybackMaster="" XfadeMode=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' RateMaster="" RateScale=0 SpeedMaster="" SpeedScale=0 SpeedfromRate=0')
    Cmd('set seq ' ..
        CurrentSeqNr ..
        ' InputFilter="" SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0')
    Cmd('set seq ' .. CurrentSeqNr .. ' SequMIB=0 SequMIBMode=1')
end -- end function Command_Ext_Suite(...)

function Command_Title(title, LayNr, TLayNr, LayX, LayY, Pw, Ph, align)
    Cmd('Store Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextText=\' ' .. title .. ' \'')
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextSize \'24')
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Top')
    if (align == 1) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentH \'Left')
    elseif (align == 2) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentH \'Center')
    elseif (align == 3) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentH \'Right')
    elseif (align == 4) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentH \'Left')
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property CustomTextAlignmentV \'Bottom')
    end
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. 'Property VisibilityBorder \'0')
    Cmd('Set Layout ' ..
        TLayNr ..
        '.' .. LayNr .. 'Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. Pw .. ' PositionH ' .. Ph .. '')
end -- end function Command_Title(...)

function AddAllColor(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW, LayH, SelectedGelNr, MaxColLgn,
                     RefX)
    local col_count = 0
    local First_All_Color
    for col in ipairs(TCol) do
        col_count = col_count + 1
        local StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        local StColName = TCol[col].name
        local StringColName = string.gsub(StColName, " ", "_")
        local ColNr = SelectedGelNr .. "." .. TCol[col].no

        if col == 1 then
            First_All_Color = '' .. prefix .. 'ALL' .. StringColName .. 'ALL\''
        end
        Cmd("ClearAll /nu")
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. NrNeed + 1)
        Cmd('set seq ' ..
            CurrentSeqNr ..
            ' cue \'' ..
            prefix ..
            'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\'Go+ Sequence \'' .. prefix .. StringColName .. '*')
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " ..
            TLayNr ..
            "." ..
            LayNr ..
            " property appearance <default> PosX " ..
            LayX ..
            " PosY " ..
            LayY ..
            " PositionW " ..
            LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

        if (col_count ~= MaxColLgn) then
            LayX = math.floor(LayX + LayW + 20)
        else
            LayX = RefX
            LayX = math.floor(LayX + LayW + 20)
            LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
            LayY = math.floor(LayY - LayH)
            col_count = 0
        end

        NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    do return 1, LayNr, LayX, First_All_Color end
end -- end function AddAllColor(...)

function CheckSymbols(displayHandle, Img, ImgImp, check, add_check, long_imgimp, ImgNr)
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
            title = "Select a disk to import on & off symbols",
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
        Cmd("select Drive " .. selectedDrive .. "")

        -- Import Symbols
        for k in pairs(ImgImp) do
            if (check[k] == nil) then
                ImgNr = math.floor(ImgNr + 1);
                Cmd("Store Image 2." ..
                    ImgNr ..
                    " " ..
                    ImgImp[k].Name .. " Filename=" .. ImgImp[k].FileName .. " filepath=" .. ImgImp[k].Filepath .. "")
            end
        end
    end
end -- end function CheckSymbols(...)

function Make_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
                          Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
                          Wings_Element, MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr + 1 .. ' \'' .. prefix .. surfix[a] .. '_Reset\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr + 1 .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 2 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 3 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 4 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 5 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 6 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[a] .. '" None')
    Cmd('Insert')
    Cmd('set 7 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Group" None')
    Cmd('Insert')
    Cmd('set 8 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Block" None')
    Cmd('Insert')
    Cmd('set 9 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Wings" None')
    Cmd('Insert')
    Cmd('set 10 Command=\'Off Sequence ' .. First_Id_Lay[a + 1] .. ' Thru ' .. First_Id_Lay[a + 1] + 4)
    Cmd('Insert')
    Cmd('set 11 Command=\'Off Sequence ' .. First_Id_Lay[a + 5] .. ' Thru ' .. First_Id_Lay[a + 5] + 4)
    Cmd('Insert')
    Cmd('set 12 Command=\'Off Sequence ' .. First_Id_Lay[a + 9] .. ' Thru ' .. First_Id_Lay[a + 9] + 4)
    Cmd('Insert')
    Cmd('set 13 Command=\'Off Sequence ' .. First_Id_Lay[a + 13])
    Cmd('Insert')
    Cmd('set 14 Command=\'Off Sequence ' .. First_Id_Lay[a + 17] .. ' Thru ' .. First_Id_Lay[a + 17] + 4)
    Cmd('Insert')
    Cmd('set 15 Command=\'Off Sequence ' .. First_Id_Lay[a + 21] .. ' Thru ' .. First_Id_Lay[a + 21] + 4)
    Cmd('Insert')
    Cmd('set 16 Command=\'Off Sequence ' .. First_Id_Lay[a + 25] .. ' Thru ' .. First_Id_Lay[a + 25] + 4)
    Cmd('Insert')
    Cmd('set 17 Command=\'Off Sequence ' .. CurrentSeqNr + 1)
    Cmd("Insert")
    Cmd('set 18 Command=\'SetUserVariable "LC_Fonction" 1')
    Cmd("Insert")
    Cmd('set 19 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 20 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 21 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    Cmd("Insert")
    Cmd('set 22 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 23 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 24 Command=\'SetUserVariable "LC_Fonction" 2')
    Cmd("Insert")
    Cmd('set 25 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 26 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 27 Command=\'SetUserVariable "LC_Element" ' .. Delay_F_Element .. '')
    Cmd("Insert")
    Cmd('set 28 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 29 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 30 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 31 Command=\'SetUserVariable "LC_Fonction" 3')
    Cmd("Insert")
    Cmd('set 32 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 33 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 34 Command=\'SetUserVariable "LC_Element" ' .. Delay_T_Element .. '')
    Cmd("Insert")
    Cmd('set 35 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 36 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 37 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 38 Command=\'SetUserVariable "LC_Fonction" 4')
    Cmd("Insert")
    Cmd('set 39 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 40 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 41 Command=\'SetUserVariable "LC_Element" ' .. Phase_Element .. '')
    Cmd("Insert")
    Cmd('set 42 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 43 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 44 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 45 Command=\'SetUserVariable "LC_Fonction" 5')
    Cmd("Insert")
    Cmd('set 46 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 47 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 48 Command=\'SetUserVariable "LC_Element" ' .. Group_Element .. '')
    Cmd("Insert")
    Cmd('set 49 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 50 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 51 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 52 Command=\'SetUserVariable "LC_Fonction" 6')
    Cmd("Insert")
    Cmd('set 53 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 54 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 55 Command=\'SetUserVariable "LC_Element" ' .. Block_Element .. '')
    Cmd("Insert")
    Cmd('set 56 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 57 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 58 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 59 Command=\'SetUserVariable "LC_Fonction" 7')
    Cmd("Insert")
    Cmd('set 60 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 61 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 62 Command=\'SetUserVariable "LC_Element" ' .. Wings_Element .. '')
    Cmd("Insert")
    Cmd('set 63 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 64 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 65 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end -- end function Make_Macro_Reset(...)

function Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr,
                                 LayNr, MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'DelayFrom Input\'' .. surfix[a] .. '"')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    Cmd("Insert")
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                               MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'DelayTo Input\'' .. surfix[a] .. '"')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    Cmd("Insert")
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, fonct, TLayNr, LayNr, MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Phase Input\'' .. surfix[a] .. "'")
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "PhaseFrom' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "PhaseTo' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Group Input\'' .. surfix[a] .. '"')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    Cmd('Insert')
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Group" ')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Block Input\'' .. surfix[a] .. '"')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    Cmd('Insert')
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Block" ')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeq, LastSeq, MatrickNrStart, fonct, TLayNr, LayNr,
                            MatrickNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Wings Input' .. surfix[a] .. '"')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    Cmd('set 1 Command=\'off seq ' .. FirstSeq .. ' thru ' .. LastSeq .. ' - ' .. LastSeq .. '')
    Cmd('Insert')
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] .. 'Wings" ')
    Cmd("Insert")
    Cmd('set 3 Command=\'SetUserVariable "LC_Fonction" ' .. fonct .. '')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Element" ' .. LayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime, LastSeqTime, CurrentSeqNr,
                             SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element)
    Cmd('Store Macro ' .. CurrentMacroNr + i - 1 .. ' \'' .. prefix .. Argument_Fade[i].name .. surfix[a] .. '')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr + i - 1 .. '')
    Cmd('Insert')
    Cmd('set  1 Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. '')
    Cmd('Insert')
    Cmd('set  2 Command=\'set seq ' ..
        SeqNrStart .. ' thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[i].UseExTime .. '')
    Cmd('Insert')
    Cmd('set  3 Command=\'Set Matricks ' ..
        MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '" ' .. Argument_Fade[i].Time .. '')
    Cmd('Insert')
    Cmd('set  4 Command=\'Set Matricks ' ..
        MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '" ' .. Argument_Fade[i].Time .. '')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Fonction" 1')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 10 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
end

function Add_Macro_Call(a, TLayNr, Fade_Element, MatrickNrStart, Delay_F_Element, Delay_T_Element, Phase_Element,
                        Group_Element, Block_Element, Wings_Element)
    Cmd("Insert")
    Cmd('set 33 Command=\'SetUserVariable "LC_Fonction" 1')
    Cmd("Insert")
    Cmd('set 34 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 35 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 36 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    Cmd("Insert")
    Cmd('set 37 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 38 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 39 Command=\'SetUserVariable "LC_Fonction" 2')
    Cmd("Insert")
    Cmd('set 40 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 41 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 42 Command=\'SetUserVariable "LC_Element" ' .. Delay_F_Element .. '')
    Cmd("Insert")
    Cmd('set 43 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 44 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 45 Command=\'SetUserVariable "LC_Fonction" 3')
    Cmd("Insert")
    Cmd('set 46 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 47 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 48 Command=\'SetUserVariable "LC_Element" ' .. Delay_T_Element .. '')
    Cmd("Insert")
    Cmd('set 49 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 50 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 51 Command=\'SetUserVariable "LC_Fonction" 4')
    Cmd("Insert")
    Cmd('set 52 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 53 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 54 Command=\'SetUserVariable "LC_Element" ' .. Phase_Element .. '')
    Cmd("Insert")
    Cmd('set 55 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 56 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 57 Command=\'SetUserVariable "LC_Fonction" 5')
    Cmd("Insert")
    Cmd('set 58 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 59 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 60 Command=\'SetUserVariable "LC_Element" ' .. Group_Element .. '')
    Cmd("Insert")
    Cmd('set 61 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 62 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 63 Command=\'SetUserVariable "LC_Fonction" 6')
    Cmd("Insert")
    Cmd('set 64 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 65 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 66 Command=\'SetUserVariable "LC_Element" ' .. Block_Element .. '')
    Cmd("Insert")
    Cmd('set 67 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 68 Command=\'Call Plugin "LC_View"')
    Cmd("Insert")
    Cmd('set 69 Command=\'SetUserVariable "LC_Fonction" 7')
    Cmd("Insert")
    Cmd('set 70 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 71 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 72 Command=\'SetUserVariable "LC_Element" ' .. Wings_Element .. '')
    Cmd("Insert")
    Cmd('set 73 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 74 Command=\'Call Plugin "LC_View"')
end

function Create_Appear_Tricks(AppTricks, AppNr, prefix)
    for q in pairs(AppTricks) do
        AppTricks[q].Nr = math.floor(AppNr)
        Cmd('Store App ' ..
            AppTricks[q].Nr ..
            ' "' ..
            prefix .. AppTricks[q].Name .. '" "Appearance"=' .. AppTricks[q].StApp .. '' .. AppTricks[q].RGBref .. '')
        AppNr = math.floor(AppNr + 1)
    end
    do return 1, AppNr, AppTricks end
end

function Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName)
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    for g in ipairs(SelectedGrp) do
        AppNr = math.floor(AppNr);
        Cmd('Store App ' .. AppNr .. ' \'' .. prefix .. ' Label\' Appearance=' .. StAppOn .. ' color=\'0,0,0,1\'')
        NrAppear = math.floor(AppNr + 1)
        for col in ipairs(TCol) do
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            StColName = TCol[col].name
            StringColName = string.gsub(StColName, " ", "_")
            StAppNameOn = "\"" .. prefix .. StringColName .. " on\""
            StAppNameOff = "\"" .. prefix .. StringColName .. " off\""
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
        end
    end
    do return 1, NrAppear end
end

function Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current)
    Cmd("ClearAll /nu")
    Cmd('Set Preset 25 Property PresetMode "Universal"')
    Cmd('Fixture Thru')
    for col in ipairs(TCol) do
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        Cmd('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        Cmd('Store Preset 25.' .. All_5_Current .. '')
        Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. StringColName .. " ")
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end
    do return 1, All_5_NrEnd, All_5_Current end
end

function Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr, SelectedGrp, RefX, LayY, LayH, NrAppear, AppNr,
                                      NrNeed, TLayNr, LayW, LayNr, CurrentSeqNr, MaxColLgn, TCol, SelectedGrpNo, prefix,
                                      All_5_NrStart, MatrickNrStart, SelectedGrpName, AppTricks)
    for g in ipairs(SelectedGrp) do
        local ColLgnCount = 0
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!
        NrAppear = math.floor(AppNr + 1)
        NrNeed = math.floor(AppNr + 1)
        Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
        Cmd("Set Layout " ..
            TLayNr ..
            "." ..
            LayNr ..
            " Action=0 Appearance=" ..
            AppNr ..
            " PosX " ..
            LayX ..
            " PosY " ..
            LayY ..
            " PositionW " ..
            LayW ..
            " PositionH " ..
            LayH .. " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilitySelectionRelevance=1")
        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)
        local FirstSeqColor = CurrentSeqNr

        -- COLOR SEQ  /// Assign Values Preset 21.2 At Sequence 22 cue 1 part 0.1 /// Set Preset 25 Property'PresetMode' "Universal"
        for col in ipairs(TCol) do
            col_count = col_count + 1
            local StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            local StColName = TCol[col].name
            local StringColName = string.gsub(StColName, " ", "_")
            local ColNr = SelectedGelNr .. "." .. TCol[col].no
            -- Create Sequences
            local GrpNo = SelectedGrpNo[g]
            GrpNo = string.gsub(GrpNo, "'", "")
            Cmd("ClearAll /nu")
            -- Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .. "")
            Cmd("Store Sequence " ..
                CurrentSeqNr .. " \"" .. prefix .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
            Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            Cmd("Assign Group " .. GrpNo .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            Cmd('Assign Values Preset 25.' ..
                All_5_NrStart + col - 1 .. "At Sequence " .. CurrentSeqNr .. 'cue 1 part 0.1')
            Cmd('Assign MAtricks ' .. MatrickNrStart .. ' At Sequence ' .. CurrentSeqNr .. ' Cue 1 Part 0.1 /nu')
            Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. NrNeed)
            Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
            Command_Ext_Suite(CurrentSeqNr)
            -- Add Squences to Layout
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " ..
                TLayNr ..
                "." ..
                LayNr ..
                " property appearance <Default> PosX " ..
                LayX ..
                " PosY " ..
                LayY ..
                " PositionW " ..
                LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
            NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color
            if (col_count ~= MaxColLgn) then
                LayX = math.floor(LayX + LayW + 20)
            else
                LayX = RefX
                LayX = math.floor(LayX + LayW + 20)
                LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
                LayY = math.floor(LayY - LayH)
                col_count = 0
                ColLgnCount = math.floor(ColLgnCount + 1)
            end
            LayNr = math.floor(LayNr + 1)
            LastSeqColor = CurrentSeqNr
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end COLOR SEQ
        -- add matrick group
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('set seq ' ..
            CurrentSeqNr ..
            ' cue \'' ..
            prefix ..
            "Tricks" ..
            SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign MaTricks ' ..
            prefix ..
            SelectedGrpName[g]:gsub('\'', '') ..
            ' At Sequence ' ..
            FirstSeqColor ..
            ' Thru ' ..
            LastSeqColor ..
            ' cue 1 part 0.1 ;  Assign Sequence ' .. CurrentSeqNr + 1 .. ' At Layout ' .. TLayNr .. '.' .. LayNr)
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[2].Nr)
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " ..
            TLayNr ..
            "." ..
            LayNr ..
            " PosX " ..
            LayX ..
            " PosY " ..
            LayY ..
            " PositionW " ..
            LayW - 35 .. " PositionH " .. LayH - 35 .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') ..
            '\'')
        Cmd('set seq ' ..
            CurrentSeqNr ..
            ' cue \'' ..
            prefix ..
            "Tricksh" ..
            SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign MaTricks ' ..
            MatrickNrStart ..
            ' At Sequence ' ..
            FirstSeqColor ..
            ' Thru ' ..
            LastSeqColor ..
            ' cue 1 part 0.1 ; Assign Sequence ' .. CurrentSeqNr - 1 .. ' At Layout ' .. TLayNr .. '.' .. LayNr)
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[1].Nr)
        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW - 35 + 20)
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        Cmd('Insert')
        Cmd('set 1 Command=\'Edit Matrick ' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('ChangeDestination Root')
        Cmd('Assign Macro ' .. CurrentMacroNr .. " at layout " .. TLayNr)
        Cmd('set Macro ' .. CurrentMacroNr .. ' Property Appearance=' .. AppTricks[3].Nr)
        Cmd('Set Layout ' ..
            TLayNr ..
            '.' ..
            LayNr ..
            ' PosX ' ..
            LayX ..
            ' PosY ' ..
            LayY ..
            ' PositionW ' ..
            LayW - 35 ..
            ' PositionH ' .. LayH - 35 .. ' VisibilityObjectname= 0 VisibilityBar=0 VisibilityIndicatorBar=0')
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- FirstSeqColor = CurrentSeqNr
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    end                              -- end GRP
    do return 1, LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr end
end
