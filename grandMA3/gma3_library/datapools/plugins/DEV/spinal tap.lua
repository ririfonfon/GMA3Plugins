-------------------------------------------------------------------------------------------------------------------------
--------------------$$$$$$\------------$$\-------------------- $$\---- $$$$$$$$\-----------------------------------------
------------------ $$--__$$\---------- \__|--------------------$$ |----\__$$--__|----------------------------------------
------------------ $$ /--\__| $$$$$$\--$$\ $$$$$$$\-- $$$$$$\--$$ |------ $$ | $$$$$$\-- $$$$$$\-------------------------
------------------ \$$$$$$\--$$--__$$\ $$ |$$--__$$\--\____$$\ $$ |------ $$ | \____$$\ $$--__$$\------------------------
--------------------\____$$\ $$ /--$$ |$$ |$$ |--$$ | $$$$$$$ |$$ |------ $$ | $$$$$$$ |$$ /--$$ |-----------------------
------------------ $$\-- $$ |$$ |--$$ |$$ |$$ |--$$ |$$--__$$ |$$ |------ $$ |$$--__$$ |$$ |--$$ |-----------------------
------------------ \$$$$$$--|$$$$$$$--|$$ |$$ |--$$ |\$$$$$$$ |$$ |------ $$ |\$$$$$$$ |$$$$$$$--|-----------------------
--------------------\______/ $$--____/ \__|\__|--\__| \_______|\__|------ \__| \_______|$$--____/------------------------
---------------------------- $$ |--------"THE BEER-WARE LICENSE" (Revision 42):-------- $$ |-----------------------------
---------------------------- $$ |----Andreas Glad wrote this file.--As long as you------$$ |-----------------------------
---------------------------- $$ |-- retain this notice you can do whatever you want---- $$ |-----------------------------
---------------------------- $$ |--with this stuff. If we meet some day, and you think--$$ |-----------------------------
---------------------------- \__|this stuff is worth it, you can buy me a beer in return\__|-----------------------------
-------------------------------------------------------------------------------------------------------------------------

local maxdeviation, minsamples, maxsamples, speedmaster = 0.5, 4, 12, 1

local lasttimestamp, sampletime, lastsample, sampletable, averagetime = nil, 0, 0, {}, 0

-- formatting within Lua to workaround issues on mac os - thanks to mokaByls for debugging on mac
local Cmd = function(txt, ...) txt=txt:format(...) return Cmd(txt) end
local Echo = function(txt, ...) txt=txt:format(...) return Echo(txt) end

return function()
  local timestamp = Time()
  lasttimestamp = lasttimestamp or timestamp
  sampletime = timestamp - lasttimestamp
  lastsample = sampletable[#sampletable] or 0
  if sampletime > 0 and lastsample > 0 and sampletime-lastsample > maxdeviation or lastsample-sampletime > maxdeviation then
    Echo('Too much deviation on last tap (%.3fs), preparing new sampletable', sampletime)
    sampletable, lasttimestamp, sampletime = {}, timestamp, 0
  end
  if sampletime > 0 then
    Echo('Sampletime: %.3fs, %.0fBPM', sampletime, 60/sampletime)
    sampletable[#sampletable+1] = sampletime
    if #sampletable >= minsamples then
      averagetime = 0 for _, sample in ipairs(sampletable) do averagetime = averagetime + sample/#sampletable end
      Echo('Averagetime %.3fs, %.0fBPM (%i samples)', averagetime, 60/averagetime, #sampletable)
      Cmd('FaderMaster Master 3.%i At %.4f', speedmaster, math.sqrt(0.25/averagetime)*100)
    end
    if #sampletable >= maxsamples then table.remove(sampletable, 1) end
  else
    Echo('Awaiting next tap')
  end
  lasttimestamp, lastsample = timestamp, sampletime
end
