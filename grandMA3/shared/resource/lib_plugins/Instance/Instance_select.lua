--[[
Instance Select v1.0.0.4
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage:
* Select some fixtures
* Call Plugin "Instance Select"
* Your selection is now just Instance number.

Releases:
* 1.0.0.1 - Inital release
* 1.0.0.2 - bugs
* 1.0.0.3 - add backColor & icon
* 1.0.0.4 - gma3 1.8.1.0

Created by Richard Fontaine "RIRI", April 2020.
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

local F = string.format
local E = Echo

-- local functions forward declaration
local CalculateSFID, clamp

-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************

local function Main(display_handle, argument)

    -- select all sub fixture 

    Cmd("Down")
    Cmd("Down")
    Cmd("Down")

    local instance
    local sfIdx = SelectionFirst()

    if argument == nil then
        E('Call Plugin Instance selection')

        -- Gather information using MessageBox()

        local messageBoxQuestions = {"Instance"}
        local wfInt = "0123456789"
        local messageBoxOptions = {
            title = "Instance Select",
            backColor = "1.7",
            timeout = nil,
            timeoutResultCancel = false,
            timeoutResultID = nil,
            titleTextColor = nil,
            messageTextColor = nil,
            message = "Please enter the number of Instance",
            display = nil,
            commands = {
                {value = 1, name = "Done"}, {value = 0, name = "Cancel"}
            },
            inputs = {
                {
                    name = messageBoxQuestions[1],
                    value = "",
                    maxTextLength = 4,
                    vkPlugin = "TextInputNumOnly",
                    whiteFilter = wfInt
                }
            }
        }
        local messageBoxResult = MessageBox(messageBoxOptions)

        -- get inputs
        instance = clamp(math.floor(tonumber(
                                        messageBoxResult["inputs"][messageBoxQuestions[1]]) or
                                        0), 0, 360)
        if instance == 0 then return end
        -- have to filter out the numbers because non text inputs dont respect the black/white Filters.
        local v = "[^0123456789.]"

    end

    local selcetionString = ""
    local tt = 0

    while (sfIdx ~= nil) do
        local result, take = Checkinstance(sfIdx, instance)
        if take == true and tt == 0 then
            selcetionString = selcetionString .. result
            tt = 1
        elseif take == true and tt == 1 then
            selcetionString = selcetionString .. " + Fixture "
            selcetionString = selcetionString .. result
        end

        sfIdx = SelectionNext(sfIdx, true);
    end

    Cmd("Clear")
    Cmd("Fixture " .. selcetionString)

end

-- ****************************************************************
-- plugin exit cleanup entry point 
-- ****************************************************************

local function Cleanup() end

-- ****************************************************************
-- plugin execute entry point 
-- ****************************************************************

local function Execute(Type, ...)
    local func = signalTable[Type]
    if (func) then
        func(signalTable, ...)
    else
        local debug_text = string.format("Execute %s not supported", Type)
        E(debug_text)
    end
end

function signalTable:Key(Status, Source, Profile, Token)
    local debug_text = F("Execute Key (%s) %s UserProfile %d : %s", Status,
                         Source, Profile, Token)
    E(debug_text)
end

function signalTable:Fader(Status, Source, Profile, Token, Value)
    local debug_text = F("Execute Fader (%s) %s UserProfile %d : %s %f", Status,
                         Source, Profile, Token, Value)
    E(debug_text)
end

-- ****************************************************************
-- Local Functions
-- ****************************************************************

-- clamp
function clamp(input, min, max)
    local i = input
    if i < min then i = min end
    if i > max then i = max end
    return i
end

-- Sub Fixtures (not child fixtures), don't contain an FID. returns the aparent Sub fixture ID based on the root fixture

function Checkinstance(fixture, instance)
    local take
    local i = 0
    local inst = {}
    local result = GetSubfixture(fixture).FID
    if (result ~= nil) then return result, take end

    result = ""
    local parent

    while (GetSubfixture(fixture):GetClass() == "SubFixture") do
        i = i + 1
        parent = GetSubfixture(fixture):Parent();
        result = "." .. fixture - parent.SubfixtureIndex .. result
        inst[i] = fixture - parent.SubfixtureIndex
        fixture = parent.SubfixtureIndex
    end

    result = GetSubfixture(fixture).FID .. result

    if inst[1] == instance then
        take = true
    else
        take = false
    end

    return result, take
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main, Cleanup, Execute
