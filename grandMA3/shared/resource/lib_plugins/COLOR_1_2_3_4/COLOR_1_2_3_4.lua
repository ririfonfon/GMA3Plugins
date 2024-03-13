--[[
COLOR_1_2_3_4 v1.1.2.3
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "COLOR_1_2_3_4"
* Choose Gel color ...
* You have four Preset Color reference
* It remains only to make sequences, chases with these Four preset. and you can change the colors on the fly.

Releases:
* 1.0.0.1 - Inital release
* 1.0.1.1 - Add choise of Preset Number
* 1.0.1.2 - scale dimension w & h in use
* 1.1.2.0 - For a lot color add Max_Color_By_Line
* 1.1.2.1 - Add delete seq 999 & clear all marco line
* 1.1.2.2 - Scroll Bug
* 1.1.2.3 - gma3 1.8.1.0

Created by Richard Fontaine "RIRI", May 2020.
--]]
     --
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
    local Img = root.ShowData.MediaPools.Images:Children()
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
    E("Layout = %s", tostring(TLay))
    local TLayNr
    local TLayNrRef

    for k in pairs(TLay) do
        E("Layout n° = %s", tostring(TLay[k].NO))
        TLayNr = Maf(tonumber(TLay[k].NO))
        TLayNrRef = k
    end

    E("layout ok")

    -- Store all Used Sequence in a Table to find the last free number
    local SeqNr = root.ShowData.DataPools.Default.Sequences:Children()
    local SeqNrStart

    for k in pairs(SeqNr) do SeqNrStart = Maf(SeqNr[k].NO) end
    E("Seq ok")

    if SeqNrStart == nil then SeqNrStart = 0 end

    -- Store all Use Texture in a Table to find the last free number
    local TIcon = root.GraphicsRoot.TextureCollect.Textures:Children()
    local TIconNr

    for k in pairs(TIcon) do TIconNr = Maf(TIcon[k].NO) end
    E("textures ok")

    -- Store all Used Macro in a Table to find the last free number
    local MacroNr = root.ShowData.DataPools.Default.Macros:Children()
    local MacroNrStart

    for k in pairs(MacroNr) do MacroNrStart = Maf(MacroNr[k].NO) end
    E("Macro ok")

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
    local StAppOn = "\"Showdata.MediaPools.Images.on\""
    local StAppOff = "\"Showdata.MediaPools.Images.off\""
    local ColNr
    local SelGrp
    local TGrpChoise
    local ChoGel
    local SelColGel
    local SelectedGrp = { "COLOR_1", "COLOR_2", "COLOR_3", "COLOR_4" }
    local SelectedGel
    local Message = "Add  ColorGel, set beginning Macro Number\n\n "
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local MacroNrText = "Macro_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 10
    local count = 0
    local check = 0
    local NaLay = "1_2_3_4"
    local PColor = 901
    local MacroIndex = 15
    local LongGel
    local Start_Seq_1
    local End_Seq_1
    local Start_Seq_2
    local End_Seq_2
    local Start_Seq_3
    local End_Seq_3
    local Start_Seq_4
    local End_Seq_4

    local PopTableGel = {}

    local UsedW
    local UsedH

    local MaxColLgn = 40

    E("local ok")

    TLayNr = Maf(TLayNr + 1)
    MacroNrStart = MacroNrStart + 1
    SeqNrStart = SeqNrStart + 1

    ---- Main Box
    ::MainBox::
    local box = MessageBox({
        title = 'COLOR_1_2_3_4_By_RIRI',
        display = display_Handle,
        backColor = "1.7",
        message = Message,
        commands = {
            { name = ColGelBtn, value = 12 }, { name = OkBtn, value = ValOkBtn },
            { name = 'Cancel',  value = 0 }
        },
        inputs = {
            {
                name = SeqNrText,
                value = SeqNrStart,
                maxTextLength = 4,
                vkPlugin = "TextInputNumOnly"
            }, {
            name = MacroNrText,
            value = MacroNrStart,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
            name = 'Preset_Color_Nr',
            value = PColor,
            maxTextLength = 4,
            vkPlugin = "TextInputNumOnly"
        }, {
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
            name = 'Max_Color_By_Line',
            value = MaxColLgn,
            maxTextLength = 2,
            vkPlugin = "TextInputNumOnly"
        }
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
        MaxColLgn = box.inputs.Max_Color_By_Line
        goto addColorGel
    elseif (box.result == 1) then
        if SelectedGel == nil then
            Co("no ColorGel are selected!")
            SeqNrStart = box.inputs.Seq_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            PColor = box.inputs.Preset_Color_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addColorGel
        else
            SeqNrStart = box.inputs.Seq_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            PColor = box.inputs.Preset_Color_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
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

    E("addcolorgel ok")

    ChoGel = {};
    for k in ipairs(ColGels) do
        table.insert(ChoGel, "'" .. ColGels[k].name .. "'")
    end
    E("ChoGel ok")


    -- Setup the Messagebox
    PopTableGel = {
        title = "ColorGel",
        caller = display_handle,
        items = ChoGel,
        selectedValue = "",
        add_args = { FilterSupport = "Yes" },
    }


    SelColGel = PopupInput(PopTableGel)


    -- SelColGel = PopupInput("Select ColorGel", display_Handle, ChoGel, "",
    --                        DisMiW, DisMiH)
    -- PopupInput({
    --     title:str,
    --     caller:handle,
    --      items:table:{{'str'|'int'|'lua'|'handle', name, type-dependent}...},
    --       selectedValue:str,
    --        x:int, y:int, target:handle, render_options:{left_icon,number,right_icon}, useTopLeft:bool, properties:{prop:value}, add_args:{FilterSupport='Yes'/'No'}})


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
    Start_Seq_3 = Maf(End_Seq_2 + 1)
    End_Seq_3 = Maf(Start_Seq_3 + LongGel - 1)
    Start_Seq_4 = Maf(End_Seq_3 + 1)
    End_Seq_4 = Maf(Start_Seq_4 + LongGel - 1)
    PColor = Maf(PColor)
    MaxColLgn = tonumber(MaxColLgn)

    for g in ipairs(SelectedGrp) do
        local LayX = RefX
        local col_count = 0
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        NrSeq = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)
        LayNr = Maf(LayNr)

        Cmd("Store Layout " .. TLayNr)

        LayX = Maf(LayX + LayW + 20)

        for col in ipairs(TCol) do
            col_count = col_count + 1
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

            for i = 1, 15 do
                Cmd("Store Macro " .. MacroNrStart .. "." .. i .. "")
            end

            Cmd("Label Macro " .. MacroNrStart .. " \"" .. StColName .. " " ..
                SelectedGrp[g] .. "\"")
            Cmd("CD Macro " .. MacroNrStart)
            Cmd('Set 1 Property Command "Store Group 999/o" ')
            Cmd('Set 2 Property Command "Store Preset 25.999/o" ')
            Cmd('Set 3 Property Command "Group 999 At Preset 25.999" ')
            Cmd('Set 4 Property Command "Delete Sequence 999 /o" ')
            Cmd('Set 5 Property Command "Store Sequence 999 cue 1 /o" ')
            Cmd('Set 6 Property Command "Go Sequence 999 cue 1" ')
            Cmd('Set 7 Property Command "ClearAll" ')
            Cmd('Set 8 Property Command "Blind On" ')
            Cmd('Set 9 Property Command "Fixture Thru" ')
            Cmd('Set 10 Property Command "Down; Down; Down" ')
            Cmd('Set 11 Property Command "at Gel %d.%d" ', SelectedGelNr, TCol[col].no)
            Cmd('Set 12 Property Command "Store preset 4. %d /o" ', PColor)
            Cmd('Set 13 Property Command "ClearAll;  Preset 25.999; At Preset 25.999" ')
            Cmd('Set 14 Property Command "Blind Off" ')
            Cmd('Set 15 Property Command "Off Sequence 999" ')
            Cmd('CD Root')

            -- Add Cmd to Squence
            if (g == 1) then
                E("G 1")
                Cmd("set seq " .. SeqNrStart ..
                    " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    MacroNrStart .. "; Off Sequence " .. Start_Seq_1 ..
                    " Thru " .. End_Seq_1 .. " - " .. SeqNrStart .. "\"")
            elseif (g == 2) then
                E("G 2")
                Cmd("set seq " .. SeqNrStart ..
                    " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    MacroNrStart .. "; Off Sequence " .. Start_Seq_2 ..
                    " Thru " .. End_Seq_2 .. " - " .. SeqNrStart .. "\"")
            elseif (g == 3) then
                E("G 3")
                Cmd("set seq " .. SeqNrStart ..
                    " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    MacroNrStart .. "; Off Sequence " .. Start_Seq_3 ..
                    " Thru " .. End_Seq_3 .. " - " .. SeqNrStart .. "\"")
            elseif (g == 4) then
                E("G 4")
                Cmd("set seq " .. SeqNrStart ..
                    " cue \"CueZero\" Property Command=\"Set Layout " .. TLayNr .. "." ..
                    LayNr .. " Appearance=" .. NrNeed .. "; Macro " ..
                    MacroNrStart .. "; Off Sequence " .. Start_Seq_4 ..
                    " Thru " .. End_Seq_4 .. " - " .. SeqNrStart .. "\"")
            end

            E("set seq")
            Cmd(
                "set seq " .. SeqNrStart .. " cue \"OffCue\" Property Command=\"Set Layout " ..
                TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 ..
                "\"")

            -- end Sequences

            -- Add Sequences to Layout
            E('add sequence to layout')
            Cmd("Assign Seq " .. SeqNrStart .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" ..
                NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
                " PositionW " .. LayW .. " PositionH " .. LayH ..
                " VisibilityObjectname=0 VisibilityBar=0")

            NrNeed = Maf(NrNeed + 2);         -- Set App Nr to next color

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
                    .NO))) then
            TLayNrRef = k
        end
    end

    UsedW = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH = root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " .. UsedH)

    ::cancle::

    Cmd("ClearAll")
end

-- ****************************************************************
-- return the entry points of this plugin :
-- ****************************************************************

return Main
