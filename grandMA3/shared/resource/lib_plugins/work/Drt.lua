

local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor


-- ****************************************************************
-- Drt.printClass(userdata) : nil
-- ****************************************************************
function Drt.printClass(input, level)
    level = math.abs(math.floor(level or 0))
    assert(input ~= nil, "input must not be nil")
    assert(level == nil or type(level) == "number", "level must be number or nil")

    if type(input) ~= "userdata" then
        if type(input) == "table" then
            Echo(Drt.table2String(input))
        elseif type(input) == "string" then
            Echo(input)
        elseif type(input) == "number" then
            Echo(input)
        else
            Echo ("Not UserData: " .. type(input))
        end
        return
    end

    local indent = ""
    if level > 0 then
        for i = 1, level, 1 do
            indent = indent .. "  "
        end
    end

    local class = input:GetClass()
    Echo(indent .. "Class: " .. class)
    Echo(indent .. "Parent: " .. (input:Parent():GetClass())) --TODO: This fails if no parent
    local childCount = #input:Children()
    Echo(indent .. "ChildCount: " .. childCount)
    if childCount > 0 then
        for i = 1, childCount, 1 do
            Echo(indent .. "  " .. i .. " " .. input:Children()[i]:GetClass())
        end
    end
    local properties = {}

    --Exec
    if class == "Exec" then
        properties = {
            "Lock",
            "No",
            "Index",
            "Name",
            "Key",
            "Fader",
            "Encoder",
            "EncoderLeft",
            "EncoderRight",
            "KeyCmd",
            "EncoderClickCMD",
            "EncoderRightCMD",
            "EncoderLeftCMD",
            "MAKey",
            "MAFader",
            "MAEncoder",
            "MAEncoderLeft",
            "MAEncoderRight",
            "MAKeyCmd",
            "MAEncoderClickCMD",
            "MAEncoderRightCMD",
            "MAEncoderLeftCMD",
            "PrimanyAssignmentChanged",
            "SecondaryAssignmentChanged",
            "Width",
            "Height",
            "Object",
            "Config",
            "TotalPrimanyAssignmentChanged",
            "TotalSecondaryAssignmentChanged",
        }
    end

    --Page
    if class == "Page" then
        properties = {
            "Lock",
            "No",
            "Index",
            "Name",
            "Scribble",
            "Appearance"
        }
    end
    -- Attribute
    if class == "Attribute" then
        properties = {
            "Name",
            "Pretty",
            "MainAttribute",
            "ActivationGroup",
            "Feature",
            "Special",
            "PhysicalUnit",
            "GeometryType",
            "Color",
            "Intensity",
            "LogChannels",
            "ChannelFunctions"
        }
    -- Patch
    elseif class == "Patch" then
        properties = {
        "Name",
        "Lock"
    }
    -- AttributeDefinitions
    elseif class == "AttributeDefinitions" then
    properties = {
        "Name",
        "Lock",
    }
    -- Feature
    elseif class == "Feature" then
        properties = {
            "Name",
            "Pretty",
            "AttribCount",
            "LogChannels",
        }
    -- ActivationGroup
    elseif class == "ActivationGroup" then
        properties = {
            "Name",
            "AttribCount"
        }
    elseif class == "Attributes" then
        properties = {
            "Name",
            "AttribCount"
        }
    elseif class == "FeatureGroup" then
        properties = {
            "Name",
            "Pretty",
            "PresetMode",
            "AttribCount",
            "LogChannels",
        }
    elseif class == "UserProfile" then
        properties = {
            "Name",
            "Lock",
            "DMXReadout",
            "NormalValue",
            "ValueReadout",
            "SpeedReadout",
            "PresetReadout",
            "WheelResolution",
            "WheelMode",
            "PerciseEdit",
            "SingleStep",
            "Sync",
            "Preview",
            "ScreenEncoder",
            "TimeKeyTarget",
            "ProgPart",
            "TCSlot",
            "OverlayFade",
        }
    else
        Echo("<Class Not Configured>")
    end

    for key, value in pairs(properties) do
        local i = input[value]
        if type(i) == "boolean" then
            if i == true then
                i = "true"
            else
                i = "false"
            end
        end
        Echo("%s%s: %s (%s)", indent, value, tostring(i or "<NIL>"), type(input[value]))
        if type(i) == "userdata" then
            Drt.printClass(i, level + 1)
        end
    end
end