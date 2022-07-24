local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

local F = string.format;
local E = Echo;

local drives = Root().Temp.DriveCollect
local sep = GetPathSeparator()
local selectedDrive -- users selected drive
local options = {} -- popup options

local function myFunction(display_handle)

    -- grab a list of connected drives
    for i = 1, drives.count, 1 do
        table.insert(options, string.format("%s (%s)", drives[i].name,
                                            drives[i].DriveType))
    end

    -- present a popup for the user choose (Internal may not work)
    selectedDrive = PopupInput("Select a disk")
    -- selectedDrive = PopupInput("Select a disk", display_handle, options)

    -- if the user cancled then exit the plugin
    if selectedDrive == nil then return end

    local exportPath = GetPathOverrideFor("export",
                                          drives[selectedDrive + 1].path) .. sep ..
                           "export.JSON"

    local importPath = GetPathOverrideFor("backups",
                                          drives[selectedDrive + 1].path)

    E(exportPath)
    E(importPath)
    E(drives[selectedDrive + 1].path)

    local dir = DirList(importPath)
    E(dir)
    
end

return myFunction
