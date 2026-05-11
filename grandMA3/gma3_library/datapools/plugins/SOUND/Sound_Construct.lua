--[[
Releases:
* 2.3.2.0

Version :
* 0.0.0.9

Created by Richard Fontaine "RIRI", April 2026.
--]]

function Sound_Dialog_End(message)
    local dialog = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    dialog.H, dialog.W = 800, 800
    local mybutton = dialog:Append('Button')
    mybutton.Font = 1
    mybutton.TextAutoAdjust = "Yes"
    mybutton.Text = message
end

function Sound_Construct(Construct_Pool, Grp_Start, All_4_NrStart, Univers, Address, Fid, SeqNrStart, MacroNrStart,
                         TLayNr, NaLay, aprefix)
    Sound_Dialog_End('Sound By Riri Build A Layout')
    Cmd('ClearAll')
    Cmd('Store DataPool ' .. Construct_Pool .. ' Group ' .. Grp_Start .. ' /Overwrite /NoConfirmation')
    Cmd('Store DataPool ' .. Construct_Pool .. ' Preset 24.' .. All_4_NrStart .. ' /Overwrite /NoConfirmation')

    local prefix      = { '"A"', '"B"' }
    -- local Build_Pool  = Root().ShowData.DataPools[Construct_Pool]
    -- local Call_Pool   = thiscomponent:FindParent(DataPool():GetClass())
    local MacroObject = Root().ShowData.DataPools[Construct_Pool].Macros
    local MacroNum    = 999
    NaLay             = '"' .. NaLay .. '"'

    SOUND_Check_Size_Pool(MacroNum, MacroObject)
    MacroObject:Create(MacroNum)
    MacroObject[MacroNum]:Set('Name', 'Construct_Sound')
    for a = 1, 15 do
        MacroObject[MacroNum]:Insert(a)
    end
    MacroObject[MacroNum][1]:Set('Command',
        "Lua'SOUND_Patch(" .. Univers .. ", " .. Address .. ", " .. Fid .. ", " .. prefix[1] .. ")")
    MacroObject[MacroNum][2]:Set('Command',
        "Lua'SOUND_Build_Seq(" .. Construct_Pool .. ", " .. SeqNrStart .. ", " .. All_4_NrStart .. ", " ..
        Grp_Start .. ", " .. Fid .. ", " .. prefix[1] .. ")")
    MacroObject[MacroNum][2]:Set('Wait', 2)
    MacroObject[MacroNum][3]:Set('Command', "Lua'SOUND_Build_Macro(" .. Construct_Pool ..
        ", " .. MacroNrStart .. ", " .. TLayNr .. ", " .. prefix[1] .. ")")
    MacroObject[MacroNum][3]:Set('Wait', 2)
    MacroObject[MacroNum][4]:Set('Command',
        "Lua'SOUND_Remote_Dmx(" ..
        Construct_Pool .. ", " .. SeqNrStart .. ", " .. Univers .. ", " .. Address .. ", " .. prefix[1] .. ")")
    MacroObject[MacroNum][4]:Set('Wait', 2)
    MacroObject[MacroNum][5]:Set('Command',
        "Lua'SOUND_Build_Layout(" .. Construct_Pool .. ", " .. NaLay ..
        ", " .. TLayNr .. ", " .. MacroNrStart .. ", " .. SeqNrStart + 11 .. ", " .. prefix[1] .. ")")

    MacroObject[MacroNum][6]:Set('Command',
        "Lua'SOUND_Patch(" .. Univers .. ", " .. Address .. ", " .. Fid .. ", " .. prefix[2] .. ")")
    MacroObject[MacroNum][7]:Set('Command',
        "Lua'SOUND_Build_Seq(" .. Construct_Pool .. ", " .. SeqNrStart .. ", " .. All_4_NrStart .. ", " ..
        Grp_Start .. ", " .. Fid .. ", " .. prefix[2] .. ")")
    MacroObject[MacroNum][7]:Set('Wait', 2)
    MacroObject[MacroNum][8]:Set('Command', "Lua'SOUND_Build_Macro(" .. Construct_Pool ..
        ", " .. MacroNrStart .. ", " .. TLayNr .. ", " .. prefix[2] .. ")")
    MacroObject[MacroNum][8]:Set('Wait', 2)
    MacroObject[MacroNum][9]:Set('Command',
        "Lua'SOUND_Remote_Dmx(" ..
        Construct_Pool .. ", " .. SeqNrStart .. ", " .. Univers .. ", " .. Address .. ", " .. prefix[2] .. ")")
    MacroObject[MacroNum][9]:Set('Wait', 2)
    MacroObject[MacroNum][10]:Set('Command',
        "Lua'SOUND_Build_Layout(" .. Construct_Pool .. ", " .. NaLay ..
        ", " .. TLayNr .. ", " .. MacroNrStart .. ", " .. SeqNrStart + 11 .. ", " .. prefix[2] .. ")")
    MacroObject[MacroNum][10]:Set('Wait', 2)
    MacroObject[MacroNum][11]:Set('Command', "")
    MacroObject[MacroNum][11]:Set('Wait', 2)
    MacroObject[MacroNum][12]:Set('Command', "Lua'SOUND_Patch_Cross(" .. Univers .. ", " .. Address .. ", " .. Fid .. ")")
    MacroObject[MacroNum][12]:Set('Wait', 2)
    MacroObject[MacroNum][13]:Set('Command',
        "Lua'SOUND_Remote_Dmx_Cross(" .. Construct_Pool .. ", " .. Grp_Start .. ", " .. Univers .. ", " .. Address .. ")")
    MacroObject[MacroNum][13]:Set('Wait', 2)
    MacroObject[MacroNum][14]:Set('Command', "")
    MacroObject[MacroNum][14]:Set('Wait', 2)
    MacroObject[MacroNum][15]:Set('Command',
        "Delete DataPool " .. Construct_Pool .. " Macro " .. MacroNum .. "/NoConfirmation")

    Cmd('Go+ DataPool ' .. Construct_Pool .. ' Macro 999')

end
