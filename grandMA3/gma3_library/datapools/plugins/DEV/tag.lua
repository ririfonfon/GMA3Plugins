return function()
    for exec_no = 101, 490 do 
        local exec= GetExecutor(exec_no) 
        if exec ~= nil and exec.Object ~= nil then 
         local tag = exec.Object.Tags 
         Printf(exec .. tag) 
            if tag ~= nil and tag == "SWAP_FLASH:0" then 
                Cmd('Assign Swap Executor ' .. exec )
            end
        end
    end
end
-- end tag.lua