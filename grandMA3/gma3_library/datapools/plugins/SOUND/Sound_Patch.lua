return function()
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
        my_add_fixture_table.patch = { "210.0" .. 40 + i .. "" }
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
