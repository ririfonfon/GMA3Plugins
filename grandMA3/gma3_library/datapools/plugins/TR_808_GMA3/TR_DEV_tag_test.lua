local function getTags(obj)
    local tbl = {}
    for a, b in obj:Get('Tags', Enums.Roles.Edit):gmatch('([^:,]+):([^,]+)') do
        tbl[StrToHandle(a)] = tonumber(b)
        Printf(a .. ' - ' .. tbl[StrToHandle(a)])
    end
    return tbl
end

local function setTags(obj, tbl)
    local str = ''
    for a, b in pairs(tbl) do
        str = str .. HandleToStr(a) .. ':' .. b .. ','
    end
    obj:Set('Tags', str)
end

return function()
    local TagObject = Root().ShowData.Tags
    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools

    local myobj = SequenceObject[1]
    -- local myobj = GetObject('Sequence 1')
    local taglist = getTags(myobj)   -- get tags as table with taghandle as keys
    -- taglist[GetObject('Tag 230')] = nil -- example remove a tag from taglist
    -- taglist[GetObject('Tag 2')] = '0'    -- example add a tag to taglist as kill protect = No
    taglist[TagObject[230]] = nil -- example remove a tag from taglist
    taglist[TagObject[215]] = '0'    -- example add a tag to taglist as kill protect = No
    setTags(myobj, taglist)          --update object with new taglist
end
