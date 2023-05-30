--[[
Color_Layout v1.1.3.3
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "Color_layout"

Releases:
* 1.1.4.0 - exec time delay from to X Matricks 

Created by Richard Fontaine "RIRI", April 2020.
--]]

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local function Main(display_Handle)

    local root = Root();

    -- Store all Groups in a Table
    local FixtureGroups = root.ShowData.DataPools.Default.Groups:Children()

    -- Store all ColorGel in a Table
    local ColPath = root.ShowData.GelPools
    local ColGels = ColPath:Children()

    -- Store all Used CustomImage in a Table to find the last free number, and define the Symbols
    local Img = root.ShowData.MediaPools.Symbols:Children()
    local ImgNr

    for k in pairs(Img) do
        ImgNr = Maf(Img[k].NO)
    end

    if ImgNr == nil then
        ImgNr = 0
    end

    local ImgImp = {
        {Name =     "\"on\"",               FileName = "\"on.png\"",            Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"off\"",              FileName = "\"off.png\"",           Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"time_on\"",          FileName = "\"time_on.png\"",       Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"time_off\"",         FileName = "\"time_off.png\"",      Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"exec_time_on\"",     FileName = "\"exec_time_on.png\"",  Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"exec_time_off\"",    FileName = "\"exec_time_off.png\"", Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"calcul_on\"",        FileName = "\"calcul_on.png\"",     Filepath = "\"../Layout_Color\"", }, 
        {Name =     "\"calcul_off\"",       FileName = "\"calcul_off.png\"",    Filepath = "\"../Layout_Color\"", }
    }    
    
    -- Store all Used Appearances in a Table to find the last free number
    local App = root.ShowData.Appearances:Children()
    local AppNr
    
    for k in pairs(App) do
        AppNr = Maf(App[k].NO)
    end
    AppNr = AppNr + 1
    
    local NrAppear
    local NrNeed
    local AppCrea = 0
    local StAppNameOn
    local StAppNameOff
    local StAppOn =         '\"Showdata.MediaPools.Symbols.on\"'
    local StAppOff =        '\"Showdata.MediaPools.Symbols.off\"'
    local StAppExecOn =     '\"Showdata.MediaPools.Symbols.exec_time_on\"'
    local StAppExecOff =    '\"Showdata.MediaPools.Symbols.exec_time_off\"'
    local StAppCalculOn =   '\"Showdata.MediaPools.Symbols.calcul_on\"'
    local StAppCalculOff =  '\"Showdata.MediaPools.Symbols.calcul_off\"'
    local StApp0On =        '\"Showdata.MediaPools.Symbols.[number_0_black_png]\"'
    local StApp0Off =       '\"Showdata.MediaPools.Symbols.[number_0_white_png]\"'
    local StApp1On =        '\"Showdata.MediaPools.Symbols.[number_1_black_png]\"'
    local StApp1Off =       '\"Showdata.MediaPools.Symbols.[number_1_white_png]\"'
    local StApp2On =        '\"Showdata.MediaPools.Symbols.[number_2_black_png]\"'
    local StApp2Off =       '\"Showdata.MediaPools.Symbols.[number_2_white_png]\"'
    local StApp3On =        '\"Showdata.MediaPools.Symbols.[number_3_black_png]\"'
    local StApp3Off =       '\"Showdata.MediaPools.Symbols.[number_3_white_png]\"'
    local StApp4On =        '\"Showdata.MediaPools.Symbols.[number_4_black_png]\"'
    local StApp4Off =       '\"Showdata.MediaPools.Symbols.[number_4_white_png]\"'
    local StApp6On =        '\"Showdata.MediaPools.Symbols.[number_6_black_png]\"'
    local StApp6Off =       '\"Showdata.MediaPools.Symbols.[number_6_white_png]\"'
    local FadeRef =         ' color=\'0,0.8,0,1\''
    local DelayRef =        ' color=\'0.8,0.8,0,1\'' 
    local DelayToRef =      ' color=\'0.8,0.3,0,1\''
    
    local AppImp = {
        {Name ='\'exectime_on\'',       StApp = StAppExecOn,    Nr ='', RGBref = FadeRef},
        {Name ='\'exectime_off\'',      StApp = StAppExecOff,   Nr ='', RGBref = FadeRef},
        {Name ='\'fade0_on\'',          StApp = StApp0On,       Nr ='', RGBref = FadeRef,       Time = 0},
        {Name ='\'fade0_off\'',         StApp = StApp0Off,      Nr ='', RGBref = FadeRef,       Time = 0},
        {Name ='\'fade1_on\'',          StApp = StApp1On,       Nr ='', RGBref = FadeRef,       Time = 1},
        {Name ='\'fade1_off\'',         StApp = StApp1Off,      Nr ='', RGBref = FadeRef,       Time = 1},
        {Name ='\'fade2_on\'',          StApp = StApp2On,       Nr ='', RGBref = FadeRef,       Time = 2},
        {Name ='\'fade2_off\'',         StApp = StApp2Off,      Nr ='', RGBref = FadeRef,       Time = 2},
        {Name ='\'fade4_on\'',          StApp = StApp4On,       Nr ='', RGBref = FadeRef,       Time = 4},
        {Name ='\'fade4_off\'',         StApp = StApp4Off,      Nr ='', RGBref = FadeRef,       Time = 4},
        {Name ='\'input_fade_on\'',     StApp = StAppCalculOn,  Nr ='', RGBref = FadeRef},
        {Name ='\'input_fade_off\'',    StApp = StAppCalculOff, Nr ='', RGBref = FadeRef},
        {Name ='\'delay0_on\'',         StApp = StApp0On,       Nr ='', RGBref = DelayRef,      Time = 0},
        {Name ='\'delay0_off\'',        StApp = StApp0Off,      Nr ='', RGBref = DelayRef,      Time = 0},
        {Name ='\'delay1_on\'',         StApp = StApp1On,       Nr ='', RGBref = DelayRef,      Time = 1},
        {Name ='\'delay1_off\'',        StApp = StApp1Off,      Nr ='', RGBref = DelayRef,      Time = 1},
        {Name ='\'delay2_on\'',         StApp = StApp2On,       Nr ='', RGBref = DelayRef,      Time = 2},
        {Name ='\'delay2_off\'',        StApp = StApp2Off,      Nr ='', RGBref = DelayRef,      Time = 2},
        {Name ='\'delay4_on\'',         StApp = StApp4On,       Nr ='', RGBref = DelayRef,      Time = 4},
        {Name ='\'delay4_off\'',        StApp = StApp4Off,      Nr ='', RGBref = DelayRef,      Time = 4},
        {Name ='\'input_delay_on\'',    StApp = StAppCalculOn,  Nr ='', RGBref = DelayRef},
        {Name ='\'input_delay_off\'',   StApp = StAppCalculOff, Nr ='', RGBref = DelayRef},
        {Name ='\'delayto0_on\'',       StApp = StApp0On,       Nr ='', RGBref = DelayToRef,    Time = 0},
        {Name ='\'delayto0_off\'',      StApp = StApp0Off,      Nr ='', RGBref = DelayToRef,    Time = 0},
        {Name ='\'delayto1_on\'',       StApp = StApp1On,       Nr ='', RGBref = DelayToRef,    Time = 1},
        {Name ='\'delayto1_off\'',      StApp = StApp1Off,      Nr ='', RGBref = DelayToRef,    Time = 1},
        {Name ='\'delayto2_on\'',       StApp = StApp2On,       Nr ='', RGBref = DelayToRef,    Time = 2},
        {Name ='\'delayto2_off\'',      StApp = StApp2Off,      Nr ='', RGBref = DelayToRef,    Time = 2},
        {Name ='\'delayto4_on\'',       StApp = StApp4On,       Nr ='', RGBref = DelayToRef,    Time = 4},
        {Name ='\'delayto4_off\'',      StApp = StApp4Off,      Nr ='', RGBref = DelayToRef,    Time = 4},
        {Name ='\'input_delayto_on\'',  StApp = StAppCalculOn,  Nr ='', RGBref = DelayToRef},
        {Name ='\'input_delayto_off\'', StApp = StAppCalculOff, Nr ='', RGBref = DelayToRef}
    }

    E(AppImp[3].StApp)

    local appcheck = {}
    for k in pairs(AppImp) do
        appcheck[k] = setmetatable({value = ''}, {ref = ''})
    end

    -- Store all Use Layout in a Table to find the last free number
    local TLay = root.ShowData.DataPools.Default.Layouts:Children()
    E("Layout = %s", tostring(TLay))
    local TLayNr
    local TLayNrRef

    for k in pairs(TLay) do
        E("Layout n° = %s", tostring(TLay[k].NO))
        TLayNr = Maf(tonumber(TLay[k].NO))
        TLayNrRef = k
    end

    -- Store all Used Sequence in a Table to find the last free number
    local SeqNr = root.ShowData.DataPools.Default.Sequences:Children()
    local SeqNrStart
    local SeqNrEnd

    for k in pairs(SeqNr) do
        SeqNrStart = Maf(SeqNr[k].NO)
    end

    if SeqNrStart == nil then
        SeqNrStart = 0
    end

    -- Store all Used Macro in a Table to find the last free number
    local MacroNr = root.ShowData.DataPools.Default.Macros:Children()
    local MacroNrStart

    for k in pairs(MacroNr) do
        MacroNrStart = Maf(MacroNr[k].NO)
    end

    if MacroNrStart == nil then
        MacroNrStart = 0
    end

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do
        TIconNr = Maf(TIcon[k].NO)
    end

    -- Store all Used MAtricks in a Table to find the last free number
    local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()
    local MatrickNrStart
    for k in pairs(MatrickNr) do
        MatrickNrStart = Maf(MatrickNr[k].NO)
    end
    if MatrickNrStart == nil then
        MatrickNrStart = 0
    end

    MatrickNrStart = Maf(MatrickNrStart + 1)

    -- variables
    local LayX
    local RefX = Maf(0 - TLay[TLayNrRef].DimensionW / 2)
    local LayY = TLay[TLayNrRef].DimensionH / 2
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local TCol
    local StColName
    local StringColName
    local StColCode
    local ColNr = 0
    local SelGrp
    local TGrpChoise
    local ChoGel = {}
    local SelColGel
    local SelectedGrp = {}
    local SelectedGrpNo = {}
    local GrpNo
    local SelectedGel
    local col_count
    local Message ="Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local MacroNrText = "Macro_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 100
    local count = 0
    local check = {}
    local NaLay = "Colors"
    local PopTableGrp = {}
    local PopTableGel = {}
    
    local FirstSeqTime
    local LastSeqTime
    local FirstSeqTimeFrom
    local LastSeqTimeFrom
    local FirstSeqTimeTo
    local LastSeqTimeTo
    
    local FirstSeqDelay
    local LastSeqDelay 
    local FirstSeqDelayFrom
    local LastSeqDelayFrom
    local FirstSeqDelayTo
    local LastSeqDelayTo

    local CurrentSeqNr
    local CurrentMacroNr

    local UsedW
    local UsedH

    local MaxColLgn = 40

    local long_imgimp
    local add_check = 0

    TLayNr = Maf(TLayNr + 1)
    SeqNrStart = SeqNrStart + 1
    MacroNrStart = MacroNrStart + 1

    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end

    local Swipe_Color = {
        {name ="Gels Choose", selectedValue=11, 
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
        commands = {{
            name = 'Add Group',
            value = 11
        }, {
            name = ColGelBtn,
            value = 12
        }, {
            name = OkBtn,
            value = ValOkBtn
        }, {
            name = 'Cancel',
            value = 0
        }},
        inputs = {{
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
        }},
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
            goto addGroup
        end

    elseif (box.result == 12) then
        ValOkBtn = Maf(ValOkBtn / 10)
        if (ValOkBtn < 10) then
            ValOkBtn = 1
            OkBtn = "OK Let's GO :)"
        end

        E("add ColorGel")
        SeqNrStart = box.inputs.Sequence_Start_Nr
        MacroNrStart = box.inputs.Macro_Start_Nr
        AppNr = box.inputs.Appearance_Start_Nr
        TLayNr = box.inputs.Layout_Nr
        NaLay = box.inputs.Layout_Name
        MaxColLgn = box.inputs.Max_Color_By_Line
        MatrickNrStart = box.inputs.Matrick_Start_Nr
        goto addColorGel

    elseif (box.result == 1) then
        if SelectedGel == nil then
            Co("no ColorGel are selected!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            goto addColorGel

        elseif next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            goto addGroup
        else
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            MatrickNrStart = box.inputs.Matrick_Start_Nr
            E("now i do some Magic stuff...")
            goto doMagicStuff
        end

    elseif (box.result == 0) then
        E("User Canceled")
        goto canceled
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
    ::addColorGel::

    -- ChoGel = {};
    -- for k in ipairs(ColGels) do
    --     table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    -- end

    -- Setup the Messagebox
    PopTableGel = {
        title = "ColorGel",
        caller = display_Handle,
        items = ChoGel,
        selectedValue = "",
        add_args = {
            FilterSupport = "Yes"
        }
    }
    SelColGel = PopupInput(PopTableGel)
    SelectedGel = ColGels[SelColGel + 1].name;
    SelectedGelNr = SelColGel + 1
    E("ColorGel " .. ColGels[SelColGel + 1].name .. " selected")
    ColGelBtn = "ColorGel " .. ColGels[SelColGel + 1].name .. " selected"
    goto MainBox
    -- End ColorGel	

    -- Magic Stuff
    ::doMagicStuff::

    --fix *NrStart & use Current*Nr
    CurrentSeqNr = SeqNrStart
    CurrentMacroNr = MacroNrStart

    --check Symbols
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
                Cmd("Store Image 2." .. ImgNr .. " " .. ImgImp[k].Name .. " Filename=" .. ImgImp[k].FileName .. " filepath=" ..    ImgImp[k].Filepath .. "")
            end
        end
    end
    -- End check Images  

    -- Create MAtricks
    Cmd('Store MAtricks ' .. MatrickNrStart .. ' /nu')
    Cmd('Set Matricks ' .. MatrickNrStart .. ' name = ' .. NaLay .. ' /nu')
    -- Create Appearances/Sequences

    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. NaLay .. "")
    -- end

    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    for g in ipairs(SelectedGrp) do

        LayX = RefX
        col_count = 0
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        if (AppCrea == 0) then
            AppNr = Maf(AppNr);
            Cmd("Store App " .. AppNr .. " \"Label\" Appearance=" .. StAppOn .. " color=\"0,0,0,1\"")
        end

        NrAppear = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)

        Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Action=0 Appearance=" .. AppNr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0")

        LayNr = Maf(LayNr + 1)
        LayX = Maf(LayX + LayW + 20)

        for col in ipairs(TCol) do
            col_count = col_count + 1
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            StColName = TCol[col].name
            StringColName = string.gsub( StColName," ","_" )
            ColNr = SelectedGelNr .. "." .. TCol[col].no

            -- Cretae Appearances only 1 times
            if (AppCrea == 0) then
                StAppNameOn = "\"" .. StringColName .. " on\""
                StAppNameOff = "\"" .. StringColName .. " off\""
                Cmd("Store App " .. NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
                NrAppear = Maf(NrAppear + 1);
                Cmd("Store App " .. NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
                NrAppear = Maf(NrAppear + 1);
            end
            -- end Appearances
            E("NrAppear ")
            E(NrAppear)

            -- Create Sequences
            GrpNo = SelectedGrpNo[g]
            GrpNo = string.gsub( GrpNo,"'","" )
            Cmd("ClearAll /nu")
            Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .. "")
            Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
            Cmd("Store Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            Cmd("Assign Group " .. GrpNo .. " At Sequence " .. CurrentSeqNr .. " Cue 1 Part 0.1")
            Cmd('Assign MAtricks ' .. MatrickNrStart .. ' At Sequence ' .. CurrentSeqNr .. ' Cue 1 Part 0.1 /nu')
            -- Add Cmd to Squence
            Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed .. "\"")
            Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
            Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
            Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
            Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
            Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
            Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
            Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
            -- end Sequences

            -- Add Squences to Layout
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

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
        -- end Squences to Layout

        AppCrea = 1
        LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
    end
    -- end Appearances/Sequences 

    -- check Appear. time .... TODO trouver procedure 
    -- E("check Appear.")
    -- add_check = 0
    -- for k in pairs(App) do
    --     for q in pairs(AppImp) do
    --         if ('"' .. App[k].name .. '"' == AppImp[q].Name) then 
    --             add_check = Maf(add_check + 1)
    --             appcheck[q].value = 1   
    --             appcheck[q].ref = k     
    --             -- table.insert(appcheck.value, q, 1)
    --             -- table.insert(appcheck.ref, q, k)
    --             E(appcheck[q].value)
    --             E(appcheck[q].ref)         
    --         end
    --         long_imgimp = q
    --     end
    -- end"clearall /nu"
    
    -- if (long_imgimp == add_check) then
    --     E("Appear. exist")
    -- else
    --     E("Appear. NOT exist")
    E('Create Appear. Time Ref')
    for q in pairs(AppImp) do
        AppImp[q].Nr = Maf(NrNeed)
        Cmd( 'Store App ' .. AppImp[q].Nr .. ' "' .. AppImp[q].Name .. '" "Appearance"=' .. AppImp[q].StApp .. '' .. AppImp[q].RGBref ..'')
        NrNeed = Maf(NrNeed + 1)
    end
                   
    -- add timming / Sequences
    SeqNrEnd = CurrentSeqNr - 1
    LayY = Maf(LayY - 150) -- Add offset for Layout Element distance
    LayX = RefX
    LayX = Maf(LayX + LayW - 100)
    FirstSeqTime = CurrentSeqNr
    LastSeqTime = Maf(CurrentSeqNr + 5)

    -- Create Sequences ExecTime
    Cmd('clearall /nu')
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "ExecTime\"")
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[1].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'ExecTime\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime=1')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[2].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences    
    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[2].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences ExecTime






    -- Create Sequences time 0
    Cmd("ClearAll /nu")
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "Time 0\"")
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[3].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'Time 0\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ; set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' UseExecutorTime=0 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" 0 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" 0 ')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[4].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[4].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
        
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences time 0

    -- Create Sequences time 1
    Cmd("ClearAll /nu")
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "Time 1\"")
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[5].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'Time 1\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ;set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. '  UseExecutorTime=0 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" 1 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" 1 ')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[6].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[6].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences time 1

    -- Create Sequences time 2
    Cmd("ClearAll /nu")
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "Time 2\"")
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[7].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'Time 2\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ;set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. '  UseExecutorTime=0 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" 2 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" 2 ')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[8].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[8].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
   
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences time 2

    -- Create Sequences time 3
    Cmd("ClearAll /nu")
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "Time 3\"")
    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[9].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'Time 3\' Property Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. ' ;set seq ' .. SeqNrStart .. ' thru ' ..SeqNrEnd.. ' cuefade 3 UseExecutorTime=0 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" 4 ; Set Matricks ' .. MatrickNrStart .. ' Property "FadeTox" 4 ')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[10].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[10].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    -- end Sequences time 3

    -- Create Sequences Time Input
    Cmd("ClearAll /nu")
    Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "Time Input\"")

    -- Create Macro Time Input
    Cmd("Store Macro " .. CurrentMacroNr .. " \"" .. "Time Input\"")
    Cmd("ChangeDestination Macro " .. CurrentMacroNr .. "")
    Cmd("Insert")
    Cmd('set 1 Command=\'off seq ' .. FirstSeqTime .. ' thru ' .. LastSeqTime .. ' - ' .. CurrentSeqNr .. '')
    Cmd("Insert")    
    Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeFromx" ')
    Cmd("Insert")    
    Cmd('set 3 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "FadeTox" ')
    Cmd("ChangeDestination Root")



    -- Add Cmd to Squence
    Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[11].Nr .. "\"")
    Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'Time Input\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
    Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[12].Nr .. "\"")
    Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
    Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
    Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
    Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
    Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
    Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
    -- end Sequences

    -- Add Squences to Layout
    Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
    Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[12].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
  
    LayX = Maf(LayX + LayW + 20)
    LayNr = Maf(LayNr + 1)
    CurrentSeqNr = Maf(CurrentSeqNr + 1)
    CurrentMacroNr = Maf(CurrentMacroNr + 1)
    -- end Sequences time ?

    -- end timming / Sequences


    




















                     
     -- Update Sequences & pos
    --  LayX = Maf(LayX - 100)
     FirstSeqDelayFrom = CurrentSeqNr
     LastSeqDelayFrom = Maf(CurrentSeqNr + 4)
 
     -- Create Sequences delayfrom 0
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayFrom 0\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[13].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayFrom 0\' Property Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" 0 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[14].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[14].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
         
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayfrom 0
 
     -- Create Sequences delayfrom 1
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayFrom 1\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[15].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayFrom 1\' Property Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" 1 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[16].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[16].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
    
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayfrom 1
 
     -- Create Sequences delayfrom 2
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayFrom 2\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[17].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayFrom 2\' Property Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" 2 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[18].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[18].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
    
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayfrom 2
 
     -- Create Sequences delayfrom 3
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayFrom 3\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[19].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayFrom 3\' Property Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" 4 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[20].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[20].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
    
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayfrom 3
 
     -- Create Sequences DelayFrom Input
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayFrom Input\"")
 
     -- Create Macro DelayFrom Input
     Cmd("Store Macro " .. CurrentMacroNr .. " \"" .. "DelayFrom Input\"")
     Cmd("ChangeDestination Macro " .. CurrentMacroNr .. "")
     Cmd("Insert")
     Cmd('set 1 Command=\'off seq ' .. FirstSeqDelayFrom .. ' thru ' .. LastSeqDelayFrom .. ' - ' .. CurrentSeqNr .. '')
     Cmd("Insert")    
     Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayFromx" ')
     Cmd("ChangeDestination Root")
     


     
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr ..  " Appearance=" .. AppImp[21].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayFrom Input\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[22].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[22].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
   
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     CurrentMacroNr = Maf(CurrentMacroNr + 1)
     -- end Sequences DelayFrom ?

     -- end timming / Sequences



















     -- Update Sequences & pos
    --  LayX = Maf(LayX + LayW - 160)
     FirstSeqDelayTo = CurrentSeqNr
     LastSeqDelayTo = Maf(CurrentSeqNr + 4)
 
     -- Create Sequences delayto 0
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayTo 0\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[23].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayTo 0\' Property Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayTox" 0 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[24].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[24].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
         
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayto 0
 
     -- Create Sequences delayto 1
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayTo 1\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[25].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayTo 1\' Property Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayTox" 1 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[26].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[26].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayto 1
 
     -- Create Sequences delayto 2
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayTo 2\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[27].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayTo 2\' Property Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayTox" 2 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[28].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[28].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
    
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayto 2
 
     -- Create Sequences delayto 3
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayTo 3\"")
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[29].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayTo 3\' Property Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. ' ; Set Matricks ' .. MatrickNrStart .. ' Property "DelayTox" 4 ')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[30].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[30].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
    
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     -- end Sequences delayto 3
 
     -- Create Sequences DelayTo Input
     Cmd("ClearAll /nu")
     Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "DelayTo Input\"")
 
     -- Create Macro DelayTo Input
     Cmd("Store Macro " .. CurrentMacroNr .. " \"" .. "DelayTo Input\"")
     Cmd("ChangeDestination Macro " .. CurrentMacroNr .. "")
     Cmd("Insert")
     Cmd('set 1 Command=\'off seq ' .. FirstSeqDelayTo .. ' thru ' .. LastSeqDelayTo .. ' - ' .. CurrentSeqNr .. '')
     Cmd("Insert")    
     Cmd('set 2 Command=\'Edit Matricks ' .. MatrickNrStart .. ' Property "DelayTox" ')
     Cmd("ChangeDestination Root")
 
     -- Add Cmd to Squence
     Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. AppImp[31].Nr .. "\"")
     Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'DelayTo Input\' Property Command=\'Go Macro ' .. CurrentMacroNr ..  '')
     Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..AppImp[32].Nr .. "\"")
     Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
     Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
     Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
     Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
     Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=0 OffwhenOverridden=1 Lock=0")
     Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
     -- end Sequences
 
     -- Add Squences to Layout
     Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
     Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. AppImp[32].Nr .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
     
     LayX = Maf(LayX + LayW + 20)
     LayNr = Maf(LayNr + 1)
     CurrentSeqNr = Maf(CurrentSeqNr + 1)
     CurrentMacroNr = Maf(CurrentMacroNr + 1)
     -- end Sequences DelayTo ?
 
     -- end timming / Sequences

     -- add All Color
    LayY = TLay[TLayNrRef].DimensionH / 2
    LayY = Maf(LayY + 20) -- Add offset for Layout Element distance
    LayX = RefX
    LayX = Maf(LayX + LayW + 20)
    NrNeed = Maf(AppNr + 1)
    col_count = 0

    for col in ipairs(TCol) do
        col_count = col_count + 1
        StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        StColName = TCol[col].name
        StringColName = string.gsub( StColName," ","_" )
        ColNr = SelectedGelNr .. "." .. TCol[col].no

        -- Create Sequences
        Cmd("ClearAll /nu")
        Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "ALL" .. StringColName .. ""  .. "ALL\"")
        -- Add Cmd to Squence
        Cmd("set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd('set seq ' .. CurrentSeqNr .. ' cue \''.. 'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\' Go+ Sequence \'' .. StringColName ..  '*')
        Cmd("set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
        Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
        Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
        Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
        Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=1 OffwhenOverridden=1 Lock=0")
        Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
        -- end Sequences

        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " .. LayH .. " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")
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

    -- end All Color

    for k in pairs(root.ShowData.DataPools.Default.Layouts:Children()) do
        if (Maf(TLayNr) == Maf(tonumber(root.ShowData.DataPools.Default.Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end
    UsedW = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)

    ::canceled::
    Cmd("ClearAll /nu")
end
return Main