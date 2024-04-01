--[[
Releases:
* 2.0.0.6

Created by Richard Fontaine "RIRI", March 2024.
--]]



function Fade(axes, layout, element, matrick_call, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx, tx
    if (axes == 1) then
        fx = tonumber(MATricks[matrick]:Get('FadeFromX', Enums.Roles.Display)) or 'None'
        tx = tonumber(MATricks[matrick]:Get('FadeToX', Enums.Roles.Display)) or 'None'
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('FadeFromY', Enums.Roles.Display)) or 'None'
        tx = tonumber(MATricks[matrick]:Get('FadeToY', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('FadeFromZ', Enums.Roles.Display)) or 'None'
        tx = tonumber(MATricks[matrick]:Get('FadeToZ', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None") then
        if (tx ~= "None") then
            text = string.format('"%.2f > %.2f"', fx, tx)
        else
            text = string.format('"%.2f > %s"', fx, tx)
        end
    else
        if (tx ~= "None") then
            text = string.format('"%s > %.2f"', fx, tx)
        else
            text = string.format('"%s > %s"', fx, tx)
        end
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Delay_From(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    Echo(data_pool)
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx
    if (axes == 1) then
        fx = tonumber(MATricks[matrick]:Get('DelayFromX', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayFromx" ' .. fx)
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('DelayFromY', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayFromy" ' .. fx)
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('DelayFromZ', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayFromz" ' .. fx)
    end
    local text
    if (fx ~= "None") then
        text = string.format('"%.2f"', fx)
    else
        text = string.format('"%s"', fx)
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Delay_To(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local tx
    if (axes == 1) then
        tx = tonumber(MATricks[matrick]:Get('DelayToX', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayTox" ' .. tx)
    elseif (axes == 2) then
        tx = tonumber(MATricks[matrick]:Get('DelayToY', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayToy" ' .. tx)
    elseif (axes == 3) then
        tx = tonumber(MATricks[matrick]:Get('DelayToZ', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "DelayToz" ' .. tx)
    end
    local text
    if (tx ~= "None") then
        text = string.format('"%.2f"', tx)
    else
        text = string.format('"%s"', tx)
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Phase(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx, tx
    if (axes == 1) then
        fx = MATricks[matrick]:Get('PhaseFromX', Enums.Roles.Display)
        tx = MATricks[matrick]:Get('PhaseToX', Enums.Roles.Display)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseFromx" ' .. fx)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseTox" ' .. tx)
    elseif (axes == 2) then
        fx = MATricks[matrick]:Get('PhaseFromY', Enums.Roles.Display)
        tx = MATricks[matrick]:Get('PhaseToY', Enums.Roles.Display)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseFromy" ' .. fx)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseToy" ' .. tx)
    elseif (axes == 3) then
        fx = MATricks[matrick]:Get('PhaseFromZ', Enums.Roles.Display)
        tx = MATricks[matrick]:Get('PhaseToZ', Enums.Roles.Display)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseFromz" ' .. fx)
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "PhaseToz" ' .. tx)
    end
    local text
    if (fx ~= "None" and fx ~= "90°" and fx ~= "180°" and fx ~= "270°" and fx ~= "360°") then
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
            text = string.format('"%.2f > %.2f"', fx, tx)
        else
            text = string.format('"%.2f > %s"', fx, tx)
        end
    else
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
            text = string.format('"%s > %.2f"', fx, tx)
        else
            text = string.format('"%s > %s"', fx, tx)
        end
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Group(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx
    if (axes == 1) then
        fx = tonumber(MATricks[matrick]:Get('xGroup', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "xGroup" ' .. fx)
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yGroup', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "yGroup" ' .. fx)
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zGroup', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "zGroup" ' .. fx)
    end
    local text
    if (fx ~= "None") then
        text = string.format('"%d"', fx)
    else
        text = string.format('"%s"', fx)
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Block(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx
    if (axes == 1) then
        fx = tonumber(MATricks[matrick]:Get('xBlock', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "xBlock" ' .. fx)
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yBlock', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "yBlock" ' .. fx)
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zBlock', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "zBlock" ' .. fx)
    end
    local text
    if (fx ~= "None") then
        text = string.format('"%d"', fx)
    else
        text = string.format('"%s"', fx)
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Wings(axes, layout, element, matrick_call, matrickthru, data_pool)
    local Maf = math.floor
    local MATricks = ShowData().DataPools[data_pool].MAtricks:Children()
    local Matrick_check
    local matrick
    for k in ipairs(MATricks) do
        Matrick_check = Maf(MATricks[k].NO)
        if Matrick_check == matrick_call then
            matrick = k
        end
    end
    matrick = tonumber(matrick)
    local fx
    if (axes == 1) then
        fx = tonumber(MATricks[matrick]:Get('xWings', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "xWings" ' .. fx)
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yWings', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "yWings" ' .. fx)
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zWings', Enums.Roles.Display)) or 'None'
        Cmd('Set DataPool ' ..
        data_pool .. ' Matricks ' .. matrick + 1 .. ' Thru ' .. matrickthru .. ' Property "zWings" ' .. fx)
    end
    local text
    if (fx ~= "None") then
        text = string.format('"%d"', fx)
    else
        text = string.format('"%s"', fx)
    end
    Cmd('Set DataPool ' ..
    data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function Priority(layout, element, seq_call, data_pool)
    Echo(data_pool)
    local SEQ_Root = ShowData().DataPools[data_pool].Sequences:Children()
    local seq_check
    local seq
    local prio
    for k in ipairs(SEQ_Root) do
        seq_check = SEQ_Root[k].name
        if seq_check == seq_call then
            seq = k
        end
    end
    seq = tonumber(seq)
    prio = SEQ_Root[seq]:Get('Priority', Enums.Roles.Display) or 'None'
    if prio == "Super" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_super_png" ')
    elseif prio == "Swap" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_swap_png" ')
    elseif prio == "HTP" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_htp_png" ')
    elseif prio == "Highest" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_highest_png" ')
    elseif prio == "High" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_high_png" ')
    elseif prio == "LTP" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_ltp_png" ')
    elseif prio == "Low" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_low_png" ')
    elseif prio == "Lowest" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_lowest_png" ')
    end
end

function PriorityNumber(layout, element, seq_call, data_pool)
    local SEQ_Root = ShowData().DataPools[data_pool].Sequences:Children()
    local seq_check
    local seq
    seq_call = math.floor(seq_call)
    local prio
    for k in ipairs(SEQ_Root) do
        seq_check = math.floor(SEQ_Root[k].NO)
        if seq_check == seq_call then
            seq = k
        end
    end
    seq = tonumber(seq)
    prio = SEQ_Root[seq]:Get('Priority', Enums.Roles.Display) or 'None'
    if prio == "Super" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_super_png" ')
    elseif prio == "Swap" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_swap_png" ')
    elseif prio == "HTP" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_htp_png" ')
    elseif prio == "Highest" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_highest_png" ')
    elseif prio == "High" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_high_png" ')
    elseif prio == "LTP" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_ltp_png" ')
    elseif prio == "Low" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_low_png" ')
    elseif prio == "Lowest" then
        Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "Appearance" "p_lowest_png" ')
    end
end

-- end LC_View_Cmd.lua
