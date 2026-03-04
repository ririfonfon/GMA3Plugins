local function getTags(obj)
    local tbl = {}
    for a, b in obj:Get('Tags', Enums.Roles.Edit):gmatch('([^:,]+):([^,]+)') do
        tbl[StrToHandle(a)] = tonumber(b)
        Printf(a .. ' - ' .. tbl[StrToHandle(a)] .. ' b = ' .. tonumber(b))
        Printf(a .. ' - ' .. StrToHandle(a) .. ' b = ' .. tonumber(b))
    end
    return tbl
end

local function listTags(obj)
    local tbl = {}
    for a, b in obj:Get('Tags', Enums.Roles.Edit):gmatch('([^:,]+):([^,]+)') do
        tbl[StrToHandle(a)] = tonumber(b)
        Printf(' -' .. StrToHandle(a) .. '-')
        -- local number_tag = string.gsub(StrToHandle(a), 'Tag ', '')
        local number_tag = tostring (StrToHandle(a))
        number_tag = string.gsub(number_tag, "Tag ", "")
        Printf('=' .. tonumber(number_tag) .. '=')
    end
    return tbl
end

local function setTags(obj, tbl)
    local str = ''
    for a, b in pairs(tbl) do
        Printf('a = ' .. a .. ' b = ' .. b)
        str = str .. HandleToStr(a) .. ':' .. b .. ','
        Printf(str)
    end
    obj:Set('Tags', str)
end

return function()
    local TagObject = Root().ShowData.Tags
    local Construct_Pool = 43
    local SequenceObject = Root().ShowData.DataPools[Construct_Pool].Sequences
    local PoolObject = Root().ShowData.DataPools

    local myobj = SequenceObject[18]
    -- local myobj = GetObject('Sequence 1')
    -- local taglist = getTags(myobj)   -- get tags as table with taghandle as keys
    local listlist = listTags(myobj)
    -- taglist[GetObject('Tag 230')] = nil -- example remove a tag from taglist
    -- taglist[GetObject('Tag 2')] = '0'    -- example add a tag to taglist as kill protect = No
    -- taglist[TagObject[157]] = nil -- example remove a tag from taglist
    -- taglist[TagObject[215]] = '0'    -- example add a tag to taglist as kill protect = No
    -- setTags(myobj, taglist)          --update object with new taglist
    -- Printf('addr tag 157 = ' .. TagObject[157]:AddrNative())
    -- Printf('addr tag 21 = ' .. TagObject[21]:AddrNative())
end
