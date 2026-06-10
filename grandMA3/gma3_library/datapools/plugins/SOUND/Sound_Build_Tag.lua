--[[
Releases:
* 2.3.2.0

Version :
* 0.0.0.93

Created by Richard Fontaine "RIRI", April 2026.
--]]

function Sound_Build_Tag()
    local TagObject = Root().ShowData.Tags
    local TagObject_C = Root().ShowData.Tags:Children()
    local SOUND_TAGS_CHECKS = {}
    local SOUND_TAGS = { 'S_solo', 'S_all', }
    local Tag_Type = { 'None', 'None',  }
    for i = 1, #SOUND_TAGS, 1 do
        SOUND_TAGS_CHECKS[i] = false
    end

    for v in pairs(SOUND_TAGS) do
        for k in pairs(TagObject_C) do
            if SOUND_TAGS[v] == TagObject_C[k].Name then
                SOUND_TAGS_CHECKS[v] = true
                break
            end
        end
    end
    for k in pairs(SOUND_TAGS_CHECKS) do
        if SOUND_TAGS_CHECKS[k] == false then
            local nr = TagObject:Acquire()
            TagObject[nr.No]:Set('Name', SOUND_TAGS[k])
            TagObject[nr.No]:Set('TAGTYPE', Tag_Type[k])
        end
    end
end