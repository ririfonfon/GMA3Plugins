--[[
COLOR_1_2 v1.0.1.2
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "COLOR_1_2" 
* Choose Gel color ...
* You have two Preset Color reference 
* It remains only to make sequences, chases with these two preset. and you can change the colors on the fly.

Releases:
* 1.0.0.1 - Inital release
* 1.0.1.1 - Add choise of Preset Number
* 1.0.1.2 - scale dimension w & h in use 

Created by Richard Fontaine "RIRI", May 2020.
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

local function Main(display_handle)

    local root = Root();

    -- Store all Display Settings in a Table and define the middle of Display 1
    local DisPath = root.GraphicsRoot.PultCollect[1].DisplayCollect:Children()
    local DisMiW = Maf(DisPath[1].W / 2)
    local DisMiH = Maf(DisPath[1].H / 2)

    -- Store all ColorGel in a Table
    local ColPath = root.ShowData.GelPools
    local ColGels = ColPath:Children()

    -- Store all Used CustomImage in a Table to find the last free number, and define the Images
    local Img = root.ShowData.ImagePools.Custom:Children()
    local ImgNr

    for k in pairs(Img) do ImgNr = Maf(Img[k].NO) end

    if ImgNr == nil then ImgNr = 0 end

    local ImgImp = {
        {
            Name = "\"on\"",
            FileName = "\"on.png\"",
            Filepath = "\"../lib_plugins/ColorLayout/images\""
        }, {
            Name = "\"off\"",
            FileName = "\"off.png\"",
            Filepath = "\"../lib_plugins/ColorLayout/images\""
        }
    }

    local IconImp = {
        {
            Name = "\"riri_plugin_Y\"",
            FileName = "\"riri_plugin_Y.tga\"",
            Filepath = "\"../lib_plugins/ColorLayout/images\""
        }, {
            Name = "\"riri_plugin_O\"",
            FileName = "\"riri_plugin_O.tga\"",
            Filepath = "\"../lib_plugins/ColorLayout/images\""
        }
    }

    -- Store all Used Appearances in a Table to find the last free number
    local App = root.ShowData.Appearances:Children()
    local AppNr

    for k in pairs(App) do AppNr = Maf(App[k].NO) end

    -- Store all Use Layout in a Table to find the last free number
    local TLay = root.ShowData.DataPools.Default.Layouts:Children()
    local TLayNr
    local TLayNrRef

    for k in pairs(TLay) do
        E(TLay[k].NO)
        TLayNr = Maf(tonumber(TLay[k].NO))
        TLayNrRef = k
    end

    -- Store all Used Sequence in a Table to find the last free number
    local SeqNr = root.ShowData.DataPools.Default.Sequences:Children()
    local SeqNrStart

    for k in pairs(SeqNr) do SeqNrStart = Maf(SeqNr[k].NO) end

    if SeqNrStart == nil then SeqNrStart = 0 end

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do TIconNr = Maf(TIcon[k].NO) end

    -- Store all Used Macro in a Table to find the last free number
    local MacroNr = root.ShowData.DataPools.Default.Macros:Children()
    local MacroNrStart

    for k in pairs(MacroNr) do MacroNrStart = Maf(MacroNr[k].NO) end

    if MacroNrStart == nil then MacroNrStart = 0 end

    -- variables
    local RefX = Maf(0 - TLay[TLayNrRef].DimensionW / 2)
    local LayY = TLay[TLayNrRef].DimensionH / 2
    local LayW = 100
    local LayH = 100
    local LayNr = 1
    local NrSeq
    local NrNeed
    local AppCrea = 0
    local TCol
    local StColName
    local StColCode
    local StAppNameOn
    local StAppNameOff
    local StAppOn = "\"Showdata.ImagePools.Custom.on\""
    local StAppOff = "\"Showdata.ImagePools.Custom.off\""
    local ColNr
    local SelGrp
    local TGrpChoise
    local ChoGel
    local SelColGel
    local SelectedGrp = {"COLOR_1", "COLOR_2"}
    local SelectedGel
    local Message = "Add  ColorGel, set beginning Macro Number\n\n "
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local MacroNrText = "Macro_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 10
    local count = 0
    local check = 0
    local NaLay = "1_2"
    local PColor = 901
    local MacroIndex = 13
    local LongGel
    local Start_Seq_1
    local End_Seq_1
    local Start_Seq_2
    local End_Seq_2

    local UsedW
    local UsedH

    TLayNr = Maf(TLayNr + 1)
    MacroNrStart = MacroNrStart + 1
    SeqNrStart = SeqNrStart + 1

    ---- Main Box
    ::MainBox::
    local box = MessageBox({
        title = 'COLOR_1_2',
        backColor = "1.7",
        icon = "riri_plugin_O",
        message = Message,
        commands = {
            {name = ColGelBtn, value = 12}, {name = OkBtn, value = ValOkBtn},
            {name = 'Cancel', value = 0}
        },
        inputs = {
            {name = SeqNrText, value = SeqNrStart, maxTextLength = 4},
            {name = MacroNrText, value = MacroNrStart, maxTextLength = 4},
            {name = 'Preset_Color_Nr', value = PColor, maxTextLength = 4},
            {name = 'Layout_Nr', value = TLayNr, maxTextLength = 4},
            {name = 'Layout_Name', value = NaLay, maxTextLength = 16}
        }

    })

    if (box.result == 12) then
        ValOkBtn = Maf(ValOkBtn / 10)
        if (ValOkBtn < 10) then
            ValOkBtn = 1
            OkBtn = "OK Let's GO"
        end

        E("add ColorGel")
        SeqNrStart = box.inputs.Seq_Start_Nr
        MacroNrStart = box.inputs.Macro_Start_Nr
        PColor = box.inputs.Preset_Color_Nr
        TLayNr = box.inputs.Layout_Nr
        NaLay = box.inputs.Layout_Name
        goto addColorGel
    elseif (box.result == 1) then
        if SelectedGel == nil then
            Co("no ColorGel are selected!")
            SeqNrStart = box.inputs.Seq_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            PColor = box.inputs.Preset_Color_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            goto addColorGel
        else
            SeqNrStart = box.inputs.Seq_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            PColor = box.inputs.Preset_Color_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            E("now i do some Magic stuff...")
            goto doMagicStuff
        end
    elseif (box.result == 0) then
        E("User Cancled")
        goto cancle
    end

    ---- End Main Box  

    ---- Choise ColorGel  
    -- Create a Choise for each Group in Table
    ::addColorGel::

    ChoGel = {};
    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end

    -- Setup the Messagebox
    SelColGel = PopupInput("Select ColorGel", display_handle, ChoGel, "",
                           DisMiW, DisMiH);
    SelectedGel = ColGels[SelColGel + 1].name;
    SelectedGelNr = SelColGel + 1
    E("ColorGel " .. ColGels[SelColGel + 1].name .. " selected")
    ColGelBtn = "ColorGel " .. ColGels[SelColGel + 1].name .. " selected"
    goto MainBox
    ---- End ColorGel	

    ---- Magic Stuff
    ::doMagicStuff::

    ----check Images
    for k in pairs(Img) do
        if ('"' .. Img[k].name .. '"' == ImgImp[1].Name) then
            check = check + 1
        end
    end

    if (check > 0) then
        E("file exist")
    else
        ---- Import Images
        ImgNr = Maf(ImgNr + 1);
        Cmd(
            "Store Image 3." .. ImgNr .. " " .. ImgImp[1].Name .. " Filename=" ..
                ImgImp[1].FileName .. " filepath=" .. ImgImp[1].Filepath .. "")
        ImgNr = Maf(ImgNr + 1);
        Cmd(
            "Store Image 3." .. ImgNr .. " " .. ImgImp[2].Name .. " Filename=" ..
                ImgImp[2].FileName .. " filepath=" .. ImgImp[2].Filepath .. "")
    end
    ---- End check Images  

    ---- Create Appearances/Sequences

    -- Create new Layout View
    Cmd("Store Layout " .. TLayNr .. " \"" .. NaLay .. "")
    -- end

    TCol = ColPath:Children()[SelectedGelNr]

    -- check how long Gel

    for k in ipairs(TCol) do LongGel = Maf(TCol[k].no) end

    Start_Seq_1 = SeqNrStart
    End_Seq_1 = Maf(Start_Seq_1 + LongGel - 1)
    Start_Seq_2 = Maf(End_Seq_1 + 1)
    End_Seq_2 = Maf(Start_Seq_2 + LongGel - 1)
    PColor = Maf(PColor)

    for g in ipairs(SelectedGrp) do
        local LayX = RefX
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        if (AppCrea == 0) then
            AppNr = Maf(AppNr + 1);
            Cmd("Store App " .. AppNr .. " \"Label\" Appearance=" .. StAppOn ..
                    " color=\"0,0,0,1\"")
        end

        NrSeq = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)

        --  Cmd("Assign Group "..SelectedGrp[g].." at Layout "..TLayNr)
        Cmd("Store Layout " .. TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. "Action=0 Appearance=" ..
                AppNr .. "Name " .. SelectedGrp[g] .. " PosX " .. LayX ..
                " PosY " .. LayY .. " PositionW " .. LayW .. " PositionH " ..
                LayH .. " Objectname=1 Bar=0 IndicatorBar=Background")

        LayNr = Maf(LayNr + 1)
        LayX = Maf(LayX + LayW + 20)

        for col in ipairs(TCol) do
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," ..
                            TCol[col].b .. ",1\""
            StColName = TCol[col].name
            ColNr = SelectedGelNr .. "." .. TCol[col].no

            -- Cretae Appearances only 1 times
            if (AppCrea == 0) then
                StAppNameOn = "\"" .. StColName .. " on\""
                StAppNameOff = "\"" .. StColName .. " off\""
                Cmd("Store App " .. NrSeq .. " " .. StAppNameOn ..
                        " Appearance=" .. StAppOn .. " color=" .. StColCode ..
                        "")
                NrSeq = Maf(NrSeq + 1);
                Cmd("Store App " .. NrSeq .. " " .. StAppNameOff ..
                        " Appearance=" .. StAppOff .. " color=" .. StColCode ..
                        "")
                NrSeq = Maf(NrSeq + 1);
            end
            -- end Appearances

            -- Create Sequences
            Cmd(
                "clearall;Store Sequence " .. SeqNrStart .. " \"" .. StColName ..
                    " " .. SelectedGrp[g] .. "\"")
            -- Create Macros
            Cmd("Store Macro " .. MacroNrStart .. ".1 Thru " .. MacroNrStart ..
                    "." .. MacroIndex)
            Cmd("Label Macro " .. MacroNrStart .. " \"" .. StColName .. " " ..
                    SelectedGrp[g] .. "\"")
            Cmd("CD Macro " .. MacroNrStart)
            Cmd('Set 1 Command "Store Group 999/o" ')
            Cmd('Set 2 Command "Store Preset 25.999/o" ')
            Cmd('Set 3 Command "Group 999 At Preset 25.999')
            Cmd('Set 4 Command "Store Sequence 999 cue 1 /o ')
            Cmd('Set 5 Command "Go Sequence 999 cue 1')
            Cmd('Set 6 Command "Blind On" ')
            Cmd('Set 7 Command "Fixture Thru" ')
            Cmd('Set 8 Command "Down; Down; Down" ')
            Cmd('Set 9 Command "at Gel %d . %d" ', SelectedGelNr, TCol[col].no)
            Cmd('Set 10 Command "Store preset 4. %d /o" ', PColor)
            Cmd('Set 11 Command "ClearAll;  Preset 25.999; At Preset 25.999" ')
            Cmd('Set 12 Command "Blind Off" ')
            Cmd('Set 13 Command "Off Sequence 999" ')
            Cmd('CD Root')

            -- Add Cmd to Squence
            if (g == 1) then
                Cmd("set seq " .. SeqNrStart ..
                        " cue \"CueZero\" cmd=\"Set Layout " .. TLayNr .. "." ..
                        LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                        MacroNrStart .. "; Off Sequence " .. Start_Seq_1 ..
                        " Thru " .. End_Seq_1 .. " - " .. SeqNrStart .. "\"")
            else
                Cmd("set seq " .. SeqNrStart ..
                        " cue \"CueZero\" cmd=\"Set Layout " .. TLayNr .. "." ..
                        LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                        MacroNrStart .. "; Off Sequence " .. Start_Seq_2 ..
                        " Thru " .. End_Seq_2 .. " - " .. SeqNrStart .. "\"")
            end

            Cmd(
                "set seq " .. SeqNrStart .. " cue \"OffCue\" cmd=\"Set Layout " ..
                    TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 ..
                    "\"")

            -- end Sequences

            -- Add Squences to Layout
            Cmd("Assign Seq " .. SeqNrStart .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" ..
                    NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
                    " PositionW " .. LayW .. " PositionH " .. LayH ..
                    " Objectname=0 Bar=0")

            NrNeed = Maf(NrNeed + 2); -- Set App Nr to next color
            LayX = Maf(LayX + LayW + 20)

            LayNr = Maf(LayNr + 1)

            SeqNrStart = Maf(SeqNrStart + 1)
            MacroNrStart = Maf(MacroNrStart + 1)
        end
        -- end Squences to Layout

        AppCrea = 1
        LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
        PColor = Maf(PColor + 1)
    end
    ---- end Appearances/Sequences 

    for k in pairs(root.ShowData.DataPools.Default.Layouts:Children()) do
        if (Maf(TLayNr) ==
            Maf(tonumber(root.ShowData.DataPools.Default.Layouts:Children()[k]
                             .NO))) then TLayNrRef = k end
    end

    UsedW = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW
    UsedH = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " ..
            UsedH)

    ::cancle::

    Cmd("ClearAll")
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main
