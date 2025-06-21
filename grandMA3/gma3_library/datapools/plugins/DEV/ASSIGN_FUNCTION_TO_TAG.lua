return function()
    local Select = UserVars()
    local tag = GetVar(Select, "Tag")
    local fonction = GetVar(Select, "Function")

    for exec_no = 101, 490 do 
        local exec= GetExecutor(exec_no) 
        if exec ~= nil and exec.Object ~= nil then 
         local object_tag = exec.Object.Tags 
         Printf(exec .. object_tag) 
            if object_tag ~= nil and object_tag == '' .. tag ..':0' then 
                Cmd('Assign ' .. fonction .. ' Executor ' .. exec )
            end
        end
    end
    DelVar(Select, "Tag")
    DelVar(Select, "Function")
end
-- end tag.lua