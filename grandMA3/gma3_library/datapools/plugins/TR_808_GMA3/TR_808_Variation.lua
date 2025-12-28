--[[
    Releases:
    * 0.0.0.1

    Created by Richard Fontaine "RIRI", december 2025.

--]]
local Printf, Echo, GetExecutor, CmdIndirectWait, ipairs, mfloor = Printf, Echo, GetExecutor, CmdIndirectWait, ipairs,
    math.floor


local function main()
    local Select = UserVars()
    local TR_Pool, TR_Save, TR_Load
    Printf("*******************************************************TR_Variation called************************************************")
    if GetVar(Select, "TR_Save") then
        TR_Save = tonumber((GetVar(Select, "TR_Save")))
        Printf("TR_Save : %i", TR_Save)
    end
    if GetVar(Select, "TR_Load") then
        TR_Load = tonumber((GetVar(Select, "TR_Load")))
        Printf("TR_Load : %i", TR_Load)
    end
    if GetVar(Select, "TR_Pool") then
        TR_Pool = GetVar(Select, "TR_Pool")
        Printf("TR_Pool: %i", TR_Pool)
    end

    
    CmdIndirectWait('ChangeDestination DataPool  ' .. TR_Pool)

    if (TR_Save == 1) then      -- Save to A
    Printf("*******************************************************SAVE A************************************************")
        CmdIndirectWait('Copy Sequence 381 at 401 /Overwrite')
        CmdIndirectWait('Copy Sequence 382 at 402 /Overwrite')
        CmdIndirectWait('Copy Sequence 383 at 403 /Overwrite')
        CmdIndirectWait('Copy Sequence 384 at 404 /Overwrite')
        CmdIndirectWait('Copy Sequence 385 at 405 /Overwrite')
        CmdIndirectWait('Copy Sequence 386 at 406 /Overwrite')
        CmdIndirectWait('Copy Sequence 387 at 407 /Overwrite')
        CmdIndirectWait('Copy Sequence 388 at 408 /Overwrite')
        CmdIndirectWait('Copy Sequence 389 at 409 /Overwrite')
        CmdIndirectWait('Copy Sequence 390 at 410 /Overwrite')
        CmdIndirectWait('Copy Sequence 391 at 411 /Overwrite')
        CmdIndirectWait('Copy Sequence 392 at 412 /Overwrite')
        CmdIndirectWait('Set Sequence 401 Thru 412 Property "Name" "VARIA_A_SUB#1"')
    Printf("*******************************************************SAVE A************************************************")
    elseif (TR_Save == 2) then  -- Save to B
        Printf("*******************************************************SAVE B************************************************")
        CmdIndirectWait('Copy Sequence 381 at 421 /Overwrite')
        CmdIndirectWait('Copy Sequence 382 at 422 /Overwrite')
        CmdIndirectWait('Copy Sequence 383 at 423 /Overwrite')
        CmdIndirectWait('Copy Sequence 384 at 424 /Overwrite')
        CmdIndirectWait('Copy Sequence 385 at 425 /Overwrite')
        CmdIndirectWait('Copy Sequence 386 at 426 /Overwrite')
        CmdIndirectWait('Copy Sequence 387 at 427 /Overwrite')
        CmdIndirectWait('Copy Sequence 388 at 428 /Overwrite')
        CmdIndirectWait('Copy Sequence 389 at 429 /Overwrite')
        CmdIndirectWait('Copy Sequence 390 at 430 /Overwrite')
        CmdIndirectWait('Copy Sequence 391 at 431 /Overwrite')
        CmdIndirectWait('Copy Sequence 392 at 432 /Overwrite')
        CmdIndirectWait('Set Sequence 421 Thru 432 Property "Name" "VARIA_B_SUB#1"')
    Printf("*******************************************************SAVE B************************************************")
    elseif (TR_Save == 3) then  -- Save to C
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_C"')
    elseif (TR_Save == 4) then  -- Save to D
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_D"')
    elseif (TR_Save == 5) then  -- Save to E
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_E"')
    elseif (TR_Save == 6) then  -- Save to F
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_F"')
    elseif (TR_Save == 7) then  -- Save to G
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_G"')
    elseif (TR_Save == 8) then  -- Save to H
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Save To Varia_H"')
    end
    if (TR_Load == 1) then  -- Load from A
        Printf("*******************************************************LOAD A************************************************")
        CmdIndirectWait('Copy Sequence 401 at 381 /Overwrite')
        CmdIndirectWait('Copy Sequence 402 at 382 /Overwrite')
        CmdIndirectWait('Copy Sequence 403 at 383 /Overwrite')
        CmdIndirectWait('Copy Sequence 404 at 384 /Overwrite')
        CmdIndirectWait('Copy Sequence 405 at 385 /Overwrite')
        CmdIndirectWait('Copy Sequence 406 at 386 /Overwrite')
        CmdIndirectWait('Copy Sequence 407 at 387 /Overwrite')
        CmdIndirectWait('Copy Sequence 408 at 388 /Overwrite')
        CmdIndirectWait('Copy Sequence 409 at 389 /Overwrite')
        CmdIndirectWait('Copy Sequence 410 at 390 /Overwrite')
        CmdIndirectWait('Copy Sequence 411 at 390 /Overwrite')
        CmdIndirectWait('Copy Sequence 412 at 392 /Overwrite')
    Printf("*******************************************************LOAD A************************************************")
    elseif (TR_Load == 2) then -- Load from B
    Printf("*******************************************************LOAD B************************************************")
        CmdIndirectWait('Copy Sequence 421 at 381 /Overwrite')
        CmdIndirectWait('Copy Sequence 422 at 382 /Overwrite')
        CmdIndirectWait('Copy Sequence 423 at 383 /Overwrite')
        CmdIndirectWait('Copy Sequence 424 at 384 /Overwrite')
        CmdIndirectWait('Copy Sequence 425 at 385 /Overwrite')
        CmdIndirectWait('Copy Sequence 426 at 386 /Overwrite')
        CmdIndirectWait('Copy Sequence 427 at 387 /Overwrite')
        CmdIndirectWait('Copy Sequence 428 at 388 /Overwrite')
        CmdIndirectWait('Copy Sequence 429 at 389 /Overwrite')
        CmdIndirectWait('Copy Sequence 430 at 390 /Overwrite')
        CmdIndirectWait('Copy Sequence 431 at 390 /Overwrite')
        CmdIndirectWait('Copy Sequence 432 at 392 /Overwrite')
    Printf("*******************************************************LOAD B************************************************")
    elseif (TR_Load == 3) then -- Load from C
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_C"')
    elseif (TR_Load == 4) then -- Load from D
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_D"')
    elseif (TR_Load == 5) then -- Load from E
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_E"')
    elseif (TR_Load == 6) then -- Load from F
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_F"')
    elseif (TR_Load == 7) then -- Load from G
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_G"')
    elseif (TR_Load == 8) then -- Load from H
        CmdIndirectWait('Go+ DataPool ' .. TR_Pool .. ' Macro "Load From Varia_H"')
    end



    DelVar(Select, "TR_Pool")
    DelVar(Select, "TR_Save")
    DelVar(Select, "TR_Load")

    CmdIndirectWait('Set Sequence 381 Thru 392 Property "Name" "SUB_#1"')
    CmdIndirectWait('ChangeDestination Root')

end


return main
