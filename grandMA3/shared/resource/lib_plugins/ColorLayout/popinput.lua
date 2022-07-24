local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local function main(displayHandle)

    local root = Root();

    local FixtureGroups = root.ShowData.DataPools.Default.Groups:Children()
    local TGrpChoise

    TGrpChoise = {}
    for k in ipairs(FixtureGroups) do
        table.insert(TGrpChoise, "'" .. FixtureGroups[k].name .. "'")
        E(FixtureGroups[k].name)
    end

    local PopTable = {
        title = "Fixture Group",
        caller = displayHandle,
        items = TGrpChoise,
        selectedValue = "",
        add_args = {FilterSupport="Yes"},
    }
    local a = PopupInput(PopTable)
    Printf("a = %s",tostring(a))
    E(a)
    -- Printf("b = %s",tostring(b))
end

return main







PopupInput({title:str,caller:handle,items:table:{{'str'|'int'|'lua'|'handle', name, type-dependent}...},selectedValue:str,x:int,y:int,target:handle,render_options:{left_icon,number,right_icon},useTopLeft:bool,properties:{prop:value}}): string:value







Cmd("Assign Group "..SelectedGrp[g].." at Layout "..TLayNr)
Cmd("Set Layout "..TLayNr.."."..LayNr.." Action=0")
Cmd("Set Layout "..TLayNr.."."..LayNr.." Appearance="..AppNr..)
Cmd("Set Layout "..TLayNr.."."..LayNr.." PosX "..LayX.." PosY "..LayY.." PositionW "..LayW.." PositionH "..LayH..)
Cmd("Set Layout "..TLayNr.."."..LayNr.." VisibilityObjectname=0")
Cmd("Set Layout "..TLayNr.."."..LayNr.." VisibilityBar=0")
Cmd("Set Layout "..TLayNr.."."..LayNr.." IndicatorBar=Background")

Cmd("Set Layout " .. TLayNr .. "." .. LayNr .. " Appearance=" ..
NrNeed + 1 .. " PosX " .. LayX .. " PosY " .. LayY ..
" PositionW " .. LayW .. " PositionH " .. LayH ..
" VisibilityObjectname=0 VisibilityBar=0")