Mod link: https://www.moddb.com/mods/stalker-anomaly/addons/health-and-weather-based-saturation

This mod assigns saturation level to each weather groups


I strongly recommend to use alongside with:
	* DX9 Time and Weather Based Bloom and Sunshafts
	* Michikos Weather Revamp Revised
	* Dynamic Time-based Tonemap Extended

Not currently compatible with:
	* AyyKyu's Screen Effects Modified by Handsome_ooyeah


How to configure this mod:
- Currently no MCM support, if someone can make an MCM support for this addon then please
  contact me.

To configure, open the script in "gamedata/scripts/health_and_weather_based_saturation.script"
with a text editor (notepad, notepad++, sublime text, vim, nvim, etc.) and edit these
variables's value at the beginning of the script:

	Note: The values should be within 0 - 2 or else the console will be spammed with
	"Invalid Arguments" log message.

	* local HEALTH_BASED (true by default)
		- replacing the value with "false" disables the actor health multiplier and the
		  saturation level will now only base on the assigned saturation value of a
		  weather's group
	* local DEBUG_MODE (false by default)
		- for debug mode especially when playing on the weather editor
	* local BRIGHT_WEATHER_SATURATION (1.5 by default)
	* local SLIGHTLY_BRIGHT_WEATHER_SATURATION (1.3 by default)
	* local CLOUDY_WEATHER_SATURATION (1 by default)
	* local STORMY_RAINY_WEATHER_SATURATION (0.8 by default)
	* local BLOWOUT_PSISTORM_WEATHER_SATURATION (1 by default)
	* local UNDERGROUND_MAP_SATURATION (1.5 by default)

	Below these individual variables are their corresponding weather presets or files

Tips:
	* By pressing "9" (not the numpad) you can view some logs in the console pane by
	  pressing "`". Maybe it can help on debugging or reporting some bugs in the Moddb site.

Installation:
	* Extract the archive
	* copy the "gamedata" folder to your Anomaly directory folder

Uninstallation:
	* just delete the "health_and_weather_based_saturation.script" inside
	  "<Anomaly Directory Folder>/gamedata/scripts"

