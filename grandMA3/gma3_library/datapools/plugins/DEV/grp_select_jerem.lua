local my_table, my_handle = select(3, ...)
local ChooseFixtureGroup, fixtureGroup, target, aim, Cible, Objectif

function ChooseFixtureGroup(obj)
    local children = DataPool().Groups:Children()
    if children and #children > 0 then
        local popupItems = {}
        local popupNumber = {}
        local count = 1
        for _, groupObject in ipairs(children) do
            popupItems[#popupItems + 1] = {
                'handle',
                groupObject.No .. '    ' .. groupObject.Name,
                groupObject
            }
            -- popupNumber[count] = { groupObject.No}
            table.insert(popupNumber, count, groupObject.No)
            count = count + 1
        end

        local groupPopup = {
            title  = 'a Fixture Group for ' .. obj,
            caller = GetFocusDisplay(),
            items  = popupItems,
        }

        local selectionIndex, _ = PopupInput(groupPopup)
        -- Echo('index ' .. selectionIndex)
        local grpnumb = popupNumber[selectionIndex]
        -- Echo('grpnumb ' .. grpnumb)
        if grpnumb then
            fixtureGroup = DataPool().Groups[grpnumb]
            if fixtureGroup ~= nil then
                -- Echo('Selected Group: ' .. fixtureGroup.Name)
                -- Echo('Selected Group: ' .. fixtureGroup.No)
                -- SetVar(UserVars(), obj, fixtureGroup.no)
                return fixtureGroup.No
            else
                ErrEcho('WRONG NAME OR NUMBER')
                return nil
            end
        end
    else
        ErrEcho("No groups available.")
    end
end

local function main()
    Select = UserVars()
    if GetVar(UserVars(), "Target") and GetVar(UserVars(), "Aim") then
        target = GetVar(UserVars(), "Target")
        Echo('Target - > ' .. target)
        aim = GetVar(UserVars(), "Aim")
        Echo('Aim - > ' .. aim)
    else
        ErrEcho('not Target or Aim defined')
        return
    end
    Cible = ChooseFixtureGroup(target)
    if Cible ~= nil then
        Echo(target .. ' -> ' .. Cible)
        Echo(Cible)
    end
    Objectif = ChooseFixtureGroup(aim)
    if Objectif ~= nil then
        Echo(aim .. ' -> ' .. Objectif)
    end
    SetVar(UserVars(), target, tonumber(Cible))
    SetVar(UserVars(), aim, tonumber(Objectif))
end
return main
