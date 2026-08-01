-- grandMA3 Plugin: Standalone Group Picker
-- Author:   LXTater
-- Website:  www.LXTater.com
-- License:  Free to use, modify, and share. Do not sell it or charge for access without permission (just DM Me.)
-- Docs:     https://github.com/LXTater/ma3-plugin-devkitapedia/wiki/UI-Popups

local signalTable, myHandle = select(3, ...)

local function pickGroup()

    -- Standard display setup
    local disp  = GetFocusDisplay()
    local ov    = (disp and disp.ScreenOverlay) or GetDisplayByIndex(1).ScreenOverlay
    local dispW = tonumber(disp and disp.W) or 1920
    local dispH = tonumber(disp and disp.H) or 1080

    local W = math.floor(dispW * 0.55)
    local H = math.floor(dispH * 0.60)

    -- Signal keys
    local sSel    = "GroupPick_sel"    -- Selected group in the group picker
    local sDp     = "GroupPick_dp"     -- Selected datapool in the DP selector
    local sFilter = "GroupPick_filter" -- Filter toggle state

    -- Popup shell
    local popup = ov:Append("Popup")
    popup.Name, popup.Columns, popup.Rows = "GroupPicker", 1, 2
    popup.W, popup.H    = W, H
    popup.MaxSize       = string.format("%d,%d", math.floor(dispW * 0.95), dispH)
    popup.AlignmentH    = "Center"
    popup.AlignmentV    = "Center"
    popup.AutoClose     = "Yes"
    popup.CloseOnEscape = "Yes"
    popup[1][2].SizePolicy = "Content"

    -- Title bar: title | filter toggle | datapool selector | close
    local tb = popup:Append("TitleBar")
    tb.Columns, tb.Rows = 4, 1
    tb.Anchors = "0,0"
    tb.Texture = "corner2"
    tb[2][2].SizePolicy = "Fixed";   tb[2][2].Size = "50"
    tb[2][3].SizePolicy = "Content"
    tb[2][4].SizePolicy = "Fixed";   tb[2][4].Size = "50"

    local tLbl = tb:Append("TitleButton")
    tLbl.Text    = "LXTater - Pick a Group"
    tLbl.Texture = "corner1"
    tLbl.Anchors = "0,0"

    local tClose = tb:Append("CloseButton")
    tClose.Anchors = "3,0"
    tClose.Texture = "corner2"

    -- Dialog frame for the list, scrollbars, and filter.
    -- Tip: add a UITab column here to recreate a native recipe value selector.
    local df = popup:Append("DialogFrame")
    df.Columns, df.Rows = 1, 3
    df.ExpandContent = "Yes"
    df[1][1].SizePolicy = "Content"
    df[1][2].SizePolicy = "Content"
    df[1][3].SizePolicy = "Content"

    -- Scrollable group list
    local list = df:Append("ScrollableItemList")
    list.Anchors         = "0,1"
    list.Name            = "Popup"
    list.H               = "100%"
    list.ContentDriven   = "Yes"
    list.ForceContentMin = "Yes"               -- Helps with layout edge cases
    list.AllowBlocks     = "Yes"               -- Yes = multi-column; No = single long column
    list.ItemType        = "PopupItemButtonExt" -- Required for selection + appearances
    list.ShowLeftIcon    = "Yes"
    list.ShowRightIcon   = "No"
    list.PluginComponent = myHandle
    list.OnSelectedItem  = sSel

    -- Vertical scrollbar (hidden; included for reference)
    local sV = df:Append("ScrollBarV")
    sV.ScrollTarget   = list
    sV.W              = "20"
    sV.ScrollOpposite = "No"
    sV.Visible        = "No"
    sV.AlignmentH     = "Right"

    -- Horizontal scrollbar
    local sH = df:Append("ScrollBarH")
    sH.Anchors        = "0,1"
    sH.H              = "20"
    sH.ScrollTarget   = list
    sH.ScrollOpposite = "No"
    sH.Visible        = "Yes"
    sH.AlignmentV     = "Bottom"

    -- Filter field (hidden by default; toggled via filter button)
    local fl = df:Append("LineEdit")
    fl.H        = 50
    fl.Name     = "ItemFilterField"
    fl.Anchors  = "0,0"
    fl.Property = "ItemFilter"
    fl.Target   = list
    fl.Visible  = "No"
    fl.Focus    = "InitialFocus"
    fl.Execute  = ":SelectFirstItem"

    -- Filter toggle button in title bar
    local filterOn = false
    local fb = tb:Append("Button")
    fb.Anchors         = "1,0"
    fb.Icon            = "object_filter"
    fb.PluginComponent = myHandle
    fb.Clicked         = sFilter

    signalTable[sFilter] = function()
        filterOn = not filterOn
        if filterOn then
            fl.Visible = "Yes"
            fl.Focus   = "InitialFocus"
        else
            fl.Visible      = "No"
            fl.Content      = ""
            list.ItemFilter = ""
            list:Changed()
        end
    end

    -- Datapool selector in title bar 
    -- local curDP = DataPool()
    local curDP = Root().ShowData.DataPools[2]
    local dpSel = tb:Append("ObjectSelector")
    dpSel.Anchors          = "2,0"
    dpSel.W                = "150"
    dpSel.Text             = "DataPool"
    dpSel.SelectionChanged = sDp
    dpSel.PluginComponent  = myHandle
    dpSel.ShowLabel        = "Yes"
    dpSel.TextColor        = "Button.Text"
    dpSel.Target           = ShowData().Datapools
    dpSel.Visible          = "Yes"
    -- dpSel:SelectListItemByIndex(1)
    dpSel:SelectListItemByIndex(2)

    df:WaitInit()

    -- Populate list.
    local rowObjects = {}
    local function populate(dp)
        list:ClearList()
        rowObjects = {}

        -- Row 1 is the "None" button
        list:AddListObjectItem(Root(), "None", { appearance = false, scribble = false })

        local coll = dp and dp.Groups
        if not coll then list:Changed(); return end

        local kids
        local ok = pcall(function() kids = coll:Children() end)
        if not ok or not kids then list:Changed(); return end

        local row = 2
        for _, o in ipairs(kids) do
            rowObjects[row] = o
            list:AddListObjectItem(o, o.Name, { appearance = true, scribble = true })
            row = row + 1
        end
        list:Changed()
    end


        -- relayout() forces a redraw of the list and popup container. Helps with formatting issues.

    local function relayout()
        pcall(function() list:Changed() end)
        pcall(function() popup:Changed() end)
    end

    local needsRelayout = false

    populate(curDP)
    relayout()
    coroutine.yield({ ui = 2 })
    relayout()

    local picked = nil

    signalTable[sSel] = function(caller)
        local idx = caller:GetListSelectedItemIndex()
        if idx and idx > 0 then picked = rowObjects[idx] end
    end

    signalTable[sDp] = function(caller)
        local idx = caller:GetListSelectedItemIndex()
        if idx and idx > 0 then
            local dp = ShowData().Datapools[idx]
            if dp then
                curDP = dp
                populate(dp)
                -- Cannot yield inside a signal handler; flag the wait loop instead.
                needsRelayout = true
            end
        end
    end

    -- Block until a group is picked or the popup is closed
    repeat
        if needsRelayout then
            needsRelayout = false
            relayout()
            coroutine.yield({ ui = 2 })
            relayout()
        end
        coroutine.yield({ ui = 1 })
    until picked ~= nil or not IsObjectValid(popup)

    -- Cleanup
    signalTable[sSel]    = nil
    signalTable[sDp]     = nil
    signalTable[sFilter] = nil
    --restore our values to nil to help with err handling.
    pcall(function() popup:Close() end)


    return picked
end

return function()
    local g = pickGroup()
    if g then
        Printf("[LXTater GroupPicker] Picked Group %s - %s", tostring(g.No), tostring(g.Name))
    else
        Printf("[LXTater GroupPicker] Cancelled")
    end
end