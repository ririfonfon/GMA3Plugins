-- local function main()
--     local Select = UserVars()
--     local Call = false
--     if GetVar(Select, "TR_Fonction") then
--         TR_Fonction = tonumber((GetVar(Select, "TR_Fonction")))
--         Call = true
--     end

--     if Call == false then
--         Printf('call false')
--     elseif Call == true then
--         Printf('call true')
--     end
-- end
-- return main


-- Recipe Line Duplicate - New Group - Whole Sequence
-- v2.3.1.1  (MA3 2.3) - 2025-10-31
-- Written by jeff @ penlight.ca
-- https://github.com/jefffarrow/
-- Released under WTFPL Public License

-- duplicates either the first or last recipe lines of each cue (in part 0) and assigns a new selection

-- If you find this plugin useful, please buy me a coffee https://buymeacoffee.com/jfarrow

local srcSeq, grpNum, lineSel
local function copyRecipeLines()
	local srcPart = 0
	local seqHandle = DataPool().Sequences[srcSeq]
	local cuesTable = seqHandle:Children()
	for cue = 1, #cuesTable do
		local cueHandle = cuesTable[cue]
		if cueHandle.Name == "CueZero" or cueHandle.Name == "OffCue" then
		else
			local srcCue = cueHandle.No / 1000
			local cuePartHandle =
				ObjectList("Sequence " .. srcSeq .. " Cue " .. srcCue .. " Part " .. srcPart)[1]
			local rLineTable = cuePartHandle:Children()
			if #rLineTable == 0 then
				Printf("No recipie lines in Sequence " .. srcSeq .. " Cue " .. srcCue .. " Part " .. srcPart)
			else
				local line, lineCount = 1, #rLineTable
				-- line source logic
				if lineSel == 2 then line = lineCount end
				local rLineHandle = cuePartHandle[line]
				-- acquire a new recipie line and copy the contents from the source defined above
				cuePartHandle:Acquire():Copy(rLineHandle)
				-- update the selection of the new line we just created
				cuePartHandle[lineCount + 1].selection = DataPool().Groups[grpNum]
			end
		end
		cue = cue + 1
	end
end

local function main()
    local wf, wfd, vk = "0123456789", "0123456789.", "NumericInput"
	local options = {
		icon = "cooking",
		backColor = "Global.PartlySelected",
		title = "Duplicate Recipe Lines & Assign New Group",
		message = "For each cue in the sequence\nDuplicate Recipe Line and assign a New Group\nPart 0 is default - Entries must be numerical",
		commands = { { value = 1, name = "Ok" }, { value = 0, name = "Cancel" } },
		inputs = {
			{ name = "Sequence to process", value = SelectedSequence().No, whiteFilter = wf, vkPlugin = vk, order = 1 },
			{ name = "Group number to assign", value = "" , whiteFilter = wf, vkPlugin = vk, order = 2 },
		},
		selectors = {
			{ name = "Recipe Line to Copy", selectedValue = 2, type = 1, values = { ["First"] = 1, ["Last"] = 2 } },
		},
	}
	local r = MessageBox(options)

	if r.success then
		if r.result == 0 then Echo("User pressed Cancel") end
		if r.result == 1 then Echo("User pressed OK")
            srcSeq = tonumber(r.inputs["Sequence to process"])
			grpNum = tonumber(r.inputs["Group number to assign"])
			lineSel = tonumber(r.selectors["Recipe Line to Copy"])
            copyRecipeLines()
		end
	else Echo("User escaped the dialog") end
end

return main

