--[[
Export_Screen_Shots v1.0.0.4
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage:
* Call Plugin "Export_Screen_Shots"
* Will any screen shots (with the name *display*.png) to selected USB sticks
  in the selcted folder

Issues:
* The console currently enumerates all disk connected to the console including 
  pervious versions (?) This may cause some skipped files even with the USB key
  dot not include the selected file
* The copied files are not checked for consistancy, this could be done but did
  not seem nessassary
* If a file exists on a key with the exact name the fill will be skipped and noted
  in the System Monitor
* if the key does not have the grandMA3 folder structure the copy will fail and all
  files will be skipped. Store a show to the stick first.

Releases:
*1.0.0.1 - Inital release
*1.0.0.2 - Fixed a path 
*1.0.0.3 - Buggs
*1.0.0.4 - Add Drive & select folder

--]] --
local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F = string.format;
local E = Echo;

-- Local Functions
local split, copyFileToUSB
local selectedDrive -- users selected drive
local drives = Root().Temp.DriveCollect
local select
local foptions = {"lib_images", "export"} -- popup options

-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************

local function Main(display_handle, argument)

    
    local sep = GetPathSeparator()
    local options = {} -- popup options

    for i = 1, drives.count, 1 do
        table.insert(options, string.format("%s (%s)", drives[i].name,
                                            drives[i].DriveType))
    end

    -- present a popup for the user choose (Internal may not work)
    selectedDrive = PopupInput("Select a disk", display_handle, options)

    -- if the user cancled then exit the plugin
    if selectedDrive == nil then return end

    select = PopupInput("select a Folder", display_handle, foptions)

    -- local bib_images = GetPathOverrideFor("lib_images", "") .. sep
    local lib_images = GetPathOverrideFor(foptions[select + 1], "") .. sep

    local source_images = GetPathOverrideFor("lib_images", "") .. sep -- MaLightingTechnology\gma3_1.0.0\shared\resource\lib_images\

    local destination_path = ""
    local files = {}
    E("source_images Path: " .. (source_images or "<NONE>"))

    local pfile
    if (sep == "\\") then
        pfile = io.popen('dir /B "' .. source_images .. '"*display*.png')
        for filename in pfile:lines() do
            files[filename] = source_images .. filename
        end
    else
        pfile = io.popen('ls "' .. source_images .. '"*display*.png')
        for filename in pfile:lines() do
            local file = split(filename, "/")

            files[file[#file]] = filename -- file listing includes full path, just use the first last part
        end
    end

    -- files to copy

    -- get someone else to do it.
    local result = copyFileToUSB(files, false)
end

-- ****************************************************************
-- Local Functions
-- ****************************************************************

-- split
function split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function copyFileToUSB(sourceFiles, overwrite)
    local sep = package.config:sub(1, 1) -- windows or linux paths
    local usbFound = false
    local copyCount = 0
    local skipCount = 0

    for k, v in pairs(sourceFiles) do
        local srcFileHandle = assert(io.open(v, "rb"))
        local fileContent = srcFileHandle:read("*all")

        local path = drives[selectedDrive + 1].path

        local exportFilePath = GetPathOverrideFor(foptions[select + 1], path) ..
                                   sep
        local importFilePath = GetPathOverrideFor("lib_images", path) .. sep
        local file = io.open(exportFilePath .. k, "r")
        if overwrite == false and file ~= nil then
            E("Skipping Existing: %s", exportFilePath)
            skipCount = skipCount + 1
            io.close(file)
            goto continue
        end

        local file, err = io.open(exportFilePath .. k, "wb")
        if file then
            assert(file:write(fileContent))
            io.close(file)
            copyCount = copyCount + 1
            E("Wrote: %s -> %s", k, exportFilePath .. k)
            -- files are kind of large, lets sync once at the end.
            -- SyncFS();
            usbFound = true
        else
            E("Error opening file %s : %s", k, tostring(err))
        end
        ::continue::
    end

    if copyCount == 0 and skipCount == 0 then
        Printf("Copy Screenshots: Nothing to copy.")
    elseif copyCount > 0 then
        SyncFS()
        Printf(
            "Copy Screenshots: Copied %d, Skipped %d Details in System Monitor",
            copyCount, skipCount)
    elseif copyCount == 0 and skipCount == 1 then
        Printf("Copy Screenshots: Nothing to copy, all %d file(s) skipped",
               skipCount)
    else
        Printf("Copy Screenshots: Nothing to copy, %d file skipped", skipCount)
    end
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main
