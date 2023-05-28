--	attributeTimings
--	v1.2.1  (MA3 1.9) - 2023-04-15
--	Written by Jeff Farrow @ penlight.ca
--
--  Used to set attribute fade and delay times for the current cue
--  Creates a popup with fields for fade & delay with a swipe to select the attribute
--
--  Thanks to all the users on the LUA Plugins at forum.malighting.com
--  Your tips and insight have been invaluable
--
--	Released under the 'Improve and return' license
--	Please improve and return to me: jeff@penlight.ca
--	Kindly keep some credit in the files if shared
--	Suggestions for improvements also welcome, or just tell me when you use it


local function attributeTimings()
    local attList = {}
    for k, value in ipairs(DataPool().PresetPools:Children()) do
        attList[value.name] = value.no
    end

    local options = {
        icon = "time",
        backColor = "Global.PartlySelected",
        title = "Attribute Cue Timings",
        message = "Set Attribute Fade / Delay Times for the current cue",
        commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
        inputs = { { name = "Fade Time", value = "", whiteFilter = ".0123456789" }, { name = "Delay Time", value = "", whiteFilter = ".0123456789" } },
        selectors = { { name = "Att", selectedValue = 1, values = attList, type=0 } }
    }

    local r = MessageBox(options)

    if r.success then
        if r.result == 0 then
            Echo('User pressed Cancel')
        end
        if r.result == 1 then
            Echo('User pressed OK')
            if (r.inputs["Fade Time"] ~= "") then -- test for blank entry
                Cmd('Set Cue Property "preset%sfade" %s', tostring(r.selectors["Att"]), tostring(r.inputs["Fade Time"]))
            end
            if (r.inputs["Delay Time"] ~= "") then -- test for blank entry
                Cmd('Set Cue Property "preset%sdelay" %s', tostring(r.selectors["Att"]), tostring(r.inputs["Delay Time"]))
            end
        end
    else
        Echo('User escaped the dialog')
    end
end

return attributeTimings
