--[[
Color_Layout v1.1.3.1
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "Color_layout"

Releases:
* 1.0.0.1 - Inital release
* 1.1.0.1 - Add logic if layout on off exist
* 1.1.0.2 - Add last free number
* 1.1.0.3 - bugg remove for multi layout
* 1.1.1.0 - Add label layout & number layout
* 1.1.1.1 - Add numerique input
* 1.1.1.2 - Bugg Layouts Number
* 1.1.1.3 - Scale dimension w & h in use 
* 1.1.2.0 - For a lot color add Max_Color_By_Line
* 1.1.3.0 - gma 3 1.7.2.2 
* 1.1.3.1 - gma 3 1.8.1.0 
* 1.1.3.2 - gma 3 1.9.2.2 
* 1.1.3.3 - Add ALL color 

Created by Richard Fontaine "RIRI", April 2020.
--]] --
local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local function Main(display_Handle)

    local root = Root();

    -- Store all Display Settings in a Table and define the middle of Display 1
    local DisPath = root.GraphicsRoot.PultCollect[1].DisplayCollect:Children()
    local DisMiW = Maf(DisPath[1].W / 2)
    local DisMiH = Maf(DisPath[1].H / 2)

    -- Store all Groups in a Table
    local FixtureGroups = root.ShowData.DataPools.Default.Groups:Children()

    -- Store all ColorGel in a Table
    local ColPath = root.ShowData.GelPools
    local ColGels = ColPath:Children()

    -- Store all Used CustomImage in a Table to find the last free number, and define the Images
    local Img = root.ShowData.MediaPools.Images:Children()
    local ImgNr

    for k in pairs(Img) do
        ImgNr = Maf(Img[k].NO)
    end

    if ImgNr == nil then
        ImgNr = 0
    end

    local ImgImp = {{
        Name = "\"on\"",
        FileName = "\"on.png\"",
        Filepath = "\"../images\""
    }, {
        Name = "\"off\"",
        FileName = "\"off.png\"",
        Filepath = "\"../images\""
    }}

    -- Store all Used Appearances in a Table to find the last free number
    local App = root.ShowData.Appearances:Children()
    local AppNr

    for k in pairs(App) do
        AppNr = Maf(App[k].NO)
    end
    AppNr = AppNr + 1

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

    for k in pairs(SeqNr) do
        SeqNrStart = Maf(SeqNr[k].NO)
    end

    if SeqNrStart == nil then
        SeqNrStart = 0
    end

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do
        TIconNr = Maf(TIcon[k].NO)
    end

    -- variables
    local RefX = Maf(0 - TLay[TLayNrRef].DimensionW / 2)
    local LayY = TLay[TLayNrRef].DimensionH / 2
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local NrAppear
    local NrNeed
    local AppCrea = 0
    local TCol
    local StColName
    local StringColName
    local StColCode
    local StAppNameOn
    local StAppNameOff
    local StAppOn = "\"Showdata.MediaPools.Images.on\""
    local StAppOff = "\"Showdata.MediaPools.Images.off\""
    local ColNr = 0
    local SelGrp
    local TGrpChoise
    local ChoGel
    local SelColGel
    local SelectedGrp = {}
    local SelectedGel
    local Message =
        "Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 100
    local count = 0
    local check = 0
    local NaLay = "Colors"
    local PopTableGrp = {}
    local PopTableGel = {}

    local CurrentSeqNr

    local UsedW
    local UsedH

    local MaxColLgn = 40

    TLayNr = Maf(TLayNr + 1)
    SeqNrStart = SeqNrStart + 1

    ---- Main Box
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
        }}

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
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto MainBox
        else
            E("add Group")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
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
        AppNr = box.inputs.Appearance_Start_Nr
        TLayNr = box.inputs.Layout_Nr
        NaLay = box.inputs.Layout_Name
        MaxColLgn = box.inputs.Max_Color_By_Line
        goto addColorGel

    elseif (box.result == 1) then
        if SelectedGel == nil then
            Co("no ColorGel are selected!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addColorGel

        elseif next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addGroup
        else
            SeqNrStart = box.inputs.Sequence_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            E("now i do some Magic stuff...")
            goto doMagicStuff
        end

    elseif (box.result == 0) then
        E("User Canceled")
        goto canceled
    end

    ---- End Main Box  

    ---- Choise Fixture Group  
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
    E("A")
    Message = Message .. FixtureGroups[SelGrp + 1].name .. "\n"
    E("Select Group " .. FixtureGroups[SelGrp + 1].name)
    table.remove(FixtureGroups, SelGrp + 1)
    goto MainBox
    ---- End Choise Fixture Group	        

    ---- Choise ColorGel  
    -- Create a Choise for each Group in Table
    ::addColorGel::

    ChoGel = {};
    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end

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
    ---- End ColorGel	

    ---- Magic Stuff
    ::doMagicStuff::

    ----fix SeqNrStart & use CurrentSeqNr
    CurrentSeqNr = SeqNrStart

    ----check Images
    for k in pairs(Img) do
        if ('"' .. Img[k].name .. '"' == ImgImp[1].Name) then
            check = check + 1
        end
    end

    if (check > 0) then
        E("file exist")
    else
        E("file NOT exist")
        ---- Select a disk
        local drives = Root().Temp.DriveCollect
        local selectedDrive -- users selected drive
        local options = {} -- popup options
        local PopTableDisk = {} -- 
        ---- grab a list of connected drives
        for i = 1, drives.count, 1 do
            table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
        end
        ---- present a popup for the user choose (Internal may not work)
        PopTableDisk = {
            title = "Select a disk to import on & off image",
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

        ---- Import Images
        ImgNr = Maf(ImgNr + 1);
        Cmd("Store Image 3." .. ImgNr .. " " .. ImgImp[1].Name .. " Filename=" .. ImgImp[1].FileName .. " filepath=" ..
                ImgImp[1].Filepath .. "")
        ImgNr = Maf(ImgNr + 1);
        Cmd("Store Image 3." .. ImgNr .. " " .. ImgImp[2].Name .. " Filename=" .. ImgImp[2].FileName .. " filepath=" ..
                ImgImp[2].Filepath .. "")
    end
    ---- End check Images  

    ---- Create Appearances/Sequences

    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. NaLay .. "")
    -- end

    TCol = ColPath:Children()[SelectedGelNr]
    MaxColLgn = tonumber(MaxColLgn)

    for g in ipairs(SelectedGrp) do

        local LayX = RefX
        local col_count = 0
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        if (AppCrea == 0) then
            AppNr = Maf(AppNr);
            Cmd("Store App " .. AppNr .. " \"Label\" Appearance=" .. StAppOn .. " color=\"0,0,0,1\"")
        end

        NrAppear = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)

        Cmd("Assign Group " .. SelectedGrp[g] .. " at Layout " .. TLayNr)
        Cmd(
            "Set Layout " .. TLayNr .. "." .. LayNr .. " Action=0 Appearance=" .. AppNr .. " PosX " .. LayX .. " PosY " ..
                LayY .. " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=1 VisibilityBar=0 VisibilityIndicatorBar=0")

        LayNr = Maf(LayNr + 1)
        LayX = Maf(LayX + LayW + 20)

        for col in ipairs(TCol) do
            col_count = col_count + 1
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            StColName = TCol[col].name
            StringColName = string.gsub( StColName," ","" )
            ColNr = SelectedGelNr .. "." .. TCol[col].no

            -- Cretae Appearances only 1 times
            if (AppCrea == 0) then
                StAppNameOn = "\"" .. StringColName .. " on\""
                StAppNameOff = "\"" .. StringColName .. " off\""
                Cmd(
                    "Store App " .. NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode ..
                        "")
                NrAppear = Maf(NrAppear + 1);
                Cmd(
                    "Store App " .. NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode ..
                        "")
                NrAppear = Maf(NrAppear + 1);
            end
            -- end Appearances

            -- Create Sequences
            Cmd("clearall")
            Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .. "")
            Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. StringColName .. " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
            -- Add Cmd to Squence
            Cmd(
                "set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr ..
                    " Appearance=" .. NrNeed .. "\"")
            Cmd(
                "set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr ..
                    " Appearance=" .. NrNeed + 1 .. "\"")
            Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
            Cmd("set seq " .. CurrentSeqNr ..
                    " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
            Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
            Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
            Cmd("set seq " .. CurrentSeqNr ..
                    " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=1 OffwhenOverridden=1 Lock=0")
            Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
            -- end Sequences

            -- Add Squences to Layout
            Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
            Cmd(
                "Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " ..
                    LayY .. " PositionW " .. LayW .. " PositionH " .. LayH ..
                    " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

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
    ---- end Appearances/Sequences 



    
    
    
    ---- add timming / Sequences
    SeqNrEnd = CurrentSeqNr

    ---- end timming / Sequences

    ---- add All Color
    LayY = TLay[TLayNrRef].DimensionH / 2
    LayY = Maf(LayY + 20) -- Add offset for Layout Element distance
    -- LayY = Maf(LayY + LayH)
    LayX = RefX
    LayX = Maf(LayX + LayW + 20)
    NrNeed = Maf(AppNr + 1)
    col_count = 0

    for col in ipairs(TCol) do
        col_count = col_count + 1
        StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
        StColName = TCol[col].name
        StringColName = string.gsub( StColName," ","" )
        ColNr = SelectedGelNr .. "." .. TCol[col].no
        

       


        -- Create Sequences
        Cmd("clearall")
        Cmd("Store Sequence " .. CurrentSeqNr .. " \"" .. "ALL" .. StringColName .. ""  .. "ALL\"")
        -- Add Cmd to Squence
        Cmd(
            "set seq " .. CurrentSeqNr .. " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr ..
                " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd(
            'set seq ' .. CurrentSeqNr .. ' cue \''.. 'ALL' .. StringColName .. '' .. 'ALL\' Property Command=\' Go+ Sequence \'' .. StringColName ..  '*')
        Cmd(
            "set seq " .. CurrentSeqNr .. " cue \"OffCue\" Property Command=\"Set Layout " .. TLayNr .. "." .. LayNr ..
                " Appearance=" .. NrNeed + 1 .. "\"")
        Cmd("set seq " .. CurrentSeqNr .. " AutoStart=1 AutoStop=1 MasterGoMode=None AutoFix=0 AutoStomp=0")
        Cmd("set seq " .. CurrentSeqNr .. " Tracking=0 WrapAround=1 ReleaseFirstCue=0 RestartMode=1 CommandEnable=1 XFadeReload=0")
        Cmd("set seq " .. CurrentSeqNr .. " OutputFilter='' Priority=0 SoftLTP=1 PlaybackMaster='' XfadeMode=0")
        Cmd("set seq " .. CurrentSeqNr .. " RateMaster='' RateScale=0 SpeedMaster='' SpeedScale=0 SpeedfromRate=0")
        Cmd("set seq " .. CurrentSeqNr .. " InputFilter='' SwapProtect=0 KillProtect=0 IncludeLinkLastGo=1 UseExecutorTime=1 OffwhenOverridden=1 Lock=0")
        Cmd("set seq " .. CurrentSeqNr .. " SequMIB=0 SequMIBMode=1")
        -- end Sequences

        -- Add Squences to Layout
        Cmd("Assign Seq " .. CurrentSeqNr .. " at Layout " .. TLayNr)
        Cmd(
            "Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" .. NrNeed + 1 .. " PosX " .. LayX .. " PosY " ..
                LayY .. " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0 VisibilityIndicatorBar=0")

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

    ---- end All Color










    for k in pairs(root.ShowData.DataPools.Default.Layouts:Children()) do
        if (Maf(TLayNr) == Maf(tonumber(root.ShowData.DataPools.Default.Layouts:Children()[k].NO))) then
            TLayNrRef = k
        end
    end

    UsedW = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)

    ::canceled::

    Cmd("ClearAll")
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main
