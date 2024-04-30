-------------------------------------------------------------------------------------
--  MIT License
--
--  Copyright (c) 2023 MA Lighting International GmbH
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
-------------------------------------------------------------------------------------
--  Usage:
--      Directly from Commandline:
--          Assuming variables SRCFixtures, DSTFixtures & OrientationType exist,
--          Lua 'Clone3D( "Source", "Destination", "MyOrientation" )'
--
--  Purpose:
--      The purpose of this plugin is to copy and paste the 3D position and
--      rotation information from source fixtures to destination fixtures.
--
--  Functionality:
--      The plugin uses variables to take the userinput
--
--  Assumption:
--      When running the plugin from the commandline, it assumes that the variables
--      SRCFixtures, DSTFixtures & OrientationType already exit.
-------------------------------------------------------------------------------------
function Clone3D(SRCFixtures, DSTFixtures, OrientationType)
    local UserInputSRC            = GetVar(UserVars(), SRCFixtures)
    local UserInputDST            = GetVar(UserVars(), DSTFixtures)
    local UserInputORI            = GetVar(UserVars(), OrientationType)

    local StartSRCFixture         = 0
    local LastSRCFixture          = 0
    local SingleSRCFixture        = 0
    local TotalSRCFixtures        = 0
    local StartSRCFixtureMinusOne = 0
    if string.find(UserInputSRC, " ") then
        StartSRCFixture         = tonumber(string.match(UserInputSRC, "(.-)%s"))
        LastSRCFixture          = tonumber(string.match(UserInputSRC, "%s[T|tH|hR|rU|u].*%s(.*)"))
        TotalSRCFixtures        = (LastSRCFixture - StartSRCFixture) + 1
        StartSRCFixtureMinusOne = StartSRCFixture - 1
    else
        SingleSRCFixture = tonumber(UserInputSRC)
        TotalSRCFixtures = 1
        StartSRCFixtureMinusOne = SingleSRCFixture - 1
    end

    local StartDSTFixture         = 0
    local LastDSTFixture          = 0
    local SingleDSTFixture        = 0
    local TotalDSTFixtures        = 0
    local StartDSTFixtureMinusOne = 0
    if string.find(UserInputDST, " ") then
        StartDSTFixture         = tonumber(string.match(UserInputDST, "(.-)%s"))
        LastDSTFixture          = tonumber(string.match(UserInputDST, "%s[T|tH|hR|rU|u].*%s(.*)"))
        TotalDSTFixtures        = (LastDSTFixture - StartDSTFixture) + 1
        StartDSTFixtureMinusOne = StartDSTFixture - 1
    else
        SingleDSTFixture        = tonumber(UserInputDST)
        TotalDSTFixtures        = 1
        StartDSTFixtureMinusOne = SingleDSTFixture - 1
    end

    if TotalDSTFixtures ~= TotalSRCFixtures then
        Confirm("Range Mismatch", "The amound of Source Fixtures and Destination Fixtures are not the same")
    else
        if UserInputORI == "3D" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosX"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosY"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosZ"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotX"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotY"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotZ"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "Pos" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosX"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosY"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosZ"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "PosX" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosX"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "PosY" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosY"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "PosZ" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("PosZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("PosZ"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "Rot" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotX"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotY"))
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotZ"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "RotX" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotX",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotX"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "RotY" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotY",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotY"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        elseif UserInputORI == "RotZ" then
            for i = 1, TotalDSTFixtures do
                ObjectList("Fixture " .. StartDSTFixtureMinusOne + i)[1]:Set("RotZ",
                    ObjectList("Fixture " .. StartSRCFixtureMinusOne + 1)[1]:Get("RotZ"))
                StartSRCFixtureMinusOne = StartSRCFixtureMinusOne + 1
            end
        end
    end
end

local function main()
    local OrientationOptions = {
        ["3D"] = 1
        ,
        ["Pos"] = 2
        ,
        ["PosX"] = 3
        ,
        ["PosY"] = 4
        ,
        ["PosZ"] = 5
        ,
        ["Rot"] = 6
        ,
        ["RotX"] = 7
        ,
        ["RotY"] = 8
        ,
        ["RotZ"] = 9
    }

    -- MessageBoxUI Message
    local Clone3DUIMessage = [[
Note:

    * The amount of Source & Destination Fixtures should be same.

    * Under Orientation,
            "3D"  would copy-paste both Position & Rotation information.
            "Pos" would copy-paste only Position information.
            "Rot" would copy-paste only Rotation information.
    ]]
    -- Getting Information from MessageBoxUI
    local Clone3DUI = MessageBox({
        title = "Clone3D"
        ,
        message = Clone3DUIMessage
        ,
        message_align_h = Enums.AlignmentH.Left
        ,
        message_align_v = Enums.AlignmentV.Top
        ,
        commands = {
            { value = 1, name = "Clone3D Orientation" }
            , { value = 0, name = "Cancel" }
        }
        ,
        inputs = {
            { value = "", name = "1. Source Fixtures", whiteFilter = "0123456789 TtHhRrUu", vkPlugin = "TextInputNumOnlyRange" }
            , { value = "", name = "2. Destination Fixtures", whiteFilter = "0123456789 TtHhRrUu", vkPlugin = "TextInputNumOnlyRange" }
        }
        ,
        selectors = {
            { name = "Orientation", selectedValue = 1, type = 1, values = OrientationOptions }
        }
    })

    -- Pass MessageBoxUI Inputs as Variables to Clone3D()
    if Clone3DUI["success"] == true then
        if Clone3DUI["result"] == 1 then
            SetVar(UserVars(), "SRCFixtures", Clone3DUI["inputs"]["1. Source Fixtures"])
            SetVar(UserVars(), "DSTFixtures", Clone3DUI["inputs"]["2. Destination Fixtures"])
            local SRCFixturesFromMain = GetVar(UserVars(), "SRCFixtures")
            local DSTFixturesFromMain = GetVar(UserVars(), "DSTFixtures")
            local OrientationFromMain = 0
            if Clone3DUI["selectors"]["Orientation"] == 1 then
                OrientationFromMain = "3D"
            elseif Clone3DUI["selectors"]["Orientation"] == 2 then
                OrientationFromMain = "Pos"
            elseif Clone3DUI["selectors"]["Orientation"] == 3 then
                OrientationFromMain = "PosX"
            elseif Clone3DUI["selectors"]["Orientation"] == 4 then
                OrientationFromMain = "PosY"
            elseif Clone3DUI["selectors"]["Orientation"] == 5 then
                OrientationFromMain = "PosZ"
            elseif Clone3DUI["selectors"]["Orientation"] == 6 then
                OrientationFromMain = "Rot"
            elseif Clone3DUI["selectors"]["Orientation"] == 7 then
                OrientationFromMain = "RotX"
            elseif Clone3DUI["selectors"]["Orientation"] == 8 then
                OrientationFromMain = "RotY"
            elseif Clone3DUI["selectors"]["Orientation"] == 9 then
                OrientationFromMain = "RotZ"
            end
            SetVar(UserVars(), "OrientationType", OrientationFromMain)
            Clone3D("SRCFixtures", "DSTFixtures", "OrientationType")
        end
    end
end

return main
