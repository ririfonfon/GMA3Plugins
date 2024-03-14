--[[
Releases:
* 1.0.0.0

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
        Echo("file not exist")
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

function Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName)
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Images.on\"'
    local StAppOff = '\"Showdata.MediaPools.Images.off\"'
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

function Create_Matrix(MatrickNr, Argument_Matricks, surfix, prefix)
    for axes in pairs(surfix) do
        for g in pairs(Argument_Matricks) do
            Cmd('Store MAtricks ' .. MatrickNr .. ' /nu')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' name = ' .. prefix .. surfix[axes] ..
                "_" .. Argument_Matricks[g].Name:gsub('\'', '') .. ' /nu')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "PhaseFrom' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phasefrom .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "PhaseTo' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phaseto .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Group" "' .. Argument_Matricks[g].group .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Wings" "' .. Argument_Matricks[g].wing .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Block" "' .. Argument_Matricks[g].block .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Shuffle" "' .. Argument_Matricks[g].shuffle .. '')
            Cmd('Set Matricks ' .. MatrickNr .. ' Property "PhaserTransform" ' .. Argument_Matricks[g].transform .. '')
            MatrickNr = math.floor(MatrickNr + 1)
        end
    end
end

function Create_Preset_Ref_1234(prefix, All_5_Current, SelectedGelNr)
    Cmd("ClearAll /nu")
    Cmd('Fixture Thru')
    for i = 1, 4 do
        Cmd('At Gel ' .. SelectedGelNr .. ".1")
        Cmd('Store Preset 25.' .. All_5_Current .. '')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    local Preset_Ref = All_5_Current - 4
    do return 1, All_5_Current, Preset_Ref end
end

function Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref, Phaser_Off)
    local transition
    local Preset_cal
    Cmd("ClearAll /nu")
    Cmd('Fixture Thru')
    Cmd('Attribute "ColorRGB_R" At Relative 0')
    Cmd('Attribute "ColorRGB_G" At Relative 0')
    Cmd('Attribute "ColorRGB_B" At Relative 0')
    Cmd('Attribute "ColorRGB_W" At Relative 0')
    Cmd('Store Preset 25.' .. All_5_Current .. '')
    Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. "ref_off")
    Phaser_Off = All_5_Current
    All_5_Current = math.floor(All_5_Current + 1)
    for i = 1, 3 do
        if (i == 1) then
            transition = 100
        elseif (i == 2) then
            transition = 50
        elseif (i == 3) then
            transition = 0
        end
        for g in ipairs(Argument_Ref) do
            Cmd("ClearAll /nu")
            Cmd('Fixture Thru')
            for st = 1, Argument_Ref[g].Step do
                if (st == 1) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step1
                elseif (st == 2) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step2
                elseif (st == 3) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step3
                elseif (st == 4) then
                    Preset_cal = Preset_Ref + Argument_Ref[g].Step4
                end
                Cmd('Next Step')
                Cmd('At Preset 25.' .. Preset_cal .. '')
            end

            for st = 1, Argument_Ref[g].Step do
                Cmd('Attribute "ColorRGB_R"')
                Cmd('At Transition Percent ' .. transition .. '')
                Cmd('Attribute "ColorRGB_G"')
                Cmd('At Transition Percent ' .. transition .. '')
                Cmd('Attribute "ColorRGB_B"')
                Cmd('At Transition Percent ' .. transition .. '')
                Cmd('Attribute "ColorRGB_W"')
                Cmd('At Transition Percent ' .. transition .. '')
                Cmd('Previous Step')
            end

            Cmd('Store Preset 25.' .. All_5_Current .. '')
            Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. Argument_Ref[g].Name)
            All_5_Current = math.floor(All_5_Current + 1)
        end
    end
    do return 1, Phaser_Off, All_5_Current end
end

function Copy_Phaser_Ref(Phaser_Off, All_5_Current, Phaser_Ref)
    Phaser_Ref = All_5_Current
    for i = 1, 8 do
        local cop = Phaser_Off + i
        Cmd('Copy Preset 25.' .. cop .. ' At Preset 25.' .. All_5_Current .. '')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    do return 1, Phaser_Ref, All_5_Current end
end

function Create_Active_Appearances(AppImp, NrAppear, prefix)
    for q in pairs(AppImp) do
        AppImp[q].Nr = math.floor(NrAppear)
        Cmd('Store App ' ..
            AppImp[q].Nr ..
            ' ' .. prefix .. AppImp[q].Name .. ' "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref .. '')
        NrAppear = math.floor(NrAppear + 1)
    end
    do return 1, NrAppear end
end

function Create_Group_Appearances(AppImp, NrAppear, prefix, SelectedGrp, SelectedGrpName, color_ref)
    local a = 1
    for grp in pairs(SelectedGrp) do
        for q in pairs(AppImp) do
            AppImp[q].Nr = math.floor(NrAppear)
            Cmd('Store App ' ..
                AppImp[q].Nr ..
                ' ' ..
                prefix ..
                AppImp[q].Name ..
                SelectedGrpName[grp] .. ' "Appearance"=' .. AppImp[q].StApp .. '' .. color_ref[a].RGBref .. '')
            NrAppear = math.floor(NrAppear + 1)
        end
        a = a + 1
        if a > 15 then
            a = 1
        end
    end
    do return 1, NrAppear end
end

function Create_Group_Sequence(SelectedGrp, SelectedGrpName, Phaser_Off, CurrentSeqNr, SelectedGrpNo, prefix,
                               Sequence_Ref)
    Sequence_Ref = CurrentSeqNr
    for g in ipairs(SelectedGrp) do
        local GrpNo = SelectedGrpNo[g]
        Cmd("ClearAll /nu")
        Cmd("Store Sequence " ..
            CurrentSeqNr .. " \"" .. prefix .. " " .. SelectedGrpName[g] .. "\"")
        Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
        Cmd("Assign Group " .. SelectedGrpName[g] .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
        Cmd('Assign Values Preset 25.' ..
            Phaser_Off .. "At Sequence " .. CurrentSeqNr .. 'cue 1 part 0.1')
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    do return 1, CurrentSeqNr, Sequence_Ref end
end

function Create_Layout_Phaser(TLayNr, NaLay, SelectedGelNr, CurrentSeqNr, Preset_Ref, MaxColLgn, RefX, LayY,
                              LayH, AppNr, LayW, StColName, CurrentMacroNr, ColPath, prefix, All_5_NrStart)
    local Macro_Pool = Root().ShowData.DataPools.Default.Macros
    local TCol
    local LongGel
    local Start_Seq_1
    local End_Seq_1
    local Start_Seq_2
    local End_Seq_2
    local Start_Seq_3
    local End_Seq_3
    local Start_Seq_4
    local End_Seq_4
    local LayNr = 1
    local NrSeq
    local NrNeed
    local Grp1234 = { "COLOR_1", "COLOR_2", "COLOR_3", "COLOR_4" }



    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. prefix .. NaLay .. "")
    -- end
    TCol = ColPath:Children()[SelectedGelNr]
    -- check how long Gel

    for k in ipairs(TCol) do LongGel = math.floor(TCol[k].no) end

    Start_Seq_1 = CurrentSeqNr
    End_Seq_1 = math.floor(Start_Seq_1 + LongGel - 1)
    Start_Seq_2 = math.floor(End_Seq_1 + 1)
    End_Seq_2 = math.floor(Start_Seq_2 + LongGel - 1)
    Start_Seq_3 = math.floor(End_Seq_2 + 1)
    End_Seq_3 = math.floor(Start_Seq_3 + LongGel - 1)
    Start_Seq_4 = math.floor(End_Seq_3 + 1)
    End_Seq_4 = math.floor(Start_Seq_4 + LongGel - 1)
    Preset_Ref = math.floor(Preset_Ref)
    MaxColLgn = tonumber(MaxColLgn)

    for g in ipairs(Grp1234) do
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        NrSeq = math.floor(AppNr + 1)
        NrNeed = math.floor(AppNr + 1)
        LayNr = math.floor(LayNr)

        Cmd("Store Layout " .. TLayNr .. "." .. LayNr .. "")
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " Action=0 Appearance=" .. AppNr ..
            " PosX " .. LayX ..
            " PosY " .. LayY ..
            " PositionW " .. LayW ..
            " PositionH " .. LayH ..
            " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 CustomTextSize=20 CustomTextText=".. Grp1234[g] .. "")

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)



        for col in ipairs(TCol) do
            col_count = col_count + 1
            StColName = TCol[col].name


            -- Create Sequences
            Cmd("ClearAll /nu")
            Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. prefix .. " " .. StColName ..
                " " .. Grp1234[g] .. "\"")

            -- Create Macros
            Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. ' ' .. StColName .. ' ' ..
                Grp1234[g] .. '\'')
            Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
            Cmd('Insert')
            Cmd('ChangeDestination Root')
            local add_all5 = tonumber(All_5_NrStart + TCol[col].no - 1)
            Macro_Pool[CurrentMacroNr][1]:Set('Command',
                'Copy Preset 25.' .. add_all5 .. ' At Preset 25.' .. Preset_Ref .. ' /o /nu')

            -- Add Cmd to Sequences
            if (g == 1) then
                Echo("G 1")
                Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    CurrentMacroNr .. "; Off Sequence " .. Start_Seq_1 ..
                    " Thru " .. End_Seq_1 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 2) then
                Echo("G 2")
                Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    CurrentMacroNr .. "; Off Sequence " .. Start_Seq_2 ..
                    " Thru " .. End_Seq_2 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 3) then
                Echo("G 3")
                Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    CurrentMacroNr .. "; Off Sequence " .. Start_Seq_3 ..
                    " Thru " .. End_Seq_3 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 4) then
                Echo("G 4")
                Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    CurrentMacroNr .. "; Off Sequence " .. Start_Seq_4 ..
                    " Thru " .. End_Seq_4 .. " - " .. CurrentSeqNr .. "\"")
            end

            Echo("set seq")
            Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " ..
                TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 ..
                "\"")

            -- end Cmd to Sequences

            -- Add Sequences to Layout
            Echo('add sequence to layout')
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..
                NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 ")
            -- end Sequences to Layout

            NrNeed = math.floor(NrNeed + 2); -- Set App Nr to next color

            if (col_count ~= MaxColLgn) then
                LayX = math.floor(LayX + LayW + 20)
            else
                LayX = RefX
                LayX = math.floor(LayX + LayW + 20)
                LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
                LayY = math.floor(LayY - LayH)
                col_count = 0
            end
            LayNr = math.floor(LayNr + 1)

            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end

        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
        Preset_Ref = math.floor(Preset_Ref + 1)
    end

    do return 1, CurrentMacroNr end
end
