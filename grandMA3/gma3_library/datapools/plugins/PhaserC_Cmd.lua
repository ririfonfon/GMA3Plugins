--[[
Releases:
* 1.0.0.0

Created by Richard Fontaine "RIRI", March 2024.
--]]

function CheckSymbols(displayHandle, Img, ImgImp, check, add_check, long_imgimp, ImgNr)
    for k in pairs(Img) do
        for q in pairs(ImgImp) do
            if ('"' .. Img[k].name .. '"' == ImgImp[q].Name) then
                check[q] = 1
                add_check = math.floor(add_check + 1)
            end
            long_imgimp = q
        end
    end

    if (long_imgimp == add_check) then
        Echo("file exist")
    else
        Echo("file not exist")
        -- Select a disk
        local drives = Root().Temp.DriveCollect
        local selectedDrive     -- users selected drive
        local options = {}      -- popup options
        local PopTableDisk = {} --
        -- grab a list of connected drives
        for i = 1, drives.count, 1 do
            table.insert(options, string.format("%s (%s)", drives[i].name, drives[i].DriveType))
        end
        -- present a popup for the user choose (Internal may not work)
        PopTableDisk = {
            title = "Select a disk to import on & off symbols",
            caller = displayHandle,
            items = options,
            selectedValue = "",
            add_args = {
                FilterSupport = "Yes"
            }
        }
        selectedDrive = PopupInput(PopTableDisk)
        selectedDrive = selectedDrive + 1

        -- if the user cancled then exit the plugin
        if selectedDrive == nil then
            return
        end

        -- grab the export path for the selected drive and append the file name
        Cmd("select Drive " .. selectedDrive .. "")

        -- Import Symbols
        for k in pairs(ImgImp) do
            if (check[k] == nil) then
                ImgNr = math.floor(ImgNr + 1);
                Cmd("Store Image 2." ..
                    ImgNr ..
                    " " ..
                    ImgImp[k].Name .. " Filename=" .. ImgImp[k].FileName .. " filepath=" .. ImgImp[k].Filepath .. "")
            end
        end
    end
end -- end function CheckSymbols(...)

function Create_Appearances(SelectedGrp, AppNr, prefix, TCol, NrAppear, StColCode, StColName, StringColName)
    local StAppNameOn
    local StAppNameOff
    local StAppOn = '\"Showdata.MediaPools.Images.on\"'
    local StAppOff = '\"Showdata.MediaPools.Images.off\"'
    for g in ipairs(SelectedGrp) do
        AppNr = math.floor(AppNr);
        Cmd('Store App ' .. AppNr .. ' \'' .. prefix .. ' Label\' Appearance=' .. StAppOn .. ' color=\'0,0,0,1\'')
        NrAppear = math.floor(AppNr + 1)
        for col in ipairs(TCol) do
            StColCode = "\"" .. TCol[col].r .. "," .. TCol[col].g .. "," .. TCol[col].b .. ",1\""
            StColName = TCol[col].name
            StringColName = string.gsub(StColName, " ", "_")
            StAppNameOn = "\"" .. prefix .. StringColName .. " on\""
            StAppNameOff = "\"" .. prefix .. StringColName .. " off\""
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOn .. " Appearance=" .. StAppOn .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
            Cmd("Store App " ..
                NrAppear .. " " .. StAppNameOff .. " Appearance=" .. StAppOff .. " color=" .. StColCode .. "")
            NrAppear = math.floor(NrAppear + 1)
        end
    end
    do return 1, NrAppear end
end

function Create_Preset_25(TCol, StColName, StringColName, SelectedGelNr, prefix, All_5_NrEnd, All_5_Current)
    Cmd("ClearAll /nu")
    Cmd('Set Preset 25 Property PresetMode "Universal"')
    Cmd('Fixture Thru')
    for col in ipairs(TCol) do
        StColName = TCol[col].name
        StringColName = string.gsub(StColName, " ", "_")
        Cmd('At Gel ' .. SelectedGelNr .. "." .. col .. '')
        Cmd('Store Preset 25.' .. All_5_Current .. '')
        Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. StringColName .. " ")
        All_5_NrEnd = All_5_Current
        All_5_Current = math.floor(All_5_Current + 1)
    end
    do return 1, All_5_NrEnd, All_5_Current end
end

function Create_Matrix(MatrickNr, Argument_Matricks, surfix, prefix)
    for axes in pairs(surfix) do
        for g in pairs(Argument_Matricks) do
            Cmd('Store MAtricks ' .. MatrickNr .. ' /nu')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' name = ' .. prefix .. surfix[axes] ..
                "_" .. Argument_Matricks[g].Name:gsub('\'', '') .. ' /nu')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "PhaseFrom' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phasefrom .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "PhaseTo' .. surfix[axes] .. '" "' .. Argument_Matricks[g].phaseto .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Group" "' .. Argument_Matricks[g].group .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Wings" "' .. Argument_Matricks[g].wing .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Block" "' .. Argument_Matricks[g].block .. '')
            Cmd('Set Matricks ' ..
                MatrickNr .. ' Property "' .. surfix[axes] .. 'Shuffle" "' .. Argument_Matricks[g].shuffle .. '')
            Cmd('Set Matricks ' .. MatrickNr .. ' Property "PhaserTransform" ' .. Argument_Matricks[g].transform .. '')
            MatrickNr = math.floor(MatrickNr + 1)
        end
    end
end

function Create_Preset_Ref_1234(prefix, All_5_Current, SelectedGelNr)
    Cmd("ClearAll /nu")
    Cmd('Fixture Thru')
    for i = 1, 4 do
        Cmd('At Gel ' .. SelectedGelNr .. ".1")
        Cmd('Store Preset 25.' .. All_5_Current .. '')
        All_5_Current = math.floor(All_5_Current + 1)
    end
    local Preset_Ref = All_5_Current - 4
    do return 1, All_5_Current, Preset_Ref end
end

function Create_Phaser(All_5_Current, Preset_Ref, prefix, Argument_Ref)
    Cmd("ClearAll /nu")
    Cmd('Fixture Thru')
    Cmd('Attribute "ColorRGB_R" At Relative 0')
    Cmd('Store Preset 25.' .. All_5_Current .. '')
    Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. "ref_off")
    local Phaser_Off = All_5_Current
    All_5_Current = math.floor(All_5_Current + 1)
    -- for i = 1, 3 do
    --     for g in ipairs(Argument_Ref) do
    --         Cmd("ClearAll /nu")
    --         Cmd('Fixture Thru')
    --         for st in pairs(tonumber(Argument_Ref[g].Step)) do
    --             Echo(st)
    --         end
    --         Cmd('Attribute "ColorRGB_R" At Relative 0')
    --         Cmd('Store Preset 25.' .. All_5_Current .. '')
    --         Cmd('Label Preset 25.' .. All_5_Current .. " " .. prefix .. Argument_Ref[g].Name)
    --     end
    -- end
end
