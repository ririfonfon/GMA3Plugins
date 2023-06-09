local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

function Command_Ext_Suite(CurrentSeqNr)
    Cmd('set seq ' .. CurrentSeqNr .. ' property prefercueappearance=on')
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

function AddAllColor(TCol,CurrentSeqNr,prefix,TLayNr,LayNr,NrNeed,LayX,LayY,LayW,LayH,SelectedGelNr,MaxColLgn,RefX)
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
        -- Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd('set seq ' .. CurrentSeqNr .. ' cue 1 Property Appearance=' .. NrNeed + 1 )
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. prefix .. 'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\'Go+ Sequence \'' .. prefix .. StringColName ..  '*')
        -- Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout "  .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd('set seq ' ..CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1 )
        Command_Ext_Suite(CurrentSeqNr)
        
        -- end Sequences

        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        -- Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        Cmd("Set Layout "  .. TLayNr .. "." .. LayNr .. " property appearance <default> PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
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

function Mainbox_Call(display_Handle,TLayNr,NaLay,SeqNrStart,MacroNrStart,AppNr,MaxColLgn,MatrickNrStart,ColGels,FixtureGroups,SelectedGelNr,SelectedGrp,SelectedGrpNo)

    local ChoGel = {}
    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end
    local count = 0
    local OkBtn = ""
    local ValOkBtn = 12
    local Message = "Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
    local PopTableGrp = {}
    local SelGrp
    local TGrpChoise
    local Swipe_Color = {
        {name ="____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____", selectedValue=11, 
            values={
                ["'" .. ColGels[1].name .. "'"]=1,["'" .. ColGels[2].name .. "'"]=2,["'" .. ColGels[3].name .. "'"]=3,["'" .. ColGels[4].name .. "'"]=4,["'" .. ColGels[5].name .. "'"]=5,
                ["'" .. ColGels[6].name .. "'"]=6,["'" .. ColGels[7].name .. "'"]=7,["'" .. ColGels[8].name .. "'"]=8,["'" .. ColGels[9].name .. "'"]=9,["'" .. ColGels[10].name .. "'"]=10,
                ["'" .. ColGels[11].name .. "'"]=11
            },type=0
        }
    }

    -- Main Box
    ::MainBox::
    local box = MessageBox({
        title = 'Color_Layout_By_RIRI',
        display = display_Handle,
        backColor = "1.7",
        message = Message,
        commands = { {
            name = 'Add Group',
            value = 11
        }, {
            name = OkBtn,
            value = ValOkBtn
        }, {
            name = 'Cancel',
            value = 0
        } },
        inputs = { {
            name = 'Layout_Nr',
            value = TLayNr,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Layout_Name',
            value = NaLay,
            maxTextLength = 16,
            vkPlugin = "TextInput"
        }, {
            name = 'Sequence_Start_Nr',
            blackFilter = "*",
            value = SeqNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Macro_Start_Nr',
            blackFilter = "*",
            value = MacroNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Appearance_Start_Nr',
            blackFilter = "*",
            value = AppNr,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Max_Color_By_Line',
            value = MaxColLgn,
            maxTextLength = 2,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Matrick_Start_Nr',
            value = MatrickNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        } },
        selectors = Swipe_Color

    })

    if (box.result == 11 or box.result == 100 or box.result == 10) then
        if (count == 0 or ValOkBtn == 100) then
            ValOkBtn = Maf(ValOkBtn / 10)
            if (ValOkBtn < 10) then
                ValOkBtn = 1
            end
        end

        if (ValOkBtn == 1) then
            OkBtn = "OK Let's GO :)"
        end

        for k in pairs(FixtureGroups) do
            count = count + 1
        end

        if (count == 0) then
            E("all Groups are added")
            Co("all Groups are added")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors
                .____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto MainBox
        else
            E("add Group")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors
                .____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto addGroup
        end
    elseif (box.result == 1) then
        if next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors
                .____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            goto addGroup
        else
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            SelectedGelNr = box.selectors
                .____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____GELS__CHOOSE____
            E("now i do some Magic stuff...")
            return 1,SeqNrStart,MacroNrStart,AppNr,TLayNr,NaLay,MaxColLgn,MatrickNrStart,SelectedGelNr
        end
    elseif (box.result == 0) then
        E("User Canceled")
        return 0
        -- goto canceled
    end

    -- End Main Box

    -- Choise Fixture Group
    -- Create a Choise for each Group in Table
    ::addGroup::

    TGrpChoise = {}
    for k in ipairs(FixtureGroups) do
        table.insert(TGrpChoise, "'" .. FixtureGroups[k].name .. "'")
        E(FixtureGroups[k].name)
    end

    -- Setup the Messagebox
    PopTableGrp = {
        title = "Fixture Group",
        caller = display_Handle,
        items = TGrpChoise,
        selectedValue = "",
        add_args = {
            FilterSupport = "Yes"
        }
    }
    SelGrp = PopupInput(PopTableGrp)

    table.insert(SelectedGrp, "'" .. FixtureGroups[SelGrp + 1].name .. "'")
    table.insert(SelectedGrpNo, "'" .. FixtureGroups[SelGrp + 1].NO .. "'")
    E("A")
    Message = Message .. FixtureGroups[SelGrp + 1].name .. "\n"
    E("Select Group " .. FixtureGroups[SelGrp + 1].name)
    table.remove(FixtureGroups, SelGrp + 1)
    goto MainBox
    -- End Choise Fixture Group	

    -- Choise ColorGel
    -- Create a Choise for each Group in Table
end

function Make_Macro_Reset(CurrentMacroNr,prefix,surfix,MatrickNrStart,a,CurrentSeqNr,First_Id_Lay)

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
    Cmd('set 7 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..'Group" None')
    Cmd('Insert')
    Cmd('set 8 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..'Block" None')
    Cmd('Insert')
    Cmd('set 9 Command=\'set Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..'Wings" None')
    Cmd('Insert')
    Cmd('set 10 Command=\'Off Sequence ' .. First_Id_Lay[a + 1] .. ' Thru ' .. First_Id_Lay[a + 1] + 4 )
    Cmd('Insert')
    Cmd('set 11 Command=\'Off Sequence ' .. First_Id_Lay[a + 5] .. ' Thru ' .. First_Id_Lay[a + 5] + 4 )
    Cmd('Insert')
    Cmd('set 12 Command=\'Off Sequence ' .. First_Id_Lay[a + 9] .. ' Thru ' .. First_Id_Lay[a + 9] + 4 )
    Cmd('Insert')
    Cmd('set 13 Command=\'Off Sequence ' .. First_Id_Lay[a + 13])
    Cmd('Insert')
    Cmd('set 14 Command=\'Off Sequence ' .. First_Id_Lay[a + 17] .. ' Thru ' .. First_Id_Lay[a + 17] + 4 )
    Cmd('Insert')
    Cmd('set 15 Command=\'Off Sequence ' .. First_Id_Lay[a + 21] .. ' Thru ' .. First_Id_Lay[a + 21] + 4 )
    Cmd('Insert')
    Cmd('set 16 Command=\'Off Sequence ' .. First_Id_Lay[a + 25] .. ' Thru ' .. First_Id_Lay[a + 25] + 4 )
    Cmd('Insert')
    Cmd('set 17 Command=\'Off Sequence ' .. CurrentSeqNr + 1)
    Cmd('ChangeDestination Root')
end