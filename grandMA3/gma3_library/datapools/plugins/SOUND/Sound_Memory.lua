return function()
    local S_Object    = Root().ShowData.DataPools[6].Sequences:Children()
    local Sound_Type  = { 'All', 'Bass', 'Mid', 'High', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5', 'Band6', 'Band7' }
    local cible       = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local destination = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    for type in ipairs(Sound_Type) do

        for k in ipairs(S_Object) do
            if S_Object[k].name == 'RecepieSound ' .. Sound_Type[type] then
                cible[type] = k
            elseif S_Object[k].name == 'MEM_1_RecepieSound ' .. Sound_Type[type] then
                destination[type] = k
            end
        end

        for part = 1, 3, 1 do
            S_Object[destination[type]][3][1][part]:Set('Selection', S_Object[cible[type]][3][1][part].Selection)
            S_Object[destination[type]][3][1][part]:Set('Values', S_Object[cible[type]][3][1][part].Values)
            S_Object[destination[type]][3][1][part]:Set('MAtricks', S_Object[cible[type]][3][1][part].MAtricks)
            S_Object[destination[type]][3][1][part]:Set('FadeFromX', S_Object[cible[type]][3][1][part].FadeFromX)
            S_Object[destination[type]][3][1][part]:Set('DelayFromX', S_Object[cible[type]][3][1][part].DelayFromX)
        end
    end
end
