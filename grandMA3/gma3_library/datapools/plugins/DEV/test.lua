local h_page = nil
local function main()
    local targetPage = CurrentExecPage()
    local pagenumber = targetPage.No
    local last_pagenumber = h_page
    Echo('page : ' .. pagenumber)

    if pagenumber ~= last_pagenumber then
        send_osc('PageNumber', 0, pagenumber)
        h_page = pagenumber
        Echo('page : ' .. pagenumber)
    end
end

return main
