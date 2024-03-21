--[[
    Releases:
    * 1.1.9.0

    Created by Richard Fontaine "RIRI", March 2024.
    --]]

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

function Create_Matricks(MatrickNrStart, prefix, NaLay, SelectedGrp, SelectedGrpName, MatrickNr)
    Cmd('Store MAtricks ' .. MatrickNrStart .. ' /nu')
    Cmd('Set Matricks ' .. MatrickNrStart .. ' name = ' .. prefix .. NaLay .. ' /nu')
    MatrickNr = math.floor(MatrickNrStart + 1)
    for g in pairs(SelectedGrp) do
        Cmd('Store MAtricks ' .. MatrickNr .. ' /nu')
        Cmd('Set Matricks ' .. MatrickNr .. ' name = ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') .. ' /nu')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeFromx" 0')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeFromy" 0')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeFromz" 0')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeTox" 0')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeToy" 0')
        Cmd('Set Matricks ' .. MatrickNr .. ' Property "FadeToz" 0')
        MatrickNr = math.floor(MatrickNr + 1)
    end
    do return 1, MatrickNr end
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
    local LastSeqColor
    local ColLgnCount = 0

    for g in ipairs(SelectedGrp) do
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!
        NrAppear = math.floor(AppNr + 1)
        NrNeed = math.floor(AppNr + 1)
        Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " Action=0 Appearance=" .. AppNr ..
            " PosX " .. LayX .. " PosY " .. LayY ..
            " PositionW " .. LayW .. " PositionH " .. LayH ..
            " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilitySelectionRelevance=1")
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
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
                " property appearance <Default> PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
            NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color
            if (col_count ~= MaxColLgn) then
                LayX = math.floor(LayX + LayW + 20)
            else
                LayX = RefX
                LayX = math.floor(LayX + LayW + 20)
                LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
                LayY = math.floor(LayY - LayH)
                col_count = 0
                if (g == 1) then ColLgnCount = math.floor(ColLgnCount + 1) end
            end
            LayNr = math.floor(LayNr + 1)
            LastSeqColor = CurrentSeqNr
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end COLOR SEQ
        -- add matrick group
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign MaTricks ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') ..
            ' At Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
            ' cue 1 part 0.1 ;  Assign Sequence ' .. CurrentSeqNr + 1 .. ' At Layout ' .. TLayNr .. '.' .. LayNr)
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[2].Nr)
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " PosX " .. LayX .. " PosY " .. LayY ..
            " PositionW " .. LayW - 35 .. " PositionH " .. LayH - 35 ..
            " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') ..
            '\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. "Tricksh" ..
            SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign MaTricks ' .. MatrickNrStart ..
            ' At Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
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
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname= 0 VisibilityBar=0 VisibilityIndicatorBar=0')
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- FirstSeqColor = CurrentSeqNr
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    end                              -- end GRP
    do return 1, LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr, ColLgnCount end
end                                  -- end Create_Appearances_Sequences

function Create_Fade_Sequences(MakeX, FirstSeqTime, LastSeqTime, CurrentSeqNr, CurrentMacroNr, prefix, surfix,
                               First_Id_Lay, LayNr, MatrickNrStart, TLayNr, Fade_Element, Argument_Fade,
                               AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element, a)
    -- Setup Fade seq
    if MakeX then
        FirstSeqTime = CurrentSeqNr
        First_Id_Lay[37] = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 5)
    else
        FirstSeqTime = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 4)
    end
    -- Create Macro Time Input
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Time Input' .. surfix[a] .. '')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    Cmd('Insert')
    if MakeX then
        Cmd('set 1 Command=\'off seq ' ..
            FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
        Fade_Element = math.floor(LayNr + 3)
    else
        Cmd('set 1 Command=\'off seq ' ..
            First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    end
    Cmd('Insert')
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 3 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 4 Command=\'SetUserVariable "LC_Fonction" 1')
    Cmd("Insert")
    Cmd('set 5 Command=\'SetUserVariable "LC_Axes" "' .. a .. '"')
    Cmd("Insert")
    Cmd('set 6 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    Cmd("Insert")
    Cmd('set 7 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    Cmd("Insert")
    Cmd('set 8 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    Cmd("Insert")
    Cmd('set 9 Command=\'Call Plugin "LC_View"')
    Cmd('ChangeDestination Root')
    if a == 1 then
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[1].name .. surfix[a] .. '\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[1].Nr)
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[1].name .. surfix[a] ..
            '\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr ..
            ' ; set seq ' ..
            SeqNrStart .. ' thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[2].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')

        LayNr = math.floor(LayNr + 1)
        Command_Title('Ex.Time', LayNr, TLayNr, LayX, LayY, 700, 140, 1)
        LayNr = math.floor(LayNr + 1)
        Command_Title('FADE', LayNr, TLayNr, LayX, LayY, 700, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', LayNr, TLayNr, LayX, LayY, 700, 140, 3)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end

    for i = 2, 6 do
        local ia = tonumber(i * 2 - 1)
        local ib = tonumber(i * 2)
        if i == 2 then
            if a == 1 then
                First_Id_Lay[1] = math.floor(LayNr)
                First_Id_Lay[2] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[3] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[4] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[1]
        end
        -- Create Sequences
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[i].name .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 6 then
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[i].name .. surfix[a] ..
                '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
        else
            Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
                LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element)
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Fade[i].name .. surfix[a] ..
                '\' Property Command=\'Go Macro ' .. CurrentMacroNr + i - 1 .. '')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences

        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Seq ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_F_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences FADE
    do return 1, CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay, Fade_Element end
end     -- end Create_Fade_Sequences

function Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                                     AppImp, CurrentMacroNr, FirstSeqDelayFrom, LastSeqDelayFrom, a, MatrickNrStart,
                                     TLayNr, Delay_F_Element, MatrickNr, MakeX, LayX, LayY, LayW, LayH, Delay_T_Element)
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 11)
        local ib = tonumber(i * 2 + 12)
        if i == 1 then
            if a == 1 then
                First_Id_Lay[5] = math.floor(LayNr)
                First_Id_Lay[6] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[7] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[8] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[5]
        end
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Delay[i].name .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Delay[i].name .. surfix[a] ..
                '\' Property Command=\'Go Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. Argument_Delay[i].name .. surfix[a] ..
                '\' Property Command=\'off seq ' ..
                FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
                ' ; Set Matricks ' ..
                MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call Plugin "LC_View" ')
        end
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- Add Squences to Layout
        if MakeX then
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
                " property appearance <default> PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_T_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayFrom
    do return 1, Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr end
end     --Create_Delay_From_Sequences

function Command_Title(title, LayNr, TLayNr, LayX, LayY, Pw, Ph, align)
    Cmd('Store Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextText=\' ' .. title .. ' \'')
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextSize \'24')
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Top')
    if (align == 1) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    elseif (align == 2) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Center')
    elseif (align == 3) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Right')
    elseif (align == 4) then
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Bottom')
    end
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property VisibilityBorder \'0')
    Cmd('Set Layout ' ..
        TLayNr ..
        '.' .. LayNr .. ' Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. Pw .. ' PositionH ' .. Ph .. '')
end -- end function Command_Title(...)

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

function AddAllColor(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW, LayH, SelectedGelNr, MaxColLgn,
                     RefX)
    local col_count = 0
    local First_All_Color
    for col in ipairs(TCol) do
        col_count = col_count + 1
        -- local StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        local StColName = TCol[col].name
        local StringColName = string.gsub(StColName, " ", "_")
        -- local ColNr = SelectedGelNr .. "." .. TCol[col].no

        if col == 1 then
            First_All_Color = '' .. prefix .. 'ALL' .. StringColName .. 'ALL\''
        end
        Cmd("ClearAll /nu")
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. NrNeed + 1)
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \'' .. prefix .. 'ALL' .. StringColName .. '' ..
            'ALL\' Property Command=\'Go+ Sequence \'' .. prefix .. StringColName .. '*')
        Cmd('set seq ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " property appearance <default> PosX " .. LayX .. " PosY " .. LayY ..
            " PositionW " .. LayW .. " PositionH " .. LayH ..
            " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

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
end -- end function AddAllColor

--end LC_Cmd.lua
