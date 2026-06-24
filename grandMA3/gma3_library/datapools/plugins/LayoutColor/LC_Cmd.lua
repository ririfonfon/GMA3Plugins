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
                                      Construct_Pool, Groups_Pool,Color_Range)
    local MacroObject, SequenceObject, Layout_Object, Nr = LC_Get_Object(Construct_Pool)
    local LastSeqColor, grpnrselect
    local ColLgnCount                                    = 0
    local Ligne_Inc                                      = false
    local GroupsObject                                   = Root().ShowData.DataPools[Groups_Pool].Groups:Children()
    local All5Object                                     = Root().ShowData.DataPools[Construct_Pool].PresetPools[25]
    local MatricksObject                                 = Root().ShowData.DataPools[Construct_Pool].Matricks
    local AppearObject                                   = Root().ShowData.Appearances
    
    for g = 1, NbGroup, 1 do
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
        Layout_Object[TLayNr][Nr.No]:Set('Action', 0)
    
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

            Nr = Layout_Object[TLayNr]:Acquire()
            Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
            Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
            Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
            Layout_Object[TLayNr][Nr.No]:Set('width', 100)
            Layout_Object[TLayNr][Nr.No]:Set('height', 100)
            Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
            Layout_Object[TLayNr][Nr.No]:Set('Note', 'Seq Color')
            LC_Set_Def(TLayNr, Nr, Layout_Object)

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

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', SequenceObject[CurrentSeqNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Tricks')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

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

        LayNr = math.floor(LayNr + 1)
        LayX = math.floor(LayX + LayW - 35 + 20)

        LC_Check_Size_Pool(CurrentMacroNr, MacroObject)
        MacroObject:Create(CurrentMacroNr)
        MacroObject[CurrentMacroNr]:Set('Name', "'" .. prefix .. '_Group_' .. g .. "'")
        MacroObject[CurrentMacroNr]:Set('Appearance', AppearObject[AppTricks[3].Nr])
        MacroObject[CurrentMacroNr]:Insert(1)

        MacroObject[CurrentMacroNr][1]:Set('Command', 'Edit DataPool ' ..
            Construct_Pool .. ' Matrick ' .. prefix .. '_Group_' .. g)

        Nr = Layout_Object[TLayNr]:Acquire()
        Layout_Object[TLayNr][Nr.No]:Set('Object', MacroObject[CurrentMacroNr])
        Layout_Object[TLayNr][Nr.No]:Set('posx', LayX)
        Layout_Object[TLayNr][Nr.No]:Set('posy', LayY)
        Layout_Object[TLayNr][Nr.No]:Set('width', 65)
        Layout_Object[TLayNr][Nr.No]:Set('height', 65)
        Layout_Object[TLayNr][Nr.No]:Set('action', 'Go+')
        Layout_Object[TLayNr][Nr.No]:Set('Note', 'Macro')
        LC_Set_Def(TLayNr, Nr, Layout_Object)

        CurrentMacroNr = math.floor(CurrentMacroNr + 1)
        LayNr = math.floor(LayNr + 1)
        CurrentSeqNr = math.floor(CurrentSeqNr + 1)
        -- FirstSeqColor = CurrentSeqNr
        LayY = math.floor(LayY - 20) -- Add offset for Layout Element distance
    end                              -- end GRP
    return LayY, NrNeed, LayNr, CurrentSeqNr, CurrentMacroNr, ColLgnCount, Ligne_Inc
end                                  -- end Create_Appearances_Sequences



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
