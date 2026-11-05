--[[
Releases:
* 2.5.1.1

Version:
* 0.0.0.2

Created by Richard Fontaine "RIRI", July 2026.
--]]

function Group_Manage_lua(fid, grp, mode)
    CmdIndirectWait('Preview Toggle')
    CmdIndirectWait('fixture ' .. fid)
    CmdIndirectWait("Grid 'Linearize' 'Numerical'")
    if mode == 1 then
        CmdIndirectWait('Store Group ' .. grp .. '/Merge')
    else
        CmdIndirectWait('Store Group ' .. grp .. '/Remove')
    end
    CmdIndirectWait('Preview Toggle')
end
