--[[
Releases:
* 0.0.0.3
use :
1 MacroLine 1 SetUserVariable "Tag" "xxxx"
2 MacroLine 2 SetUserVariable "Function" "xxxx"
3 MacroLine 3 Plugin "ASSIGN_FUNCTION_TO_TAG"


Created by Richard Fontaine "RIRI", june 2025.
--]]
return function()
    local Select = UserVars()
    local tag = GetVar(Select, "Tag")
    local fonction = GetVar(Select, "Function")

    for exec_no = 101, 490 do
        local exec = GetExecutor(exec_no)
        if exec ~= nil and exec.Object ~= nil then
            local object_tag = exec.Object.Tags
            if object_tag ~= nil and object_tag == '' .. tag .. ':0' then
                exec.Key = fonction
            end
        end
    end
    DelVar(Select, "Tag")
    DelVar(Select, "Function")
end
-- end tag.lua
