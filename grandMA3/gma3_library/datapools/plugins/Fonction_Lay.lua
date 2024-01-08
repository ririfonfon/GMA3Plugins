

local root = Root();
local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()


function Fade(axes,layout,element,matrick)
    local fx, tx
    if (axes == "x") then
        fx = tonumber(MatrickNr[matrick]:Get('FadeFromX', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[matrick]:Get('FadeToX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[matrick]:Get('FadeFromY', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[matrick]:Get('FadeToY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[matrick]:Get('FadeFromZ', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[matrick]:Get('FadeToZ', Enums.Roles.Display)) or 'None'
    end
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
    -- Cmd('Set Layout 2.40 Property "CustomTextText" '.. text ..' ')
end

function Delay_From(axes,layout,element,matrick)
	local fx 
	if (axes == "x") then
        fx = tonumber(MatrickNr[matrick]:Get('DelayFromX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
	    fx = tonumber(MatrickNr[matrick]:Get('DelayFromY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
	    fx = tonumber(MatrickNr[matrick]:Get('DelayFromZ', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%.2f"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
    -- Cmd('Set Layout 2.47 Property "CustomTextText" '.. text ..' ')
end

function Delay_To(axes,layout,element,matrick)
	local tx
	if (axes == "x") then
        tx = tonumber(MatrickNr[matrick]:Get('DelayToX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        tx = tonumber(MatrickNr[matrick]:Get('DelayToY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        tx = tonumber(MatrickNr[matrick]:Get('DelayToZ', Enums.Roles.Display)) or 'None'
    end
    local text
    if (tx ~= "None" ) then
        text = string.format( '"%.2f"', tx )
    else
        text = string.format( '"%s"', tx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
    -- Cmd('Set Layout 2.54 Property "CustomTextText" '.. text ..' ')
end

function Phase(axes,layout,element,matrick)
	local fx, tx
    if (axes == "x") then
        fx = MatrickNr[matrick]:Get('PhaseFromX', Enums.Roles.Display)
        tx = MatrickNr[matrick]:Get('PhaseToX', Enums.Roles.Display)
    elseif (axes == "y") then
        fx = MatrickNr[matrick]:Get('PhaseFromY', Enums.Roles.Display)
        tx = MatrickNr[matrick]:Get('PhaseToY', Enums.Roles.Display)
    elseif (axes == "z") then
        fx = MatrickNr[matrick]:Get('PhaseFromZ', Enums.Roles.Display)
    	tx = MatrickNr[matrick]:Get('PhaseToZ', Enums.Roles.Display)
    end
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
    -- Cmd('Set Layout 2.62 Property "CustomTextText" '.. text ..' ')
end

function Group(axes,layout,element,matrick)
	local fx
	if (axes == "x") then
        fx = tonumber(MatrickNr[matrick]:Get('xGroup', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[matrick]:Get('yGroup', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[matrick]:Get('zGroup', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
    -- Cmd('Set Layout 2.64 Property "CustomTextText" '.. text ..' ')
end

function Block(axes,layout,element,matrick)
    local fx
	if (axes == "x") then
        fx = tonumber(MatrickNr[matrick]:Get('xBlock', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[matrick]:Get('yBlock', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[matrick]:Get('zBlock', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
    -- Cmd('Set Layout 2.71 Property "CustomTextText" '.. text ..' ')
end

function Wings(axes,layout,element,matrick)
    local fx
    if (axes == "x") then
        fx = tonumber(MatrickNr[matrick]:Get('xWings', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[matrick]:Get('yWings', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[matrick]:Get('zWings', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout '.. layout .. "." .. element .. ' Property "CustomTextText" '.. text ..' ')
    -- Cmd('Set Layout 2.78 Property "CustomTextText" '.. text ..' ')
end
