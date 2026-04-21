--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

function SOUND_Patch(Univers, Address, Fid)
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
        my_add_fixture_table.name = 'Sound ' .. Sound_Type[i]
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
