--[[
Releases:
* 2.0.0.9

Created by Richard Fontaine "RIRI", April 2024.
--]]

function PC_Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName, AppRef)
    AppRef = AppNr
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    for g in ipairs(SelectedGrp) do
        AppNr = math.floor(AppNr);
        Cmd('Store App ' .. AppNr .. ' \'' .. prefix .. ' Label\' Appearance=' .. StAppOn .. ' color=\'0,0,0,1\'')
        AppNr = math.floor(AppNr + 1);
        Cmd('Store App ' .. AppNr .. ' \'' .. prefix .. ' Labelon\' Appearance=' .. StAppOn .. ' color=\'1,1,1,1\'')
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
    do return 1, NrAppear, AppRef end
end

function PC_Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current)
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

function PC_Create_Matricks(MatrickNr, Argument_Matricks, surfix, prefix, Data_Pool_Nr)
    for axes in pairs(surfix) do
        for g in pairs(Argument_Matricks) do
            Cmd('Store MAtricks ' .. MatrickNr .. ' /nu')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' name = ' .. prefix .. surfix[axes] .. Argument_Matricks[g].Name:gsub('\'', '') .. ' /nu')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "PhaseFrom' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phasefrom .. '')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "PhaseTo' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phaseto .. '')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Group" "' .. Argument_Matricks[g].group .. '')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Wings" "' .. Argument_Matricks[g].wing .. '')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Block" "' .. Argument_Matricks[g].block .. '')
            Cmd('Set DataPool ' .. Data_Pool_Nr .. '  Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Shuffle" "' .. Argument_Matricks[g].shuffle .. '')
            Cmd('Set DataPool ' ..
                Data_Pool_Nr ..
                '  Matricks ' .. MatrickNr .. ' Property "PhaserTransform" ' .. Argument_Matricks[g].transform .. '')
            MatrickNr = math.floor(MatrickNr + 1)
        end
    end
end

function PC_Create_Preset_Ref_1234(All_5_Current, SelectedGelNr)
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

function PC_Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref, Phaser_Off)
    local transition
    local Preset_cal
    Cmd("ClearAll /nu")
    Cmd('Fixture Thru')
    Cmd('Attribute "ColorRGB_R" At Relative 0')
    Cmd('Attribute "ColorRGB_G" At Relative 0')
    Cmd('Attribute "ColorRGB_B" At Relative 0')
    Cmd('Attribute "ColorRGB_W" At Relative 0')
    Cmd('Store Preset 25.' .. All_5_Current .. '')
    Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. "off")
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

function Copy_Phaser_Ref(Phaser_Off, All_5_Current, Phaser_Ref, Preset_25_Ref)
    Phaser_Ref = All_5_Current
    Preset_25_Ref[1] = Phaser_Off
    for i = 1, 8 do
        Preset_25_Ref[i + 1] = All_5_Current
        local cop = Phaser_Off + i
        Cmd('Copy Preset 25.' .. cop .. ' At Preset 25.' .. All_5_Current .. '')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    do return 1, Phaser_Ref, All_5_Current, Preset_25_Ref end
end

function PC_Create_Active_Appearances(AppImp, NrAppear, prefix)
    for q in pairs(AppImp) do
        AppImp[q].Nr = math.floor(NrAppear)
        Cmd('Store App ' .. AppImp[q].Nr .. ' ' .. prefix .. AppImp[q].Name ..
            ' "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref .. '')
        NrAppear = math.floor(NrAppear + 1)
    end
    do return 1, NrAppear end
end

function PC_Create_Group_Appearances(AppImp, NrAppear, prefix, SelectedGrp, SelectedGrpName, color_ref)
    local a = 1
    for grp in pairs(SelectedGrp) do
        for q = 1, 19 do
            AppImp[q].Nr = math.floor(NrAppear)
            Cmd('Store App ' .. AppImp[q].Nr .. ' ' .. prefix .. AppImp[q].Name ..
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

function PC_Create_Group_Sequence(SelectedGrp, SelectedGrpName, Phaser_Off, CurrentSeqNr, SelectedGrpNo, prefix,
                                  Sequence_Ref, Sequence_Ref_End)
    Sequence_Ref = CurrentSeqNr
    for g in ipairs(SelectedGrp) do
        Cmd("ClearAll /nu")
        Cmd("Store Sequence " ..
            CurrentSeqNr .. " \"" .. prefix .. SelectedGrpName[g] .. "\"")
        Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
        Cmd("Assign Group " .. SelectedGrpNo[g] .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
        Cmd('Assign Preset 25.' .. Phaser_Off .. " At Sequence " .. CurrentSeqNr .. 'cue 1 part 0.1')
        Cmd('Set Sequence ' .. CurrentSeqNr .. 'Property Priority HTP')
        Cmd('Set Sequence ' .. CurrentSeqNr .. 'Property OffWhenOverridden=0')
        Cmd('Set Sequence ' .. CurrentSeqNr .. 'Property SwapProtect=1')
        Cmd('Set Sequence ' .. CurrentSeqNr .. 'Property KillProtect=1')
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    Sequence_Ref_End = math.floor(CurrentSeqNr - 1)
    do return 1, CurrentSeqNr, Sequence_Ref, Sequence_Ref_End end
end

function PC_Create_Layout_Phaser(TLayNr, NaLay, SelectedGelNr, CurrentSeqNr, Preset_Ref, MaxColLgn, RefX, LayY,
                                 LayH, AppNr, LayW, StColName, CurrentMacroNr, ColPath, prefix, All_5_NrStart,
                                 Data_Pool_Nr)
    local Macro_Pool = DataPool().Macros
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

    -- Group 1234
    for g in ipairs(Grp1234) do
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        NrNeed = math.floor(AppNr + 2)
        LayNr = math.floor(LayNr)

        Cmd("Store Layout " .. TLayNr .. "." .. LayNr .. "")
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " Property Appearance " .. AppNr ..
            " PosX " .. LayX ..
            " PosY " .. LayY ..
            " PositionW " .. LayW ..
            " PositionH " .. LayH ..
            " Action=0 VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 CustomTextSize=20 CustomTextText=" ..
            Grp1234[g] .. "")

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)


        -- create color 1234
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
            Macro_Pool[CurrentMacroNr][1]:Set('Command', 'Copy DataPool ' ..
                Data_Pool_Nr .. '  Preset 25.' .. add_all5 .. ' At DataPool ' .. Data_Pool_Nr ..
                '  Preset 25.' .. Preset_Ref .. ' /o /nu')

            -- Add Cmd to Sequences
            if (g == 1) then
                Echo("G 1")
                Cmd("Set seq " .. CurrentSeqNr ..
                    " cue \"CueZero\" Property Command=\"Set DataPool " .. Data_Pool_Nr .. " Layout " .. TLayNr .. "." .. LayNr ..
                    " Property Appearance " .. NrNeed .. " VisibilityBorder=0 ; Go+ DataPool " .. Data_Pool_Nr ..
                    " Macro " .. CurrentMacroNr .. "; Off DataPool " .. Data_Pool_Nr .. "  Sequence " .. Start_Seq_1 ..
                    " Thru " .. End_Seq_1 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 2) then
                Echo("G 2")
                Cmd("Set seq " .. CurrentSeqNr ..
                    " cue \"CueZero\" Property Command=\"Set DataPool " .. Data_Pool_Nr .. " Layout " .. TLayNr .. "." .. LayNr ..
                    " Property Appearance " .. NrNeed .. " VisibilityBorder=0 ; Go+ DataPool " .. Data_Pool_Nr ..
                    " Macro " .. CurrentMacroNr .. "; Off DataPool " .. Data_Pool_Nr .. "  Sequence " .. Start_Seq_2 ..
                    " Thru " .. End_Seq_2 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 3) then
                Echo("G 3")
                Cmd("Set seq " .. CurrentSeqNr ..
                    " cue \"CueZero\" Property Command=\"Set DataPool " .. Data_Pool_Nr .. " Layout " .. TLayNr .. "." .. LayNr ..
                    " Property Appearance " .. NrNeed .. " VisibilityBorder=0 ; Go+ DataPool " .. Data_Pool_Nr ..
                    " Macro " .. CurrentMacroNr .. "; Off DataPool " .. Data_Pool_Nr .. "  Sequence " .. Start_Seq_3 ..
                    " Thru " .. End_Seq_3 .. " - " .. CurrentSeqNr .. "\"")
            elseif (g == 4) then
                Echo("G 4")
                Cmd("Set seq " .. CurrentSeqNr ..
                    " cue \"CueZero\" Property Command=\"Set DataPool " .. Data_Pool_Nr .. " Layout " .. TLayNr .. "." .. LayNr ..
                    " Property Appearance " .. NrNeed .. " VisibilityBorder=0 ; Go+ DataPool " .. Data_Pool_Nr ..
                    " Macro " .. CurrentMacroNr .. "; Off DataPool " .. Data_Pool_Nr .. "  Sequence " .. Start_Seq_4 ..
                    " Thru " .. End_Seq_4 .. " - " .. CurrentSeqNr .. "\"")
            end

            Echo("Set seq")
            Cmd("Set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set DataPool " .. Data_Pool_Nr .. " Layout " ..
                TLayNr .. "." .. LayNr .. " Property Appearance " .. NrNeed + 1 ..
                " VisibilityBorder=0 \"")

            -- end Cmd to Sequences

            -- Add Sequences to Layout
            Echo('add sequence to layout')
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Property Appearance " ..
                NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")
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
        -- end create color 1234

        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
        Preset_Ref = math.floor(Preset_Ref + 1)
    end
    -- end Group 1234

    do return 1, CurrentMacroNr, CurrentSeqNr, LayNr, LayY end
end

function PC_Create_Layout_FixGroup(CurrentMacroNr, CurrentSeqNr, LayNr, LayY, RefX, LayH, LayW, TLayNr, NaLay,
                                   SelectedGrp, SelectedGrpName, Argument_Matricks, surfix, prefix, AppImp, Argument_Ref,
                                   AppRef, Preset_25_Ref, Phaser_Off, Phaser_Ref, All_Call_Ref, All_Call_Y, Data_Pool_Nr)
    local Macro_Pool = DataPool().Macros
    LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    LayY = math.floor(LayY - LayH)
    All_Call_Y = LayY
    LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    LayY = math.floor(LayY - LayH)
    local LayX = RefX
    for g in ipairs(SelectedGrp) do
        All_Call_Ref[g] = {}
    end
    for g in ipairs(SelectedGrp) do
        All_Call_Ref[g][1] = CurrentSeqNr
        Cmd('Store Sequence ' .. CurrentSeqNr ..
            ' \'' .. prefix .. ' ' .. SelectedGrpName[g] .. '_Select\'')
        Cmd('Store Sequence ' .. CurrentSeqNr .. ' Cue 2')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance  ' .. AppRef .. '')
        Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 2 Property Appearance  ' .. AppRef + 1 .. '')

        Cmd('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr ..
            " Action=0  PosX " .. LayX ..
            " PosY " .. LayY ..
            " PositionW " .. LayW ..
            " PositionH " .. LayH ..
            " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0")

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW + 20)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        local Seq_Start = CurrentSeqNr
        local Seq_End = Seq_Start + 8

        for i = 1, 9 do
            All_Call_Ref[g][i + 1] = CurrentSeqNr
            -- Create Seq
            Cmd('Store Sequence ' .. CurrentSeqNr ..
                ' \'' .. prefix .. ' ' .. SelectedGrpName[g] .. ' ' .. AppImp[i].Name .. '\'')
            -- Create Macros
            Cmd('Store Macro ' .. CurrentMacroNr ..
                ' \'' .. prefix .. ' ' .. SelectedGrpName[g] .. ' ' .. AppImp[i].Name .. '\'')
            Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
            Cmd('Insert')
            Cmd('ChangeDestination Root')
            Macro_Pool[CurrentMacroNr][1]:Set('Command', 'Assign DataPool ' .. Data_Pool_Nr ..
                '  Preset 25.' .. Preset_25_Ref[i] .. ' At DataPool ' .. Data_Pool_Nr ..
                '  Sequence ' .. prefix .. SelectedGrpName[g] .. ' Cue 1 Part 0.1')
            -- end Create Macros

            Cmd('Set Sequence ' .. CurrentSeqNr ..
                ' Cue \'CueZero\' Property Command=\'Set DataPool ' .. Data_Pool_Nr .. '  Layout ' ..
                TLayNr .. '.' .. LayNr .. ' Property Appearance ' .. prefix .. AppImp[i].Name ..
                '; Go+ DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr ..
                '; Off DataPool ' ..
                Data_Pool_Nr .. '  Sequence ' .. Seq_Start .. ' Thru ' .. Seq_End .. ' - ' .. CurrentSeqNr .. '\'')
            Cmd('Set Sequence ' .. CurrentSeqNr ..
                ' Cue \'OffCue\' Property Command=\'Set DataPool ' .. Data_Pool_Nr .. '  Layout ' ..
                TLayNr .. '.' .. LayNr .. ' Property Appearance ' .. prefix .. AppImp[i].Name .. SelectedGrpName[g] .. '')
            -- end Create Seq
            -- Assign Seq to Layout
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' At Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Appearance ' .. prefix .. AppImp[i].Name .. SelectedGrpName[g] ..
                ' PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            -- end Assign Seq to Layout
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end

        Seq_Start = CurrentSeqNr
        Seq_End = Seq_Start + 9

        for i = 10, 19 do
            All_Call_Ref[g][i + 1] = CurrentSeqNr
            -- Create Seq
            Cmd('Store Sequence ' .. CurrentSeqNr ..
                ' \'' .. prefix .. ' ' .. SelectedGrpName[g] .. ' ' .. AppImp[i].Name .. '\'')
            -- Create Macros
            Cmd('Store Macro ' .. CurrentMacroNr ..
                ' \'' .. prefix .. ' ' .. SelectedGrpName[g] .. ' ' .. AppImp[i].Name .. '\'')
            Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
            Cmd('Insert')
            Cmd('ChangeDestination Root')
            Macro_Pool[CurrentMacroNr][1]:Set('Command', 'Assign DataPool ' ..
                Data_Pool_Nr .. '  MAtricks ' .. prefix .. surfix[1] .. Argument_Matricks[i - 9].Name ..
                ' At DataPool ' .. Data_Pool_Nr .. '  Sequence ' .. prefix .. SelectedGrpName[g] .. ' Cue 1 Part 0.1')
            -- end Create Macros

            Cmd('Set Sequence ' .. CurrentSeqNr ..
                ' Cue \'CueZero\' Property Command=\'Set DataPool ' .. Data_Pool_Nr .. '  Layout ' ..
                TLayNr .. '.' .. LayNr .. ' Property Appearance ' .. prefix .. AppImp[i].Name ..
                '; Go+ DataPool ' .. Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr ..
                '; Off DataPool ' ..
                Data_Pool_Nr .. '  Sequence ' .. Seq_Start .. ' Thru ' .. Seq_End .. ' - ' .. CurrentSeqNr .. '\'')
            Cmd('Set Sequence ' .. CurrentSeqNr ..
                ' Cue \'OffCue\' Property Command=\'Set DataPool ' .. Data_Pool_Nr .. '  Layout ' ..
                TLayNr .. '.' .. LayNr .. ' Property Appearance ' .. prefix .. AppImp[i].Name .. SelectedGrpName[g] .. '')
            -- end Create Seq
            -- Assign Seq to Layout
            Cmd('Assign Sequence ' .. CurrentSeqNr .. ' At Layout ' .. TLayNr)
            Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
                ' Property Appearance ' .. prefix .. AppImp[i].Name .. SelectedGrpName[g] ..
                ' PosX ' .. LayX .. ' PosY ' .. LayY ..
                ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
                ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
            -- end Assign Seq to Layout
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
            CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        end
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
        LayY = math.floor(LayY - LayH)
        LayX = RefX
    end

    -- Create Seq 100 50 0
    Cmd('Store Sequence ' .. CurrentSeqNr ..
        ' \'' .. prefix .. ' 100 50 0 \'')
    Cmd('Store Sequence ' .. CurrentSeqNr .. 'Cue 2 Thru 3')
    Cmd('Set Sequence ' .. CurrentSeqNr .. 'Property PreferCueAppearance 1')
    -- Create Macros
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. ' cent \'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for a = 1, 8 do
        Cmd('Insert')
    end
    Cmd('ChangeDestination Root')
    for a = 1, 8 do
        Macro_Pool[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Off + a .. ' At DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end

    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. ' cinquante \'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for a = 1, 8 do
        Cmd('Insert')
    end
    Cmd('ChangeDestination Root')
    for a = 1, 8 do
        Macro_Pool[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Off + a + 8 .. ' At DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end

    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. ' zero \'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for a = 1, 8 do
        Cmd('Insert')
    end
    Cmd('ChangeDestination Root')
    for a = 1, 8 do
        Macro_Pool[CurrentMacroNr][a]:Set('Command', 'Copy DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Off + a + 16 .. ' At DataPool ' .. Data_Pool_Nr ..
            '  Preset 25.' .. Phaser_Ref + a - 1 .. '/Overwrite /NoOops')
    end
    -- end Create Macros

    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Property  Appearance  ' .. prefix .. 'cent')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Command=\'Go+ DataPool ' ..
        Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr - 2 .. '\' Property Appearance  ' .. prefix .. 'cent')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 2 Property Command=\'Go+ DataPool ' ..
        Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr - 1 .. '\' Property Appearance  ' .. prefix .. 'cinquante')
    Cmd('Set Sequence ' .. CurrentSeqNr .. ' Cue 3 Property Command=\'Go+ DataPool ' ..
        Data_Pool_Nr .. ' Macro ' .. CurrentMacroNr .. '\' Property Appearance  ' .. prefix .. 'zero')
    -- end Create Seq 100 50 0
    -- Assign Seq to Layout
    Cmd('Assign Sequence ' .. CurrentSeqNr .. ' At Layout ' .. TLayNr)
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        ' PosX ' .. LayX .. ' PosY ' .. LayY ..
        ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    -- end Assign Seq to Layout
    LayX = math.floor(LayX + LayW + 20)
    LayNr = math.floor(LayNr + 1)
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)

    do return 1, CurrentSeqNr, CurrentMacroNr, All_Call_Ref, All_Call_Y, LayNr end
end

function PC_Create_All_Call_Layout(CurrentMacroNr, LayNr, LayY, RefX, LayH, LayW, TLayNr, SelectedGrp,
                                   SelectedGrpName, prefix, All_Call_Ref, All_Call_Y, AppImp, Data_Pool_Nr)
    local Macro_Pool = DataPool().Macros
    LayY = math.floor(All_Call_Y)
    local LayX = RefX
    LayX = math.floor(LayX + LayW + 20)
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    local Ref_Macro_Call_off
    local Ref_Macro_Call_on
    local Ref_Macro_Call_Fonction = CurrentMacroNr

    -- Create Macros
    for i = 1, 19 do
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'All' .. AppImp[i].Name .. '\'')
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        for g in pairs(SelectedGrp) do
            Cmd('Insert')
        end
        Cmd('ChangeDestination Root')
        for g in pairs(SelectedGrp) do
            Macro_Pool[CurrentMacroNr][g]:Set('Command', 'Go+ DataPool ' .. Data_Pool_Nr ..
                ' Sequence ' .. All_Call_Ref[g][i + 1] .. '')
            All_Call_Ref[g][20 + i] = CurrentMacroNr
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end
    Ref_Macro_Call_off = CurrentMacroNr
    for g in ipairs(SelectedGrp) do
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g] .. 'Alloff\'')
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        for i = 1, 19 do
            Cmd('Insert')
        end
        Cmd('ChangeDestination Root')
        for i = 1, 19 do
            Macro_Pool[CurrentMacroNr][i]:Set('Command', 'Set DataPool ' .. Data_Pool_Nr ..
                ' Macro ' .. All_Call_Ref[g][20 + i] .. '.' .. g .. ' Property Enabled off')
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    Ref_Macro_Call_on = CurrentMacroNr
    for g in ipairs(SelectedGrp) do
        Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g] .. 'Allon\'')
        Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        for i = 1, 19 do
            Cmd('Insert')
        end
        Cmd('ChangeDestination Root')
        for i = 1, 19 do
            Macro_Pool[CurrentMacroNr][i]:Set('Command', 'Set DataPool ' .. Data_Pool_Nr ..
                ' Macro ' .. All_Call_Ref[g][20 + i] .. '.' .. g .. ' Property Enabled on')
        end
        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    end

    for g in ipairs(SelectedGrp) do
        Cmd('Set Sequence ' .. All_Call_Ref[g][1] ..
            ' Cue 1 Property Command=\'Go+ DataPool ' .. Data_Pool_Nr .. ' Macro ' .. Ref_Macro_Call_off + g - 1 .. '')
        Cmd('Set Sequence ' .. All_Call_Ref[g][1] ..
            ' Cue 2 Property Command=\'Go+ DataPool ' .. Data_Pool_Nr .. ' Macro ' .. Ref_Macro_Call_on + g - 1 .. '')
    end

    for i = 1, 19 do
        Cmd('Assign Macro ' .. Ref_Macro_Call_Fonction + i - 1 .. ' At Layout ' .. TLayNr)
        Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
            ' Property Appearance  arrow_down_png PosX ' .. LayX .. ' PosY ' .. LayY ..
            ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
            ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
        -- end Assign Seq to Layout
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
    end
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    do return 1, CurrentMacroNr, LayX, LayNr end
end

function PC_Create_Macro_Priority(CurrentMacroNr, TLayNr, LayNr, LayX, LayY, LayW, LayH, prefix, Sequence_Ref,
                                  Sequence_Ref_End, Data_Pool_Nr)
    LayY = 440
    local Macro_Pool = DataPool().Macros
    CurrentMacroNr = math.floor(CurrentMacroNr)
    Cmd('Store Macro ' .. CurrentMacroNr .. ' \'' .. 'Priority\'')
    Cmd('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    for i = 1, 7 do
        Cmd('Insert')
    end
    Cmd('Assign DataPool ' .. Data_Pool_Nr .. '  Macro ' .. CurrentMacroNr .. ' at Layout ' .. TLayNr)
    Cmd('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        ' property appearance <default> PosX ' .. LayX .. ' PosY ' .. LayY ..
        ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0')
    Cmd('Set Layout ' .. TLayNr .. "." .. LayNr .. ' Property "Appearance" "p_super_png" VisibilityBorder=0')
    Cmd('ChangeDestination Root')
    local Color_message = 'SetUserVariable "LC_Sequence" "' .. Sequence_Ref .. '"'
    Color_message = string.gsub(Color_message, "'", "")
    Macro_Pool[CurrentMacroNr]:Set('name', '' .. prefix .. 'Priority')
    Macro_Pool[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' .. Data_Pool_Nr ..
        '  Sequence ' .. Sequence_Ref .. " Thru " .. Sequence_Ref_End .. ' Property "priority"')
    Macro_Pool[CurrentMacroNr][2]:Set('Command', 'SetUserVariable "LC_Fonction" 9')
    Macro_Pool[CurrentMacroNr][3]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr)
    Macro_Pool[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Element" ' .. LayNr)
    Macro_Pool[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Data_Pool" ' .. Data_Pool_Nr)
    Macro_Pool[CurrentMacroNr][6]:Set('Command', Color_message)
    Macro_Pool[CurrentMacroNr][7]:Set('Command', 'Call DataPool ' .. Data_Pool_Nr .. '  Plugin "LC_View"')
end

-- end PhaserC_Cmd.lua
