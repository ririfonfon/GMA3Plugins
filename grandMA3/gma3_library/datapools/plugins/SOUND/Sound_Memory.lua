return function()
    local mem_nbr     = 1
    local S_Object    = Root().ShowData.DataPools[6].Sequences:Children()
    local Sound_Type  = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }
    local cible       = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local destination = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local incr
    local Target
    local L_Object    = Root().ShowData.DataPools[6].Layouts
    for k in ipairs(L_Object[1]) do
        if L_Object[1][k].Name == 'Grp part 01 Sound All' then
            incr = L_Object[1][k].No
        end
    end
    for type in ipairs(Sound_Type) do
        for k in ipairs(S_Object) do
            if S_Object[k].name == 'RecepieSound ' .. Sound_Type[type] then
                cible[type] = k
            elseif S_Object[k].name == "MEM_" .. mem_nbr .. "_RecepieSound " .. Sound_Type[type] then
                destination[type] = k
            end
        end

        -- for part = 1, 3, 1 do
        --     S_Object[destination[type]][3][1][part]:Set('Selection', S_Object[cible[type]][3][1][part].Selection)
        --     S_Object[destination[type]][3][1][part]:Set('Values', S_Object[cible[type]][3][1][part].Values)
        --     S_Object[destination[type]][3][1][part]:Set('MAtricks', S_Object[cible[type]][3][1][part].MAtricks)
        --     S_Object[destination[type]][3][1][part]:Set('FadeFromX', S_Object[cible[type]][3][1][part].FadeFromX)
        --     S_Object[destination[type]][3][1][part]:Set('FadeToX', S_Object[cible[type]][3][1][part].FadeToX)
        --     S_Object[destination[type]][3][1][part]:Set('DelayFromX', S_Object[cible[type]][3][1][part].DelayFromX)
        --     S_Object[destination[type]][3][1][part]:Set('DelayToX', S_Object[cible[type]][3][1][part].DelayToX)
        -- end
        for part = 1, 3, 1 do
            S_Object[cible[type]][3][1][part]:Set('Selection', S_Object[destination[type]][3][1][part].Selection)
            if S_Object[destination[type]][3][1][part].Selection == nil then
                Target = 'Group'
            else
                Target = S_Object[destination[type]][3][1][part].Selection.Name
            end
            L_Object[1][incr]:Set('CustomTextText', Target)
            incr = incr + 1
            S_Object[cible[type]][3][1][part]:Set('Values', S_Object[destination[type]][3][1][part].Values)
            if S_Object[destination[type]][3][1][part].Values == nil then
                Target = 'Value'
            else
                Target = S_Object[destination[type]][3][1][part].Values.Name
            end
            L_Object[1][incr]:Set('CustomTextText', Target)
            incr = incr + 1
            S_Object[cible[type]][3][1][part]:Set('MAtricks', S_Object[destination[type]][3][1][part].MAtricks)
            if S_Object[destination[type]][3][1][part].Matricks == nil then
                Target = 'Matricks'
            else
                Target = S_Object[destination[type]][3][1][part].Matricks.Name
            end
            L_Object[1][incr]:Set('CustomTextText', Target)
            incr = incr + 1
            S_Object[cible[type]][3][1][part]:Set('FadeFromX', S_Object[destination[type]][3][1][part].FadeFromX)
            if S_Object[destination[type]][3][1][part].FadeFromX == nil then
                Target = "N/"
            else
                Target = tostring(S_Object[destination[type]][3][1][part].FadeFromX.Name) .. "/"
            end
            S_Object[cible[type]][3][1][part]:Set('FadeToX', S_Object[destination[type]][3][1][part].FadeToX)
            if S_Object[destination[type]][3][1][part].FadeToX == nil then
                Target = Target .. "N"
            else
                Target = Target .. tostring(S_Object[destination[type]][3][1][part].FadeToX.Name)
            end
            L_Object[1][incr]:Set('CustomTextText', Target)
            incr = incr + 1
            S_Object[cible[type]][3][1][part]:Set('DelayFromX', S_Object[destination[type]][3][1][part].DelayFromX)
            if S_Object[destination[type]][3][1][part].DelayFromX == nil then
                Target = "N/"
            else
                Target = tostring(S_Object[destination[type]][3][1][part].DelayFromX.Name) .. "/"
            end
            S_Object[cible[type]][3][1][part]:Set('DelayToX', S_Object[destination[type]][3][1][part].DelayToX)
            if S_Object[destination[type]][3][1][part].DelayToX == nil then
                Target = Target .. "N"
            else
                Target = Target .. tostring(S_Object[destination[type]][3][1][part].DelayToX.Name)
            end
            L_Object[1][incr]:Set('CustomTextText', Target)
            incr = incr + 1
        end
    end
end
