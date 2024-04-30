--[[
    Releases:
    * 2.0.0.8

    Created by Richard Fontaine "RIRI", April 2024.
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
end -- end CheckSymbols

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
end -- end Create_Matricks

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
end -- end Create_Appear_Tricks

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
            StAppNameOff = "\"" .. prefix .. StringColName .. " Off\""
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
        end
    end
    do return 1, NrAppear end
end -- end Create_Appearances

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
end -- end Create_Preset_25

function Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr, SelectedGrp, RefX, LayY, LayH, NrAppear, AppNr,
                                      NrNeed, TLayNr, LayW, LayNr, CurrentSeqNr, MaxColLgn, TCol, SelectedGrpNo, prefix,
                                      All_5_NrStart, MatrickNrStart, SelectedGrpName, AppTricks, Data_Pool_Nr)
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
            " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilitySelectionRelevance=1 VisibilityBorder=0")
        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)
        local FirstSeqColor = CurrentSeqNr

        -- COLOR SEQ  /// Assign Values Preset 21.2 At Sequence 22 Cue 1 part 0.1 /// Set Preset 25 Property'PresetMode' "Universal"
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
                All_5_NrStart + col - 1 .. "At Sequence " .. CurrentSeqNr .. 'Cue 1 part 0.1')
            Cmd('Assign MAtricks ' .. MatrickNrStart .. ' At Sequence ' .. CurrentSeqNr .. ' Cue 1 Part 0.1 /nu')
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. NrNeed)
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
            Command_Ext_Suite(CurrentSeqNr)
            -- Add Squences to Layout
            Cmd("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
                " Property appearance <Default> PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")
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
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign DataPool ' ..
            Data_Pool_Nr .. ' MaTricks ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') ..
            ' At DataPool ' .. Data_Pool_Nr .. ' Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
            ' Cue 1 part 0.1 ;  Assign DataPool ' ..
            Data_Pool_Nr ..
            ' Sequence ' .. CurrentSeqNr + 1 .. ' At DataPool ' .. Data_Pool_Nr .. ' Layout ' .. TLayNr .. '.' .. LayNr)
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[2].Nr)
        Cmd("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " PosX " .. LayX .. " PosY " .. LayY ..
            " PositionW " .. LayW - 35 .. " PositionH " .. LayH - 35 ..
            " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') ..
            '\'')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. "Tricksh" ..
            SelectedGrpName[g]:gsub('\'', '') ..
            '\' Property Command=\'Assign DataPool ' .. Data_Pool_Nr .. ' MaTricks ' .. MatrickNrStart ..
            ' At DataPool ' .. Data_Pool_Nr .. ' Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
            ' Cue 1 part 0.1 ; Assign DataPool ' ..
            Data_Pool_Nr ..
            ' Sequence ' .. CurrentSeqNr - 1 .. ' At DataPool ' .. Data_Pool_Nr .. ' Layout ' .. TLayNr .. '.' .. LayNr)
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[1].Nr)
        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW - 35 + 20)
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        Cmd('Insert')
        Cmd('set 1 Command=\'Edit DataPool ' ..
            Data_Pool_Nr .. ' Matrick ' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))
        Cmd('ChangeDestination Root')
        Cmd('Assign Macro ' .. CurrentMacroNr .. " at layout " .. TLayNr)
        Cmd('set Macro ' .. CurrentMacroNr .. ' Property Appearance=' .. AppTricks[3].Nr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname= 0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
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
                               AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element, a,
                               Data_Pool_Nr)
    -- Setup Fade Sequence
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
        Cmd('set 1 Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
            FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
        Fade_Element = math.floor(LayNr + 3)
    else
        Cmd('set 1 Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
            First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    end
    Cmd('Insert')
    Cmd('set 2 Command=\'Edit DataPool ' ..
        Data_Pool_Nr .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    Cmd("Insert")
    Cmd('set 3 Command=\'Edit DataPool ' ..
        Data_Pool_Nr .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
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
    Cmd('set 9 Command=\'Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View"')
    Cmd('ChangeDestination Root')
    if a == 1 then
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[1].name .. surfix[a] .. '\'')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[1].Nr)
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Fade[1].name .. surfix[a] ..
            '\' Property Command=\'Off DataPool ' ..
            Data_Pool_Nr .. ' Sequence ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr ..
            ' ; Set Sequence ' ..
            SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[2].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')

        LayNr = math.floor(LayNr + 1)
        Command_Title('Ex.Time', TLayNr, LayNr, LayX, LayY, 700, 140, 1)
        LayNr = math.floor(LayNr + 1)
        Command_Title('FADE', TLayNr, LayNr, LayX, LayY, 700, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX, LayY, 700, 140, 3)
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
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 6 then
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Fade[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
                LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Data_Pool_Nr)
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Fade[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr + i - 1 .. '')
        end
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences

        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_F_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences FADE
    do return 1, CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay, Fade_Element end
end     -- end Create_Fade_Sequences

function Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                                     AppImp, CurrentMacroNr, a, MatrickNrStart, TLayNr, Delay_F_Element, MatrickNr, MakeX,
                                     LayX, LayY, LayW, LayH, Delay_T_Element, Data_Pool_Nr)
    -- Setup DelayFrom Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 5)
    local FirstSeqDelayFrom = CurrentSeqNr
    local LastSeqDelayFrom = math.floor(CurrentSeqNr + 4)

    -- Create Macro DelayFrom Input
    Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayFrom, LastSeqDelayFrom,
        MatrickNrStart, 2, TLayNr, Delay_F_Element, MatrickNr, Data_Pool_Nr)

    if MakeX then
        Command_Title('DELAY FROM', TLayNr, LayNr, LayX, LayY, 580, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3)
        LayNr = math.floor(LayNr + 1)
    end

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
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('Set DataPool ' ..
                Data_Pool_Nr ..
                ' Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Delay[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Delay[i].name .. surfix[a] ..
                '\' Property Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
                FirstSeqDelayFrom .. ' Thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Data_Pool_Nr .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View" ')
        end
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- Add Squences to Layout
        if MakeX then
            Cmd("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
                " Property appearance <default> PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_T_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayFrom
    do return 1, Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr, CurrentMacroNr end
end     --Create_Delay_From_Sequences

function Create_Delay_To_Sequences(a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, Argument_DelayTo, surfix,
                                   MatrickNrStart, TLayNr, Delay_T_Element, MatrickNr, AppImp, LayX, LayY, LayW, LayH,
                                   Phase_Element, CurrentMacroNr, MakeX, Data_Pool_Nr)
    -- Setup DelayTo Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    local FirstSeqDelayTo = CurrentSeqNr
    local LastSeqDelayTo = math.floor(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayTo, LastSeqDelayTo, MatrickNrStart,
        3, TLayNr, Delay_T_Element, MatrickNr, Data_Pool_Nr)

    if MakeX then
        Command_Title('DELAY TO', TLayNr, LayNr, LayX, LayY, 580, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3)
        LayNr = math.floor(LayNr + 1)
    end

    for i = 1, 5 do
        local ia = tonumber(i * 2 + 21)
        local ib = tonumber(i * 2 + 22)
        if i == 1 then
            if a == 1 then
                First_Id_Lay[9] = math.floor(LayNr)
                First_Id_Lay[10] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[11] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[12] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[9]
        end
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] ..
                '\' Property Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
                FirstSeqDelayTo .. ' Thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Data_Pool_Nr .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View" ')
        end
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayTo
    do return 1, First_Id_Lay, Current_Id_Lay, LayX, LayNr, Phase_Element, CurrentSeqNr, CurrentMacroNr end
end     -- end Create_Delay_To_Sequences

function Create_Phase_Sequence(LayY, LayX, LayW, a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, CurrentMacroNr,
                               prefix, surfix, MatrickNrStart, TLayNr, Phase_Element, MatrickNr, AppImp, MakeX, LayH,
                               RefX, Group_Element, Data_Pool_Nr)
    -- Add offset for Layout Element distance
    LayY = math.floor(LayY - 150)
    LayX = RefX
    LayX = math.floor(LayX + LayW - 100)

    -- Create Macro Phase Input
    if a == 1 then
        First_Id_Lay[13] = math.floor(LayNr)
        First_Id_Lay[14] = CurrentSeqNr
    elseif a == 2 then
        First_Id_Lay[15] = CurrentSeqNr
    elseif a == 3 then
        First_Id_Lay[16] = CurrentSeqNr
    end
    Current_Id_Lay = First_Id_Lay[13]
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    Create_Macro_Phase(CurrentMacroNr, prefix, surfix, a, MatrickNrStart, 4, TLayNr, Phase_Element, MatrickNr,
        Data_Pool_Nr)

    -- Create Sequences Phase
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'Phase Input' .. surfix[a] .. '\'')
    -- Add Cmd to Squence
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[63].Nr)
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. 'Phase Input' .. surfix[a] ..
        '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[64].Nr)
    Command_Ext_Suite(CurrentSeqNr)

    -- Add Squences to Layout
    if MakeX then
        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1)
        LayNr = math.floor(LayNr + 1)
        Group_Element = math.floor(LayNr + 1)
    end
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    do return 1, Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element end
end -- end Create_Phase_Sequence

function Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, a, MatrickNrStart,
                               TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                               Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Data_Pool_Nr)
    -- Setup XGroup Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqGrp = CurrentSeqNr
    LastSeqGrp = math.floor(CurrentSeqNr + 4)
    -- Create Macro Group Input
    Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeqGrp, LastSeqGrp, MatrickNrStart, 5, TLayNr,
        Group_Element, MatrickNr, Data_Pool_Nr)

    if MakeX then
        Command_Title('GROUP', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('None', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 3)
        LayNr = math.floor(LayNr + 1)
    end
    -- Create Sequences XGroup
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 31)
        local ib = tonumber(i * 2 + 32)
        if i == 1 then
            if a == 1 then
                First_Id_Lay[17] = math.floor(LayNr)
                First_Id_Lay[18] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[19] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[20] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[17]
        end
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] ..
                '\' Property Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
                FirstSeqGrp .. ' Thru ' .. LastSeqGrp .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Data_Pool_Nr .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Group" ' .. Argument_Xgrp[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View" ')
        end
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Block_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    do
        return 1, CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp,
            FirstSeqGrp
    end
end -- end Create_Group_Sequence

function Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xblock, AppImp, Wings_Element, LayW, LayH, Data_Pool_Nr)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqBlock = CurrentSeqNr
    LastSeqBlock = math.floor(CurrentSeqNr + 4)
    -- Create Macro Block Input
    Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeqBlock, LastSeqBlock, MatrickNrStart, 6,
        TLayNr, Block_Element, MatrickNr, Data_Pool_Nr)

    if MakeX then
        Command_Title('BLOCK', TLayNr, LayNr, LayX, LayY, 580, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3)
        LayNr = math.floor(LayNr + 1)
    end
    -- Create Sequences XBlock
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 41)
        local ib = tonumber(i * 2 + 42)
        if i == 1 then
            if a == 1 then
                First_Id_Lay[21] = math.floor(LayNr)
                First_Id_Lay[22] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[23] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[24] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[21]
        end
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] .. '\'')
        -- Add Cmd to Squence
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('Set Sequence ' ..
                CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('Set Sequence ' ..
                CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] ..
                '\' Property Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
                FirstSeqBlock .. ' Thru ' .. LastSeqBlock .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Data_Pool_Nr .. ' Matricks ' .. MatrickNrStart ..
                ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View" ')
        end
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Wings_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    do
        return 1, CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock,
            LastSeqBlock
    end
end -- end Create_Block_Sequence

function Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xwings, AppImp, LayW, LayH, Data_Pool_Nr)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqWings = CurrentSeqNr
    LastSeqWings = math.floor(CurrentSeqNr + 4)
    -- Create Macro Wings Input
    Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeqWings, LastSeqWings, MatrickNrStart, 7,
        TLayNr, Wings_Element, MatrickNr, Data_Pool_Nr)

    if MakeX then
        Command_Title('WINGS', TLayNr, LayNr, LayX, LayY, 580, 140, 2)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3)
        LayNr = math.floor(LayNr + 1)
    end
    -- Create Sequences Wings
    for i = 1, 5 do
        local ia = tonumber(i * 2 + 51)
        local ib = tonumber(i * 2 + 52)
        if i == 1 then
            if a == 1 then
                First_Id_Lay[25] = math.floor(LayNr)
                First_Id_Lay[26] = CurrentSeqNr
            elseif a == 2 then
                First_Id_Lay[27] = CurrentSeqNr
            elseif a == 3 then
                First_Id_Lay[28] = CurrentSeqNr
            end
            Current_Id_Lay = First_Id_Lay[25]
        end
        Cmd('ClearAll /nu')
        Cmd('Store Sequence ' ..
            CurrentSeqNr .. ' \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] .. '\'')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        if i == 5 then
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] ..
                '\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
        else
            Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] ..
                '\' Property Command=\'Off DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
                FirstSeqWings .. ' Thru ' .. LastSeqWings .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Data_Pool_Nr .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Wings" ' .. Argument_Xwings[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Data_Pool_Nr .. ' Plugin "LC_View" ')
        end -- end Sequences
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        Command_Ext_Suite(CurrentSeqNr)
        -- Add Squences to Layout
        if MakeX then
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    do return 1, CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr end
end -- end Create_Wings_Sequence

function Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, Call_inc, CallT, MatrickNrStart, a,
                             CurrentSeqNr, TLayNr, Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element,
                             Group_Element, Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY,
                             LayW, LayH, Data_Pool_Nr)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    First_Id_Lay[33 + a] = CurrentMacroNr
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for m = 1, 31 do
        if m == 1 or m == 6 or m == 11 or m == 16 or m == 17 or m == 22 or m == 27 then
            Call_inc = 0
        end
        if m < 6 then
            CallT = 1
        elseif m < 11 then
            CallT = 5
        elseif m < 16 then
            CallT = 9
        elseif m < 17 then
            CallT = 13
        elseif m < 22 then
            CallT = 17
        elseif m < 27 then
            CallT = 21
        elseif m <= 31 then
            CallT = 25
        end
        Cmd('Insert')
        Cmd('Set ' .. m .. ' Command=\'Assign DataPool ' .. Data_Pool_Nr .. ' Sequence ' ..
            First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Data_Pool_Nr .. ' Layout ' ..
            TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        Call_inc = math.floor(Call_inc + 1)
    end
    Cmd('ChangeDestination Root')
    Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
        Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
        Wings_Element, MatrickNr, Data_Pool_Nr)

    First_Id_Lay[28 + a] = CurrentSeqNr
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[66 + tonumber(a * 2 - 1)].Nr)
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. surfix[a] ..
        '_Call\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[67 + tonumber(a * 2 - 1)].Nr)
    Command_Ext_Suite(CurrentSeqNr)
    Cmd('ClearAll /nu')
    Cmd('Store Sequence ' .. CurrentSeqNr + 1 .. ' \'' .. prefix .. surfix[a] .. '_Reset\'')
    Cmd("Set Sequence " .. CurrentSeqNr + 1 .. " Cue 1 Property Appearance=" .. prefix .. "'skull_on'")
    Cmd('Set Sequence ' .. CurrentSeqNr + 1 .. ' Cue \'' .. prefix .. surfix[a] ..
        '_Reset\' Property Command=\'Go DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr + 1 .. '')
    Cmd("Set Sequence " .. CurrentSeqNr + 1 .. " Property Appearance=" .. prefix .. "'skull_off'")
    Command_Ext_Suite(CurrentSeqNr + 1)
    if MakeX == false then
        LayNr = math.floor(LayNr + 1)
    end
    if a == 1 then
        First_Id_Lay[32] = LayX
        First_Id_Lay[33] = LayY
        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 170 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        Cmd('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 170 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    elseif a == 2 then
        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 90 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        Cmd('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 90 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    elseif a == 3 then
        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 10 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        Cmd('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
            ' Property Appearance <default> PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 10 ..
            ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    end
    do return 1, First_Id_Lay, LayNr, CurrentMacroNr end
end -- end Create_XYZ_Sequence

function Create_All_Color(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW, LayH, MaxColLgn,
                          RefX, AppNr, Data_Pool_Nr)
    LayNr = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    LayX = math.floor(LayX + LayW + 20)
    NrNeed = math.floor(AppNr + 1)
    local col_count = 0
    local First_All_Color
    for col in ipairs(TCol) do
        col_count = col_count + 1
        local StColName = TCol[col].name
        local StringColName = string.gsub(StColName, " ", "_")

        if col == 1 then
            First_All_Color = '' .. prefix .. 'ALL' .. StringColName .. 'ALL\''
        end
        Cmd("ClearAll /nu")
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. NrNeed + 1)
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue \'' .. prefix .. 'ALL' .. StringColName .. '' ..
            'ALL\' Property Command=\'Go+ DataPool ' .. Data_Pool_Nr .. ' Sequence \'' .. prefix .. StringColName .. '*')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
        Command_Ext_Suite(CurrentSeqNr)
        Cmd("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " Property appearance <default> PosX " .. LayX .. " PosY " .. LayY ..
            " PositionW " .. LayW .. " PositionH " .. LayH ..
            " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")

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
    LayX = math.floor(LayX + LayW + 20)

    do return 1, LayNr, LayX, First_All_Color end
end -- end Create_All_Color

function Command_Title(title, TLayNr, LayNr, LayX, LayY, Pw, Ph, align)
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
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property VisibilityBorder=0')
    Cmd('Set Layout ' ..
        TLayNr ..
        '.' .. LayNr .. ' Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. Pw .. ' PositionH ' .. Ph .. '')
end -- end function Command_Title(...)

function Command_Ext_Suite(CurrentSeqNr)
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property prefercueappearance=on')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0')
    Cmd('Set Sequence ' .. CurrentSeqNr ..
        ' Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' OutputFilter="" Priority=0 SoftLTP=1 PlaybackMaster="" XfadeMode=0')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' RateMaster="" RateScale=0 SpeedMaster="" SpeedScale=0 SpeedfromRate=0')
    Cmd('Set Sequence ' .. CurrentSeqNr ..
        ' InputFilter="" SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' SequMIB=0 SequMIBMode=1')
end -- end function Command_Ext_Suite(...)

--end LC_Cmd.lua
