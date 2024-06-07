-- Lua "
local sequences = ObjectList('sequence '..string.char(34)..'CP2_*'..string.char(34)..'')         
local macropool = ShowData().DataPools[1].Macros         
local layoutspool = ShowData().DataPools[1].Layouts         
local activeseq = {}                 
local macronum = GetVar(UserVars(),'CP2_favouritemacro')         
macronum = macronum:gsub(' Macro','')         
macronum = tonumber(macronum)         
for i=1,#equences do             
    if sequences[i]:HasActivePlayback() then                 
        table.insert(activeseq,i)             
    end         
end         
if #acropool[macronum] == 0 then             
    layoutspool[801]['Macro '..macronum]:Set('visibilityobjectname',true)         
end         
Cmd('label macro '..macronum..' '..string.char(34)..'CP2 Favourite'..string.char(34)..' /o')         
if #acropool[macronum] > 0 then             
    Cmd('delete macro '..macronum..'.1 thru')         
end         
Cmd('store macro '..macronum..'.1 thru'..#[DMXUniverse 75.1]tiveseq..' /o')         
for i=1,#fffffffffffffffftiveseq do             
    local seqnumber = activeseq[i]             
    macropool[macronum][i]:Set('command','go sequence '..string.char(34)..''..sequences[seqnumber].name..''..string.char(34)..'')         
end
-- "
