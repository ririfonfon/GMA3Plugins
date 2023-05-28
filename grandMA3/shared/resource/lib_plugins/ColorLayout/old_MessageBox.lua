
local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local root = Root();

-- Store all ColorGel in a Table
local ColPath = root.ShowData.GelPools
local ColGels = ColPath:Children()

local OkBtn = ""
local ColGelBtn = "Add ColorGel"
local ValOkBtn = 100
local TGrpChoise
local count = 0
local Message = "Add Fixture Group and ColorGel\n * set beginning Appearance & Sequence Number\n\n Selected Group(s) are: \n"
local SelGrp = " "
local SelColGel
local PopTableGrp = {}
local ChoGel
local PopTableGel = {}
local SelectedGel

function Message_Box(tln,nl,sns,mns,an,mcl,fg,sg,sgn,sgnr)

    local TLayNr = tln
    local NaLay = nl
    local SeqNrStart = sns
    local MacroNrStart = mns
    local AppNr = an
    local MaxColLgn = mcl
    local FixtureGroups = fg
    local valide
    local SelectedGrp = sg
    local SelectedGrpNo = sgn
    local SelectedGelNr = sgnr
    
    -- Message Box
    ::MessageBox::
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
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto MessageBox
        else
            E("add Group")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
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
        MacroNrStart = box.inputs.Macro_Start_Nr
        AppNr = box.inputs.Appearance_Start_Nr
        TLayNr = box.inputs.Layout_Nr
        NaLay = box.inputs.Layout_Name
        MaxColLgn = box.inputs.Max_Color_By_Line
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
            goto addColorGel
            
        elseif next(SelectedGrp) == nil then
            Co("no Group are added!")
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
            goto addGroup
        else
            SeqNrStart = box.inputs.Sequence_Start_Nr
            MacroNrStart = box.inputs.Macro_Start_Nr
            AppNr = box.inputs.Appearance_Start_Nr
            TLayNr = box.inputs.Layout_Nr
            NaLay = box.inputs.Layout_Name
            MaxColLgn = box.inputs.Max_Color_By_Line
           valide = 1
           goto VA
        end
        
    elseif (box.result == 0) then
        goto VA
    end
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
        items = {"Select","Some","Value","Please"},
        selectedValue = "",
        add_args = {FilterSupport = "Yes"}
    }
    E("******")
    SelGrp = PopupInput(PopTableGrp)
    
    table.insert(SelectedGrp, "'" .. FixtureGroups[SelGrp + 1].name .. "'")
    table.insert(SelectedGrpNo, "'" .. FixtureGroups[SelGrp + 1].NO .. "'")
    E("A")
    Message = Message .. FixtureGroups[SelGrp + 1].name .. "\n"
    E("Select Group " .. FixtureGroups[SelGrp + 1].name)
    table.remove(FixtureGroups, SelGrp + 1)
    goto MessageBox
    -- End Choise Fixture Group	        
    
    -- Choise ColorGel  
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
    goto MessageBox
    -- End ColorGel	

    ::VA::
    if valide == 1 then
        E("now i do some Magic stuff...")
        return 1,SeqNrStart,MacroNrStart,AppNr,TLayNr,NaLay,MaxColLgn,SelectedGelNr,SelectedGrp,SelectedGrpNo 
    else
        E("User Canceled")
        return 0      
    end
end