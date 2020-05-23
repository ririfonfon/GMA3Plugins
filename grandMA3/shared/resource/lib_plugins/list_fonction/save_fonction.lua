--[[
save_fonction v1.0.0.1
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "save_fonction"

Releases:
* 1.0.0.1 - Inital release

Created by Richard Fontaine "RIRI", May 2020.
--]] --
local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

local filename = "ExportFile.JSON"
local drives = Root().Temp.DriveCollect
local sep = GetPathSeparator()
local selectedDrive -- users selected drive
local options = {} -- popup options
local formats = {"Json", "CSV"}

local function myFunction(display_handle)

    -- data to store
    local i = 0
    local data = {}

    for k, v in pairs(_G) do
        i = i + 1
        Printf(string.format("%s\n", k))
        data[i] = (string.format("%s\n", k))
    end

    -- grab a list of connected drives
    for i = 1, drives.count, 1 do
        table.insert(options, string.format("%s (%s)", drives[i].name,
                                            drives[i].DriveType))
    end

    -- present a popup for the user choose (Internal may not work)
    selectedDrive = PopupInput("Select a disk", display_handle, options)

    -- if the user cancled then exit the plugin
    if selectedDrive == nil then return end

    -- grab the export path for the selected drive and append the file name
    local exportPath = GetPathOverrideFor("export",
                                          drives[selectedDrive + 1].path) .. sep ..
                           filename

    -- export the JSON the the selected path
    ask = PopupInput("Select format", display_handle, formats)
    if formats == 1 then
        local result = ExportJson(exportPath, data) -- as of 1.1.3.2 always returns nil
    else
        local result = ExportCSV(exportPath, data) -- as of 1.1.3.2 always returns nil
    end

    -- sync the files to disk when done and before your user unplugs the device
    SyncFS()

    -- written in the negitive since it seems to always return nil in 1.1.3.2
    if result == false then
        Echo("Failed to write to " .. exportPath)
    else
        Echo("Wrote file to " .. exportPath)
    end

end

return myFunction
