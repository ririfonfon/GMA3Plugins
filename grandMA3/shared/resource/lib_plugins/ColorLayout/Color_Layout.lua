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
    E("Layout = %s",tostring(TLay))
    local TLayNr
    local TLayNrRef

    for k in pairs(TLay) do
        E("Layout n° = %s",tostring(TLay[k].NO))
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
    local SelectedGrp = {}
    local SelectedGel
    local Message =
        "Add Fixture Group and ColorGel, set beginning Sequence Number\n\n Selected Group(s) are: \n"
    local ColGelBtn = "Add ColorGel"
    local SeqNrText = "Seq_Start_Nr"
    local OkBtn = ""
    local ValOkBtn = 100
    local count = 0
    local check = 0
    local NaLay = "Colors"
    local PopTableGrp = {}
    local PopTableGel = {}

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
        commands = {
            {name = 'Add Group', value = 11}, {name = ColGelBtn, value = 12},
            {name = OkBtn, value = ValOkBtn}, {name = 'Cancel', value = 0}
        },
        inputs = {
            {
                name = SeqNrText,
                value = SeqNrStart,
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

    if (box.result == 11 or box.result == 100 or box.result == 10) then

        if (count == 0 or ValOkBtn == 100) then
            ValOkBtn = Maf(ValOkBtn / 10)
            if (ValOkBtn < 10) then ValOkBtn = 1 end
        end

        if (ValOkBtn == 1) then OkBtn = "OK Let's GO" end

        for k in pairs(FixtureGroups) do count = count + 1 end

        if (count == 0) then
            E("all Groups are added")
            Co("all Groups are added")
            SeqNrStart = box.inputs.Seq_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto MainBox
        else
            E("add Group")
            SeqNrStart = box.inputs.Seq_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addGroup
        end

    elseif (box.result == 12) then
        ValOkBtn = Maf(ValOkBtn / 10)
        if (ValOkBtn < 10) then
            ValOkBtn = 1
            OkBtn = "OK Let's GO"
        end

        E("add ColorGel")
        SeqNrStart = box.inputs.Seq_Start_Nr
        TLayNr = box.inputs.Layout_Nr
        NaLay = box.inputs.Layout_Name
        MaxColLgn = box.inputs.Max_Color_By_Line
        goto addColorGel

    elseif (box.result == 1) then
        if SelectedGel == nil then
            Co("no ColorGel are selected!")
            SeqNrStart = box.inputs.Seq_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addColorGel

        elseif next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Seq_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addGroup
        else
            SeqNrStart = box.inputs.Seq_Start_Nr
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
    add_args = {FilterSupport="Yes"},
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
        add_args = {FilterSupport="Yes"},
        }
    SelColGel = PopupInput(PopTableGel)
    -- SelColGel = PopupInput("Select ColorGel", display_Handle, ChoGel, "",
    --                        DisMiW, DisMiH)
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
    MaxColLgn = tonumber(MaxColLgn)

    for g in ipairs(SelectedGrp) do

        local LayX = RefX
        local col_count = 0
        LayY = Maf(LayY - LayH) -- Max Y Position minus hight from element. 0 are at the Bottom!

        if (AppCrea == 0) then
            AppNr = Maf(AppNr + 1);
            Cmd("Store App " .. AppNr .. " \"Label\" Appearance=" .. StAppOn ..
                    " color=\"0,0,0,1\"")
        end

        NrSeq = Maf(AppNr + 1)
        NrNeed = Maf(AppNr + 1)

        Cmd("Assign Group "..SelectedGrp[g].." at Layout "..TLayNr)
        Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Action=0 Appearance="..
        AppNr.." PosX "..LayX.." PosY "..LayY.." PositionW "..
        LayW.." PositionH "..LayH..
        " VisibilityObjectname=1 VisibilityBar=0 IndicatorBar=Background")

        LayNr = Maf(LayNr + 1)
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
            Cmd("clearall")
            Cmd("Group " .. SelectedGrp[g] .. " at Gel " .. ColNr .."")
            Cmd("Store Sequence " .. SeqNrStart .. " \"" .. StColName ..
                    " " .. SelectedGrp[g]:gsub('\'', '') .. "\"")
            -- Add Cmd to Squence
            Cmd(
                "set seq " .. SeqNrStart .. " cue \"CueZero\" Property Command=\"Set Layout " ..
                    TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed .. "\"")
            Cmd(
                "set seq " .. SeqNrStart .. " cue \"OffCue\" Property Command=\"Set Layout " ..
                    TLayNr .. "." .. LayNr .. " Appearance=" .. NrNeed + 1 ..
                    "\"")
            -- end Sequences

            -- Add Squences to Layout
            Cmd("Assign Seq " .. SeqNrStart .. " at Layout " .. TLayNr)
            Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " appearance=" ..
                    NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
                    " PositionW " .. LayW .. " PositionH " .. LayH ..
                    " VisibilityObjectname=0 VisibilityBar=0")

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

            SeqNrStart = Maf(SeqNrStart + 1)
        end
        -- end Squences to Layout

        AppCrea = 1
        LayY = Maf(LayY - 20) -- Add offset for Layout Element distance
    end
    ---- end Appearances/Sequences 

    for k in pairs(root.ShowData.DataPools.Default.Layouts:Children()) do
        if (Maf(TLayNr) ==
            Maf(tonumber(root.ShowData.DataPools.Default.Layouts:Children()[k]
                             .NO))) then TLayNrRef = k end
    end

    UsedW =
        root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedW / 2
    UsedH =
        root.ShowData.DataPools.Default.Layouts:Children()[TLayNrRef].UsedH / 2
    Cmd("Set Layout " .. TLayNr .. " DimensionW " .. UsedW .. " DimensionH " ..
            UsedH)

    ::cancle::

    Cmd("ClearAll")
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main
