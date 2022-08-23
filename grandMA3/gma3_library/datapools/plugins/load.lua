--[[
Load v1.0.0.0
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage
* Call Plugin "Load" 
* Select Sequence in list
* Select Cue in list
* 

Releases:
* 1.0.0.0 - Inital release

Created by Richard Fontaine "RIRI", May 2020.
--]] -- 
local pluginName = select(1, ...);
local componentName = select(2, ...);
local signalTable = select(3, ...);
local my_handle = select(4, ...);

-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F = string.format
local E = Echo
local Co = Confirm
local Maf = math.floor

local function Load(display_handle)

    local Sequences = DataPool().Sequences

    -- Store all Used Sequence in a Table 
    local Seq = Sequences:Children()
    local ChoSeq = {}
    for k in ipairs(Seq) do table.insert(ChoSeq, "'" .. Seq[k].name .. "'") end

    local Selected = PopupInput("Select a Sequence", display_handle, ChoSeq)
    local SeqNr = tonumber(Seq[Selected + 1].NO)
    local SelectedSeq = Sequences:Children()[Selected + 1]

    local Cue = SelectedSeq:Children()

    local ChoCue = {}
    for k in ipairs(Cue) do
        if (k > 2) then table.insert(ChoCue, "'" .. Cue[k].name .. "'") end
    end

    local SelectedCue = PopupInput("Select a Cue", display_handle, ChoCue)

    local CueNr = tonumber(Cue[SelectedCue + 3].NO)

    Cmd("Load Sequence " .. SeqNr .. " cue " .. CueNr)

end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Load
