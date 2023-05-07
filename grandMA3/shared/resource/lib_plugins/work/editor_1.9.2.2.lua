Echo(string:format ...)
ErrEcho(string:format ...)
Printf(string:format ...)
ErrPrintf(string:format ...)
Cmd(string:format [,light_userdata:undo], ...)
CmdIndirect(string:cmd_to_execute [,light_userdata:undo [,light_userdata:target]])
CmdIndirectWait(string:cmd_to_execute [,light_userdata:undo [,light_userdata:target]])
HostOS()
HostType()
HostSubType()
SerialNumber()
OverallDeviceCertificate()
RemoteCommand(string:ip, string:command)
ReleaseType()
DevMode3d()
Version()
BuildDetails()
GetShowFileStatus()
ConfigTable()
CmdObj()
Root()
Pult()
DefaultDisplayPositions()
Patch()
FixtureType()
ShowData()
ShowSettings()
DataPool()
MasterPool()
DeviceConfiguration()
Programmer()
ProgrammerPart()
Selection()
CurrentUser()
CurrentProfile()
CurrentEnvironment()
CurrentExecPage()
SelectedSequence()
GetExecutor(integer:exec number)
LoadExecConfig(light_userdata: exec handle)
SaveExecConfig(light_userdata: exec handle)
SelectionFirst()
SelectionNext(int:current subfixture index)
SelectionCount()
SelectionComponentX()
SelectionComponentY()
SelectionComponentZ()
GetSubfixtureCount()
GetSubfixture(int:subfixture index)
GetUIChannelCount()
GetRTChannelCount()
GetAttributeCount()
GetUIChannels(integer: subfixture index or light userdata: reference to Subfixture object[,boolean: as handles])
GetRTChannels(integer: fixture index or light userdata: reference to Fixture object[,boolean: as handles])
GetUIChannel(integer: channel UI index OR light userdata: ref to Subfixture, integer: attribute index or string: attribute name)
GetRTChannel(integer: channel RT index)
GetAttributeByUIChannel(integer: UI channel index)
GetAttributeIndex(string:attribute name)
GetUIChannelIndex(int:subfixture index,int:attribute index)
GetChannelFunctionIndex(int:ui channel index,int:attribute index)
GetChannelFunction(int:ui channel index,int:attribute index)
GetSelectedAttribute()
GetTokenName(string:shortName)
GetTokenNameByIndex(integer: token index)
SetProgPhaser(number:uichannelindex, {[abs_preset:<light_userdata: handle>][rel_preset:<light_userdata: handle>][fade:<val>][delay:<val>][speed:<Hz>][phase:<val>][measure:<val>][gridpos:<val>]   {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]}*})
SetProgPhaserValue(number:uichannelindex, number:step, {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]})
GetProgPhaser(number:uichannelindex, bool:phaser_only)
GetProgPhaserValue(number:uichannelindex, number:step)
SetColor(string:colormodel(RGB,xyY,Lab,XYZ,HSB), double:tripel1, double:tripel2, double:tripel3, double: Brightness, double: Quality, bool: const_Brightness)
GetPresetData(light_userdata:handle(Preset)[,phasers only(default: false)[,by fixtures(default: false)]])
ColMeasureDeviceDarkCalibrate()
ColMeasureDeviceDoMeasurement()
ObjectList(string:address)
FromAddr(string:address [, light_userdata:base handle])
ToAddr(light_userdata:handle)
IntToHandle(LuaInteger)
HandleToInt(light_userdata:handle)
StrToHandle(string: handle in H#... format)
HandleToStr(light_userdata:handle)
IsObjectValid(light_userdata:handle)
Export(string:filename, table:export_data)
Import(string:filename)
ExportJson(string:filename, table:export_data)
ExportCSV(string:filename, table:export_data)
HookObjectChange(function:callback, light_userdata:handle, light_userdata:plugin_handle [,light_userdata:target])
PrepareWaitObjectChange(light_userdata:object[, int:change level threshold])
Unhook(function:callback)
UnhookMultiple(function:callback(can be nil), light_userdata:handle to target(can be nil), light_userdata: handle to context (can be nil))
DumpAllHooks()
GetPath(string:path type | int as path type from enum 'PathType' [,bool: create])
GetPathType(light_userdata:target object [, integer: content type (Enums.PathContentType)])
GetPathOverrideFor(string:path type | int as path type from enum 'PathType', string:path [,bool: create])
GetPathSeparator()
FileExists(string:path)
CreateDirectoryRecursive(string:path)
SyncFS()
DirList(string:path [,string:filter(s)])
StartProgress(string:name)
StopProgress(light_userdate:handle)
SetProgressText(light_userdate:handle, string:text)
SetProgressRange(light_userdate:handle, integer:start, integer:end)
SetProgress(light_userdate:handle, integer:value)
IncProgress(light_userdate:handle [, integer:delta])
GetPropertyColumnId(light_userdata:handle, string:propertyname)
Keyboard(integer: displayIndex, string:type('press','char','release'), (str:char(for type 'char') | str:keycode, bool:shift, bool:ctrl, bool:alt, bool:numlock))
Mouse(integer: displayIndex, string:type('press','move','release'), (str:button('Left', 'Middle', 'Right' for 'press', 'release') | integer:absX, integer:absY))
Touch(integer: displayIndex, string:type('press','move','release'), integer:touchId, integer:absX, integer:absY)
Time()
MouseObj()
TouchObj()
KeyboardObj()
Timer(function:name, number:delaytime, number:max_count, [function:cleanup], [light_userdata:context object])
FindBestDMXPatchAddr(light_userdata:patch, integer:starting address, integer:footprint)
CheckDMXCollision(light_userdata:dmx mode, string:dmx address [,integer:count [,integer:breakIndex]])
CheckFIDCollision(integer:FID [,integer:count [,integer:type]])
GetDMXValue(integer:address [,integer:universe, boolean: modePercent])
GetDMXUniverse(integer:universe [,boolean: modePercent])
SetLED(light_userdata:usb device object handle,table:led_values)
GetButton(light_userdata:usb device object handle)
CreateUndo(string:undo text)
CloseUndo(light userdata: handle to undo)
DeskLocked()
SelectionNotifyBegin(ligh_userdata:associated context)
SelectionNotifyObject(ligh_userdata:object to notify about)
SelectionNotifyEnd(ligh_userdata:associated context)
CreateMultiPatch({array of fixture handles}, integer: count[, string: undo text])
GlobalVars()
UserVars()
PluginVars([string: plugin name])
AddonVars(string: addon name)
SetVar(light userdata: variables, string:varname,value)
GetVar(light userdata: variables, string:varname)
DelVar(light userdata: variables, string:varname)
GetApiDescriptor()
GetObjApiDescriptor()
GetDebugFPS()
GetSample(string: type ('MEMORY', 'CPU', 'CPUTEMP', 'GPUTEMP', 'SYSTEMP', 'FANRPM'))
AddFixtures({mode:handle to DMX mode, amount:integer [,undo: string][,parent: handle][,insert_index:integer][,idtype:string][,cid:string][,fid:string][,name:string][,layer:string][,class:string][,patch:{array 1..8: string address}]})
ClassExists(string:class_name)
IsClassDerivedFrom(string:derived_name, string:base_name)
GetClassDerivationLevel(string:class_name)
TextInput([string:title [, string:value [, integer:x [, integer:y]]]])
PopupInput({title:str, caller:handle, items:table:{{'str'|'int'|'lua'|'handle', name, type-dependent}...}, selectedValue:str, x:int, y:int, target:handle, render_options:{left_icon,number,right_icon}, useTopLeft:bool, properties:{prop:value}, add_args:{FilterSupport='Yes'/'No'}})
Confirm([string:title [,string:message [,integer:displayIndex [,boolean:showCancel]]]])
GetDisplayByIndex(integer:display_index)
GetRemoteVideoInfo()
GetUIObjectAtPosition(integer:display_index, {x,y}:position)
DrawPointer(integer:display_index, {x,y}:position[, number:duration])
WaitObjectDelete(light_userdata:handle to UIObject[, number:seconds to wait])
GetFocus()
GetFocusDisplay()
GetDisplayCollect()
FindBestFocus([light_userdata:handle])
FindNextFocus([bool:backwards(false)[,int(Focus::Reason):reason(UserTabKey)]])
CloseAllOverlays()
GetTopModal()
GetTopOverlay(integer:display_index)
WaitModal([number:seconds to wait])
SetBlockInput(boolean:block)
FindTexture(string:texture name)
MessageBox({title:string,[ backColor:string,][,timeout:number (ms)][,timeoutResultCancel:boolean][,timeoutResultID:number][ icon:string,][ titleTextColor:string,][ messageTextColor:string,] message:string[, display:(integer|lightuserdata)], commands:{array of {value:integer, name:string}}, inputs:{array of {name:string, value:string, blackFilter:string, whiteFilter:string, vkPlugin:string, maxTextLength:integer}}, states:{array of {name:string, state:boolean[,group:integer]}, selectors:{array of {name:string, selectedValue:integer, values:table[,type:integer 0-swipe, 1-radio]} })
ToAddr(light_userdata:handle)
Dump(light_userdata:handle)
Addr(light_userdata:handle [,light_userdata:base_handle [,bool:force parent-based address]])
AddrNative(light_userdata:handle [,light_userdata:base_handle [,bool:escape names]])
Index(light_userdata:handle)
Parent(light_userdata:handle)
Count(light_userdata:handle)
MaxCount(light_userdata:handle)
Compare(light_userdata:handle, light_userdata:handle)
Resize(light_userdata:handle, number size)
Ptr(light_userdata:handle, number:index(1-based))
CmdlinePtr(light_userdata:handle, number:index(1-based))
Children(light_userdata:handle)
CurrentChild(light_userdata:handle)
Create(light_userdata:handle, number:child_index(1-based) [,string:class[,light_userdata:undo]])
Append(light_userdata:handle [,string:class [,light_userdata:undo[,integer:count]]])
Aquire(light_userdata:handle [,string:class [,light_userdata:undo]])
Delete(light_userdata:handle, number:child_index(1-based) [,light_userdata:undo])
Insert(light_userdata:handle, number:child_index(1-based) [,string:class [,light_userdata:undo[,integer:count]]])
Remove(light_userdata:handle, number:child_index(1-based) [,light_userdata:undo])
Copy(light_userdata:dst_handle, light_userdata:src_handle [,light_userdata:undo])
HasParent(light_userdata:handle, handle:object to check)
Changed(light_userdata:handle, string:change level enum name)
IsEmpty(light_userdata:handle)
PrepareAccess(light_userdata:handle)
Set(light_userdata:handle, string:property_name, string:property_value[,Enums.ChangeLevel:override change level])
SetChildren(light_userdata:handle_of_parent, string:property_name, string:property_value [,bool:recursive (default: false)])
Get(light_userdata:handle, string:property_name [,enum{Roles}:role])
PropertyCount(light_userdata:handle)
PropertyName(light_userdata:handle, number:property_index)
PropertyType(light_userdata:handle, number:property_index)
PropertyInfo(light_userdata:handle, number:property_index)
IsValid(light_userdata:handle)
IsClass(light_userdata:handle)
GetClass(light_userdata:handle)
GetChildClass(light_userdata:handle)
GetAssignedObj(light_userdata:handle)
HasEditSettingUI(light_userdata:handle)
HasEditUI(light_userdata:handle)
GetUIEditor(light_userdata:handle)
GetUISettings(light_userdata:handle)
FindParent(light_userdata:search_start_handle,string search_class_name)
Find(light_userdata:search_start_handle,string search_name [,string search_class_name])
FindRecursive(light_userdata:search_start_handle,string search_name [,string search_class_name])
FindWild(light_userdata:search_start_handle,string search_name)
Import(light_userdata:handle, string:file_path,string:file_name)
Export(light_userdata:handle, string:file_path,string:file_name)
GetExportFileName(light_userdata:handle [,bool:camel_case_to_file_name])
Load(light_userdata:handle, string:file_path, string:file_name)
Save(light_userdata:handle, string:file_path, string:file_name)
CommandCall(light_userdata:handle, light_userdata:dest_handle, bool:focusSearchAllowed(default:true))
CommandAt(light_userdata:handle)
CommandDelete(light_userdata:handle)
CommandStore(light_userdata:handle)
CommandCreateDefaults(light_userdata:handle)
SetFader(light_userdata:handle, {[double:value[0..100]], [bool:faderDisabled], [string:token(Fader*)]})
GetFader(light_userdata:handle, {[string:token(Fader*)], [integer:index]})
GetFaderText(light_userdata:handle, {[string:token(Fader*)], [integer:index]})
GetLineCount(light_userdata:handle)
GetLineAt(light_userdata:handle, number:line_number)
HasActivePlayback(light_userdata:handle)
HasReferences(light_userdata:handle)
HasDependencies(light_userdata:handle)
GetReferences(light_userdata:handle)
GetDependencies(light_userdata:handle)
InputSetTitle(light_userdata:handle, string:name_value)
InputSetValue(light_userdata:handle, string:value)
InputSetEditTitle(light_userdata:handle, string:name_value)
InputSetAdditionalParameter(light_userdata:handle, string:parameter name, string:parameter value)
InputRun(light_userdata:handle)
InputCallFunction(light_userdata:handle, string:function name [,...parameters to function...])
InputHasFunction(light_userdata:handle, string:function name)
InputSetMaxLength(light_userdata:handle, int:length)
AddListStringItem(light_userdata:handle,string:name,string:value[,{[left={...}][right={...}]}:appearance])
AddListPropertyItem(light_userdata:handle,string:name,string:value,light_userdata:target handle[,{[left={...}][right={...}]}:appearance])
AddListNumericItem(light_userdata:handle,string:name,number:value[,light_userdata:base handle[,{[left={...}][right={...}]}:appearance]])
AddListLuaItem(light_userdata:handle,string:name,string:value/function name,lua_function:callback reference[,<any lua type>:argument to pass to callback[,{[left={...}][right={...}]}:appearance]])
AddListChildren(light_userdata:handle, light_userdata:parent[,enum{Roles}:role])
AddListChildrenNames(light_userdata:handle, light_userdata:parent[,enum{Roles}:role])
AddListRecursiveNames(light_userdata:handle, light_userdata:parent[,enum{Roles}:role])
RemoveListItem(light_userdata:handle,string:name)
ClearList(light_userdata:handle)
SelectListItemByName(light_userdata:handle,string:name_value)
SelectListItemByValue(light_userdata:handle,string:value)
SelectListItemByIndex(light_userdata:handle,integer:index(1-based))
IsListItemEnabled(light_userdata:handle,integer:index)
SetEnabledListItem(light_userdata:handle,integer:index[,bool:enable(default:true)])
IsListItemEmpty(light_userdata:handle,integer:index)
SetEmptyListItem(light_userdata:handle,integer:index[,bool:empty(default:true)])
GetListItemValueStr(light_userdata:handle,integer:index)
SetListItemValueStr(light_userdata:handle,integer:index,string:value)
GetListItemValueI64(light_userdata:handle,integer:index)
GetListItemName(light_userdata:handle,integer:index)
SetListItemName(light_userdata:handle,integer:index,string:name)
GetListItemAppearance(light_userdata:handle,integer:index)
SetListItemAppearance(light_userdata:handle,integer:index,{[left={...AppearanceData...}][right={...AppearanceData...}]})
GetListItemButton(light_userdata:handle,integer:index)
GetListSelectedItemIndex(light_userdata:handle)
GetListItemsCount(light_userdata:handle)
FindListItemByValueStr(light_userdata:handle,string:value)
FindListItemByName(light_userdata:handle,string:value)
GridGetBase(light_userdata:handle to UIGrid (or derived))
GridGetData(light_userdata:handle to UIGrid (or derived))
GridGetSelection(light_userdata:handle to UIGrid (or derived))
GridGetSelectedCells(light_userdata:handle to UIGrid (or derived))
GridGetSettings(light_userdata:handle to UIGrid (or derived))
GridGetDimensions(light_userdata:handle to UIGrid (or derived))
GridGetScrollOffset(light_userdata:handle to UIGrid (or derived))
GridSetColumnSize(light_userdata:handle to UIGrid (or derived), integer: columnId, integer:size in pixels)
GridGetScrollCell(light_userdata:handle to UIGrid (or derived))
GridGetCellData(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridIsCellVisible(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridCellExists(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridIsCellReadOnly(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridScrollCellIntoView(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridGetCellDimensions(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GridGetParentRowId(light_userdata:handle to UIGrid (or derived), integer: rowId)
GridsGetExpandHeaderCell(light_userdata:handle to UIGrid (or derived))
GridsGetLevelButtonWidth(light_userdata:handle to UIGrid (or derived), {r,c}:cell)
GetOverlay(light_userdata:handle to UIObject)
GetDisplay(light_userdata:handle to UIObject)
GetDisplayIndex(light_userdata:handle to UIObject)
GetScreen(light_userdata:handle to UIObject)
GetUIChildrenCount(light_userdata:handle to UIObject)
ClearUIChildren(light_userdata:handle to UIObject)
GetUIChild(light_userdata:handle to UIObject, integer:index(1-based))
UIChildren(light_userdata:handle to UIObject)
WaitInit(light_userdata:handle to UIObject[, number:seconds to wait[, bool: force to re-init, default - false]])
WaitChildren(light_userdata:handle to UIObject, integer:expected amount of children, [, number:seconds to wait])
HookDelete(light_userdata:handle to UIObject, function:callback to invoke on deletion[,any:argument to pass by])
IsVisible(light_userdata:handle to UIObject)
IsEnabled(light_userdata:handle to UIObject)
ShowModal(light_userdata:handle,callback:function)
SetPositionHint(light_userdata:handle,integer:x,integer:y)
ScrollIsNeeded(light_userdata:handle,integer:scroll type (see 'ScrollType' enum))
ScrollDo(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer:scroll entity (item or area, see 'ScrollParamEntity' enum), integer: value type (absolute or relative, see 'ScrollParamValueType' enum), number: value to scroll (items - 1-based), boolean: updateOpposite side)
ScrollGetInfo(light_userdata:handle,integer:scroll type (see 'ScrollType' enum))
ScrollGetItemSize(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: 1-based item idx)
ScrollGetItemOffset(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: 1-based item idx)
ScrollGetItemByOffset(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: offset)
SetContextSensHelpLink(light_userdata:handle to UIObject, string:topic name)
UILGGetColumnWidth(light_userdata:handle to UILayoutGrid, idx:integer)
UILGGetRowHeight(light_userdata:handle to UILayoutGrid, idx:integer)
UILGGetColumnAbsXLeft(light_userdata:handle to UILayoutGrid, idx:integer)
UILGGetColumnAbsXRight(light_userdata:handle to UILayoutGrid, idx:integer)
UILGGetRowAbsYTop(light_userdata:handle to UILayoutGrid, idx:integer)
UILGGetRowAbsYBottom(light_userdata:handle to UILayoutGrid, idx:integer)
OverlaySetCloseCallback(light_userdata:handle to Overlay, callbackName:string[, ctx:anything])
