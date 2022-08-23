local pluginName    = select(1,...);
local componentName = select(2,...);
local signalTable   = select(3,...);
local display_handlex     = select(4,...);

local GetStages, GetFixtures, OutputPatch, dump

-- ****************************************************************
-- plugin main entry point
-- ****************************************************************
local function Main(display_handle,argument)

    local patch = ""
    patch = GetStages(patch)
    --GetFixtures(patch)
    --Echo(Patch().Stages[2].Fixtures[1].name)
    OutputPatch(patch, display_handle)
end

function GetStages(patch)
    local stages = Patch().Stages
    patch = "FID,CID,IDType,NAME,Fixture Type,Mode,Layer,Class,Patch,Break 1,Break 2,Break 3,Break 4,Break 5,Break 6,Break 7,Break 8,\n"

    for iStages, vStages in ipairs(stages) do
        if iStages ~= 1 then
            patch = patch .. vStages.name .. "\n"

            -- grab fixtures
            patch = GetFixtures(patch, vStages.Fixtures)
        end
    end
    return patch
end

function GetFixtures(patch, fixtures)
    for iFixtures, vFixtures in ipairs(fixtures) do
        patch = patch .. vFixtures.FID .. ","
        patch = patch .. vFixtures.CID .. ","
        patch = patch .. vFixtures.IDType .. ","
        patch = patch .. vFixtures.Name .. ","
        patch = patch .. vFixtures.FixtureType ..","
        patch = patch .. vFixtures.Mode .. ","
        if vFixtures.Layer then
            patch = patch .. (vFixtures.Layer.Name or "") .. ","
        else
            patch = patch .. ","
        end
        if vFixtures.Class then
            patch = patch .. (vFixtures.Class.Name or "") .. ","
        else
            patch = patch .. ","
        end
        patch = patch .. vFixtures.Patch .. ","
        if (vFixtures.Break1 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break1 .. ","
        end
        if (vFixtures.Break2 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break2 .. ","
        end
        if (vFixtures.Break3 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break3 .. ","
        end
        if (vFixtures.Break4 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break4 .. ","
        end
        if (vFixtures.Break5 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break5 .. ","
        end
        if (vFixtures.Break6 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break6 .. ","
        end
        if (vFixtures.Break7 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break7 .. ","
        end
        if (vFixtures.Break8 == -1) then
            patch = patch .. ","
        else
            patch = patch .. vFixtures.Break8 .. ","
        end
        patch = patch .. "\n"
    end
    return patch
end

function OutputPatch(patch, display_handle)

    local drives = Root().Temp.DriveCollect
    local options = {}
    local sep = GetPathSeparator()

    -- grab a list of connected drives
    for i = 1, drives.count , 1 do
        table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
    end

    local StorageDev = Root().UsbNotifier.StorageDevice:Children()
    local StorageDevList = {}
    local StorageCount = 0;
    for key,value in pairs(StorageDev) do
        table.insert(StorageDevList,value.Name)
        StorageCount = StorageCount + 1
    end
    if StorageCount == 0 then
        Confirm("Get Sys Info", "Please attatch Usb storage and try again.\nScript is aborting.")
        return
    end
    local ret = PopupInput("Select Storage", display_handle, StorageDevList);

    local outputFile = GetPathOverrideFor(GetPathType(Patch()), drives[2].path) .. sep .."PatchExport.csv"

    for index, value in ipairs(drives) do
        Echo(value.path)
    end

    -- Echo(outputFile)
    local file = io.open(outputFile,"w+")
    if file == nil then
        Printf()
        return
    end
    file:write(patch)
    file:close()
    SyncFS()
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

return Main