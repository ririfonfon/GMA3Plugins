--[[ Busking Layouts Creator v 0.9.1
Created by Yury Belousov ]]

local YB_GMA3_CP_GEN = select(3,...)

function YB_GMA3_CP_GEN.create_name_prefix(type,DP)
    local object_classes = {'group','preset *.','sequence','layout','appearance','matrick','macro','tag'}
    local general_prefix
    if type == 'color' then
        general_prefix = 'CP'
    elseif type == 'position' then
        general_prefix = 'PP'
    end
    local prefix_index = 1
    local prefix
    local detected = false
    repeat
        prefix = general_prefix..tostring(prefix_index)..'_'
        for _,class in ipairs(object_classes) do
            local objects = ObjectList(string.format('datapool * %s "%s*"',class,prefix))
            if #objects > 0 then
                detected = true
                prefix_index = prefix_index + 1
                break
            else
                detected = false
            end
        end
    until not detected
    return prefix
end