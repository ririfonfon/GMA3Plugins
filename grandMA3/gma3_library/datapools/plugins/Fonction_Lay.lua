

local root = Root();
local MatrickNr = root.ShowData.DataPools.Default.MAtricks:Children()


function Fade(axes)
    local fx, tx
    if (axes == "x") then
        fx = tonumber(MatrickNr[1]:Get('FadeFromX', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[1]:Get('FadeToX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[1]:Get('FadeFromY', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[1]:Get('FadeToY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[1]:Get('FadeFromZ', Enums.Roles.Display)) or 'None'
        tx = tonumber(MatrickNr[1]:Get('FadeToZ', Enums.Roles.Display)) or 'None'
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
    Cmd('Set Layout 2.40 Property "CustomTextText" '.. text ..' ')
end

function Delay_From(axes)
	local fx 
	if (axes == "x") then
        fx = tonumber(MatrickNr[1]:Get('DelayFromX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
	    fx = tonumber(MatrickNr[1]:Get('DelayFromY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
	    fx = tonumber(MatrickNr[1]:Get('DelayFromZ', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%.2f"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout 2.47 Property "CustomTextText" '.. text ..' ')
end

function Delay_To(axes)
	local tx
	if (axes == "x") then
        tx = tonumber(MatrickNr[1]:Get('DelayToX', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        tx = tonumber(MatrickNr[1]:Get('DelayToY', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        tx = tonumber(MatrickNr[1]:Get('DelayToZ', Enums.Roles.Display)) or 'None'
    end
    local text
    if (tx ~= "None" ) then
        text = string.format( '"%.2f"', tx )
    else
        text = string.format( '"%s"', tx )
    end
    Cmd('Set Layout 2.54 Property "CustomTextText" '.. text ..' ')
end

function Phase(axes)
	local fx, tx
    if (axes == "x") then
        fx = MatrickNr[1]:Get('PhaseFromX', Enums.Roles.Display)
        tx = MatrickNr[1]:Get('PhaseToX', Enums.Roles.Display)
    elseif (axes == "y") then
        fx = MatrickNr[1]:Get('PhaseFromY', Enums.Roles.Display)
        tx = MatrickNr[1]:Get('PhaseToY', Enums.Roles.Display)
    elseif (axes == "z") then
        fx = MatrickNr[1]:Get('PhaseFromZ', Enums.Roles.Display)
    	tx = MatrickNr[1]:Get('PhaseToZ', Enums.Roles.Display)
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
    Cmd('Set Layout 2.62 Property "CustomTextText" '.. text ..' ')
end

function Group(axes)
	local fx
	if (axes == "x") then
        fx = tonumber(MatrickNr[1]:Get('xGroup', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[1]:Get('yGroup', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[1]:Get('zGroup', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout 2.64 Property "CustomTextText" '.. text ..' ')
end

function Block(axes)
    local fx
	if (axes == "x") then
        fx = tonumber(MatrickNr[1]:Get('xBlock', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[1]:Get('yBlock', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[1]:Get('zBlock', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout 2.71 Property "CustomTextText" '.. text ..' ')
end

function Wings(axes)
    local fx
    if (axes == "x") then
        fx = tonumber(MatrickNr[1]:Get('xWings', Enums.Roles.Display)) or 'None'
    elseif (axes == "y") then
        fx = tonumber(MatrickNr[1]:Get('yWings', Enums.Roles.Display)) or 'None'
    elseif (axes == "z") then
        fx = tonumber(MatrickNr[1]:Get('zWings', Enums.Roles.Display)) or 'None'
    end
    local text
    if (fx ~= "None" ) then
        text = string.format( '"%d"', fx )
    else
        text = string.format( '"%s"', fx )
    end
    Cmd('Set Layout 2.78 Property "CustomTextText" '.. text ..' ')
end
