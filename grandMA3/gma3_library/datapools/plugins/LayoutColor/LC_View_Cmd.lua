--[[
Releases:
* 2.4.2.2

Version:
* 2.3.6.0

Rewrite by Richard Fontaine "RIRI", June 2026.
--]]



function LCV_Fade(axes, layout, element, matrick_call, data_pool)
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

function LCV_Delay_From(axes, layout, element, matrick_call, matrickthru, data_pool)
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

function LCV_Delay_To(axes, layout, element, matrick_call, matrickthru, data_pool)
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

function LCV_Phase(axes, layout, element, matrick_call, matrickthru, data_pool)
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
    -- Echo('fx ' .. fx .. ' tx ' .. tx)
    local text
    if (fx ~= "None" and fx ~= "90°" and fx ~= "180°" and fx ~= "270°" and fx ~= "360°") then
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
            text = string.format('"%.2f > %.2f"', fx, tx)
        else
            text = string.format('"%s > %s"', fx, tx)
            -- text = string.format('"%.2f > %s"', fx, tx)
        end
    else
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
            text = string.format('"%s > %s"', fx, tx)
            -- text = string.format('"%s > %.2f"', fx, tx)
        else
            text = string.format('"%s > %s"', fx, tx)
        end
    end
    Cmd('Set DataPool ' ..
        data_pool .. ' Layout ' .. layout .. "." .. element .. ' Property "CustomTextText" ' .. text .. ' ')
end

function LCV_Group(axes, layout, element, matrick_call, matrickthru, data_pool)
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

function LCV_Block(axes, layout, element, matrick_call, matrickthru, data_pool)
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

function LCV_Wings(axes, layout, element, matrick_call, matrickthru, data_pool)
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

function LCV_Priority(layout, element, seq_call, data_pool)
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

function LCV_PriorityNumber(layout, element, seq_call, data_pool)
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

function LCV_Favourites(layout, macrostore, data_pool, prefix, macro)
    local sequences = ObjectList('DataPool ' .. data_pool ..
        ' Sequence ' .. string.char(34) .. '' .. prefix .. '*' .. string.char(34) .. '')
    local macropool = ShowData().DataPools[data_pool].Macros
    local layoutspool = ShowData().DataPools[data_pool].Layouts
    local activeseq = {}
    Printf(macrostore)
    local macronum = macrostore
    macronum = macronum:gsub(' Macro', '')
    local mess = 'DataPool ' .. data_pool
    macronum = macronum:gsub(mess, '')
    macronum = tonumber(macronum)
    Printf(macronum)
    for i = 1, #sequences do
        if sequences[i]:HasActivePlayback() then
            table.insert(activeseq, i)
        end
    end
    if #macropool[macronum] == 0 then
        layoutspool[layout]['Macro ' .. macronum]:Set('visibilityobjectname', true)
    end
    Cmd('label DataPool ' ..
        data_pool ..
        ' macro ' .. macronum .. ' ' .. string.char(34) .. prefix .. ' Favourite' .. string.char(34) .. ' /o')
    if #macropool[macronum] > 0 then
        Cmd('delete DataPool ' .. data_pool .. ' macro ' .. macronum .. '.1 thru')
    end
    Cmd('store DataPool ' .. data_pool .. ' macro ' .. macronum .. '.1 thru' .. #activeseq .. ' /o')
    for i = 1, #activeseq do
        local seqnumber = activeseq[i]
        macropool[macronum][i]:Set('command', 'go DataPool ' .. data_pool ..
            ' Sequence ' .. string.char(34) .. '' .. sequences[seqnumber].name .. '' .. string.char(34) .. '')
    end
    Cmd('Set DataPool ' .. data_pool .. ' Macro ' .. macro .. ' Property "Appearance" "LC_Black"')
end

function LCV_Group_select(layout, element, seq_call, data_pool)
    local SEQ_Root = ShowData().DataPools[data_pool].Sequences:Children()
    local pool = DataPool().No
    local GroupObject = ShowData().DataPools[pool].Groups:Children()
    local LayoutObject = Root().ShowData.DataPools[data_pool].Layouts
    local Target
    for k in ipairs(SEQ_Root) do
        if SEQ_Root[k].No == seq_call then
            Target = SEQ_Root[k][3][1][1].Selection.No
            break
        end
    end
    for g in ipairs(GroupObject) do
        if GroupObject[g].No == Target then
            LayoutObject[layout][element]:Set('Object', GroupObject[g])
        end
    end
end

-- end LC_View_Cmd.lua
