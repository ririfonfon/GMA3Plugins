--[[
    Releases:
    * 2.3.1.2

    Created by Richard Fontaine "RIRI", September 2025.
    --]]

local function Check_Size_Pool(id, PoolObject)
    if not id then return PoolObject:Acquire() end
    local idtype = math.type(id) or type(id)
    if idtype ~= 'integer' then error('wrong argument expected integer got ' .. idtype) end
    if IsObjectValid(PoolObject[id]) then error('id is already used : ' .. id) end
    local maxsize = PoolObject:MaxCount()
    if id < 1 or id > maxsize then error('id out of range') end
    local poolsize = PoolObject:Count()
    if id > poolsize then
        local newsize = math.min(maxsize, math.ceil(id / 1000) * 1000)
        PoolObject:Resize(newsize)
    end
end

function CheckSymbols(Img, ImgImp, check, add_check, long_imgimp, ImgNr)
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
end -- end CheckSymbols

function Create_Matricks(MatrickNrStart, prefix, NaLay, NbGroup, MatrickNr, pool_construct)
    local MatrickObject = Root().ShowData.DataPools[pool_construct].Matricks
    Echo('pool ' .. pool_construct .. ' Matrick ' .. MatrickNrStart)
    Check_Size_Pool(MatrickNrStart, MatrickObject)
    MatrickObject:Acquire()
    MatrickObject:Create(MatrickNrStart)
    MatrickObject[MatrickNrStart]:Set('Name', "'" .. prefix .. NaLay .. "'")
    MatrickNr = math.floor(MatrickNrStart + 1)
    for g = 1, NbGroup, 1 do
        Check_Size_Pool(MatrickNr, MatrickObject)
        MatrickObject:Create(MatrickNr)
        MatrickObject[MatrickNr]:Set('Name', prefix .. '_Group_' .. g)
        MatrickObject[MatrickNr]:Set('FadeFromx', 0)
        MatrickObject[MatrickNr]:Set('FadeFromy', 0)
        MatrickObject[MatrickNr]:Set('FadeFromz', 0)
        MatrickObject[MatrickNr]:Set('FadeTox', 0)
        MatrickObject[MatrickNr]:Set('FadeToy', 0)
        MatrickObject[MatrickNr]:Set('FadeToz', 0)
        MatrickNr = math.floor(MatrickNr + 1)
    end
    return MatrickNr
end -- end Create_Matricks

function Create_Appear_Tricks(AppTricks, AppNr, prefix)
    local AppObject = Root().ShowData.Appearances
    for q in pairs(AppTricks) do
        AppTricks[q].Nr = math.floor(AppNr)
        Check_Size_Pool(AppTricks[q].Nr, AppObject)
        AppObject:Create(AppTricks[q].Nr)
        AppObject[AppTricks[q].Nr]:Set('Name', "'" .. prefix .. AppTricks[q].Name .. "'")
        AppObject[AppTricks[q].Nr]:Set('Appearance', AppTricks[q].StApp:gsub('"', ''))
        AppObject[AppTricks[q].Nr]:Set('Color', AppTricks[q].RGBref:gsub('"', ''))
        AppNr = math.floor(AppNr + 1)
    end
    return AppNr, AppTricks
end -- end Create_Appear_Tricks

function Create_Appearances(AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName)
    local AppObject = Root().ShowData.Appearances
    AppObject:Acquire()
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff = '\"Showdata.MediaPools.Symbols.off\"'
    NrAppear = math.floor(AppNr)
    Check_Size_Pool(NrAppear, AppObject)
    AppObject:Create(NrAppear)
    AppObject[NrAppear]:Set('Name', "'" .. prefix .. 'Label')
    AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
    AppObject[NrAppear]:Set('Color', '0, 0, 0, 1')

    NrAppear = math.floor(NrAppear + 1)
    for col in ipairs(TCol) do
        StColCode = TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ", 1"
        StColName = TCol[col].name
        StringColName = StColName:gsub(' ', '_')
        StAppNameOn = prefix .. StringColName .. "_On"
        StAppNameOff = prefix .. StringColName .. "_Off"
        Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        AppObject[NrAppear]:Set('Name', "'" .. StAppNameOn:gsub('"', '') .. "'")
        AppObject[NrAppear]:Set('Appearance', StAppOn:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
        Check_Size_Pool(NrAppear, AppObject)
        AppObject:Create(NrAppear)
        AppObject[NrAppear]:Set('Name', "'" .. StAppNameOff:gsub('"', '') .. "'")
        AppObject[NrAppear]:Set('Appearance', StAppOff:gsub('"', ''))
        AppObject[NrAppear]:Set('Color', StColCode:gsub('"', ''))

        NrAppear = math.floor(NrAppear + 1)
    end
    -- end
    return NrAppear
end -- end Create_Appearances

function Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current,
                          pool_construct)
    local Preset25Object = Root().ShowData.DataPools[pool_construct].PresetPools[25]
    Preset25Object:Set('PresetMode', 'Universal')

    CmdIndirectWait("ClearAll /nu")
    CmdIndirectWait('Fixture Thru')
    for col in ipairs(TCol) do
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        local convert = prefix .. StringColName
        local Name = string.gsub(convert, " ", "_")
        CmdIndirectWait('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        CmdIndirectWait('Store DataPool ' .. pool_construct .. ' Preset 25.' .. All_5_Current .. '')
        CmdIndirectWait('Label DataPool ' .. pool_construct .. ' Preset 25.' .. All_5_Current .. " " .. Name .. " ")
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end
    CmdIndirectWait("ClearAll /nu")
    return All_5_NrEnd, All_5_Current
end -- end Create_Preset_25

function LC_Dialog_End(message)
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 800, 800
    local mybutton = dialog:Append('Button')
    mybutton.Font = 1
    mybutton.TextAutoAdjust = "Yes"
    mybutton.Text = message
end

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
end

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
end

-- SelectedGrp,SelectedGrpNo, SelectedGrpName,
function Create_Appearances_Sequences(CurrentMacroNr, SelectedGelNr, NbGroup, RefX, LayY,
                                      LayH, NrAppear, AppNr, NrNeed, TLayNr, LayW, LayNr,
                                      CurrentSeqNr, MaxColLgn, TCol, prefix,
                                      All_5_NrStart, MatrickNrStart, AppTricks,
                                      Construct_Pool, Groups_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local LastSeqColor, grpnrselect
    local ColLgnCount                                    = 0
    local Ligne_Inc                                      = false
    local GroupsObject                                   = Root().ShowData.DataPools[Groups_Pool].Groups:Children()
    local All5Object                                     = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]
    local MatricksObject                                 = Root().ShowData.DataPools[Construct_Pool].Matricks
    local AppearObject                                   = Root().ShowData.Appearances
    for g = 1, NbGroup, 1 do
        -- for r in ipairs(GroupsObject) do
        --     Echo('grp name ' .. GroupsObject[r].Name)
        --     if GroupsObject[r].Name == SelectedGrp[g]:gsub("'", "") then
        --         grpnrselect = r
        --         break
        --     end
        -- end
        -- Echo('Select ' .. SelectedGrp[g]:gsub("'", ""))
        -- Echo('GRP ' .. GroupsObject[grpnrselect].NO)
        local LayX = RefX
        local col_count = 0
        LayY = math.floor(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!
        NrAppear = math.floor(AppNr + 1)
        NrNeed = math.floor(AppNr + 1)
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', GroupsObject[1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Group' .. g)
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        Layout_Object[TLayNr][Nr.No]:Set('visibilityobjectname', 'Visible')
        -- CmdIndirectWait("Assign DataPool " .. Groups_Pool .. " Group " .. SelectedGrp[g] ..
        --     " at DataPool " .. Groups_Pool .. " Layout " .. TLayNr)
        -- CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppNr ..
        --     " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH ..
        --     " Action='Layout Default' VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilitySelectionRelevance=1 VisibilityBorder=0 VisibilityIcon=0")
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
            -- local GrpNo = SelectedGrpNo[g]
            -- GrpNo = string.gsub(GrpNo, "'", "")

            LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
            SequenceObject:Create(CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('Name',
                "'" .. prefix .. StringColName .. "_Group_" .. g .. "'")
            LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
            SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
            SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
            SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

            SequenceObject[CurrentSeqNr]:Insert()
            SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[NrNeed + 1])
            SequenceObject[CurrentSeqNr][3]:Set('No', 1)
            SequenceObject[CurrentSeqNr][3]:Create(1)
            SequenceObject[CurrentSeqNr][3][1]:Insert()
            SequenceObject[CurrentSeqNr][3][1]:Set('Appearance', AppearObject[NrNeed])
            SequenceObject[CurrentSeqNr][3][1]:Create(1)
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Selection', GroupsObject[1])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Values', All5Object[All_5_NrStart + col - 1])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('MAtricks', MatricksObject[MatrickNrStart])
            SequenceObject[CurrentSeqNr][3][1][1]:Set('SelectionMode', 'Strict')
            SequenceObject[CurrentSeqNr][3][1][1]:Set('Enabled', 'Yes')

            -- CmdIndirectWait("ClearAll /nu")
            -- CmdIndirectWait("Store Sequence " ..
            --     CurrentSeqNr .. " \"" .. prefix .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
            -- CmdIndirectWait("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            -- CmdIndirectWait("Assign Group " .. GrpNo .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            -- CmdIndirectWait('Assign Values Preset 25.' ..
            --     All_5_NrStart + col - 1 .. "At Sequence " .. CurrentSeqNr .. 'Cue 1 part 0.1')
            -- CmdIndirectWait('Assign MAtricks ' ..
            --     MatrickNrStart .. ' At Sequence ' .. CurrentSeqNr .. ' Cue 1 Part 0.1 /nu')
            -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. NrNeed)
            -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
            -- Command_Ext_Suite(CurrentSeqNr)
            -- Add Squences to Layout

            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', 100)
            Layout_Object[TLayNr][Nr.No]:Set('height', 100)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)

            -- CmdIndirectWait("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            -- CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
            --     " Property PosX " .. LayX .. " PosY " .. LayY ..
            --     " PositionW " .. LayW .. " PositionH " .. LayH ..
            --     " Action='Layout Default' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")

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
                Ligne_Inc = true
            end
            LayNr = math.floor(LayNr + 1)
            LastSeqColor = CurrentSeqNr
            CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        end -- end COLOR SEQ

        -- add matrick group

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. "Tricks_Group_" .. g .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppTricks[2].Nr])

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command', "Assign DataPool " .. Construct_Pool ..
            " MaTricks '" .. prefix .. '_Group_' .. g ..
            "' At DataPool " .. Construct_Pool .. " Sequence " .. FirstSeqColor .. " Thru " .. LastSeqColor ..
            " Cue 1 part 0.1 ;  Assign DataPool " .. Construct_Pool .. " Sequence " .. CurrentSeqNr + 1 ..
            " At DataPool " .. Construct_Pool .. " Layout " .. TLayNr .. "." .. LayNr .. "")

        -- Assign DataPool 2 MAtricks LC1_SPOT_GRID At DataPool 2 Sequence 2 Thru 30 Cue 1 Part 0.1 ; Assign DataPool 2 Sequence 32 At DataPool 2 Layout 2.31
        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. "Tricks" .. SelectedGrpName[g]:gsub('\'', ''))
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Command=\'Assign DataPool ' ..
        --     Construct_Pool .. ' MaTricks ' .. prefix .. SelectedGrpName[g]:gsub('\'', '') ..
        --     ' At DataPool ' .. Construct_Pool .. ' Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
        --     ' Cue 1 part 0.1 ;  Assign DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr + 1 ..
        --     ' At DataPool ' .. Construct_Pool .. ' Layout ' .. TLayNr .. '.' .. LayNr)
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[2].Nr)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Tricks')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        -- CmdIndirectWait("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        -- CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        --     " PosX " .. LayX .. " PosY " .. LayY ..
        --     " PositionW " .. LayW - 35 .. " PositionH " .. LayH - 35 ..
        --     " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")

        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. "Tricksh" .. '_Group_' .. g .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppearObject[AppTricks[1].Nr])
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Create(1)
        SequenceObject[CurrentSeqNr][3][1]:Set('Command', "Assign DataPool " .. Construct_Pool ..
            ' MaTricks ' .. MatrickNrStart .. ' At DataPool ' .. Construct_Pool .. ' Sequence ' .. FirstSeqColor ..
            ' Thru ' .. LastSeqColor .. ' Cue 1 part 0.1 ; Assign DataPool ' .. Construct_Pool ..
            ' Sequence ' .. CurrentSeqNr - 1 .. ' At DataPool ' .. Construct_Pool .. ' Layout ' .. TLayNr ..
            '.' .. LayNr .. "")

        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. "Tricksh" .. SelectedGrpName[g]:gsub('\'', '') ..
        --     '\'')
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr ..
        --     ' Cue 1 Property Command=\'Assign DataPool ' .. Construct_Pool .. ' MaTricks ' .. MatrickNrStart ..
        --     ' At DataPool ' .. Construct_Pool .. ' Sequence ' .. FirstSeqColor .. ' Thru ' .. LastSeqColor ..
        --     ' Cue 1 part 0.1 ; Assign DataPool ' .. Construct_Pool ..' Sequence ' .. CurrentSeqNr - 1 ..
        --     ' At DataPool ' .. Construct_Pool .. ' Layout ' .. TLayNr .. '.' .. LayNr)
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppTricks[1].Nr)

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW - 35 + 20)

        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. '_Group_' .. g .. "'")
        MacroObject[CurrentMacroNr]:Set('Appearance', AppearObject[AppTricks[3].Nr])
        MacroObject[CurrentMacroNr]:Insert(1)

        MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
            Construct_Pool .. ' Matrick ' .. prefix .. '_Group_' .. g)

        -- CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))
        -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
        -- Cmd('Insert')
        -- CmdIndirectWait('set 1 Command=\'Edit DataPool ' ..
        --     Construct_Pool .. ' Matrick ' .. prefix .. SelectedGrpName[g]:gsub('\'', ''))

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Macro')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        -- CmdIndirectWait('Assign Macro ' .. CurrentMacroNr .. " at layout " .. TLayNr)
        -- CmdIndirectWait('set Macro ' .. CurrentMacroNr .. ' Property Appearance=' .. AppTricks[3].Nr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname= 0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- FirstSeqColor = CurrentSeqNr
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    end                              -- end GRP
    return LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr, ColLgnCount, Ligne_Inc
end                                  -- end Create_Appearances_Sequences

function Create_Fade_Sequences(MakeX, FirstSeqTime, LastSeqTime, CurrentSeqNr, CurrentMacroNr, prefix, surfix,
                               First_Id_Lay, LayNr, MatrickNrStart, TLayNr, Fade_Element, Argument_Fade,
                               AppImp, LayX, LayY, LayW, LayH, SeqNrStart, SeqNrEnd, Current_Id_Lay, Delay_F_Element, a,
                               Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    -- Setup Fade Sequence
    prefix                                               = 'o' .. prefix
    if MakeX then
        FirstSeqTime = CurrentSeqNr
        First_Id_Lay[37] = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 5)
    else
        FirstSeqTime = CurrentSeqNr
        LastSeqTime = math.floor(CurrentSeqNr + 4)
    end
    -- Create Macro Time Input
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. 'Time Input' .. surfix[a] .. "'")
    MacroObject[CurrentMacroNr]:Insert(1)
    if MakeX then
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
        Fade_Element = math.floor(LayNr + 3)
    else
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    end
    for i = 2, 9, 1 do
        MacroObject[CurrentMacroNr]:Insert(i)
    end
    MacroObject[CurrentMacroNr][2]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][3]:Set('Command', 'Edit DataPool ' ..
        Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
    MacroObject[CurrentMacroNr][4]:Set('Command', 'SetUserVariable "LC_Fonction" 1')
    MacroObject[CurrentMacroNr][5]:Set('Command', 'SetUserVariable "LC_Axes" ' .. a .. '')
    MacroObject[CurrentMacroNr][6]:Set('Command', 'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    MacroObject[CurrentMacroNr][7]:Set('Command', 'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    MacroObject[CurrentMacroNr][8]:Set('Command', 'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    MacroObject[CurrentMacroNr][9]:Set('Command', 'Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View"')
    CurrentMacroNr = CurrentMacroNr + 1
    -- CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. 'Time Input' .. surfix[a] .. '')
    -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
    -- Cmd('Insert')
    -- if MakeX then
    --     CmdIndirectWait('set 1 Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
    --         FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    --     Fade_Element = math.floor(LayNr + 3)
    -- else
    --     CmdIndirectWait('set 1 Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
    --         First_Id_Lay[37] .. ' + ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. LastSeqTime .. '')
    -- end
    -- Cmd('Insert')
    -- CmdIndirectWait('set 2 Command=\'Edit DataPool ' ..
    --     Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeFrom' .. surfix[a] .. '"')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 3 Command=\'Edit DataPool ' ..
    --     Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "FadeTo' .. surfix[a] .. '"')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 4 Command=\'SetUserVariable "LC_Fonction" 1')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 5 Command=\'SetUserVariable "LC_Axes" ' .. a .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 6 Command=\'SetUserVariable "LC_Layout" ' .. TLayNr .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 7 Command=\'SetUserVariable "LC_Element" ' .. Fade_Element .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 8 Command=\'SetUserVariable "LC_Matrick" ' .. MatrickNrStart .. '')
    -- CmdIndirectWait("Insert")
    -- CmdIndirectWait('set 9 Command=\'Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View"')
    -- CmdIndirectWait('ChangeDestination Root')
    if a == 1 then
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Fade[1].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[2].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[1].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; Set Sequence ' ..
            SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')


        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[1].name .. surfix[a] .. '\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[1].Nr)
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' ..
        --     Construct_Pool .. ' Sequence ' .. FirstSeqTime .. ' Thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr ..
        --     ' ; Set Sequence ' ..
        --     SeqNrStart .. ' Thru ' .. SeqNrEnd .. ' UseExecutorTime=' .. Argument_Fade[1].UseExTime .. '')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[2].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 100)
        Layout_Object[TLayNr][Nr.No]:Set('height', 100)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')

        LayNr = math.floor(LayNr + 1)
        Command_Title('Ex.Time', TLayNr, LayNr, LayX, LayY, 700, 140, 1, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('FADE', TLayNr, LayNr, LayX, LayY, 700, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX, LayY, 700, 140, 3, Construct_Pool)
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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Fade[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ia].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        if i == 6 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. "'")
        else
            CurrentMacroNr = Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
                LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool)
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + i - 1 .. "'")
        end
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Fade[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 6 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        -- Create_Macro_Fade_E(CurrentMacroNr, prefix, Argument_Fade, i, surfix, a, FirstSeqTime,
        --     LastSeqTime, CurrentSeqNr, SeqNrStart, SeqNrEnd, MatrickNrStart, TLayNr, Fade_Element, Construct_Pool)
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr ..
        --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + i - 1 .. '')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_F_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences FADE

    --     if MakeX then
    --         CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    --         CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --             ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --             ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --             ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    --         LayX = math.floor(LayX + LayW + 20)
    --         LayNr = math.floor(LayNr + 1)
    --         Delay_F_Element = math.floor(LayNr + 1)
    --     end
    --     CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    -- end -- end Sequences FADE
    return CurrentSeqNr, Delay_F_Element, LayNr, LayX, Current_Id_Lay, Fade_Element, CurrentMacroNr
end -- end Create_Fade_Sequences

function Create_Delay_From_Sequences(First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, surfix, Argument_Delay,
                                     AppImp, CurrentMacroNr, a, MatrickNrStart, TLayNr, Delay_F_Element, MatrickNr, MakeX,
                                     LayX, LayY, LayW, LayH, Delay_T_Element, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup DelayFrom Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 5)
    local FirstSeqDelayFrom = CurrentSeqNr
    local LastSeqDelayFrom = math.floor(CurrentSeqNr + 4)

    -- Create Macro DelayFrom Input
    Create_Macro_Delay_From(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayFrom, LastSeqDelayFrom,
        MatrickNrStart, 2, TLayNr, Delay_F_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('DELAY FROM', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Delay[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqDelayFrom .. ' Thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Delay[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set DataPool ' .. Construct_Pool .. ' Sequence ' .. CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqDelayFrom .. ' Thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
        --         MatrickNrStart .. ' Property "DelayFrom' .. surfix[a] .. '" ' .. Argument_Delay[i].Time ..
        --         '  ; SetUserVariable "LC_Fonction" 2 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Delay_F_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)

        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Delay_T_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        --     CmdIndirectWait("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        --     CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        --         " Property PosX " .. LayX .. " PosY " .. LayY ..
        --         " PositionW " .. LayW .. " PositionH " .. LayH ..
        --         " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Delay_T_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayFrom
    return Current_Id_Lay, First_Id_Lay, LayX, LayNr, Delay_T_Element, CurrentSeqNr, CurrentMacroNr
end     --Create_Delay_From_Sequences

function Create_Delay_To_Sequences(a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, prefix, Argument_DelayTo, surfix,
                                   MatrickNrStart, TLayNr, Delay_T_Element, MatrickNr, AppImp, LayX, LayY, LayW, LayH,
                                   Phase_Element, CurrentMacroNr, MakeX, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup DelayTo Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    local FirstSeqDelayTo = CurrentSeqNr
    local LastSeqDelayTo = math.floor(CurrentSeqNr + 4)
    -- Create Macro DelayTo Input
    Create_Macro_Delay_To(CurrentMacroNr, prefix, surfix, a, FirstSeqDelayTo, LastSeqDelayTo, MatrickNrStart,
        3, TLayNr, Delay_T_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('DELAY TO', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqDelayTo .. ' Thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
                MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_DelayTo[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqDelayTo .. ' Thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' ..
        --         MatrickNrStart .. ' Property "DelayTo' .. surfix[a] .. '" ' .. Argument_DelayTo[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 3 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Delay_T_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- if MakeX then
        --     -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        --     -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Phase_Element = math.floor(LayNr + 2)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end -- end Sequences DelayTo
    return First_Id_Lay, Current_Id_Lay, LayX, LayNr, Phase_Element, CurrentSeqNr, CurrentMacroNr
end     -- end Create_Delay_To_Sequences

function Create_Phase_Sequence(LayY, LayX, LayW, a, First_Id_Lay, LayNr, CurrentSeqNr, Current_Id_Lay, CurrentMacroNr,
                               prefix, surfix, MatrickNrStart, TLayNr, Phase_Element, MatrickNr, AppImp, MakeX, LayH,
                               RefX, Group_Element, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
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
        Construct_Pool)

    -- Create Sequences Phase

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. 'Phase Input' .. surfix[a] .. "'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[64].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[63].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('Command', 'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')


    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'Phase Input' .. surfix[a] .. '\'')
    -- Add CmdIndirectWait to Squence
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[63].Nr)
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[64].Nr)
    -- Command_Ext_Suite(CurrentSeqNr)

    -- Add Squences to Layout
    if MakeX then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)
        LayX = math.floor(LayX + LayW + 20)
        LayNr = math.floor(LayNr + 1)
        Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Group_Element = math.floor(LayNr + 1)
    end
    CurrentSeqNr = math.floor(CurrentSeqNr + 1)

    -- if MakeX then
    -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
    --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
    --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
    --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    -- LayX = math.floor(LayX + LayW + 20)
    -- LayNr = math.floor(LayNr + 1)
    -- Command_Title('PHASE', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 4)
    -- LayNr = math.floor(LayNr + 1)
    -- Command_Title('none > none', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 1)
    -- LayNr = math.floor(LayNr + 1)
    -- Group_Element = math.floor(LayNr + 1)
    -- end
    -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    return Current_Id_Lay, CurrentMacroNr, LayY, LayX, LayNr, CurrentSeqNr, Group_Element
end -- end Create_Phase_Sequence

function Create_Group_Sequence(CurrentMacroNr, FirstSeqGrp, CurrentSeqNr, LastSeqGrp, prefix, surfix, a, MatrickNrStart,
                               TLayNr, Group_Element, MatrickNr, LayNr, LayX, LayY, First_Id_Lay, Current_Id_Lay,
                               Argument_Xgrp, AppImp, LayW, LayH, Block_Element, MakeX, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    -- Setup XGroup Sequence
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqGrp = CurrentSeqNr
    LastSeqGrp = math.floor(CurrentSeqNr + 4)
    -- Create Macro Group Input
    Create_Macro_Group(CurrentMacroNr, prefix, surfix, a, FirstSeqGrp, LastSeqGrp, MatrickNrStart, 5, TLayNr,
        Group_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('GROUP', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('None', TLayNr, LayNr, LayX - 120, LayY - 30, 700, 170, 3, Construct_Pool)
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
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqGrp .. ' Thru ' .. LastSeqGrp .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Group" ' .. Argument_Xgrp[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xgrp[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqGrp .. ' Thru ' .. LastSeqGrp .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
        --         'Group" ' .. Argument_Xgrp[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 5 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Group_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Block_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- if MakeX then
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     " Action='Layout Default' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        --     Block_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Block_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, LastSeqGrp,
        FirstSeqGrp
end -- end Create_Group_Sequence

function Create_Block_Sequence(CurrentMacroNr, FirstSeqBlock, CurrentSeqNr, LastSeqBlock, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Block_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xblock, AppImp, Wings_Element, LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqBlock = CurrentSeqNr
    LastSeqBlock = math.floor(CurrentSeqNr + 4)
    -- Create Macro Block Input
    Create_Macro_Block(CurrentMacroNr, prefix, surfix, a, FirstSeqBlock, LastSeqBlock, MatrickNrStart, 6,
        TLayNr, Block_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('BLOCK', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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

        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xblock[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqBlock .. ' Thru ' .. LastSeqBlock .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart ..
                ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
                ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xblock[i].name .. surfix[a] .. '\'')
        -- Add CmdIndirectWait to Squence
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr ..
        --         ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqBlock .. ' Thru ' .. LastSeqBlock .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart ..
        --         ' Property "' .. surfix[a] .. 'Block" ' .. Argument_Xblock[i].Time ..
        --         ' ; SetUserVariable "LC_Fonction" 6 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Block_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- end Sequences
        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Wings_Element = math.floor(LayNr + 1)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --     ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        -- LayX = math.floor(LayX + LayW + 20)
        --     -- LayNr = math.floor(LayNr + 1)
        --     Wings_Element = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, Wings_Element, LayNr, LayX, Current_Id_Lay, First_Id_Lay, CurrentMacroNr, FirstSeqBlock,
        LastSeqBlock
end -- end Create_Block_Sequence

function Create_Wings_Sequence(CurrentMacroNr, FirstSeqWings, CurrentSeqNr, LastSeqWings, prefix, surfix, a,
                               MatrickNrStart, TLayNr, Wings_Element, MatrickNr, MakeX, LayNr, LayX, LayY, First_Id_Lay,
                               Current_Id_Lay, Argument_Xwings, AppImp, LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    FirstSeqWings = CurrentSeqNr
    LastSeqWings = math.floor(CurrentSeqNr + 4)
    -- Create Macro Wings Input
    Create_Macro_Wings(CurrentMacroNr, prefix, surfix, a, FirstSeqWings, LastSeqWings, MatrickNrStart, 7,
        TLayNr, Wings_Element, MatrickNr, Construct_Pool)

    if MakeX then
        Command_Title('WINGS', TLayNr, LayNr, LayX, LayY, 580, 140, 2, Construct_Pool)
        LayNr = math.floor(LayNr + 1)
        Command_Title('none', TLayNr, LayNr, LayX, LayY, 580, 140, 3, Construct_Pool)
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
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. Argument_Xwings[i].name .. surfix[a] .. "'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[ib].Nr)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[ia].Nr)
        if i == 5 then
            SequenceObject[CurrentSeqNr][3]:Set('Command',
                'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        else
            SequenceObject[CurrentSeqNr][3]:Set('Command', 'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
                FirstSeqWings .. ' Thru ' .. LastSeqWings .. ' - ' .. CurrentSeqNr ..
                ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
                'Wings" ' .. Argument_Xwings[i].Time ..
                '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
                '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
                ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
                ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
                ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
                ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        end

        -- CmdIndirectWait('ClearAll /nu')
        -- CmdIndirectWait('Store Sequence ' ..
        --     CurrentSeqNr .. ' \'' .. prefix .. Argument_Xwings[i].name .. surfix[a] .. '\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[ia].Nr)
        -- if i == 5 then
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr ..
        --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
        -- else
        --     CmdIndirectWait('Set Sequence ' ..
        --         CurrentSeqNr .. ' Cue 1 Property Command=\'Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --         FirstSeqWings .. ' Thru ' .. LastSeqWings .. ' - ' .. CurrentSeqNr ..
        --         ' ; Set DataPool ' .. Construct_Pool .. ' Matricks ' .. MatrickNrStart .. ' Property "' .. surfix[a] ..
        --         'Wings" ' .. Argument_Xwings[i].Time ..
        --         '  ; SetUserVariable "LC_Fonction" 7 ; SetUserVariable "LC_Axes" "' .. a ..
        --         '" ; SetUserVariable "LC_Layout" ' .. TLayNr ..
        --         ' ; SetUserVariable "LC_Element" ' .. Wings_Element ..
        --         ' ; SetUserVariable "LC_Matrick" ' .. MatrickNrStart ..
        --         ' ; SetUserVariable "LC_Matrick_Thru" ' .. MatrickNr ..
        --         ' ; Call DataPool ' .. Construct_Pool .. ' Plugin "LC_View" ')
        -- end -- end Sequences
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[ib].Nr)
        -- Command_Ext_Suite(CurrentSeqNr)
        -- Add Squences to Layout
        if MakeX then
            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
            Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)
            LayX = math.floor(LayX + LayW + 20)
            LayNr = math.floor(LayNr + 1)
            Phase_Element = math.floor(LayNr + 2)
        end
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)

        -- if MakeX then
        --     CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --         ' Property PosX ' .. LayX .. ' PosY ' .. LayY ..
        --         ' PositionW ' .. LayW .. ' PositionH ' .. LayH ..
        --         ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        --     LayX = math.floor(LayX + LayW + 20)
        --     LayNr = math.floor(LayNr + 1)
        -- end
        -- CurrentSeqNr = math.floor(CurrentSeqNr + 1)
    end
    return CurrentSeqNr, LayNr, LayX, Current_Id_Lay, First_Id_Lay, LastSeqWings, FirstSeqWings, CurrentMacroNr
end -- end Create_Wings_Sequence

function Create_XYZ_Sequence(CurrentMacroNr, First_Id_Lay, prefix, surfix, Call_inc, CallT, MatrickNrStart, a,
                             CurrentSeqNr, TLayNr, Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element,
                             Group_Element, Block_Element, Wings_Element, MatrickNr, AppImp, MakeX, LayNr, LayX, LayY,
                             LayW, LayH, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    prefix = 'o' .. prefix
    CurrentMacroNr = math.floor(CurrentMacroNr + 1)
    First_Id_Lay[33 + a] = CurrentMacroNr
    LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
    MacroObject:Create(CurrentMacroNr)
    MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Call'")
    -- CmdIndirectWait('Store Macro ' .. CurrentMacroNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    -- CmdIndirectWait('ChangeDestination Macro ' .. CurrentMacroNr .. '')
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
        MacroObject[CurrentMacroNr]:Insert(1)
        MacroObject[CurrentMacroNr][1]:Set('Command', 'Assign DataPool ' .. Construct_Pool .. ' Sequence ' ..
            First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Construct_Pool .. ' Layout ' ..
            TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        -- Cmd('Insert')
        -- CmdIndirectWait('Set ' .. m .. ' Command=\'Assign DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --     First_Id_Lay[CallT + a] + Call_inc .. ' At DataPool ' .. Construct_Pool .. ' Layout ' ..
        --     TLayNr .. '.' .. First_Id_Lay[CallT] + Call_inc)
        Call_inc = math.floor(Call_inc + 1)
    end
    -- CmdIndirectWait('ChangeDestination Root')
    Create_Macro_Reset(CurrentMacroNr, prefix, surfix, MatrickNrStart, a, CurrentSeqNr, First_Id_Lay, TLayNr,
        Fade_Element, Delay_F_Element, Delay_T_Element, Phase_Element, Group_Element, Block_Element,
        Wings_Element, MatrickNr, Construct_Pool)

    First_Id_Lay[28 + a] = CurrentSeqNr

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Call'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', AppImp[67 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', AppImp[66 + tonumber(a * 2 - 1)].Nr)
    SequenceObject[CurrentSeqNr][3]:Set('Command', 'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')

    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. surfix[a] .. '_Call\'')
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Appearance=' .. AppImp[66 + tonumber(a * 2 - 1)].Nr)
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr .. ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr .. '')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. AppImp[67 + tonumber(a * 2 - 1)].Nr)
    -- Command_Ext_Suite(CurrentSeqNr)

    LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
    SequenceObject:Create(CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. surfix[a] .. "_Reset'")
    LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
    SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
    SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
    SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

    SequenceObject[CurrentSeqNr]:Insert()
    SequenceObject[CurrentSeqNr]:Set('Appearance', prefix:gsub('o', '') .. "'skull_off'")
    SequenceObject[CurrentSeqNr][3]:Set('No', 1)
    SequenceObject[CurrentSeqNr][3]:Set('Appearance', prefix:gsub('o', '') .. "'skull_on'")
    SequenceObject[CurrentSeqNr][3]:Set('Command',
        'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + 1 .. '')

    -- CmdIndirectWait('ClearAll /nu')
    -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr + 1 .. ' \'' .. prefix .. surfix[a] .. '_Reset\'')
    -- CmdIndirectWait("Set Sequence " ..
    --     CurrentSeqNr + 1 .. " Cue 1 Property Appearance=" .. prefix:gsub('o', '') .. "'skull_on'")
    -- CmdIndirectWait('Set Sequence ' ..
    --     CurrentSeqNr + 1 ..
    --     ' Cue 1 Property Command=\'Go DataPool ' .. Construct_Pool .. ' Macro ' .. CurrentMacroNr + 1 .. '')
    -- CmdIndirectWait("Set Sequence " ..
    --     CurrentSeqNr + 1 .. " Property Appearance=" .. prefix:gsub('o', '') .. "'skull_off'")
    -- Command_Ext_Suite(CurrentSeqNr + 1)
    if MakeX == false then
        LayNr = math.floor(LayNr + 1)
    end
    if a == 1 then
        First_Id_Lay[32] = LayX
        First_Id_Lay[33] = LayY
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 170 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 170)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 170 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    elseif a == 2 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 90 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 90)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 90 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    elseif a == 3 then
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32])
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr ..
        --     ' Property PosX ' .. First_Id_Lay[32] .. ' PosY ' .. First_Id_Lay[33] + 10 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr + 1])
        Layout_Object[TLayNr][Nr.No]:Set('posx', First_Id_Lay[32] + 85)
        Layout_Object[TLayNr][Nr.No]:Set('posy', First_Id_Lay[33] + 10)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW - 35)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH - 35)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'X_Y_Z')
        -- CmdIndirectWait('Assign Sequence ' .. CurrentSeqNr + 1 .. ' at Layout ' .. TLayNr)
        -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr + 1 ..
        --     ' Property PosX ' .. First_Id_Lay[32] + 85 .. ' PosY ' .. First_Id_Lay[33] + 10 ..
        --     ' PositionW ' .. LayW - 35 .. ' PositionH ' .. LayH - 35 ..
        --     ' VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0')
    end
    return First_Id_Lay, LayNr, CurrentMacroNr
end -- end Create_XYZ_Sequence

function Create_All_Color(TCol, CurrentSeqNr, prefix, TLayNr, LayNr, NrNeed, LayX, LayY, LayW, LayH, MaxColLgn,
                          RefX, AppNr, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
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
            First_All_Color = prefix .. 'ALL' .. StringColName .. 'ALL\''
        end
        LC_Check_Size_Pool(CurrentSeqNr, SequenceObject)
        SequenceObject:Create(CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('Name', "'" .. prefix .. 'ALL' .. StringColName .. "ALL'")
        LC_Sequence_Defo(SequenceObject, CurrentSeqNr)
        SequenceObject[CurrentSeqNr]:Set('TRACKING', 'No')
        SequenceObject[CurrentSeqNr]:Set('PRIORITY', 'HTP')
        SequenceObject[CurrentSeqNr]:Set('SOFTLTP', 'No')

        SequenceObject[CurrentSeqNr]:Insert()
        SequenceObject[CurrentSeqNr]:Set('Appearance', NrNeed + 1)
        SequenceObject[CurrentSeqNr][3]:Set('No', 1)
        SequenceObject[CurrentSeqNr][3]:Set('Appearance', NrNeed + 1)
        SequenceObject[CurrentSeqNr][3]:Set('Command', 'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
            prefix .. StringColName .. '* ; Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
            CurrentSeqNr .. '\'')


        -- CmdIndirectWait("ClearAll /nu")
        -- CmdIndirectWait('Store Sequence ' .. CurrentSeqNr .. ' \'' .. prefix .. 'ALL' .. StringColName .. 'ALL\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Cue 1 Property Appearance=' .. NrNeed + 1)
        -- CmdIndirectWait('Set Sequence ' ..
        --     CurrentSeqNr .. ' Cue 1 Property Command= \'Go+ DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --     prefix .. StringColName .. '* ; Off DataPool ' .. Construct_Pool .. ' Sequence ' ..
        --     CurrentSeqNr .. '\'')
        -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Appearance=' .. NrNeed + 1)
        -- Command_Ext_Suite(CurrentSeqNr)
        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', LayW)
        Layout_Object[TLayNr][Nr.No]:Set('height', LayH)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        -- CmdIndirectWait("Assign Sequence " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        -- CmdIndirectWait("Set Layout " .. TLayNr .. "." .. LayNr ..
        --     " Property PosX " .. LayX .. " PosY " .. LayY ..
        --     " PositionW " .. LayW .. " PositionH " .. LayH ..
        --     " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0 VisibilityBorder=0 VisibilityIcon=0")

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

    return LayNr, LayX, First_All_Color
end -- end Create_All_Color

function Command_Title(title, TLayNr, LayNr, LayX, LayY, Pw, Ph, align, Construct_Pool)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)

    Nr = Layout_Object[TLayNr]:Acquire()
    Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('posy', LayX)
    Layout_Object[TLayNr][Nr.No]:Set('width', Pw)
    Layout_Object[TLayNr][Nr.No]:Set('height', Ph)
    Layout_Object[TLayNr][Nr.No]:Set('Note', 'Titre')
    Layout_Object[TLayNr][Nr.No]:Set('customtexttext', title)
    Layout_Object[TLayNr][Nr.No]:Set('Name', title)
    Layout_Object[TLayNr][Nr.No]:Set('visibilityborder', 'None')
    Layout_Object[TLayNr][Nr.No]:Set('bordersize', 0)
    Layout_Object[TLayNr][Nr.No]:Set('customtextsize', 24)
    Layout_Object[TLayNr][Nr.No]:Set('customtextalignmentv', 'Top')
    Layout_Object[TLayNr][Nr.No]:Set('Appearance', 'None')
    if (align == 1) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Left')
    elseif (align == 2) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Center')
    elseif (align == 3) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Right')
    elseif (align == 4) then
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmenth', 'Left')
        Layout_Object[TLayNr][Nr.No]:Set('customtextalignmentv', 'Bottom')
    end

    -- CmdIndirectWait('Store Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextText=\' ' .. title .. ' \'')
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextSize \'24')
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Top')
    -- if (align == 1) then
    --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    -- elseif (align == 2) then
    --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Center')
    -- elseif (align == 3) then
    --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Right')
    -- elseif (align == 4) then
    --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentH \'Left')
    --     CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property CustomTextAlignmentV \'Bottom')
    -- end
    -- CmdIndirectWait('Set Layout ' .. TLayNr .. '.' .. LayNr .. ' Property VisibilityBorder=0 VisibilityIcon=0')
    -- CmdIndirectWait('Set Layout ' .. TLayNr ..
    --     '.' .. LayNr .. ' Property PosX ' .. LayX .. ' PosY ' .. LayY .. ' PositionW ' .. Pw .. ' PositionH ' .. Ph .. '')
end -- end function Command_Title(...)

function Command_Ext_Suite(CurrentSeqNr)
    ErrEcho('Call Command_Ext_suite')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property prefercueappearance=on')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property AutoStart=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property AutoStop=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property MasterGoMode=None')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property AutoFix=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property AutoStomp=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Tracking=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property WrapAround=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property ReleaseFirstCue=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property RestartMode=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property CueCommand=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property XFadeReload=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property OutputFilter=""')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Priority=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SoftLTP=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property PlaybackMaster=""')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property XfadeMode=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property RateMaster=""')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property RateScale=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SpeedMaster=""')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SpeedScale=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SpeedfromRate=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property InputFilter=""')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SwapProtect=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property KillProtect=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property IncludeLinkLastGo=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property UseExecutorTime=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property OffwhenOverridden=1')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property Lock=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SequMIB=0')
    -- CmdIndirectWait('Set Sequence ' .. CurrentSeqNr .. ' Property SequMIBMode=1')
end -- end function Command_Ext_Suite(...)

--end LC_Cmd.lua
