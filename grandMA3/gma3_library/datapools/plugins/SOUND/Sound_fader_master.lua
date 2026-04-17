local my_table, my_handle = select(3, ...)

return function()
    local Value
    local proxy = Root().ShowData.DataPools[6].Groups[1]
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 600, 100
    local fader = dialog:Append('UiFader')

    fader.target = proxy
    fader.Text = proxy.Name
    fader.changed = 'fader_changed'
    fader.plugincomponent = my_handle

    function my_table.fader_changed(caller)
        Value = caller.value
    end
    
    repeat
        coroutine.yield(0.1)
    until not IsObjectValid(dialog)
    Echo(Value)
end
