function Group_Manage_lua(fid, grp, mode)
    CmdIndirectWait('Store Group 900/Overwrite')
    CmdIndirectWait('Blind On')
    CmdIndirectWait('Clear')
    CmdIndirectWait('fixture ' .. fid)
    CmdIndirectWait("Grid 'Linearize' 'Numerical'")
    if mode == 1 then
        CmdIndirectWait('Store Group ' .. grp .. '/Merge')
    else
        CmdIndirectWait('Store Group ' .. grp .. '/Remove')
    end
    CmdIndirectWait('Clear')
    CmdIndirectWait('Group 900')
    CmdIndirectWait('Blind Off')
end
