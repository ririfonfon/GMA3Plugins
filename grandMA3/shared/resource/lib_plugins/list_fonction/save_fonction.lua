--[[
save_fonction v1.0.0.2
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "save_fonction"

Releases:
* 1.0.0.1 - Inital release
* 1.0.0.2 - GMA3 V 1.7.2.2

Created by Richard Fontaine "RIRI", May 2020.
--]] --
local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

local E = Echo

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
        -- data[i] = (string.format("%s", k))
        table.insert(data, (string.format("%s", k)))
        table.insert(data, (string.format("\n")))
    end

    -- grab a list of connected drives
    for i = 1, drives.count, 1 do
        table.insert(options, string.format("%s (%s)", drives[i].name,
                                            drives[i].DriveType))
    end

    -- present a popup for the user choose (Internal may not work)
    PopTableDisk = {
        title = "Select a disk",
        caller = display_handle,
        items = options,
        selectedValue = "",
        add_args = {FilterSupport="Yes"},
        }
    selectedDrive = PopupInput(PopTableDisk)

    -- if the user cancled then exit the plugin
    if selectedDrive == nil then return end

    -- grab the export path for the selected drive and append the file name

    E("selectedDrive = %s",tostring(selectedDrive))
    E("drives[selectedDrive + 1].path = %s",tostring(drives[selectedDrive + 1].path))
    E("sep = %s",tostring(sep))
    E("filename = %s",tostring(filename))
    
    local exportPath = GetPathOverrideFor("export", drives[selectedDrive + 1].path) .. sep .. filename

    -- export the JSON the the selected path
    PopTableFormat = {
        title = "Select a disk",
        caller = display_handle,
        items = formats,
        selectedValue = "",
        add_args = {FilterSupport="Yes"},
        }
    ask = PopupInput(PopTableFormat)
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
