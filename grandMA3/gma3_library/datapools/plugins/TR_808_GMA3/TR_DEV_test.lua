local function main()

    Cmd('cd datapool "TR_808_GMA3"')
    GetObject('Macro 85.1').Command = 'SetUservariable "A_TR_Solo" +1$A_TR_Solo'
end

return main