--[[
    ==========================================
    Object-Free API
    =========================================
]]

Echo(string:format ...): nothing
ErrEcho(string:format ...): nothing
Printf(string:format ...): nothing
ErrPrintf(string:format ...): nothing
Cmd(string:format [,light_userdata:undo], ...): string:command execution result (Ok, Syntax Error, Illegal Command...)
CmdIndirect(string:cmd_to_execute [,light_userdata:undo [,light_userdata:target]]): nothing
CmdIndirectWait(string:cmd_to_execute [,light_userdata:undo [,light_userdata:target]]): nothing
HostOS(nothing): string::OsType
HostType(nothing): string::HostType
HostSubType(nothing): string::HostSubType
SerialNumber(nothing): string::SerialNumber
OverallDeviceCertificate(nothing): pCertificate::OverallCertificate
RemoteCommand(string:ip, string:command): bool: success
ReleaseType(nothing): string::release type
DevMode3d(nothing): string::DevMode3d
Version(nothing): string::version
BuildDetails(nothing): table:build details
GetShowFileStatus(nothing): string::showfile status
ConfigTable(nothing): table:config details
CmdObj(nothing): light_userdata:handle
Root(nothing): light_userdata:handle
Pult(nothing): light_userdata:handle
DefaultDisplayPositions(nothing): light_userdata:handle
Patch(nothing): light_userdata:handle
FixtureType(nothing): light_userdata:handle
ShowData(nothing): light_userdata:handle
ShowSettings(nothing): light_userdata:handle
DataPool(nothing): light_userdata:handle
MasterPool(nothing): light_userdata:handle
DeviceConfiguration(nothing): light_userdata:handle
Programmer(nothing): light_userdata:handle
ProgrammerPart(nothing): light_userdata:handle
Selection(nothing): light_userdata:handle
CurrentUser(nothing): light_userdata:handle
CurrentProfile(nothing): light_userdata:handle
CurrentEnvironment(nothing): light_userdata:handle
CurrentExecPage(nothing): light_userdata:handle to current ExecPage
SelectedSequence(nothing): light_userdata:handle
GetExecutor(integer:exec number): light_userdata:handle to executor, light_userdata: handle to page
LoadExecConfig(light_userdata: exec handle): nothing
SaveExecConfig(light_userdata: exec handle): nothing
SelectionFirst(nothing): int:first subfixture index, int:x, int:y, int:z
SelectionNext(int:current subfixture index): int: next subfixture index, int:x, int:y, int:z
SelectionCount(nothing): int: amount of selected subfixtures
SelectionComponentX(nothing): int: min, int:max, int:index, int:block, int:group
SelectionComponentY(nothing): int: min, int:max, int:index, int:block, int:group
SelectionComponentZ(nothing): int: min, int:max, int:index, int:block, int:group
GetSubfixtureCount(nothing): int:subfixture count
GetSubfixture(int:subfixture index): light userdata:reference to Subfixture object or nil
GetUIChannelCount(nothing): int:ui channel count
GetRTChannelCount(nothing): int:rt channel count
GetAttributeCount(nothing): int:attribute count
GetUIChannels(integer: subfixture index or light userdata: reference to Subfixture object[,boolean: as handles]): {array of UI channel indices or handles} or nil
GetRTChannels(integer: fixture index or light userdata: reference to Fixture object[,boolean: as handles]): {array of RT channel indices or handles} or nil
GetUIChannel(integer: channel UI index OR light userdata: ref to Subfixture, integer: attribute index or string: attribute name): {ChannelUI descriptor} or nil
GetRTChannel(integer: channel RT index): {ChannelRT descriptor} or nil
GetAttributeByUIChannel(integer: UI channel index): light userdata: reference to attribute or nil
GetAttributeIndex(string:attribute name): int:attribute index
GetUIChannelIndex(int:subfixture index,int:attribute index): int:ui channel index
GetChannelFunctionIndex(int:ui channel index,int:attribute index): int:channel function index
GetChannelFunction(int:ui channel index,int:attribute index): light_userdata: handle
GetSelectedAttribute(): light_userdata:attribute handle
GetTokenName(string:shortName): string:fullName
GetTokenNameByIndex(integer: token index): string:fullName
SetProgPhaser(number:uichannelindex, {[abs_preset:<light_userdata: handle>][rel_preset:<light_userdata: handle>][fade:<val>][delay:<val>][speed:<Hz>][phase:<val>][measure:<val>][gridpos:<val>]   {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]}*}): nothing
SetProgPhaserValue(number:uichannelindex, number:step, {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]}): nothing
GetProgPhaser(number:uichannelindex, bool:phaser_only): {[abs_preset:<light_userdata: handle>][rel_preset:<light_userdata: handle>][fade:<val>][delay:<val>][speed:<Hz>][phase:<val>][measure:<val>][gridpos:<val>][mask_active_phaser:<bool>][mask_active_value:<bool>][mask_individual:<bool>] {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]}*}
GetProgPhaserValue(number:uichannelindex, number:step): {[function:<val>] [absolute:<val>][absolute_value:<val>][relative:<val>] [accel:<val>][accel_type:<Enums.SplineType>][decel:<val>][decel_type:<Enums.SplineType>] [trans:<val>][width:<val>] [integrated:<light_userdata: handle>]}
SetColor(string:colormodel(RGB,xyY,Lab,XYZ,HSB), double:tripel1, double:tripel2, double:tripel3, double: Brightness, double: Quality, bool: const_Brightness): int:flag
GetPresetData(light_userdata:handle(Preset)[,phasers only(default: false)[,by fixtures(default: false)]]): array of phaser data
ColMeasureDeviceDarkCalibrate(): int:flag
ColMeasureDeviceDoMeasurement(): table:values
ObjectList(string:address): table of light_userdata:handle
FromAddr(string:address [, light_userdata:base handle]): light_userdata:handle
ToAddr(light_userdata:handle): string:address
IntToHandle(LuaInteger): light_userdata:handle
HandleToInt(light_userdata:handle): LuaInteger
StrToHandle(string: handle in H#... format): light_userdata:handle
HandleToStr(light_userdata:handle): string: handle in H#... format
IsObjectValid(light_userdata:handle): true or nil
Export(string:filename, table:export_data): bool:success
Import(string:filename): table:content
ExportJson(string:filename, table:export_data): bool:success
ExportCSV(string:filename, table:export_data): bool:success
HookObjectChange(function:callback, light_userdata:handle, light_userdata:plugin_handle [,light_userdata:target]): nothing
PrepareWaitObjectChange(light_userdata:object[, int:change level threshold]): true or nil
Unhook(function:callback): nothing
UnhookMultiple(function:callback(can be nil), light_userdata:handle to target(can be nil), light_userdata: handle to context (can be nil)): integer: amount of removed hooks
DumpAllHooks(nothing): nothing
GetPath(string:path type | int as path type from enum 'PathType' [,bool: create]): string:path
GetPathType(light_userdata:target object [, integer: content type (Enums.PathContentType)]): path type name
GetPathOverrideFor(string:path type | int as path type from enum 'PathType', string:path [,bool: create]): string:overriden path
GetPathSeparator(): 
FileExists(string:path): boolean:result
CreateDirectoryRecursive(string:path): boolean:result
SyncFS(nothing): nothing
DirList(string:path [,string:filter(s)]): array of {name:string, size:int, time:int}
StartProgress(string:name): light_userdate:handle
StopProgress(light_userdate:handle): nothing
SetProgressText(light_userdate:handle, string:text): nothing
SetProgressRange(light_userdate:handle, integer:start, integer:end): nothing
SetProgress(light_userdate:handle, integer:value): nothing
IncProgress(light_userdate:handle [, integer:delta]): nothing
GetPropertyColumnId(light_userdata:handle, string:propertyname): LuaInteger
Keyboard(integer: displayIndex, string:type('press','char','release'), (str:char(for type 'char') | str:keycode, bool:shift, bool:ctrl, bool:alt, bool:numlock)): nothing
Mouse(integer: displayIndex, string:type('press','move','release'), (str:button('Left', 'Middle', 'Right' for 'press', 'release') | integer:absX, integer:absY)): 
Touch(integer: displayIndex, string:type('press','move','release'), integer:touchId, integer:absX, integer:absY): 
Time(nothing): number:time
MouseObj(nothing): light_userdata:mouse object handle
TouchObj(nothing): light_userdata:touch object handle
KeyboardObj(nothing): light_userdata:keyboard object handle
Timer(function:name, number:delaytime, number:max_count, [function:cleanup], [light_userdata:context object]): nothing
FindBestDMXPatchAddr(light_userdata:patch, integer:starting address, integer:footprint): integer:absolute address
CheckDMXCollision(light_userdata:dmx mode, string:dmx address [,integer:count [,integer:breakIndex]]): boolean:true - no collision, false - collisions
CheckFIDCollision(integer:FID [,integer:count [,integer:type]]): boolean: true - no FID collisions, false - collisions
GetDMXValue(integer:address [,integer:universe, boolean: modePercent]): integer: dmx value
GetDMXUniverse(integer:universe [,boolean: modePercent]): table of integer: dmx values
SetLED(light_userdata:usb device object handle,table:led_values): nothing
GetButton(light_userdata:usb device object handle): table of bool:state
CreateUndo(string:undo text): light userdata: handle to undo
CloseUndo(light userdata: handle to undo): boolean: true if was closed, false - if it's still in use
DeskLocked(): boolean: true if desk is locked
RefreshLibrary(light userdata: Handle): 
SelectionNotifyBegin(ligh_userdata:associated context): 
SelectionNotifyObject(ligh_userdata:object to notify about): 
SelectionNotifyEnd(ligh_userdata:associated context): 
CreateMultiPatch({array of fixture handles}, integer: count[, string: undo text]): integer: amount of multi-patch fixtures created
GlobalVars(): light userdata: global variables
UserVars(): light userdata: user variables
PluginVars([string: plugin name]): light userdata: plugin variables
AddonVars(string: addon name): light userdata: addon variables
SetVar(light userdata: variables, string:varname,value): bool:success
GetVar(light userdata: variables, string:varname): value
DelVar(light userdata: variables, string:varname): bool:success
GetApiDescriptor(nothing): table: api content
GetObjApiDescriptor(nothing): table: api content
GetDebugFPS(nothing): number: fps
GetSample(string: type ('MEMORY', 'CPU', 'CPUTEMP', 'GPUTEMP', 'SYSTEMP', 'FANRPM')): number: current value in percent
AddFixtures({mode:handle to DMX mode, amount:integer [,undo: string][,parent: handle][,insert_index:integer][,idtype:string][,cid:string][,fid:string][,name:string][,layer:string][,class:string][,patch:{array 1..8: string address}]}): true on success or nil
ClassExists(string:class_name): boolean:result
IsClassDerivedFrom(string:derived_name, string:base_name): boolean:result
GetClassDerivationLevel(string:class_name): integer:result or nil
TextInput([string:title [, string:value [, integer:x [, integer:y]]]]): string:value
PopupInput({title:str, caller:handle, items:table:{{'str'|'int'|'lua'|'handle', name, type-dependent}...}, selectedValue:str, x:int, y:int, target:handle, render_options:{left_icon,number,right_icon}, useTopLeft:bool, properties:{prop:value}, add_args:{FilterSupport='Yes'/'No'}}): string:value
Confirm([string:title [,string:message [,integer:displayIndex [,boolean:showCancel]]]]): boolean:result
GetDisplayByIndex(integer:display_index): light_userdata:display_handle
GetRemoteVideoInfo(nothing): integer:wingID, boolean:isExtension
GetUIObjectAtPosition(integer:display_index, {x,y}:position): light_userdata:handle to UI object or nil
DrawPointer(integer:display_index, {x,y}:position[, number:duration]): nothing
WaitObjectDelete(light_userdata:handle to UIObject[, number:seconds to wait]): boolean:true on success, nil on timeout
GetFocus(nothing): light_userdata:display_handle
GetFocusDisplay(nothing): light_userdata:display_handle
GetDisplayCollect(nothing): light_userdata:handle to DisplayCollect
FindBestFocus([light_userdata:handle]): nothing
FindNextFocus([bool:backwards(false)[,int(Focus::Reason):reason(UserTabKey)]]): nothing
CloseAllOverlays(nothing): nothing
GetTopModal(nothing): light userdata: handle to top modal overlay
GetTopOverlay(integer:display_index): light userdata: handle to top overlay on the display
WaitModal([number:seconds to wait]): handle to modal overlay or nil on failure(timeout)
SetBlockInput(boolean:block): nothing
FindTexture(string:texture name): light userdata: handle to texture found
MessageBox({title:string,[ backColor:string,][,timeout:number (ms)][,timeoutResultCancel:boolean][,timeoutResultID:number][ icon:string,][ titleTextColor:string,][ messageTextColor:string,] message:string[, display:(integer|lightuserdata)], commands:{array of {value:integer, name:string}}, inputs:{array of {name:string, value:string, blackFilter:string, whiteFilter:string, vkPlugin:string, maxTextLength:integer}}, states:{array of {name:string, state:boolean[,group:integer]}, selectors:{array of {name:string, selectedValue:integer, values:table[,type:integer 0-swipe, 1-radio]} }): {success:boolean, result:integer, inputs:{array of [name:string] = value:string}, states:{array of [name:string] = state:boolean}, selectors:{array of [name:string] = selected-value:integer}}

==========================================
Object API
==========================================

ToAddr(light_userdata:handle): string:address
Dump(light_userdata:handle): string:information
Addr(light_userdata:handle [,light_userdata:base_handle [,bool:force parent-based address]]): text:numeric root address
AddrNative(light_userdata:handle [,light_userdata:base_handle [,bool:escape names]]): text:numeric root address
Index(light_userdata:handle): number:index
Parent(light_userdata:handle): light_userdata:parent_handle
Count(light_userdata:handle): number:child_count
MaxCount(light_userdata:handle): number:child_count
Compare(light_userdata:handle, light_userdata:handle): bool:isEqual, String:whatDiffers
Resize(light_userdata:handle, number size): nothing
Ptr(light_userdata:handle, number:index(1-based)): light_userdata:child_handle
CmdlinePtr(light_userdata:handle, number:index(1-based)): light_userdata:child_handle
Children(light_userdata:handle): table of light_userdata:child_handles
CurrentChild(light_userdata:handle): light_userdata:current child or nil
Create(light_userdata:handle, number:child_index(1-based) [,string:class[,light_userdata:undo]]): light_userdata:child_handle
Append(light_userdata:handle [,string:class [,light_userdata:undo[,integer:count]]]): light_userdata:child_handle
Aquire(light_userdata:handle [,string:class [,light_userdata:undo]]): light_userdata:child_handle
Delete(light_userdata:handle, number:child_index(1-based) [,light_userdata:undo]): nothing
Insert(light_userdata:handle, number:child_index(1-based) [,string:class [,light_userdata:undo[,integer:count]]]): light_userdata:child_handle
Remove(light_userdata:handle, number:child_index(1-based) [,light_userdata:undo]): nothing
Copy(light_userdata:dst_handle, light_userdata:src_handle [,light_userdata:undo]): nothing
HasParent(light_userdata:handle, handle:object to check): nothing
Changed(light_userdata:handle, string:change level enum name): nothing
IsEmpty(light_userdata:handle): boolean:returns true if objects is considered 'empty'
PrepareAccess(light_userdata:handle): nothing
Set(light_userdata:handle, string:property_name, string:property_value[,Enums.ChangeLevel:override change level]): nothing
SetChildren(light_userdata:handle_of_parent, string:property_name, string:property_value [,bool:recursive (default: false)]): nothing
Get(light_userdata:handle, string:property_name [,enum{Roles}:role]): string:property_value (if 'role' provided - always string)
PropertyCount(light_userdata:handle): number:property_count
PropertyName(light_userdata:handle, number:property_index): string:property_name
PropertyType(light_userdata:handle, number:property_index): string:property_type
PropertyInfo(light_userdata:handle, number:property_index): {string:ReadOnly, string:ImportIgnore, string:ExportIgnore}
IsValid(light_userdata:handle): bool:result
IsClass(light_userdata:handle): string:class_name
GetClass(light_userdata:handle): string:class_name
GetChildClass(light_userdata:handle): string:class_name
GetAssignedObj(light_userdata:handle): light_userdata:handle
HasEditSettingUI(light_userdata:handle): bool:result
HasEditUI(light_userdata:handle): bool:result
GetUIEditor(light_userdata:handle): string:ui_editor_name
GetUISettings(light_userdata:handle): string:ui_settings_name
FindParent(light_userdata:search_start_handle,string search_class_name): light_userdata:found_handle
Find(light_userdata:search_start_handle,string search_name [,string search_class_name]): light_userdata:found_handle
FindRecursive(light_userdata:search_start_handle,string search_name [,string search_class_name]): light_userdata:found_handle
FindWild(light_userdata:search_start_handle,string search_name): light_userdata:found_handle
Import(light_userdata:handle, string:file_path,string:file_name): bool:success
Export(light_userdata:handle, string:file_path,string:file_name): bool:success
GetExportFileName(light_userdata:handle [,bool:camel_case_to_file_name]): string:filename
Load(light_userdata:handle, string:file_path, string:file_name): bool:success
Save(light_userdata:handle, string:file_path, string:file_name): bool:success
CommandCall(light_userdata:handle, light_userdata:dest_handle, bool:focusSearchAllowed(default:true)): nothing
CommandAt(light_userdata:handle): nothing
CommandDelete(light_userdata:handle): nothing
CommandStore(light_userdata:handle): nothing
CommandCreateDefaults(light_userdata:handle): nothing
SetFader(light_userdata:handle, {[double:value[0..100]], [bool:faderDisabled], [string:token(Fader*)]}): nothing
GetFader(light_userdata:handle, {[string:token(Fader*)], [integer:index]}): double:value[0..100]
GetFaderText(light_userdata:handle, {[string:token(Fader*)], [integer:index]}): string:text
GetLineCount(light_userdata:handle): number:count
GetLineAt(light_userdata:handle, number:line_number): string:line_content
HasActivePlayback(light_userdata:handle): boolean:result
HasReferences(light_userdata:handle): boolean:result
HasDependencies(light_userdata:handle): boolean:result
GetReferences(light_userdata:handle): {light_userdata:handle}
GetDependencies(light_userdata:handle): {light_userdata:handle}
InputSetTitle(light_userdata:handle, string:name_value): nothing
InputSetValue(light_userdata:handle, string:value): nothing
InputSetEditTitle(light_userdata:handle, string:name_value): nothing
InputSetAdditionalParameter(light_userdata:handle, string:parameter name, string:parameter value): nothing
InputRun(light_userdata:handle): nothing
InputCallFunction(light_userdata:handle, string:function name [,...parameters to function...]): <depends on function>
InputHasFunction(light_userdata:handle, string:function name): true or nil
InputSetMaxLength(light_userdata:handle, int:length): nothing
AddListStringItem(light_userdata:handle,string:name,string:value[,{[left={...}][right={...}]}:appearance]): nothing
AddListPropertyItem(light_userdata:handle,string:name,string:value,light_userdata:target handle[,{[left={...}][right={...}]}:appearance]): nothing
AddListNumericItem(light_userdata:handle,string:name,number:value[,light_userdata:base handle[,{[left={...}][right={...}]}:appearance]]): nothing
AddListLuaItem(light_userdata:handle,string:name,string:value/function name,lua_function:callback reference[,<any lua type>:argument to pass to callback[,{[left={...}][right={...}]}:appearance]]): nothing
AddListObjectItem(light_userdata:handle,light_userdata:target object[,(string: explicit name[,{[left={...}][right={...}]}:appearance] | enum{Roles}: role [,:boolean: extended_name[,{[left={...}][right={...}]}:appearance]])]): nothing
AddListStringItems(light_userdata:handle, table{item={[1]=name,[2]=value},...}): nothing
AddListPropertyItems(light_userdata:handle, table{item={[1]=name,[2]=property name,[3]=target handle},...}): nothing
AddListNumericItems(light_userdata:handle, table{item={[1]=name,[2]=integer:value},...}): nothing
AddListLuaItems(light_userdata:handle, table{item={[1]=name,[2]=value/function name,[3]=callback reference[,[4]=argument of any lua type to pass to callback]},...}): nothing
AddListChildren(light_userdata:handle, light_userdata:parent[,enum{Roles}:role]): nothing
AddListChildrenNames(light_userdata:handle, light_userdata:parent[,enum{Roles}:role]): nothing
AddListRecursiveNames(light_userdata:handle, light_userdata:parent[,enum{Roles}:role]): nothing
RemoveListItem(light_userdata:handle,string:name): nothing
ClearList(light_userdata:handle): nothing
SelectListItemByName(light_userdata:handle,string:name_value): nothing
SelectListItemByValue(light_userdata:handle,string:value): nothing
SelectListItemByIndex(light_userdata:handle,integer:index(1-based)): nothing
IsListItemEnabled(light_userdata:handle,integer:index): nothing
SetEnabledListItem(light_userdata:handle,integer:index[,bool:enable(default:true)]): nothing
IsListItemEmpty(light_userdata:handle,integer:index): nothing
SetEmptyListItem(light_userdata:handle,integer:index[,bool:empty(default:true)]): nothing
GetListItemValueStr(light_userdata:handle,integer:index): string:value
SetListItemValueStr(light_userdata:handle,integer:index,string:value): nothing
GetListItemValueI64(light_userdata:handle,integer:index): integer:value
GetListItemName(light_userdata:handle,integer:index): string:name
SetListItemName(light_userdata:handle,integer:index,string:name): nothing
GetListItemAppearance(light_userdata:handle,integer:index): {left={AppearanceData}, right={AppearanceData}}
SetListItemAppearance(light_userdata:handle,integer:index,{[left={...AppearanceData...}][right={...AppearanceData...}]}): nothing
GetListItemButton(light_userdata:handle,integer:index): light userdata:button or nil if not visible
GetListSelectedItemIndex(light_userdata:handle): integer:1-based index
GetListItemsCount(light_userdata:handle): integer:amount of items in the list
FindListItemByValueStr(light_userdata:handle,string:value): integer:1-based index
FindListItemByName(light_userdata:handle,string:value): integer:1-based index
GridGetBase(light_userdata:handle to UIGrid (or derived)): light_userdata:handle to GridBase
GridGetData(light_userdata:handle to UIGrid (or derived)): light_userdata:handle to GridData
GridGetSelection(light_userdata:handle to UIGrid (or derived)): light_userdata:handle to GridSelection
GridGetSelectedCells(light_userdata:handle to UIGrid (or derived)): array of {r,c, r_UniqueId,r_GroupId,c_UniqueId,c_GroupId} cells in the selection
GridGetSettings(light_userdata:handle to UIGrid (or derived)): light_userdata:handle to GridSettings
GridGetDimensions(light_userdata:handle to UIGrid (or derived)): {r,c}
GridGetScrollOffset(light_userdata:handle to UIGrid (or derived)): {v = {index,offset}, h={index,offset}}
GridSetColumnSize(light_userdata:handle to UIGrid (or derived), integer: columnId, integer:size in pixels): nothing
GridGetScrollCell(light_userdata:handle to UIGrid (or derived)): {r,c}
GridGetCellData(light_userdata:handle to UIGrid (or derived), {r,c}:cell): {text, color={text,back}}
GridIsCellVisible(light_userdata:handle to UIGrid (or derived), {r,c}:cell): boolean
GridCellExists(light_userdata:handle to UIGrid (or derived), {r,c}:cell): boolean
GridIsCellReadOnly(light_userdata:handle to UIGrid (or derived), {r,c}:cell): boolean
GridScrollCellIntoView(light_userdata:handle to UIGrid (or derived), {r,c}:cell): nothing
GridGetCellDimensions(light_userdata:handle to UIGrid (or derived), {r,c}:cell): {x,y,w,h}
GridGetParentRowId(light_userdata:handle to UIGrid (or derived), integer: rowId): parent row id (integer) or nil (if there's no parent)
GridsGetExpandHeaderCell(light_userdata:handle to UIGrid (or derived)): {r,c} or nil
GridsGetLevelButtonWidth(light_userdata:handle to UIGrid (or derived), {r,c}:cell): width in pixels or nil
GetOverlay(light_userdata:handle to UIObject): light_userdata:overlay_handle
GetDisplay(light_userdata:handle to UIObject): light_userdata:display_handle
GetDisplayIndex(light_userdata:handle to UIObject): integer:display_index
GetScreen(light_userdata:handle to UIObject): light_userdata:handle
GetUIChildrenCount(light_userdata:handle to UIObject): integer:count
ClearUIChildren(light_userdata:handle to UIObject): nothing
GetUIChild(light_userdata:handle to UIObject, integer:index(1-based)): light_userdata:handle to UIObject
UIChildren(light_userdata:handle to UIObject): array of references to children of passed UIObject
WaitInit(light_userdata:handle to UIObject[, number:seconds to wait[, bool: force to re-init, default - false]]): boolean:true on success, nil on timeout or if object doesn't exist
WaitChildren(light_userdata:handle to UIObject, integer:expected amount of children, [, number:seconds to wait]): boolean:true on success, nil on timeout or if object doesn't exist
HookDelete(light_userdata:handle to UIObject, function:callback to invoke on deletion[,any:argument to pass by]): boolean:true on success, nil on failure
IsVisible(light_userdata:handle to UIObject): bool: is visible
IsEnabled(light_userdata:handle to UIObject): bool: is enabled
ShowModal(light_userdata:handle,callback:function): nothing
SetPositionHint(light_userdata:handle,integer:x,integer:y): nothing
ScrollIsNeeded(light_userdata:handle,integer:scroll type (see 'ScrollType' enum)): boolean:true if scroll of the requested type is needed
ScrollDo(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer:scroll entity (item or area, see 'ScrollParamEntity' enum), integer: value type (absolute or relative, see 'ScrollParamValueType' enum), number: value to scroll (items - 1-based), boolean: updateOpposite side): boolean:true scroll
ScrollGetInfo(light_userdata:handle,integer:scroll type (see 'ScrollType' enum)): {index(1-based), offset, visibleArea, totalArea, itemsCount, itemsOnPage} or nil
ScrollGetItemSize(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: 1-based item idx): integer:size of the item of nil
ScrollGetItemOffset(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: 1-based item idx): integer:offset of the item or nil
ScrollGetItemByOffset(light_userdata:handle,integer:scroll type (see 'ScrollType' enum), integer: offset): integer:1-based item index
SetContextSensHelpLink(light_userdata:handle to UIObject, string:topic name): nothing
UILGGetColumnWidth(light_userdata:handle to UILayoutGrid, idx:integer): size:integer
UILGGetRowHeight(light_userdata:handle to UILayoutGrid, idx:integer): size:integer
UILGGetColumnAbsXLeft(light_userdata:handle to UILayoutGrid, idx:integer): x:integer
UILGGetColumnAbsXRight(light_userdata:handle to UILayoutGrid, idx:integer): x:integer
UILGGetRowAbsYTop(light_userdata:handle to UILayoutGrid, idx:integer): y:integer
UILGGetRowAbsYBottom(light_userdata:handle to UILayoutGrid, idx:integer): y:integer
OverlaySetCloseCallback(light_userdata:handle to Overlay, callbackName:string[, ctx:anything]): nothing
