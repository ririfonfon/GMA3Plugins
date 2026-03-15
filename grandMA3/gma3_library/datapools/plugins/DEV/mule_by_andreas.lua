--[[---------------------------------------------------------------------------
   "THE BEER-WARE LICENSE" (Revision 42):
   Andreas Glad wrote this file.  As long as you retain this notice you
   can do whatever you want with this stuff. If we meet some day, and you think
   this stuff is worth it, you can buy me a beer in return.
-------------------------------------------------------------------------------
MMMMMM             MMMMMMUUUUUUU     UUUUUUULLLLLLLLL         EEEEEEEEEEEEEEEEE
M:::::M           M:::::MU:::::U     U:::::UL:::::::L         E:::::::::::::::E
M::::::M         M::::::MU:::::U     U:::::UL:::::::L         E:::::::::::::::E
M:::::::M       M:::::::MUU::::U     U::::UULL:::::LL         EE::::EEEEEEE:::E
M::::::::M     M::::::::M U::::U     U::::U   L:::L             E:::E     EEEEE
M:::::::::M   M:::::::::M U::::D     D::::U   L:::L             E:::E
M:::::M::::M M::::M:::::M U::::D     D::::U   L:::L             E::::EEEEEEE
M::::M M::::M::::M M::::M U::::D     D::::U   L:::L             E::::::::::E
M::::M  M:::::::M  M::::M U::::D     D::::U   L:::L             E::::::::::E
M::::M   M:::::M   M::::M U::::D     D::::U   L:::L             E::::EEEEEEE
M::::M    M:::M    M::::M U::::D     D::::U   L:::L             E:::E
M::::M     MMM     M::::M U:::::U   U:::::U   L:::L       LLLL  E:::E     EEEEE
M::::M             M::::M U::::::UUU::::::U LL:::::LLLLLLL:::LEE::::EEEEEE::::E
M::::M             M::::M  UU:::::::::::UU  L::::::::::::::::LE:::::::::::::::E
M::::M             M::::M   UU:::::::::UU   L::::::::::::::::LE:::::::::::::::E
MMMMMM             MMMMMM     UUUUUUUUU     LLLLLLLLLLLLLLLLLLEEEEEEEEEEEEEEE]]

local MULE_spell = [=[ Lua "

--[[ bits'n'bytes, be my fuel, turn this macro, into a MULE  --]]

local function findembedded(mline)
  local cmd = mline.Command
  local embedded = cmd:find('^Macro%s') and ObjectList(cmd)
  return embedded and #embedded > 0 and embedded
end

local function findgoto(mline)
  local gtarget = select(3, mline.Command:find('{%s*goto%s+(.+)}'))
  if gtarget then
    local macro, linename = mline:Parent(), string.format('::%s::', gtarget)
    gtarget = macro[linename] and macro[linename]:Index()
    return gtarget or ErrPrintf('MULE: could not find macroline '..linename) or mline:Index() + 1
  end
end

local basecode = [[return function() local gma = _G do local _ENV = setmetatable({},
  {__index = function(t,k) return GetVar(UserVars(),k) or GetVar(GlobalVars(),k) or gma[k] end})
  return %s end end
]]

local function evaluate(condition)
  local success, result = pcall(load(basecode:format(condition))())
  if success then return result and true or false
  else ErrPrintf('MULE: could not evaluate condition: '..condition) return false end
end

local function resolve(statement)
  local success, result = pcall(load(basecode:format(statement))())
  if success then return tostring(result)
  else ErrPrintf('MULE: could not resolve statement: '..statement) return '{'..statement..'}' end
end

local function validate(mline)
  if mline.Enabled == false or #mline.Command == 0 or mline.Name == 'MULE_spell' then return false end
  local condition = select(3, mline.Name:find('%[(.+)%]'))
  if condition then return evaluate(condition) else return true end
end

local function linewait(mline)
  if mline.Wait > 0 then coroutine.yield(mline.Wait/256^3) end
end

local function executebyproxy(mline)
  local proxy = DataPool().Macros:Aquire() proxy.Name ='MULE-assistant'
  local ml = proxy:Append() ml:Copy(mline)
  ml.Command = ml.Command:gsub('{(.-)}', resolve)
  proxy:Append() proxy:CommandCall()
  local pb = StartProgress('awaiting user completion of commandline')
  repeat coroutine.yield(0.05) until not proxy:HasActivePlayback()
  StopProgress(pb)
  proxy:CommandDelete()
end

local function execute(mline)
  local gotoline = findgoto(mline)
  if gotoline then return gotoline end
  if mline.AddToCmdline == true or mline.Execute == false then
    executebyproxy(mline)
  else
    local cmd = mline.Command:gsub('{(.-)}', resolve)
    CmdIndirectWait(cmd)
  end
end

local function parse(macro, line, endline)
  if type(macro) == 'table' then for _, macro in ipairs(macro) do parse(macro) end return end
  if macro:HasActivePlayback() then Cmd('Off '..macro:ToAddr()) end
  line, endline = line or 1, endline or #macro
  local pb = StartProgress(string.format('Executing Macro %q macroline', macro.Name)) SetProgressRange(pb, line, endline)
  repeat
    local mline, embedded, gotoline
    SetProgress(pb, line)
    mline = macro[line]
    embedded = findembedded(mline)
    if validate(mline) then
      if embedded then parse(embedded) else gotoline = execute(mline) end
      linewait(mline)
    end
    line = gotoline or line + 1
  until line > endline
  StopProgress(pb)
end

for _, wrapper in ipairs(ObjectList('Macro *.MULE_spell')) do
  if wrapper and wrapper:Parent():HasActivePlayback() then
    Printf('MULE v1.0')
    parse(wrapper:Parent())
    return
  end
end

--[[ bits'n'bytes, be my fuel, turn this macro, into a MULE  --]]

"]=]

local function addspell(macro)
  local ml = macro.MULE_spell or macro:Insert(1)
  ml.Lock = false
  ml.Command = MULE_spell:gsub('/n', ' '):gsub('%s+', ' ')
  ml.Name = 'MULE_spell' ml.AddToCmdline = false ml.Execute = true ml.Wait = -1
  ml.Lock = true
  return macro
end

local function newmule()
  local macro = addspell(DataPool().Macros:Aquire())
  CmdIndirectWait('Edit '..macro:ToAddr())
end

local function examplemule()
  local macro = addspell(DataPool().Macros:Aquire())
  macro.Name = 'MULE Example'
  local ml
  ml = macro:Append() ml.Command = 'SetUservar "mycounter" 0'
  ml = macro:Append() ml.Command = 'SetUservar "mycounter" {mycounter + 1}' ml.Name = "::loopstart::"
  ml = macro:Append() ml.Command = 'Fixture $mycounter'
  ml = macro:Append() ml.Command = 'At {mycounter * 10}'
  ml = macro:Append() ml.Command = '{goto loopstart}' ml.Name = "[mycounter < 10]"
  ml = macro:Append() ml.Command = 'DelUservar "mycounter"'
  CmdIndirectWait('Edit '..macro:ToAddr())
end

local function enchantmacro()
  local items = {}
  for k, macro in ipairs(DataPool().Macros:Children()) do
    if not macro.MULE_spell then
      items[#items+1] = {'handle', macro.No..': '..macro.Name, macro}
    end
  end
  local popup = {
    title = 'macro to enchant',
    caller = GetFocusDisplay(),
    items = items,
    add_args = {FilterSupport="Yes"}
  }
  local _, macro = PopupInput(popup)
  macro = macro and StrToHandle(macro)
  if macro then
    if macro.Lock == 'Yes' then
      ErrPrintf('MULE: macro is locked')
    else
      Printf('MULE: enchanting '..macro:ToAddr())
      addspell(macro)
    end
  else
    ErrPrintf('MULE: no normal macro found/selected')
  end
end

local function cleanup()
  for i = 0, 10 do StopProgress(i) end
  local helpers = ObjectList('Macro "MULE-assistant*"')
  for k, macro in ipairs(helpers) do macro:CommandDelete() end
end

local function help()
  local message = [[ SYNTAX

Use square brackets in macroline-name to define a condition
[myvar < 10]

Use curly brackets in macroline-command to insert showdata or calculations
Label Cue 1 "created by {CurrentUser().Name}"
At {5 + myvar * 3}

Use double colons in macroline-name to define goto targets
::myloopstart::

Use curly brackets in macroline-command to jump/loop via goto
{goto myloopstart}

USAGE

This plugin is not required for the enchanted macro to run.
The magic spell is included in first macroline of each mule.
  ]]
  local menu = {
    icon = 'wizard', title = 'MULE creator 1.0 - Help',
    message = message,
    commands = {
      {value = 1, name = 'Create example mule', func = examplemule},
      {value = 2, name = 'Close'}
    }
  }
  local choice = MessageBox(menu)
  local func = choice.success and menu.commands[choice.result].func
  if func then func() end
end

local function main()
  cleanup() -- just in case a mule has had an exception and left some garbage
  local menu = {
    icon = 'wizard', title = 'MULE creator 1.0 - by Andreas Glad',
    message = 'mule (noun) /myül/ - a macro under lua enchantment',
    commands = {
      {value = 1, name = 'Create new mule', func = newmule},
      {value = 2, name = 'Enchant existing macro', func = enchantmacro},
      {value = 3, name = 'Help', func = help},
      {value = 4, name = 'Cancel'}
    }
  }
  local choice = MessageBox(menu)
  local func = choice.success and menu.commands[choice.result].func
  if func then func() end
end

return main