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
    local Construct_Pool, Name_Construct_Pool, Name_Layout, Speed_Nr, Name_Speed
    local Call_Pool = myHandle:FindParent(DataPool():GetClass())
    local SpeedMaster = Root().ShowData.Masters.Speed:Children()
    local Speed_Name = {}
    for sp = 1, #SpeedMaster do
        Speed_Name[sp] = SpeedMaster[sp].Name
        sp = sp + 1
    end


    local inputs = {
        { name = "Free DataPool for TR_808", value = "46",          whiteFilter = "0123456789" },
        { name = "Name of DataPool",         value = "TR_808_test", maxTextLength = 20 },
        { name = "Name of Layout",           value = "TR_808_test", maxTextLength = 20 },
        { name = "Name of Speed Master",     value = "TR_SPEED",    maxTextLength = 20 },
    }

    local selectors = {
        {
            name = "Speed Master",
            -- SelectedValue = 1,
            values = {
                [Speed_Name[1]] = 1,
                [Speed_Name[2]] = 2,
                [Speed_Name[3]] = 3,
                [Speed_Name[4]] = 4,
                [Speed_Name[5]] = 5,
                [Speed_Name[6]] = 6,
                [Speed_Name[7]] = 7,
                [Speed_Name[8]] = 8,
                [Speed_Name[9]] = 9,
                [Speed_Name[10]] = 10,
                [Speed_Name[11]] = 11,
                [Speed_Name[12]] = 12,
                [Speed_Name[13]] = 13,
                [Speed_Name[14]] = 14,
                [Speed_Name[15]] = 15,
                [Speed_Name[16]] = 16
            },
            type = 0
        },
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
                selectors = selectors,
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
        elseif k == 'Name of Speed Master' then
            Name_Speed = (v)
        end
    end

    for k, v in pairs(resultTable.selectors) do
        if k == 'Speed Master' then
            Speed_Nr = tonumber(v)
            SpeedMaster[Speed_Nr]:Set('Name', Name_Speed)
            Name_Speed = SpeedMaster[Speed_Nr].Name
        end
    end

    if resultTable.result == 0 then
        Printf('Name : ' .. Name_Speed .. ' SpeedMaster nr : ' .. Speed_Nr .. ' name : ' .. Speed_Name[Speed_Nr])
        return
    end

    Check_DataPool(Construct_Pool, Name_Construct_Pool)
    Build_Tag()
    Build_Appearance()
    Build_MAtricks(Construct_Pool)
    Build_Macro_Varia(Construct_Pool)
    Build_Macro_Tempo(Construct_Pool)
    Build_Macro_Sub(Construct_Pool)
    Build_Macro_All_None(Construct_Pool)
    Build_Macro_All_Sub_Varia(Construct_Pool)
    Build_Macro_Mute_Select(Construct_Pool)

    Build_Seq_R_Y_O(Construct_Pool)
    Build_Seq_Varia_G_R(Construct_Pool)
    Build_Seq_Start_Stop(Construct_Pool, Name_Speed)
    Build_Seq_Mute_Solo(Construct_Pool)
    Build_Seq_Sub(Construct_Pool)
    Build_Seq_Btn_Sub(Construct_Pool)

    Build_Layout(Construct_Pool, Name_Layout)



    Printf('REturn')
end
return main
