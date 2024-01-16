--[[
Releases:
* 1.1.7.1

Created by Richard Fontaine "RIRI", January 2024.
--]]



function Fade(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    Echo(fx)
    Echo(tx)
    local text
    if (fx ~= "None" ) then
        if (tx ~= "None") then
        text = string.format( '"%.2f > %.2f"', fx , tx )
        else
        text = string.format( '"%.2f > %s"', fx , tx )
        end
    else
        if (tx ~= "None") then
        text = string.format( '"%s > %.2f"', fx , tx )
        else
        text = string.format( '"%s > %s"', fx , tx )
        end
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Delay_From(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
	    fx = tonumber(MATricks[matrick]:Get('DelayFromY', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
	    fx = tonumber(MATricks[matrick]:Get('DelayFromZ', Enums.Roles.Display)) or 'None'
    end
    Echo(fx)
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%.2f"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Delay_To(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
        tx = tonumber(MATricks[matrick]:Get('DelayToY', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
        tx = tonumber(MATricks[matrick]:Get('DelayToZ', Enums.Roles.Display)) or 'None'
    end
    Echo(tx)
    local text
    if (tx ~= "None" ) then
        text = string.format( '"%.2f"', tx )
    else
        text = string.format( '"%s"', tx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Phase(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
        fx = MATricks[matrick]:Get('PhaseFromY', Enums.Roles.Display)
        tx = MATricks[matrick]:Get('PhaseToY', Enums.Roles.Display)
    elseif (axes == 3) then
        fx = MATricks[matrick]:Get('PhaseFromZ', Enums.Roles.Display)
    	tx = MATricks[matrick]:Get('PhaseToZ', Enums.Roles.Display)
    end
    Echo(fx)
    Echo(tx)
    local text
    if (fx ~= "None" and fx ~= "90°" and fx ~= "180°" and fx ~= "270°" and fx ~= "360°" ) then
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
        text = string.format( '"%.2f > %.2f"', fx , tx )
        else
        text = string.format( '"%.2f > %s"', fx , tx )
        end
    else
        if (tx ~= "None" and tx ~= "90°" and tx ~= "180°" and tx ~= "270°" and tx ~= "360°") then
        text = string.format( '"%s > %.2f"', fx , tx )
        else
        text = string.format( '"%s > %s"', fx , tx )
        end
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Group(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yGroup', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zGroup', Enums.Roles.Display)) or 'None'
    end
    Echo(fx)
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Block(axes,layout,element,matrick_call)
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yBlock', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zBlock', Enums.Roles.Display)) or 'None'
    end
    Echo(fx)
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Wings(axes,layout,element,matrick_call)  
    local root = Root();
    local Maf = math.floor
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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
    elseif (axes == 2) then
        fx = tonumber(MATricks[matrick]:Get('yWings', Enums.Roles.Display)) or 'None'
    elseif (axes == 3) then
        fx = tonumber(MATricks[matrick]:Get('zWings', Enums.Roles.Display)) or 'None'
    end
    Echo(fx)
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
end

function Priority(layout,element,seq_call)
    local root = Root();
    local Maf = math.floor
    local SEQ_Root = root.ShowData.DataPools.Default.Sequences:Children()
    local seq_check
    local seq
    local prio
    Echo(seq_call)
    -- seq_call = seq_call +"ALLWhiteALL"
    Echo(seq_call)
    for k in ipairs(SEQ_Root) do
        seq_check = SEQ_Root[k].name
        if seq_check == seq_call then
            Echo("good")
            seq = k
        end
    end
    seq = tonumber(seq)
    Echo(seq)
    prio = SEQ_Root[seq]:Get('Priority' , Enums.Roles.Display) or 'None'
    Echo(prio)
    if prio == "Super" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_super_png" ')
    elseif prio == "Swap" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_swap_png" ')
    elseif prio == "HTP" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_htp_png" ')
    elseif prio == "Highest" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_highest_png" ')
    elseif prio == "High" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_high_png" ')
    elseif prio == "LTP" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_ltp_png" ')
    elseif prio == "Low" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_low_png" ')
    elseif prio == "Lowest" then
        Cmd('Set Layout '.. layout .. "." .. element .. ' Property "Appearance" "p_lowest_png" ')
    end
end
