--[[
@title: [ UI The Bad Idea.lua ]
@author: [ BakaCowpoke ]
@date: [ 2/3/2026 ]
@license: [ CC0 ]
@description: [ A Very BAD Idea to "Brute Force" Determine what are valid UI Elements 
	since there seems to be no readily available comprehensive list.

	I have never seen so much Red in the System Monitor.

	Some items do quite a bit Visually, some didn't seem to do anything.
		I didn't spend time exploring.  

		I highly recommend creating a variable of any you're interested in 
		and executing a Dump.

		[ie.  Printf(theAbused[1]:Dump()) ]


	Initial possibleCandidates List generated with Grep on a Mac in the 
	Terminal Utility.  Did try to use xmllint, seemed to hang 
	because of the sheer number of files.  Took less time this way.
	Grep Search command listed below.

	grep -Eorh '<[a-zA-Z0-9_]{6,}[:space:]' /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared | sort -u 
  
	Add another pair of Brackets around :space: it breaks the comment in this file.


	If run on the full set 2 items will cause errors:
		
		"ContextButton"
		"LogoButton"

		Both seem to have a Lock on their Text Field,
		but they do Append.

	I kept all the Negative Results in this set since some 
	things i expected to work Crashed the Program.


	Hope This Helps!

	]
]]



--For UI Element Functions
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local alfredPlease = select(3, ...)



local function theBADIdea()

	-- Loop Control Variables are around Line 1585


	local continue = false

	local possibleCandidates = {
	--"Abbreviations", 
	--"ActivationGroup", 
	--"ActivationGroups", 
	--"Agenda", 
	--"AgendaCall", 
	--"AgendaCopy", 
	--"AgendaCountdown", 
	--"AgendaDaylight", 
	"AgendaDaysGrid",
	--"AgendaDelete", 
	--"AgendaEvent", 
	--"AgendaExchange", 
	--"AgendaExecute", 
	--"AgendaExport", 
	"AgendaGrid",   
	--"AgendaLabel", 
	--"AgendaLock", 
	"AgendaMonthsGrid",   
	--"AgendaOops", 
	--"AgendaRepeat", 
	--"AgendaStore", 
	--"AllExecEditor",  --Crashed
	--"AllPoolLayoutGrid",   
	--"AllPoolTitleButton",   
	--"AllPoolWindow", 
	"AnalogClock", 
	--"ApiTests", 
	--"Appearance", 
	--"AppearanceAssign", 
	--"AppearanceCopy", 
	--"AppearanceDelete", 
	"AppearanceEditContent", 
	"AppearanceEditor", 
	--"AppearanceExchange", 
	--"AppearanceExport", 
	"AppearanceInput", 
	--"AppearanceLabel", 
	--"AppearanceLock", 
	--"AppearanceMove", 
	--"AppearanceOops", 
	--"AppearancePoolLayoutGrid",   --Crashed
	"AppearancePreview", 
	--"AppearanceSet", 
	--"AppearanceStore", 
	"AppearanceTitleBar",   
	--"article", 
	--"ArtNet", 
	--"ask_for_usb_copy", 
	--"AssignAuto", 
	--"AssignmentEditorFilterItem", 
	--"AssignmentUITab", 
	--"AtComplexAuto", 
	"AtFilterDialog", 
	--"AtFilterSettings", 
	--"Attribute", 
	--"AttributeAt", 
	--"AttributePark", 
	--"AttributeRadioButtonList",  --Crashed
	--"Attributes", 
	"AudioPreview", 
	"AutoCloseValueFadeControl", 
	--"AutoCreateAndAutoStore", 
	--"AutocreateFTPresets", 
	--"AutocreateGroups", 
	--"AutoCreatePresetFromChannelSet", 
	--"AutoCreatePresetGeneric", 
	"AutoLayout", 
	"AuxValueControl", 
	--"Backdrop", 
	"BackupMenu", 
	"BandFader",   
	"BaseInput", 
	--"BasicDialogs", 
	"BatteryStatusIcon", 
	--"Bitmap", 
	--"BitmapAttributes", 
	--"BitmapDelete", 
	--"BitmapExchange", 
	--"BitmapExport", 
	--"BitmapLabel", 
	--"BitmapLock", 
	--"BitmapOops", 
	--"BitmapStore", 
	"BladeView", 
	"BlinkingFadeButton",   
	--"break_on_fail", 
	"Button",      
	--"CachedObject",  
	--"CachedObjectInstalled", 
	--"Camera", 
	--"CameraCopy", 
	--"CameraDelete", 
	"CameraEditor", 
	--"CameraExchange", 
	--"CameraExport", 
	--"CameraLabel", 
	--"CameraLock", 
	--"CameraMove", 
	--"CameraOops", 
	--"CameraPoolLayoutGrid",   --Crashed
	--"CameraSet", 
	--"CameraStore", 
	--"Capture", 
	--"Certificate", 
	--"ChannelFunction", 
	--"ChannelSet", 
	"ChannelTestView", 
	--"check_basic_functions", 
	--"check_flaky_tests", 
	--"check_flaky_tests_stable", 
	"CheckBox",   
	"ChildRadioButtonList", 
	--"circle", 
	--"clipPath", 
	--"ClockWindow",  --Crashed
	"CloneAtFilterSelector", 
	"CloneFilterButton",   
	"CloneFilterGrid",   
	--"CloneFilterGridData", 
	"CloneGrid",   
	"CloneOverlay", 
	"CloningDialog", 
	--"CloseButton",     --Not Sure why this caused an Error...I've used it before
	"CmdDlgFunctionButtonsLeft", 
	"CmdDlgFunctionButtonsRight", 
	--"CmdInput", 
	--"Cmdline", 
	"CmdlineEdit", 
	--"CmdlineInput", 
	--"ColorDef", 
	--"ColorDefGroup", 
	"ColorEditBar",   
	--"ColorEngine", 
	"ColorEngineDebugView", 
	--"ColorGroup", 
	"ColorInput", 
	--"ColorInterfacefader",   
	"ColorMeasurementOverlay", 
	"ColorPickerContent", 
	--"ColorPickerfader",   
	--"ColorPickerSettings", 
	"ColorPickHSCircle", 
	"ColorPickHSRect", 
	"ColorPickXYZ", 
	"ColorPropertyInput", 
	--"ColorSpaceCollect", 
	--"ColorSpaceData", 
	"ColorTestView", 
	--"ColorTheme", 
	"ColorView", 
	--"colorwheel", 
	--"Commandline", --Crash
	--"CommandLineHistory", --Crash
	--"CommandlineHistoryTextView", --Crash
	--"CommandLineWindow", --Crash
	--"CommandlineWindowSettings", --Crash
	"CommandPreviewButton",   
	--"CommandWingBar",   --Crash
	--"CommandWingBarContainer", --Crash
	--"CommandWingBarPlaybackContent",   --Reboot No Warning
	--"CommandWingBarWindow", --Crash
	--"complex", 
	--"ComponentLua", 
	--"ComponentXML", 
	--"ConfigEntry", 
	--"Configuration", 
	--"ConfigurationCopy", 
	--"ConfigurationDelete", 
	--"ConfigurationExchange", 
	--"ConfigurationExport", 
	--"ConfigurationLabel", 
	--"ConfigurationLock", 
	--"ConfigurationMove", 
	--"ConfigurationOops", 
	--"ConfigurationPoolLayoutGrid",  --Crashed 
	--"Configurations", 
	--"ConfigurationSet", 
	--"ConfigurationStore", 
	--"Connectors", 
	--"ContentSheetGridScroller",  --Crashed
	--"ContentView",  --Crashed
	--"ContentWindow",  --Crashed
	"ContextButton",   --WIERD...May just have a Locked down Text field
	--"copy_logfiles_to_usb", 
	"CopyCueMessageBox",   
	"CpuTempView", 
	"CPUTestView", 
	--"CrashTickets", 
	--"create_Object_method_table", 
	--"create_systemtest_view", 
	--"create_test_history", 
	--"CueBlock", 
	--"CueBreak", 
	--"CueConvert", 
	--"CueCopy", 
	--"CueCopyP2", 
	--"CueCopyP3", 
	--"CueCopyP4", 
	--"CueCopyP5", 
	--"CueDelete", 
	--"CueEdit", 
	--"CueExport", 
	--"CueFadeDelay", 
	--"CueGoto", 
	"CueInputGrid",   
	--"CueLoad", 
	--"CueLock", 
	--"CueMove", 
	"CueNumberInput", 
	--"CueOff", 
	--"CueOops", 
	--"CueOutFadeDelay", 
	--"Cuepart", 
	--"CuepartAt", 
	--"CuepartCopy", 
	--"CuepartDelete", 
	--"CuepartLock", 
	--"CuepartMove", 
	--"CuepartOops", 
	--"CuepartRecipeCopy", 
	--"CuepartRecipeMove", 
	--"CuepartRecipeProperties", 
	--"CuepartSelfix", 
	--"CuepartStore", 
	--"CueSelfix", 
	--"CueSet", 
	--"CueStore", 
	--"CueStoreCueOnly", 
	--"CueTransition", 
	--"CueUpdate", 
	--"CueUpdateGridData", 
	--"CueZero", 
	"CustomMasterLayoutGrid",   
	--"CustomMasterSection", 
	--"DataNegotiation", 
	--"Datapool", 
	--"DatapoolCopy", 
	--"DatapoolDelete", 
	--"DatapoolExchange", 
	--"DatapoolExport", 
	--"DatapoolLabel", 
	--"DataPoolLayoutGrid",   --Crashed
	--"DatapoolLock", 
	--"DatapoolMove", 
	--"DatapoolOops", 
	--"DatapoolSet", 
	--"DatapoolStore", 
	"DateClock", 
	"DatumInput", 
	"DBObjectBar",   
	"DBObjectGrid",   
	"DBObjectGridBase", 
	--"DBObjectGridCell", 
	--"DBObjectGridColumnConfiguration", 
	--"DBObjectGridData", 
	"DBObjectTab",  
	"DCRemoteInfo", 
	--"DeactivationGroup", 
	--"DeactivationGroups", 
	--"debug_speed_multiplier", 
	--"DefaultColumns", 
	--"DefaultEdit", 
	--"DefaultValues", 
	"DeleteCueMessageBox",   
	"DeleteWindowButton",   
	--"Dependency", 
	--"DependencyExport", 
	--"DeskLock",  --I DO NOT reccomend Appending This
	"Dialog", 
	"DialogButton",   
	"DialogContainer", 
	"DialogFrame",   
	"DialogHelp", 
	"DialogPrivacyPolicy", 
	"DialogReleaseNotes", 
	"DialogTrackpad", 
	"DialogTrademarks", 
	"DigitalClock", 
	--"dimmer", 
	--"Dimmer", 
	"DimmerWheelButton",   
	--"Disclosure", 
	--"Display", 
	--"DisplayLock", 
	--"DisplayOops", 
	"DisplaySelectButton",   
	--"DisplayStore", 
	--"DMXChannel", 
	--"DMXChannels", 
	--"DmxConfigurations", 
	--"DmxCurve", 
	--"DmxCurvePoint", 
	--"DmxCurves", 
	--"DMXMode", 
	"DMXSheet", 
	"DmxTesterBar",   
	"DriveSelector", 
	"DriveStatusButton",   
	--"dump_log_on_fail", 
	--"EditContentAuto", 
	--"EditorAppearanceButton",   
	--"EditorCategoryButton",   
	--"EditorNameButton",   
	--"EditorNoteButton",   
	--"EditorPropertyButton",   
	"EditorPropertyButtons", 
	--"EditorScribbleButton",   
	--"EditorSubCategoryButton",   
	--"EditorSwipeButton",   
	--"EditorTagButton",   
	--"EditRecipeAuto", 
	--"EditTitleBarButton",   
	--"EditTrackDataAuto", 
	"EjectButton",   
	--"ellipse",
	--"ellipse", 
	--"Emitter", 
	--"Emitters", 
	--"enable_network_test", 
	--"EnableMasterFaderButton",   --Crashed
	--"EncoderBankSelector",   --Crashed
	--"EncoderBar",   
	--"EncoderBarPoolButton",   
	--"EncoderBarPoolLayoutGrid",   --Crashed
	"EncoderBarSlot", 
	"EncoderControl", 
	--"EncoderDefinition", 
	--"EncoderGeneric", 
	"EncoderLinkButton",   
	"EncoderOverlay", 
	--"EncoderResolution", 
	--"endTime", 
	--"enumerate_logfiles", 
	"ExecActionGrid",   
	--"ExecAssign", 
	--"ExecAt", 
	--"ExecAuto", 
	--"ExecBlack", 
	"ExecConfigInput", 
	--"ExecConfiguration", 
	--"ExecCopy", 
	--"ExecDelete", 
	--"ExecEdit", 
	--"ExecExport", 
	--"ExecFix", 
	--"ExecFlash", 
	--"ExecGo", 
	--"ExecGoto", 
	--"ExecLoad", 
	--"ExecLock", 
	--"ExecMove", 
	--"ExecMover", 
	--"ExecOff", 
	--"ExecOn", 
	--"ExecOops", 
	--"ExecResizer", 
	--"ExecSelect", 
	"ExecSelectorEncoder", 
	"ExecSelectorEvent", 
	--"ExecSelectorfader",   
	"ExecSelectorKey", 
	--"ExecSelfix", 
	--"ExecSet", 
	"ExecSizeFrame",   
	--"ExecStore", 
	--"ExecTemp", 
	--"ExecTitleButton",     -- Froze up then Crashed
	--"ExecToggle", 
	"ExecutorBar",   
	"ExecutorBarXKeys", 
	--"Executors", 
	--"ExecutorSection", 
	--"ExecutorSectionXKeys", 
	--"ExecXfade", 
	--"Existing", 
	--"expect_granted_universes", 
	--"FaderDefinition", 
	--"Faders", 
	--"FaderTemp", 
	"FaderTestView", 
	"FanRpmView", 
	--"Feature", 
	--"FeatureGroup", 
	--"FeatureGroups", 
	--"FeatureRadioButtonList",  --Crashed
	--"figure", 
	"FilebrowserView", 
	--"FileContent", 
	--"Filter", 
	--"FilterCopy", 
	--"FilterEdit", 
	"FilterEditor", 
	--"FilterExchange", 
	--"FilterExport", 
	"FilterGrid",   
	--"FilterLabel", 
	--"FilterLock", 
	--"FilterMove", 
	--"FilterOops", 
	--"FilterPoolLayoutGrid",   --Crashed
	--"FilterPoolSettings", 
	--"FilterProg", 
	--"FilterRuleParked", 
	--"FilterRuleProgrammer", 
	--"FilterRules", 
	--"FilterRuleSelection", 
	--"FilterRuleUsedInSelectedSequence", 
	--"FilterSet", 
	--"FilterStore", 
	--"Fixture", 
	--"fixture_count", 
	--"fixture_types", 
	--"FixtureAt", 
	--"FixtureChannelGridColumnConfiguration", 
	--"FixtureClone", 
	--"FixtureCutPaste", 
	--"FixtureDelete", 
	"FixtureEditor", 
	--"FixtureImport", 
	--"FixtureImportShares", 
	--"FixtureInvert", 
	--"FixtureLabel", 
	--"FixtureMultiinstance", 
	--"FixtureMultipatch", 
	--"FixtureOffset", 
	--"FixtureOops", 
	--"FixturePark", 
	--"FixtureSelect", 
	"FixtureSheet", 
	--"FixtureSheetColumnAttributeFilter", 
	--"FixtureSheetRowFilter", 
	--"FixtureSheetSettings", 
	--"Fixturetype", 
	--"FixtureType", 
	--"FixturetypeDelete", 
	--"FixturetypeEdit", 
	--"FixturetypeExchange", 
	"FixtureTypeImport", 
	--"FixturetypeImportExport", 
	"FixturetypeItemList", 
	--"FocusTrap", 
	--"FTDMXMacros", 
	--"FTFilters", 
	--"FTMacros", 
	--"FTPresets", 
	--"FTRDMPersonalityCollect", 
	--"FTVisualMacros", 
	--"FullscreenMode", 
	--"GamutCollect", 
	"GelColorPropertyInput", 
	"GelGrid",   
	--"GelGridSettings", 
	--"GelPool", 
	--"GelPoolLayoutGrid",  --Crashed 
	--"GeneratorBitmapEditor",  --Crashed
	--"GeneratorBitmapPoolLayoutGrid",   --Crashed
	--"GeneratorConfigurations", 
	--"GeneratorRandomPoolLayoutGrid",  --Crashed 
	"GenericAssignmentInput", 
	"GenericAssignmentSelector", 
	"GenericContext", 
	"GenericEditor", 
	"GenericEditorOverlay", 
	"GenericImport", 
	"GenericSettingsEditor", 
	"GenericSheet", 
	--"Geometries", 
	--"Geometry", 
	--"GeometryReference", 
	"Gma3EncoderControl", 
	--"GoboImage", 
	--"GoboImages", 
	--"GoboPoolLayoutGrid",   --Crashed
	"GpuTempView", 
	--"grandMA3Modules", 
	--"GrandMasterfader",   
	"GraphicsEncoderBar",   
	--"GridActivationToggleAuto", 
	--"GridColumn", 
	--"GridColumnConfiguration", 
	--"GridColumnFilter", 
	--"GridColumnFilterCollect", 
	--"GridColumnNamesFilter", 
	--"GridContentFilter", 
	"GridContentFilterEditor", 
	--"GridContentFilterItem", 
	--"GridObjectContentFilter", 
	--"GridObjectContentFilterItem", 
	"GridPatchContentFilterEditor", 
	--"GridRemove", 
	--"GridSettings", 
	--"GridStore", 
	--"GridTools", 
	--"GroupAssign", 
	--"GroupCopy", 
	--"GroupDelete", 
	--"GroupEdit", 
	--"GroupExchange", 
	--"GroupExport", 
	--"GroupFull", 
	--"GroupInsert", 
	--"GroupLabel", 
	--"GroupLock", 
	--"GroupMove", 
	--"groupname", 
	--"GroupOff", 
	--"GroupOops", 
	--"GroupPark", 
	--"GroupPoolLayoutGrid",    --Crashed
	--"GroupPoolSettings", 
	--"GroupSelfix", 
	--"GroupSet", 
	--"GroupStore", 
	--"HandlePoolWindow", 
	--"Hardkey", 
	--"hardkey_execution", 
	"HardkeyButton",   
	--"HardkeyExec", 
	--"HardkeyMacroRedirect", 
	--"Hardkeys", 
	--"HardkeyTestCases", 
	--"HardkeyXKeys", 
	"HardwareButton",   
	--"HardwareConfiguration", 
	--"Hardwarefader",   
	--"HardwareIoConnectors", 
	"HardwareMiniEncoder", 
	--"header", 
	"HelpPopup", 
	--"HelpViewerWindowSettings", 
	--"Highlight", 
	--"iFrame",   
	--"ImageAssign", 
	--"ImageCopy", 
	--"ImageDelete", 
	--"ImageExport", 
	"ImageImport", 
	"ImageInput", 
	--"ImageLabel", 
	--"ImageLock", 
	--"ImageMove", 
	--"ImageOops", 
	--"ImagePoolLayoutGrid",   --Crashed
	"ImagePopup", 
	--"ImageSet", 
	--"ImageStore", 
	--"import_systemtest_macros", 
	--"ImportExport", 
	--"ImportExportDMXProtocolsUI", 
	--"ImportExportFixtureTypeUI", 
	--"ImportExportNetworkKeysUI", 
	--"ImportExportOutputConfigUI", 
	--"ImportExportRemoteInputsUI", 
	--"ImportExportUserProfilesUI", 
	"IndicatorButton",   
	"IndicatorControl", 
	"InfoNotesGridScroller", 
	"InsertFixturesWizard", 
	--"ItemCollectColumns", 
	--"ItemCollectRows", 
	--"ItemLua", 
	--"ItemStr", 
	--"KeyboardKey", 
	--"KeyboardLayout", 
	--"KeyboardShortcut", 
	"KeyboardShortcutEditor", 
	--"KeyboardShortCuts", 
	"KeyboardShortcutsToggleIcon", 
	"KeybSCEdit", 
	"KeybSCInput", 
	--"KeyModifier", 
	--"LabelConversion", 
	--"Layout", 
	--"LayoutAssign", 
	--"LayoutBar",    --Crashed
	--"LayoutCanvas",   --Crashed
	--"LayoutConvert", 
	--"LayoutCopy", 
	--"LayoutCopyElement", 
	--"LayoutDelete", 
	--"LayoutEdit", 
	"LayoutEditor", 
	"LayoutEditorGrid",   
	--"LayoutElementDefaults", 
	"LayoutElementEditorOverlay", 
	--"LayoutExchange", 
	--"LayoutExport", 
	--"LayoutIf", 
	--"LayoutLabel", 
	--"LayoutLock", 
	--"LayoutMove", 
	--"LayoutOops", 
	--"LayoutPoolLayoutGrid",   --Crashed
	--"LayoutSet", 
	--"LayoutStore", 
	--"LayoutView",  --Crashed
	--"LayoutViewSettings", 
	"LearnBeatDisplay", 
	"LearnOverlay", 
	--"LedDefinition", 
	--"LedDefinitions", 
	"LineEdit", 
	"LineEditExt", 
	--"ListBox",   
	--"Listref", 
	--"ListRefTest", 
	--"LogicalChannel", 
	"LogoButton",   --Text field Seems like it's Locked.
	--"Lowlight", 
	--"LUA_EXPORT", 
	--"LuaRequirementHttp", 
	--"LuaRequirements", 
	--"MacroAssign", 
	--"MacroCall", 
	--"MacroCli", 
	--"MacroCopy", 
	--"MacroDelete", 
	--"MacroExchange", 
	--"MacroExecute", 
	--"MacroExport", 
	--"MacroInsert", 
	--"MacroLabel", 
	--"MacroLine", 
	"MacrolineEdit", 
	"MacrolinePreview", 
	"MacrolineTextInput", 
	--"MacroLock", 
	--"MacroMove", 
	--"MacroOops", 
	--"MacroPoolLayoutGrid",   --Crashed
	--"MacroSet", 
	--"MacroStore", 
	--"MacroSyntax", 
	"MainDialog", 
	--"MainDialogContent", 
	"MainDialogDest", 
	"MainDialogFunctionButtons", 
	--"MainDialogMainTabs", 
	--"MainDialogPlaceHolder", 
	--"MainDialogPrimaryMenu", 
	--"MainDialogSecondaryMenu", 
	"MainDialogSubMenu", 
	"MainDialogSubMenuScrollBox",   
	--"MainDialogSubTabs", 
	--"MainDlgBlindButton",   --Crashed
	--"MainDlgButtonBase",  --Crashed 
	--"MainDlgCommandControl",  --Crashed
	"MainDlgCopyButton",   
	"MainDlgCutButton",   
	"MainDlgDelButton",   
	"MainDlgDismissStationButton",   
	"MainDlgDmxModeEditor", 
	"MainDlgEditButton",   
	"MainDlgExportButton",   
	"MainDlgExportEditorButton",   
	"MainDlgFixtureSetup", 
	"MainDlgFixtureTypeEditor", 
	"MainDlgGridSelectDown", 
	"MainDlgGridSelectUp", 
	"MainDlgImportButton",   
	"MainDlgImportEditorButton",   
	"MainDlgInsertButton",   
	"MainDlgInviteStationButton",   
	"MainDlgJoinSessionButton",   
	"MainDlgLeaveSessionButton",   
	"MainDlgMergeToggleButton",   
	"MainDlgNewLineToggleButton",   
	"MainDlgPasteButton",   
	"MainDlgSelectButton",   
	"MainDlgUndoButton",   
	"MainDlgUpdateMenu", 
	--"ManetsocketSet", 
	"MaskValueControl", 
	--"Masters", 
	--"Material", 
	--"MaterialPoolLayoutGrid",   --Crashed
	--"MAtrick", 
	--"Matricks", 
	"MatricksContainer", 
	--"MatricksCopy", 
	--"MatricksDelete", 
	--"MatricksEdit", 
	--"MatricksExchange", 
	--"MatricksExport", 
	--"MatricksExportSpeed", 
	"MatricksIndicatorButton",   
	--"MatricksLabel", 
	--"MatricksLock", 
	--"MatricksOops", 
	--"MatricksPoolLayoutGrid",   --Crashed
	--"MatricksReset", 
	--"MatricksStore", 
	"MatricksToggleButton",   
	--"MatricksTransform", 
	--"MatricksWindowSettings", 
	--"MemoryStatusIcon",   --Crashed
	--"MemTestView", --Crashed
	--"MenuPoolLayoutGrid",   --Crashed
	--"Mesh3DS", 
	--"Mesh3DSMaterial", 
	--"MeshLineEdit",   --Crashed
	--"MeshMaterialGrid",  --Crashed
	--"MeshPoolLayoutGrid",   --Crashed
	"MeshPreview", 
	"MeshSettings", 
	"MessageBox",   
	--"MessageCategory", 
	--"MessageCenter", 
	--"MessageCenterButton",   
	"MessageCenterInfoButton",   
	"MessageCenterNotificationButton",   
	--"MessageCenterWindow", 
	--"MessagePriority", 
	--"metadata",
	--"MetaTable", 
	--"MiscAuto", 
	"ModalPlaceholder", 
	--"Models", 
	"MouseButton",   
	--"MouseDevices", 
	--"moving", 
	--"MultiImport", 
	"MultiLineTextInput", 
	--"MvrImportExport", 
	"Navigator", 
	"NEParamsStatusIcon", 
	--"network_test_send_echoes", 
	"NetworkSpeedTestGrid",   
	"NetworkSpeedTestOverlay", 
	"NetworkTestView", 
	"NormedGrid",   
	"NormedTitleBar",   
	"NoteTextEdit", 
	"NotificationArea", 
	"NotificationsGridScroller", 
	--"NullChild", 
	"NumericInput", 
	"NumInputEdit", 
	--"Object",   
	--"ObjectApiTests", 
	--"ObjectList", 
	"ObjectProperties", 
	"ObjectSelector", 
	"ObjectView", 
	"OffMenuOverlay", 
	--"OffTest", 
	"OopsGrid",   
	"OSCActivityButton",   
	"OSMidiGrid",   
	"OSMidiSelect", 
	"OutputConfigGrid",   
	"Overlay", 
	--"PageCopy", 
	--"PageDelete", 
	--"PageExchange", 
	--"PageExport", 
	--"PageGo", 
	--"PageInsert", 
	--"PageLabel", 
	--"PageLock", 
	--"PageMove", 
	--"PageNext", 
	--"PageOff", 
	--"PageOops", 
	--"PagePoolLayoutGrid",   --Crashed
	--"PageSet", 
	--"PageStore", 
	--"parallel_count", 
	--"Parameters", 
	--"PartialCopy", 
	"PatchFixtureGrid",   
	"PatchToOverlay", 
	--"performance_3d_fixturecount_factor", 
	"PerformanceView", 
	--"Phaser", 
	--"PhaserAuto", 
	--"PhaserBar",   --Crashed
	--"PhaserEditorBar",   --Crashed
	--"PhaserLayoutGrid",   --Crashed
	--"PhaserPathEditor",  --Crashed
	--"PhaserPhaseEditor",  --Crashed
	--"PhaserSheetRowFilter", 
	--"PhaserSpeedEditor",  --Crashed
	--"PhaserStepSheet",  --Crashed
	--"PhaserUICenter",  --Crashed
	--"PhaserWidthEditor",   --Crashed
	--"PhysicalPropertiesData", 
	--"PixelSymbol", 
	"PlaceHolder", 
	"PlaceHolderBase", 
	--"Playback", 
	--"PlaybackAssertTiming", 
	"PlaybackControlContent", 
	"PlaybackControls", 
	"PlaybackHardwareButton",   
	--"PlaybackHardwarefader",   
	--"PlaybackHardwareMiniEncoder",   --Crashed
	--"PlaybackViewExecutorBar",   --Crashed
	--"PlaybackViewWindow",   --Crashed
	--"Playground", 
	--"Plugin", 
	--"PluginAssign", 
	--"PluginCopy", 
	--"PluginDelete", 
	--"PluginExchange", 
	--"PluginExecute", 
	--"PluginExport", 
	--"PluginImport", 
	--"PluginLabel", 
	--"PluginLock", 
	--"PluginMove", 
	--"PluginOops", 
	--"PluginPoolLayoutGrid",    --Crashed
	--"Plugins", 
	--"PluginStore", 
	--"polygon", 
	--"PoolLayoutGrid",   --Crashed
	"PoolOverlay", 
	--"PoolScreen", 
	--"PoolSettings", 
	--"PoolTitleButton",   
	--"PoolWindow",    --Crashed
	"PosCalibrationView", 
	"PositionCalibration", 
	--"Preset", 
	--"PresetAllPoolSettings", 
	--"PresetAt", 
	"PresetBar",   
	--"PresetConvert", 
	--"PresetCook", 
	--"PresetCopy", 
	--"PresetData", 
	--"PresetDelete", 
	--"PresetDynamicPoolSettings", 
	--"PresetEdit", 
	--"PresetExport", 
	--"PresetGo", 
	--"PresetGridpos", 
	--"PresetInsert", 
	--"PresetLock", 
	--"PresetMatricks", 
	--"PresetMove", 
	--"PresetOff", 
	--"PresetOops", 
	--"PresetPoolLayoutGrid",    --Crashed
	--"PresetRecast", 
	--"PresetRecipe", 
	--"PresetSet", 
	--"PresetShareGlobal", 
	--"PresetSheetFilter", 
	--"PresetStore", 
	--"PresetUpdate", 
	--"ProgActivation", 
	--"ProgAtLayersTest", 
	--"ProgCallMultiStepPreset", 
	--"ProgCallSingleStepPreset", 
	--"ProgCook", 
	--"ProgCopyCutPaste", 
	--"ProgEncoder", 
	--"ProgMisc", 
	--"ProgMultiStepTest", 
	--"ProgParts", 
	--"Programmer", 
	--"ProgrammerAuto", 
	"ProgrammerGrid",   
	--"ProgrammerModeDependencies", 
	--"ProgReadout", 
	--"progress", 
	"ProgressBar",   
	--"ProgShared", 
	--"ProgSingleStepTest", 
	--"ProgTime", 
	"ProgUpdateGrid",   
	--"ProgXyz", 
	--"PropertyControl",   --Crashed
	--"PropertyInput",  --Crashed
	--"PropertyLabel",  --Crashed
	--"PropertyRadioButtonList",  --Crashed
	--"PSRImportGrid",   --Crashed
	--"PSRImportMainDialog",  --Crashed
	--"PsrImportPoolWindow",  --Crashed
	--"PSRPatchGrid",   --Crashed
	--"PSRPatchMainDialog",   --Crashed
	--"PsrPoolGrid",   
	"PSRResultShowGrid",   
	--"PSRTabs", 
	"PSRTreeViewFrame",   
	--"QuickeyPool", 
	--"QuickeyPoolLayoutGrid",    --Crashed
	--"radialGradient", 
	"RadioButtonList", 
	--"RadioButtons",  
	--"RadioGroup", 
	--"Random", 
	--"RandomChannel", 
	--"RDMAbsentNotification", 
	--"RDMFixtureType", 
	--"RecipeEditing", 
	--"Recipes", 
	--"RecipeSheetSettings", 
	--"RecipeWindow",   --Crashed
	"RecurringOverlay", 
	"ReferencesContainer", 
	"ReferencesGrid",   
	--"Relation", 
	--"Relations", 
	--"ReleaseChecks", 
	"RemoteInputLock", 
	--"RenderQualities", 
	--"RenderQualitiesCopy", 
	--"RenderQualitiesDelete", 
	--"RenderQualitiesExchange", 
	--"RenderQualitiesExport", 
	--"RenderQualitiesLabel", 
	--"RenderQualitiesLock", 
	--"RenderQualitiesOops", 
	--"RenderQualitiesStore", 
	--"RenderQuality", 
	--"RenderQualityEditor",  --Crashed
	--"RenderQualityPoolLayoutGrid",   --Crashed
	--"repeat_count", 
	--"repeat_timeout", 
	"ResizeCorner", 
	"RevertButton",   
	--"Revision", 
	--"RootExport", 
	--"RootLock", 
	"RotationButton",   
	--"run_ui_tests_on_rpu_size", 
	--"RunningPlaybacksDBObjectGridData", 
	--"RunningPlaybacksPoolLayoutGrid",   --Crashed
	--"RunningPlaybacksWindow",   --Crashed
	--"Saveshow", 
	--"Screen", 
	--"Screencontent", 
	--"ScreencontentDelete", 
	--"ScreencontentLock", 
	--"ScreencontentStore", 
	"ScreenEncoderControl", 
	"ScreenSelectorButton",   
	--"Scribble", 
	--"ScribbleCopy", 
	--"ScribbleDelete", 
	"ScribbleEditContent", 
	"ScribbleEditor", 
	"ScribbleEditView", 
	--"ScribbleExchange", 
	--"ScribbleExport", 
	"ScribbleInput", 
	--"ScribbleLabel", 
	--"ScribbleLock", 
	--"ScribbleOops", 
	--"ScribblePoolLayoutGrid",   --Crashed
	--"ScribbleStore", 
	--"script", 
	"ScrollableItemList", 
	"ScrollBarH",  
	"ScrollBarV",   
	"ScrollBox",   
	"ScrollContainer", 
	"ScrollContainerPage", 
	"ScrollContainerPageScrollItemList", 
	--"SecureTexture", 
	"SelectedGrid",   
	--"Selection", 
	--"SelectionAuto", 
	"SelectionIndicatorButton",   
	"SelectionView", 
	--"SelectionViewSettings", 
	--"SelectionViewWindow",   --Crash & Restart GMA3
	"SensorStatusIcon", 
	"SensorView", 
	--"SeparatorSymbol", 
	--"Sequence", 
	--"SequenceAssert", 
	--"SequenceAssign", 
	--"SequenceAuto", 
	--"SequenceCleanup", 
	--"SequenceCook", 
	--"SequenceCopy", 
	--"SequenceDelete", 
	"SequenceEditBar",   
	--"SequenceExchange", 
	--"SequenceExport", 
	--"SequenceGo", 
	--"SequenceGrid",   --Crashed
	--"SequenceGridPos", 
	--"SequenceInsert", 
	--"SequenceKill", 
	--"SequenceLabel", 
	--"SequenceLock", 
	--"SequenceMib", 
	--"SequenceMove", 
	--"SequenceNote", 
	--"SequenceOff", 
	--"SequenceOn", 
	--"SequenceOops", 
	--"SequencePause", 
	--"SequencePoolSettings", 
	--"SequencePresetRef", 
	--"SequencePrios", 
	--"SequenceSelfix", 
	--"SequenceSet", 
	--"SequenceSettings", 
	--"SequenceSheetColumnFilter", 
	--"SequenceSheetSettings", 
	--"SequenceStore", 
	--"SequenceTracking", 
	--"SequenceTrackingShield", 
	--"SequenceTransitions", 
	--"SequenceWindow",  --Crashed
	--"session_name_prefix", 
	--"SessionGridFilter", 
	--"SetPropertyCollect", 
	--"SetPropertyFromObjects", 
	"Settings3dContext", 
	"SettingsBox",   
	"ShadedOverlay", 
	--"Shader", 
	--"ShaderProgram", 
	--"ShaderProgramCollect", 
	"ShaperEditBar",   
	--"ShaperEditorFader",   
	"ShaperEditorFaderGrid",   
	"ShaperEncoderControl", 
	"ShaperPovFader",   
	"ShaperWindowContent", 
	--"ShaperWindowSettings", 
	"ShowCreatorFTPresetsMainDialog", 
	--"ShowCreatorGridObjectContentFilter", 
	"ShowCreatorMainDialogBase", 
	--"ShowCreatorPoolGrid",   
	--"ShowCreatorSheetSettings", 
	"ShowCreatorSubpoolSelectorList", 
	"ShowHistoryGrid",   
	--"Shuffle", 
	--"SingleDigitInput", 
	--"SingleTokens", 
	--"slave_ip", 
	--"SmartViewPoolLayoutGrid",   --Crashed
	--"SoftwareVersions", 
	"SoundBandView", 
	"SoundBeatView", 
	--"SoundChromaView", 
	--"SoundDelete", 
	--"SoundExchange", 
	--"SoundExport", 
	--"SoundLabel", 
	"SoundLevelView", 
	--"SoundLock", 
	--"SoundOops", 
	--"SoundPoolLayoutGrid",   --Crashed
	--"SoundStore", 
	"SoundWaveView", 
	--"SpecialExec", 
	"SpecialExecAppearanceButton",   
	--"SpecialExecCommands", 
	--"SpecialExecExistence", 
	"SpecialExecSection", 
	--"SpecialExecutor", 
	--"SpecialWindow",  --Crashed
	"SpecialWindowContext", 
	--"SpecialWindowSettings", 
	--"SpeedTiming", 
	"SplitterH", 
	"SplitterV", 
	"SplitView", 
	"StageEditor", 
	"StageViewBar",   
	"StatusArea", 
	"StatusBar",   
	--"StatusCenterButton",   
	--"StatusCenterEntry", 
	"StatusIcon", 
	"StatusScroller", 
	"StepControl", 
	--"StepDelete", 
	--"StepInsert", 
	--"Storage", 
	"StoreCueMessageBox",   
	--"strong", 
	--"Suspense", 
	"SwipeButton",   
	"SwipeButtonList", 
	"SwipeMenuOverlay", 
	--"Symbol", 
	--"SymbolCopy", 
	--"SymbolDelete", 
	--"SymbolExchange", 
	--"SymbolExport", 
	--"SymbolImage", 
	--"SymbolLabel", 
	--"SymbolLock", 
	--"SymbolMove", 
	--"SymbolOops", 
	--"SymbolPoolLayoutGrid",    --Crashed
	--"Symbols", 
	--"SymbolStore", 
	"SyncTestView", 
	--"SysmonWindowSettings", 
	--"SystemMonitorWindow",   --Crashed
	"SysTempView", 
	--"systemtest_view_no3d", 
	--"TabGroup", 
	--"TabItem", 
	--"TableToData", 
	--"TagButtonList",   --Crashed
	--"TagPoolLayoutGrid",   --Crashed
	"TagsEditContent", 
	"TCTimeButton",   
	--"test_stage_index", 
	--"TestAddWindowModalAutoCloseScreen", 
	--"TestAddWindowModalCloseButton",   
	--"TestNetworkGridScroll", 
	--"TestUIBandfader",   
	--"TestUIBitmap", 
	--"TestUIClickOnContextButtonToFocus", 
	--"TestUIClickOnTitleBarToFocus", 
	--"TestUIClickThroughEmptySpace_2730", 
	--"TestUIColorReadout", 
	--"TestUICommandControl", 
	--"TestUICommandHistoryAutoClose", 
	--"TestUICommandHistoryAutoCloseMultiDisplay", 
	--"TestUICommandline", 
	--"TestUICommandWingBar",   
	--"TestUICrashOnFixtureSheetOpen_3410", 
	--"TestUICuePartMovePart0", 
	--"TestUICustomMasterSection", 
	--"TestUIDBObjectGridNewLine", 
	--"TestUIDragfaders", 
	--"TestUIEditIndirect", 
	--"TestUIEncoderBar",   
	--"TestUIEncoderBarChangeLogic", 
	--"TestUIExecAssignVsEdit", 
	--"TestUIExecEditor", 
	--"TestUIExecEditorInitialTabs", 
	--"TestUIExecEditorReusage", 
	--"TestUIExecFix", 
	--"TestUIExecKeys", 
	--"TestUIExecLoad", 
	--"TestUIExecStoreOnClick", 
	--"TestUIfaderBasics", 
	--"TestUIfaderOnOffToggling", 
	--"TestUIFeatureGroupSelectorToggle", 

	--[[
	Got Tired of going through the "Test" items"
	didn't test this batch.

	"TestUIFixtureEditorStoreGeometryPopup", 
	"TestUIFixtureSheetChangeReadout", 
	"TestUIFixtureSheetDefaultPresetLink", 
	"TestUIFixtureSheetEditFixture", 
	"TestUIFixtureSheetEditUpdateCycle", 
	"TestUIFixtureSheetExtendedModeMergeFeatureGroup", 
	"TestUIFixtureSheetFeatureActivation", 
	"TestUIFixtureSheetFixtureSort", 
	"TestUIFixtureSheetNumericInput", 
	"TestUIFixtureSheetProgOnly", 
	"TestUIFixtureSheetSpecialDimmerAbsoluteLogic", 
	"TestUIFixtureSheetViewStoreRestore", 
	"TestUIFixtureTypeEditorConflicts", 
	"TestUIFixtureTypeEditorDmxValues", 
	"TestUIFixtureTypeEditorMergedChildrenEdit", 
	"TestUIFTChannelRTDefaults", 
	"TestUIFTDeleteButton",   
	"TestUIFullscreenMode", 
	"TestUIGridGenericColumnFiltering", 
	"TestUIGridsCumulative", 
	"TestUIHSplitterPanResize", 
	"TestUIImportExportDialog", 
	"TestUILayoutEditor", 
	"TestUILayoutMultiDisplay", 
	"TestUIMacroAddToCmdlineNoExecute", 
	"TestUIMainDialogDisplayIndex", 
	"TestUIMatricksEditor", 
	"TestUIMatricksPanGestureTest", 
	"TestUIMenuBackup", 
	"TestUIMultiPatch", 
	"TestUIMultiplefaderDrag", 
	"TestUINote", 
	"TestUINumericInput", 
	"TestUINumericInput_Iris", 
	"TestUIOopsMenu", 
	"TestUIOpenCloseCommandControls", 
	"TestUIOpenCloseCommandHistory", 
	"TestUIOpenCloseMasterControls", 
	"TestUIOpenCloseMenuSelector", 
	"TestUIOpenCloseMenusInPatchDialog", 
	"TestUIOpenCloseMessageCenterWindow", 
	"TestUIOpenClosePlaybackControls", 
	"TestUIPanGestures", 
	"TestUIPatchCollision", 
	"TestUIPatchCopyCutPaste", 
	"TestUIPatchInsertFixturesWizard", 
	"TestUIPatchInsertFixturesWizardExtended", 
	"TestUIPatchInsertFixturesWizardExtendedCanceled", 
	"TestUIPluginTemplates", 
	"TestUIPoolCopyFromDifferentDatapools", 
	"TestUIPoolGestureClick", 
	"TestUIPoolLayoutGridScrolling", 
	"TestUIPoolLongPressToCreateNew", 
	"TestUIPoolSwipeMenu", 
	"TestUIPresetBar",   
	"TestUIPresetPoolTargetObjectConstancy", 
	"TestUIQuickeyCMDfunction", 
	"TestUIScreenBigAreaScroll", 
	"TestUIScreenFixtureSheet", 
	"TestUIScreenResizeGesture", 
	"TestUIScreenSnap", 
	"TestUIScreenViewStoreOops", 
	"TestUIScreenWindowStoreDelete", 
	"TestUIScribble", 
	"TestUIScrollGestureMouse", 
	"TestUISelectionGrid",   
	"TestUISequenceSheetEncoderBar",   
	"TestUISplitViewBasic", 
	"TestUIStorePopupOnSequence_2618", 
	"TestUIThirdPartyVideo", 
	"TestUITimecode", 
	"TestUITimeFormat", 
	"TestUITitleButtons", 
	"TestUITrackingSheetAutoScroll", 
	"TestUITrackSheetMergedParts", 
	"TestUIUpdateMenu", 
	"TestUIUserInput", 
	"TestUIViewsVsOops", 
	"TestUIViewWidget", 
	"TestUIVSplitterPanResize", 
	"TestUIWindow3D", 
	"TestUIWindow3DSelection", 
	"TestUIWindowAgenda", 
	"TestUIWindowClock", 
	"TestUIWindowContentSheet", 
	"TestUIWindowHelp", 
	"TestUIWindowLayout", 
	"TestUIWindowLayoutBar",   
	"TestUIWindowPhaser", 
	"TestUIWindowTrackpad", 
	]]

	"TexPageDebugView", 
	"TextEdit", 
	"TextInput", 
	--"Texture", 
	--"TextureCollect", 
	--"TextureDebDialog", 
	--"Textures", 
	"TextView", 
	"ThemeMergeDialog", 
	"ThemeMergeToolBar",   
	--"ThirdParty", 
	--"throw_error_on_fail", 
	--"Tickets", 
	--"Timecode", 
	"TimecodeBar",   
	--"TimecodeCopy", 
	--"TimecodeDelete", 
	"TimecodeEditor", 
	--"TimecodeExchange", 
	--"TimecodeExport", 
	"TimecodeGrid",   
	--"TimecodeLabel", 
	--"TimecodeLock", 
	--"TimecodeMove", 
	--"TimecodeMoveSpecial", 
	--"TimecodeOops", 
	--"TimecodePoolLayoutGrid",   --Crashed
	--"TimecodeRecord", 
	--"TimecodeRecStatusIcon",   --Crashed
	--"TimecodeSlotClock",   --Crashed
	--"TimecodeSlotInfo",   --Crashed
	--"TimecodeSlotLayoutGrid",   --Crashed
	"TimecodeSlotPauseButton",   
	"TimecodeSlotPlayButton",   
	"TimecodeSlotStopButton",   
	--"TimecodeStore", 
	--"TimecodeTextGrid",   --Crashed
	--"TimecodeWindow",   --Crashed
	--"Timeconfig", 
	--"TimeKeyAuto", 
	--"TimePoolLayoutGrid",   --Crashed
	--"TimerAccuracy", 
	"TimerClock", 
	--"TimerDelete", 
	"TimerEditor", 
	--"TimerExchange", 
	--"TimerExport", 
	--"TimerGo", 
	--"TimerLabel", 
	--"TimerLock", 
	--"TimerOops", 
	--"TimerPauseButton",   --Crashed
	--"TimerPlayButton",   --Crashed
	--"TimerProperties", 
	"TimerStopButton",   
	--"TimerStore", 
	--"TimeTest", 
	--"Timezone", 
	"TimezoneGrid",   
	"TimezoneInput", 
	--"Timezones", 
	"TitleAutoLayout", 
	"TitleBar",   
	"TitleButton",   
	--"TitleButtonControl", 
	"ToggleButton",   
	--"ToolBar",   
	"TouchConfigurator", 
	--"TouchDevices", 
	"TouchTarget", 
	"TrackpadMouseControl", 
	"TrackpadPanTiltControl", 
	--"TrackSheetGridColumnConfiguration", 
	--"TreeViewRows", 
	--"UIDmxCurveEditor",   -Crashed
	"UIDMXPatch", 
	--"Uifader",    --Not sure why the typo is in the UIXML files.
	"UiFader",  --Works. Added here Manually
	"UIGrid",   
	"UILayoutGrid",   
	"UiMessageCenter", 
	"UIObject",   
	"UiScreen", 
	"UiStationGrid",   
	"UIStatusCenter", 
	--"universal_fixture_offset", 
	--"UniverseLabel", 
	--"UniverseMove", 
	--"UniversePark", 
	--"UniversePoolLayoutGrid",   --Crashed
	--"Unknown", 
	--"unnamed", 
	--"update_timing_table", 
	--"UpdateGridData", 
	--"use_max_fixture_count", 
	--"UserCopy", 
	--"UserDelete", 
	"UserEncoderPageSelector", 
	--"UserExchange", 
	--"UserExport", 
	--"UserImage", 
	--"Userinput", 
	--"UserLabel", 
	--"UserLock", 
	--"UserLogin", 
	--"UserOops", 
	--"UserPlugin", 
	--"UserPoolLayoutGrid",   --Crashed
	--"Userprofile", 
	--"UserprofileCopy", 
	--"UserprofileDelete", 
	--"UserprofileExchange", 
	--"UserprofileExport", 
	--"UserprofileExportGeneric", 
	--"UserprofileLabel", 
	--"UserprofileLock", 
	--"UserprofileOops", 
	--"UserprofileSet", 
	--"UserprofileStore", 
	--"UserSet", 
	--"UserStore", 
	--"Uservariables", 
	"ValueControl", 
	"ValueFadeControl", 
	"ValueRadioControl", 
	--"values", 
	--"VideoPoolLayoutGrid",   --Crashed
	--"View3D",  --Crashed
	--"View3DSettings", 
	--"ViewAssign", 
	"ViewBar",   
	--"ViewButton",   
	--"ViewButton",   
	--"ViewButtonDelete", 
	--"ViewButtonEdit", 
	--"ViewButtonExport", 
	--"ViewButtonLock", 
	--"ViewButtonOops", 
	--"ViewButtonPage", 
	--"ViewButtonPages", 
	--"ViewButtonStore", 
	--"ViewCopy", 
	--"ViewDelete", 
	--"ViewExchange", 
	--"ViewExport", 
	"ViewInput", 
	--"ViewLabel", 
	--"ViewLock", 
	--"ViewMove", 
	--"ViewOops", 
	--"ViewPoolLayoutGrid",   --Crashed
	--"ViewSet", 
	--"ViewStore", 
	--"ViewWidget", 
	--"VirtualKey", 
	"VirtualKeyboard", 
	"VirtualKeyboardButton",   
	--"VKValue", 
	--"VpuDialog", 
	"WarningInfoButton",   
	"WebView", 
	--"Wheels", 
	--"Window",   --Crashed & Restarted GMA3
	--"WindowAgenda",   --Crashed
	--"WindowAppearance", 
	--"WindowDiligentTest1", 
	--"WindowDiligentTest2", 
	--"WindowEncoderBar",   --Crashed & Restarted GMA3
	--"WindowFixturetypeVisualizer",   --Crashed
	--"WindowHelpViewer",   --Crashed
	--"WindowInfo",   --Crashed & Restarted GMA3
	"WindowMeshStatistics", 
	--"WindowPhaserEditorSettings", 
	--"Windows", 
	--"WindowScrollPositions", 
	--"WindowTextureStatistics",   --Crashed
	--"WindowTrackpad",   --Crashed
	--"WindowTrackpadSettings", 
	--"WindowType", 
	"WindowTypeGrid",   
	--"WingLocalDisplay", 
	--"WorldAssign", 
	--"WorldConversion", 
	--"WorldCopy", 
	--"WorldCreation", 
	--"WorldDelete", 
	--"WorldExchange", 
	--"WorldExport", 
	--"WorldInsert", 
	--"WorldLabel", 
	--"WorldLock", 
	--"WorldMove", 
	--"WorldOff", 
	--"WorldOops", 
	--"WorldPoolLayoutGrid",   --Crashed
	--"WorldSet", 
	--"WorldStore", 
	--"XKeyAuto", 
	--"XKeysHardwareButton",    --Crashed
	--"XKeysHardwareMiniEncoder",   --Crashed
	--"XKeysViewExecutorBar",   --Crashed
	--"XKeysViewWindow",   --Crashed
	--"XlrModeButton",   --Crashed
	"XlrPortInput", 
	--"XYZCheck", 
	--"XYZMArker", 
	"ZoomFactorPopup"
	}










	
	local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
		baseLayer.Name = 'Basic'
    	baseLayer.H = '70%'  --760
    	baseLayer.W = '70%'  --800
    	baseLayer.Columns = 1
    	baseLayer.Rows = 3
    	baseLayer[1][1].SizePolicy = 'Fixed'
    	baseLayer[1][1].Size = 100
    	baseLayer[1][2].SizePolicy = 'Stretch'
    	baseLayer[1][3].SizePolicy = 'Fixed'
    	baseLayer[1][3].Size = 100
    	baseLayer.AutoClose = 'No'
    	baseLayer.CloseOnEscape = 'Yes'

	local titleBar = baseLayer:Append('TitleBar')
    	titleBar.Columns = 2  
    	titleBar.Rows = 1
    	titleBar.Anchors = '0,0'
    	titleBar[2][2].SizePolicy = 'Fixed'
    	titleBar[2][2].Size = 50
    	titleBar.Texture = 'corner2'
    	titleBar.Transparent = "No"

	local titleBarIcon = titleBar:Append('TitleButton')
		titleBarIcon.Font = 'Regular24'
    	titleBarIcon.Text = 'Generic GMA3 Window'
    	titleBarIcon.Texture = 'corner1'
    	titleBarIcon.Anchors = '0,0'
    	titleBarIcon.Icon = 'star'

  	local titleBarCloseButton = titleBar:Append('CloseButton')
    	titleBarCloseButton.Anchors = '1,0'
    	titleBarCloseButton.Texture = 'corner2'


	--[[I believe I have Ahuramazda on the GrandMA Forums to thank 
		for the below ScrollBox Portions of this.  
		Thanks to "From Dark To Light" for the rest.
	]]
	local dialog = baseLayer:Append("DialogFrame")
    	dialog.H, dialog.W, dialog.Columns = '98%', '100%', 2
    	dialog[2][2].SizePolicy = "Content"
    	dialog.Anchors = '0,1'
		--Custom UI Color from above Code.
		dialog.BackColor = 33.33

	local theAbused = {}

	Printf(#possibleCandidates .. " Verified Candidates.")




	--Change startPoint value between 1 and 332 to run.
	local startPoint = 0

	--there's about 332 in the list not commented out. 
	local endPoint = #possibleCandidates
		
		for i=startPoint, endPoint do 
			if startPoint ~= 0 then 
				--Printf(i..": " .. possibleCandidates[i])
				--theAbused[i] = dialog:Append('UiFader')
				theAbused[i] = dialog:Append(tostring(possibleCandidates[i]))
  					theAbused[i].Text = 'Poor Sod.'
			else
				Printf(tostring(possibleCandidates[i]))
			end
		end
		



	local buttonGrid = baseLayer:Append('UILayoutGrid')
		buttonGrid.Columns = 2
    	buttonGrid.Rows = 1
    	buttonGrid.H = 80
    	buttonGrid.Anchors = '0,2' 

  	local applyButton = buttonGrid:Append('Button')
    	applyButton.Anchors = '0,0'
    	applyButton.Textshadow = 1
    	applyButton.HasHover = 'Yes'
    	applyButton.Text = 'Apply'
    	applyButton.Font = 'Regular28'
    	applyButton.TextalignmentH = 'Centre'
    	applyButton.PluginComponent = myHandle
    	applyButton.Clicked = 'ApplyButtonClicked'

	local cancelButton = buttonGrid:Append('Button')
    	cancelButton.Anchors = '1,0'
    	cancelButton.Textshadow = 1
    	cancelButton.HasHover = 'Yes'
    	cancelButton.Text = 'Cancel'
    	cancelButton.Font = 'Regular28'
    	cancelButton.TextalignmentH = 'Centre'
    	cancelButton.PluginComponent = myHandle
    	cancelButton.Clicked = 'CancelButtonClicked'
		

	

	signalTable.CancelButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		checkBoxState = {"Cancelled"}
		continue = true
	end


	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end
    
	repeat 

	until continue



end


alfredPlease.theBADIdea = theBADIdea




local function main()
		
	alfredPlease.theBADIdea()
    

end
return main