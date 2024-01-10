--[[
Releases:
* 1.1.6.3

Created by Richard Fontaine "RIRI", January 2023.
--]]



function Fade(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Delay_From(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Delay_To(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Phase(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Group(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Block(axes,layout,element,matrick)
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()
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

function Wings(axes,layout,element,matrick)
    
    local root = Root();
    local MATricks = root.ShowData.DataPools.Default.MAtricks:Children()local fx
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
