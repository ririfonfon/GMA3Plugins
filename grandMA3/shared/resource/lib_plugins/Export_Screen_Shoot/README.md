# Export_Screen_Shots v1.0.0.4
Please note that this will likly break in future version of the console. and to use at your own risk.

#### Usage:
* Call Plugin "Export_Screen_Shots"
* Selected a drive and a directory. The plugin will copy 
  any screen shots (with the name *display*.png) to selected USB stick
  in the selcted folder

#### Issues:
* The console currently enumerates all disk connected to the console including 
  pervious versions (?) This may cause some skipped files even with the USB key
  dot not include the selected file
* The copied files are not checked for consistancy, this could be done but did
  not seem nessassary
* If a file exists on a key with the exact name the fill will be skipped and noted
  in the System Monitor
* if the key does not have the grandMA3 folder structure the copy will fail and all
  files will be skipped. Store a show to the stick first.

#### Releases:
* 1.0.0.1 - Inital release
* 1.0.0.2 - Fixed a path 
* 1.0.0.3 - Buggs
* 1.0.0.4 - Add Drive & select folder