--[[
    Releases:
    * 0.0.0.9
    Created by Richard Fontaine "RIRI", Mars 2026.
--]]

local signalTable, thiscomponent = select(3, ...)
local myHandle = select(4, ...)

local function main(displayHandle)
    local Select = UserVars()
    local Call = false
    if GetVar(Select, "TR_Layout") then
        Retour_Recepie()
        Call = true
    end
    if GetVar(Select, "Order") then
        if GetVar(Select, "Order") ~= "Z" then
            Check_Solo()
            Call = true
        end
    end
    if GetVar(Select, "TR_Tag") then
        Edit_Tag()
        Call = true
    end
    if Call == true then
        return
    end

    Cmd('Set UserProfile *.15 Property "keyboardshortcutsactive" false')
    local Construct_Pool, Name_Construct_Pool, Name_Layout
    local Call_Pool = myHandle:FindParent(DataPool():GetClass())

    local inputs = {
        { name = "Free DataPool for TR_808", value = "46",     whiteFilter = "0123456789" },
        { name = "Name of DataPool",         value = "TR_808", maxTextLength = 20 },
        { name = "Name of Layout",           value = "TR_808", maxTextLength = 20 },
    }



    -- open messagebox:
    local resultTable =
        MessageBox(
            {
                title = "TR_808 on GMA3",
                message = "Please enter number to set.",
                message_align_h = Enums.AlignmentH.Left,
                message_align_v = Enums.AlignmentV.Top,
                commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
                inputs = inputs,
                backColor = "Global.Default",
                icon = "logo_small",
                titleTextColor = "Global.AlertText",
                messageTextColor = "Global.Text",
                autoCloseOnInput = true
            }
        )

    -- print results:

    for k, v in pairs(resultTable.inputs) do
        if k == 'Free DataPool for TR_808' then
            Construct_Pool = tonumber(v)
        elseif k == 'Name of DataPool' then
            Name_Construct_Pool = (v)
        elseif k == 'Name of Layout' then
            Name_Layout = (v)
        end
    end


    Check_DataPool(Construct_Pool, Name_Construct_Pool)

    Printf('REturn')
end
return main
