local plugintable, thiscomponent = select(3, ...)

local popuplists = {fruit = {'apple','banana','peach'}, animal = {'monkey','horse','dog','cat'}}

function plugintable.mypopup(caller)
  local itemlist = popuplists[caller.Name]
  local _, choice = PopupInput{title = caller.Name, caller = caller:GetDisplay(), items = itemlist, selectedValue = caller.Text}
  caller.Text = choice or caller.Text
end
  
return function ()
  local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
  dialog.H, dialog.W = 200, 400
  dialog = dialog:Append('UILayoutGrid')
  dialog.Rows = 2
  
  local button = dialog:Append('Button')
  button.Anchors = '0,0'
  button.Name, button.Text = 'fruit', 'please choose fruit'
  button.PluginComponent, button.Clicked = thiscomponent, 'mypopup' 
  
  local button1 = dialog:Append('Button')
  button1.Anchors = '0,1'
  button1.Name, button1.Text = 'animal', 'please choose animal'
  button1.PluginComponent, button1.Clicked = thiscomponent, 'mypopup' 
end