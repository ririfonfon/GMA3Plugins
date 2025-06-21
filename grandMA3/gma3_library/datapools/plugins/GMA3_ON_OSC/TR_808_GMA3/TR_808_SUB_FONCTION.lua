--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", june 2025.

--]]
local function main()
    local Select = UserVars()
    local layout, macrostore, data_pool, tag, macro
    if GetVar(Select, "TR_Layout") then
        layout = tonumber(GetVar(Select, "TR_Layout"))
    end
    if GetVar(Select, "TR_Favourites") then
        macrostore = GetVar(Select, "TR_Favourites")
    end
    if GetVar(Select, "TR_DataPool") then
        data_pool = GetVar(Select, "TR_DataPool")
    end
    if GetVar(Select, "TR_tag") then
        tag = GetVar(Select, "TR_Tg")
    end
    if GetVar(Select, "TR_Macro") then
        macro = GetVar(Select, "TR_Macro")
    end

    Favourites(layout, macrostore, data_pool, tag, macro)
    
end


function Favourites(layout, macrostore, data_pool, tag, macro)
    local sequences = ObjectList('DataPool ' .. data_pool ..
        ' Sequence ' .. string.char(34) .. '' .. tag .. '*' .. string.char(34) .. '')
    local macropool = ShowData().DataPools[data_pool].Macros
    local layoutspool = ShowData().DataPools[data_pool].Layouts
    local activeseq = {}
    Printf(macrostore)
    local macronum = macrostore
    macronum = macronum:gsub(' Macro', '')
    local mess = 'DataPool ' .. data_pool
    macronum = macronum:gsub(mess, '')
    macronum = tonumber(macronum)
    Printf(macronum)
    for i = 1, #sequences do
        if sequences[i]:HasActivePlayback() then
            table.insert(activeseq, i)
        end
    end
    if #macropool[macronum] == 0 then
        layoutspool[layout]['Macro ' .. macronum]:Set('visibilityobjectname', true)
    end
    Cmd('label DataPool ' ..
    data_pool .. ' macro ' .. macronum .. ' ' .. string.char(34) .. tag .. ' Favourite' .. string.char(34) .. ' /o')
    if #macropool[macronum] > 0 then
        Cmd('delete DataPool ' .. data_pool .. ' macro ' .. macronum .. '.1 thru')
    end
    Cmd('store DataPool ' .. data_pool .. ' macro ' .. macronum .. '.1 thru' .. #activeseq .. ' /o')
    for i = 1, #activeseq do
        local seqnumber = activeseq[i]
        macropool[macronum][i]:Set('command', 'go DataPool ' .. data_pool ..
            ' Sequence ' .. string.char(34) .. '' .. sequences[seqnumber].name .. '' .. string.char(34) .. '')
    end
    Cmd('Set DataPool ' .. data_pool .. ' Macro ' .. macro .. ' Property "Appearance" "TR_Black"')
end