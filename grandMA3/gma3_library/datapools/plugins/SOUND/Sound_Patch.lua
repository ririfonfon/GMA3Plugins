--[[
Releases:
* 2.3.2.0

Version :
* 0.0.0.93

Created by Richard Fontaine "RIRI", April 2026.
--]]

function SOUND_Patch(Univers, Address, Fid, prefix)
    Cmd('ChangeDestination Root')
    Cmd('ChangeDestination 14.10')

    local gma2_library = GetPath(Enums.PathType.GrandMA2Library) .. GetPathSeparator()
    local gma3_library = GetPath(Enums.PathType.GrandMA3Library) .. GetPathSeparator()
    local fixture_types = Patch().fixturetypes
    fixture_types:Acquire():Import(gma3_library, 'generic@grouping.xml')
    fixture_types:Acquire():Import(gma2_library, 'generic@dimmer.pxml')

    Cmd('ChangeDestination 7.1.2')

    if prefix == "B" then
        Fid = Fid + 11
        Address = Address + 11
    end

    local my_add_fixture_table = {}
    my_add_fixture_table.mode = Patch().FixtureTypes.Grouping.DMXModes.Default
    my_add_fixture_table.amount = 1
    my_add_fixture_table.fid = ''
    my_add_fixture_table.idtype = 'Fixture'
    my_add_fixture_table.name = prefix .. 'Sound'
    local success = AddFixtures(my_add_fixture_table)
    if success ~= nil then
        Echo('Fixture ' .. my_add_fixture_table.fid .. ' is added')
    else
        Sound_Dialog_End('AddFixture failed!')
        ErrEcho('AddFixture failed!')
    end
    local patched_grouping_fixture = Patch().stages[1][2][my_add_fixture_table.name]
    local Sound_Type = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6',
        'Band7' }

    Fid = Fid - 1
    for i = 1, 11 do
        my_add_fixture_table = {}
        my_add_fixture_table.mode = Patch().FixtureTypes.Dimmer.DMXModes['Mode 0']
        my_add_fixture_table.amount = 1
        my_add_fixture_table.fid = Fid + i
        my_add_fixture_table.idtype = 'Fixture'
        my_add_fixture_table.name = prefix .. 'Sound ' .. Sound_Type[i]
        my_add_fixture_table.patch = { "" .. Univers .. ".0" .. Address - 1 + i .. "" }
        ------------------------------------------------------
        my_add_fixture_table.parent = patched_grouping_fixture
        ------------------------------------------------------
        success = AddFixtures(my_add_fixture_table)
        if success ~= nil then
            Echo('Fixture ' .. my_add_fixture_table.fid ..
                ' is added with patch address ' .. my_add_fixture_table.patch[1])
        else
            Sound_Dialog_End('AddFixture failed!')
            ErrEcho('AddFixture failed!')
        end
    end

    Cmd('ChangeDestination Root')
end

function SOUND_Patch_Cross(Univers, Address, Fid, Construct_Pool)
    Sound_Dialog_End('Sound By Riri Build Cross_AB Mode .')

    local GroupObject = Root().ShowData.DataPools[Construct_Pool].Groups
    Cmd('ChangeDestination Root')
    Cmd('ChangeDestination 14.10')

    local gma2_library = GetPath(Enums.PathType.GrandMA2Library) .. GetPathSeparator()
    local gma3_library = GetPath(Enums.PathType.GrandMA3Library) .. GetPathSeparator()
    local fixture_types = Patch().fixturetypes
    fixture_types:Acquire():Import(gma3_library, 'generic@grouping.xml')
    fixture_types:Acquire():Import(gma2_library, 'generic@dimmer.pxml')

    Cmd('ChangeDestination 7.1.2')

    Fid = Fid + 22
    Address = Address + 22

    local good = false

    local my_add_fixture_table = {}
    my_add_fixture_table.mode = Patch().FixtureTypes.Grouping.DMXModes.Default
    my_add_fixture_table.amount = 1
    my_add_fixture_table.fid = ''
    my_add_fixture_table.idtype = 'Fixture'
    my_add_fixture_table.name = 'Sound Cross A_B'
    local success = AddFixtures(my_add_fixture_table)
    if success ~= nil then
        Echo('Fixture ' .. my_add_fixture_table.fid .. ' is added')
    else
        Sound_Dialog_End('AddFixture failed!')
        ErrEcho('AddFixture failed!')
    end
    local patched_grouping_fixture = Patch().stages[1][2][my_add_fixture_table.name]
    local Sound_Type = { 'A', 'B' }
    Fid = Fid - 1
    for i = 1, 2 do
        my_add_fixture_table = {}
        my_add_fixture_table.mode = Patch().FixtureTypes.Dimmer.DMXModes['Mode 0']
        my_add_fixture_table.amount = 1
        my_add_fixture_table.fid = Fid + i
        my_add_fixture_table.idtype = 'Fixture'
        my_add_fixture_table.name = 'Cross_' .. Sound_Type[i]
        my_add_fixture_table.patch = { "" .. Univers .. ".0" .. Address - 1 + i .. "" }
        ------------------------------------------------------
        my_add_fixture_table.parent = patched_grouping_fixture
        ------------------------------------------------------
        success = AddFixtures(my_add_fixture_table)
        if success ~= nil then
            Echo('Fixture ' .. my_add_fixture_table.fid ..
                ' is added with patch address ' .. my_add_fixture_table.patch[1])
            good = true
        else
            Sound_Dialog_End('AddFixture failed!')
            ErrEcho('AddFixture failed!')
            good = false
        end
    end
    Cmd('ChangeDestination Root')
    if good == true then
        for a = 1, 2 do
            local nri = GroupObject:Acquire()
            GroupObject:Create(nri.No)
            Cmd("AutoCreate Fixture " ..
                Fid + a .. " At DataPool " .. Construct_Pool .. " Group " .. nri.No .. " /All /NoConfirmation ")
            GroupObject[nri.No]:Set('Name', 'Cross_' .. Sound_Type[a])
        end
    end
end
