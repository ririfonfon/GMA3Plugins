function SOUND_Patch(Univers, Address)
    Cmd('ChangeDestination Root')
    Cmd('ChangeDestination 14.10')

    local gma2_library = GetPath(Enums.PathType.GrandMA2Library) .. GetPathSeparator()
    local gma3_library = GetPath(Enums.PathType.GrandMA3Library) .. GetPathSeparator()
    local fixture_types = Patch().fixturetypes
    fixture_types:Acquire():Import(gma3_library, 'generic@grouping.xml')
    fixture_types:Acquire():Import(gma2_library, 'generic@dimmer.pxml')

    Cmd('ChangeDestination 7.1.2')

    local my_add_fixture_table = {}
    my_add_fixture_table.mode = Patch().FixtureTypes.Grouping.DMXModes.Default
    my_add_fixture_table.amount = 1
    my_add_fixture_table.fid = ''
    my_add_fixture_table.idtype = 'Fixture'
    my_add_fixture_table.name = 'Sound'
    local success = AddFixtures(my_add_fixture_table)
    if success ~= nil then
        Printf('Fixture ' .. my_add_fixture_table.fid .. ' is added')
    else
        Printf('AddFixture failed!')
    end
    local patched_grouping_fixture = Patch().stages[1][2][my_add_fixture_table.name]
    local Sound_Type = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6',
        'Band7' }


    for i = 1, 11 do
        my_add_fixture_table = {}
        my_add_fixture_table.mode = Patch().FixtureTypes.Dimmer.DMXModes['Mode 0']
        my_add_fixture_table.amount = 1
        my_add_fixture_table.fid = 900 + i
        my_add_fixture_table.idtype = 'Fixture'
        my_add_fixture_table.name = 'Sound ' .. Sound_Type[i]
        my_add_fixture_table.patch = { "" .. Univers .. ".0" .. Address - 1 + i .. "" }
        ------------------------------------------------------
        my_add_fixture_table.parent = patched_grouping_fixture
        ------------------------------------------------------
        success = AddFixtures(my_add_fixture_table)
        if success ~= nil then
            Printf('Fixture ' .. my_add_fixture_table.fid ..
                ' is added with patch address ' .. my_add_fixture_table.patch[1])
        else
            Printf('AddFixture failed!')
        end
    end


    Cmd('ChangeDestination Root')
end

function Check_DMX(myDMXUniverse, myDMXAddress, myCount, myBreakIndex)
    -- Set the DMX universe - range 1-1024.
    -- local myDMXUniverse = 1
    -- Set the DMX address in the universe - range 1-512.
    -- local myDMXAddress = 1
    -- Set the optional count for the number of fixtures (break_index channel amount) to check.
    -- local myCount = 1
    -- Set the optional break_index number for fixtures with multiple breaks.
    -- Default value is 0 to indicate the first break.
    -- local myBreakIndex = 0

    -- Creates the string used for the DMX address.
    local startOfRange = string.format("%d.%03d", myDMXUniverse, myDMXAddress)

    -- Check if there is a selection and exit if there isn't.
    if SelectionFirst() == nil then
        Printf("Please make a selection and try again.")
        return
    end
    -- This gets the handle for the first fixture a patched generic Dimmers 8-bit mode.
    local myDmxMode = GetSubfixture(SelectionFirst()).ModeDirect

    if myDmxMode == nil then
        -- Exit the function if the DMX mode returns nil.
    else
        -- Do the actual collision check and provide useful feedback.
        if CheckDMXCollision(myDmxMode, startOfRange, myCount, myBreakIndex) then
            Printf("The DMX address " .. startOfRange .. " is available.")
            return true
        else
            ErrEcho("The DMX address " .. startOfRange .. " cannot be used as a start address for this patch.")
            return false
        end
    end
end

 function SOUND_Check_ID(myFID,myCount)
    -- Create a variable with the FID you want to check.
    -- local myFID = 2001
    -- Create a variable with the number of subsequent ID's to also check.
    -- local myCount = 10
    -- Create a variable with the IDType you want to check.
    -- Default value is 0. This is the "Fixture" type.
    -- Valid integers are:
    --- 0 = Fixture
    --- 1 = Channel
    --- 2 = Universal
    --- 3 = Houseligths (default name)
    --- 4 = NonDim (default name)
    --- 5 = Media (default name)
    --- 6 = Fog (default name)
    --- 7 = Effect (default name)
    --- 8 = Pyro (default name)
    --- 9 = MArker
    --- 10 = Multipatch
    local myType = 0

    -- Check if the count is more than one.
    if myCount > 1 then
        -- Check if there is a collision and print valid feedback.
        if CheckFIDCollision(myFID, myCount, myType) then
            Printf("The FID " .. myFID .. " to " .. (myFID + myCount) .. " is available.")
            return true
        else
            ErrEcho("The FID " .. myFID .. " to " .. (myFID + myCount) .. " gives an FID collision.")
            return false
        end
    else
        if CheckFIDCollision(myFID, nil, myType) then
            Printf("The FID " .. myFID .. " is available.")
            return true
        else
            ErrEcho("The FID " .. myFID .. " gives an FID collision.")
            return false
        end
    end
end

local function main()
    local Univers = 210
    local Address = 41
    local ID = 225
    local Check_Id = SOUND_Check_ID(ID,11)
    -- Cmd('Fixture Thru')
    -- local Check = Check_DMX(Univers, Address, 1, 0)
    -- Cmd('Clear')
    -- if Check == true then
    --     SOUND_Patch(Univers, Address)
    -- elseif Check == false then
    --     ErrEcho('Univers & Address NOT FREE')
    -- end
end
return main
