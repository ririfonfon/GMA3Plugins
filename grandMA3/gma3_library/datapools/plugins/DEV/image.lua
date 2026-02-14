return function ()
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    local AppearObject = Root().ShowData.Appearances

    dialog.H, dialog.W = 100, 400

    local mybutton = dialog:Append('Button') 
    mybutton.Text = 'Hello World'
    local myicon = dialog:Append('AppearancePreview') 
    myicon.Appearance = AppearObject[955]
    -- myicon.Appearance = GetObject('Image 3.1')
    myicon.BackColor, myicon.W = 'Global.Transparent', 60
    myicon.Interactive = 'No'
end