--[[ Find Property Plugin v 1.2
Created by Yury Belousov ]]

require("gma3_helpers")

local headline_character = '='
local headline_width = 80

--color-codes for echo/feedback
local col=string.char(27)..'[3';
--color-escape-start
local BK=col.."0m"
local RD=col.."1m"
local GN=col.."2m"
local YE=col.."3m"
local BL=col.."4m"
local MG=col.."5m"
local CY=col.."6m"
local WT=col.."7m"
local bold = string.char(27)..'[1m'

local properties = {}

local function compare(a,b,is_strict)
    if is_strict then
        if a==tostring(b) then
            return true
        end
    else
        if tostring(b):find(a) then
            return true
        end
    end
    return false
end

local function console_select_usb_drive(display)
    local drives = Root().temp.drivecollect:Children()
    local usb_drive_names = {}
    for _,drive in ipairs(drives) do
        if drive.drivetype == 'Removeable' then
            table.insert(usb_drive_names,drive.name)
        end
    end
    if #usb_drive_names == 0 then return false end
    local descTable = {
        title = "Select removeable drive",
        caller = display,
        items = usb_drive_names,
        add_args = {FilterSupport="Yes"},
    }
    local a,b = PopupInput(descTable)
    if a then
        CmdIndirectWait('select drive "'..tostring(b))
        return true
    else
        return false
    end
end

local function user_input()
    local inputs = {
		{name = "Where to search", value = "showdata"},
		{name = " What to search"}
	}
	local selectors = {
		{ name="Search for property value ot property name?", selectedValue=1, values={['Value']=2,['Name']=1}, type=1}
	}
    local states = {
        {name='Exact match  ',state=false}
    }
	local resultTable =
		MessageBox(
		{
			title = "Find property plugin",
			message_align_h = Enums.AlignmentH.Left,
			message_align_v = Enums.AlignmentV.Top,
            inputs=inputs,
            selectors = selectors,
            states=states,
			commands = {{value = 1, name = "Start search"}, {value = 0, name = "Cancel"}},
			backColor = "Global.Default",
			icon = "tools",
			titleTextColor = "Global.Text",
			messageTextColor = "Global.Text"
		}
	)
    if resultTable.success and resultTable.result == 1 then
        return resultTable.selectors['Search for property value ot property name?'], resultTable.inputs['Where to search'], resultTable.inputs[' What to search'],resultTable.states['Exact match  ']
    end
end

local function find_property_recursive(obj,what_to_search,is_strict,value_or_name)
    for i=0,obj:PropertyCount()-1 do
        local property_name = obj:PropertyName(i)
        local value = string.lower(tostring(obj[property_name]))
        local is_same
        if value_or_name == 'value' then
            is_same = compare(what_to_search,value,is_strict)
        else
            what_to_search = string.upper(what_to_search)
            is_same = compare(what_to_search,tostring(property_name),is_strict)
        end
        if is_same then
            table.insert(properties,obj:AddrNative(true,true)..',"'..obj:PropertyName(i)..'","'..tostring(obj[obj:PropertyName(i)])..'",')
            Echo('Address: '..MG..obj:AddrNative(true,true)..YE..' Property: '..CY..obj:PropertyName(i)..YE..' Value: '..CY..tostring(obj[obj:PropertyName(i)]))
        end
    end
    local child = obj:Children()
    if #child ~= 0 then
        for i=1,#child do
            if (obj.name ~= 'UserEnvironment 1' or    obj.name ~= 'UserEnvironment 2') and i ~= 5 then
                find_property_recursive(child[i],what_to_search,is_strict,value_or_name)
            end
        end
    end
end

local function find_property(display)
    properties = {}
    local path
    local value_or_name,where_to_search,what_to_search,is_strict = user_input()
    if what_to_search then
        if value_or_name == 2 then value_or_name = 'value' else value_or_name = 'name' end
        local obj
        local obj_name
        if where_to_search and string.lower(where_to_search) ~= 'root' and FromAddr(where_to_search) then
            obj = FromAddr(where_to_search)
            obj_name = obj:ToAddr()
        else
            obj = Root()
            obj_name = 'Root'
        end
        Echo(gma3_helpers:headline(' Search started ',headline_character,headline_width))
        find_property_recursive(obj,what_to_search,is_strict,value_or_name)
        Echo(gma3_helpers:headline(' Search completed ',headline_character,headline_width))
        Echo('Have searched for the property '..value_or_name..' '..CY..what_to_search..YE..' in '..MG..obj_name)
        Echo('Found '..WT..#properties..YE..' matches')
        Echo(gma3_helpers:headline('',headline_character,headline_width))
        if #properties ~= 0 then
            if Confirm('Store .csv file with search results?') then
                local time = Root().StationSettings.TimeConfig
                local console_stick_selected = false
                if HostType() == 'Console' then
                    console_stick_selected = console_select_usb_drive(display)
                end
                path = GetPath(Enums.PathType.Library):gsub('/',GetPathSeparator())..GetPathSeparator()..'search_plugin_results'
                CreateDirectoryRecursive(path)
                local filename_time = string.format('%02d-%s-%sT%02d-%02d-%02d',time.day,time.month:sub(1,3),tostring(time.year):sub(-2,-1),time.hour,time.minute,time.second)
                path = path..GetPathSeparator().."searched_in_"..string.lower(obj.name)..'_'..Version()..'_'..filename_time.."("..what_to_search:gsub('[%.%*%%]','').." - "..value_or_name..").csv"
                local file = io.open(path, "w")
                file:write('Address,Property,Value,\n')
                file:write(table.concat(properties,'\n'))
                file:close()
                Echo('Search results exported to: '..path)
                Echo(gma3_helpers:headline('',headline_character,headline_width))
                if console_stick_selected then
                    CmdIndirectWait('select drive 1')
                end
            end
        end
    end
end

return find_property