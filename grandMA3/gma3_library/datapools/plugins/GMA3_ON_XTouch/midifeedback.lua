--[[
______________EXEC MIDIFEEDBACK V1.2____________ rethink unnecesary calculation for midi message
_______________________BETA_____________________

Gives feedback for executor state with midivalue
0 = Empty executor
1 = Executor Off
2 = Executor On

Fill Chosenexec with the executors you want to monitor as such
[executor number]=0, [next executor number]=0
and so forth
Make sure not to delete the } at the end

Disclosure!: I Am Not A GOOD Lua Programmer! PLEASE DO improve on this! if you do PLEASE DO let me know!
Best regards. 
Kristoffer Friis Knudsen
]]




function main()
    -- executor table -- insert your chosen executors here
    local chosenexec = {
                  [401]=0, [402]=0, [403]=0, [404]=0, [405]=0, [406]=0, [407]=0, [408]=0,
                  
                  [416]=0, [417]=0, [418]=0, [419]=0, [420]=0, [421]=0, [422]=0, [423]=0,
                  [316]=0, [317]=0, [318]=0, [319]=0, [320]=0, [321]=0, [322]=0, [323]=0,
                  [216]=0, [217]=0, [218]=0, [219]=0, [220]=0, [221]=0, [222]=0, [223]=0,
                  [116]=0, [117]=0, [118]=0, [119]=0, [120]=0, [121]=0, [122]=0, [123]=0,
                  
                  [431]=0, [432]=0, [433]=0, [434]=0, [435]=0, [436]=0, [437]=0, [438]=0,
                  [331]=0, [332]=0, [333]=0, [334]=0, [335]=0, [336]=0, [337]=0, [338]=0,
                  [231]=0, [232]=0, [233]=0, [234]=0, [235]=0, [236]=0, [237]=0, [238]=0,
                  
                  [446]=0, [447]=0, [448]=0, [449]=0, [450]=0, [451]=0, [452]=0, [453]=0,
                  [346]=0, [347]=0, [348]=0, [349]=0, [350]=0, [351]=0, [352]=0, [353]=0,
                  [246]=0, [247]=0, [248]=0, [249]=0, [250]=0, [251]=0, [252]=0, [253]=0,

                  [461]=0, [462]=0, [463]=0, [464]=0, [465]=0, [466]=0, [467]=0, [468]=0,
                  [361]=0, [362]=0, [363]=0, [364]=0, [365]=0, [366]=0, [367]=0, [368]=0,
                  
                }
    
    local mapcheck = {} -- sets up table for future checks

    local midimsg = {} -- sets up table for a one time calculation
    
    local delay = .5 -- set sleep time
    
    function getseqhandle(chosenexec) -- sets chosens executors seqencehandle 
        local execinfo = GetExecutor(chosenexec) --sets variable "execinfo" to chosen executors objectid
    
        if execinfo ~= nil and execinfo.object ~= nil then
            execseq = ObjectList(tostring(execinfo))[1].object.no -- sets variable to executors assigned sequence number
            seqhandle = DataPool().Sequences[execseq] -- sets variable to executors sequence handle
        else seqhandle = nil

        end
        return seqhandle
    end

    function setmidimsg(chosenexec)
        for k in pairs(chosenexec) do -- iterates through table
        local midichannel = setmidichannel(k) 
        local midinote = setmidinote(k) 
        midimsg[k] = midichannel .. '/' .. midinote
    end
    end

        

    
    
    function setmidichannel(chosenexec) -- sets which midichannel chosen exec belongs to acording to executor groups
        -- sets midichannel
        if chosenexec >= 101 and chosenexec <= 199 then
            midichannel = 1
        elseif chosenexec >= 201 and chosenexec <= 299 then
            midichannel = 2
        elseif chosenexec >= 301 and chosenexec <= 399 then
            midichannel = 3
        elseif chosenexec >= 401 and chosenexec <= 499 then
            midichannel = 4
    
        end
        return midichannel
    end
    
    function setmidinote(chosenexec) -- sets which midichannel chosen exec belongs to acording to executor groups
        -- sets midichannel
        if chosenexec >= 101 and chosenexec <= 199 then
            midinote = chosenexec - 100
        elseif chosenexec >= 201 and chosenexec <= 299 then
            midinote = chosenexec - 200
        elseif chosenexec >= 301 and chosenexec <= 399 then
            midinote = chosenexec - 300
        elseif chosenexec >= 401 and chosenexec <= 499 then
            midinote = chosenexec - 400

        end
        return midinote
    end

    function setmidivalue(seqhandle) -- sets which midivalue should output acording to active playback or non existing sequence
        -- sets midivalue
        if seqhandle == nil then
            midivalue = 0
        elseif seqhandle:HasActivePlayback() then
        midivalue = 2
        else midivalue = 1
        end
        return midivalue
    end

    function midioutput(k) -- Checks if change in state has happened and spits out midi if so
    -- sends midi from ma3
    seqhandle = getseqhandle(k)
    chosenexec[k] = setmidivalue(seqhandle)
    if mapcheck[k] ~= chosenexec[k] then
        mapcheck[k] = chosenexec[k]
        Cmd('SendMIDI "Note" '.. midimsg[k] .. " " .. chosenexec[k])
    end
    end

    setmidimsg(chosenexec)
    
    while infiniteloop ~= '' do -- an infinite loop
        for k in pairs(chosenexec) do -- iterates through table
            midioutput(k)
    end
    coroutine.yield(delay) -- wait delay time before next loop/check
end
end
    
return main