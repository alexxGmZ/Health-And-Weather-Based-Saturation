local CreateTimeEvent = demonized_time_events.CreateTimeEvent
local RemoveTimeEvent = demonized_time_events.RemoveTimeEvent

-- Change the value to "false" if you don't want the health based aspect
local HEALTH_BASED = true

-- Change the value to "true" if you are planning to play around the debug mode
-- especially the weather editor
local DEBUG_MODE = false

local W_CLEAR1_SATURATION = 1.5
local W_CLEAR2_SATURATION = 1.5
local W_PARTLY1_SATURATION = 1.5

local W_FOGGY1_SATURATION = 1.3
local W_FOGGY2_SATURATION = 1.3
local W_RAIN1_SATURATION = 1.3
local W_PARTLY2_SATURATION = 1.3

local W_CLOUDY1_SATURATION = 1
local W_CLOUDY2_DARK_SATURATION = 1

local W_STORM1_SATURATION = 0.8
local W_STORM2_SATURATION = 0.8
local W_RAIN2_SATURATION = 0.8
local W_RAIN3_SATURATION = 0.8

local FX_BLOWOUT_DAY_SATURATION = 1
local FX_BLOWOUT_NIGHT_SATURATION = 1
local FX_PSI_STORM_DAY_SATURATION = 1
local FX_PSI_STORM_NIGHT_SATURATION = 1

local UNDERGROUND_MAP_SATURATION = 1.5
local UNDERGROUND_MAPS = {
	l03u_agr_underground = true,
	l08u_brainlab = true,
	l10u_bunker = true,
	jupiter_underground = true,
	l04u_labx18 = true,
	labx8 = true,
	l12u_sarcofag = true,
	l12u_control_monolith = true,
	l13u_warlab = true
}

local INDOOR_SATURATION = 1.5

function on_game_start()
	-- MCM stuff
	RegisterScriptCallback("on_option_change", load_settings)
	RegisterScriptCallback("actor_on_first_update", load_settings)

	RegisterScriptCallback("actor_on_update", actor_on_update)
	RegisterScriptCallback("actor_on_first_update", actor_on_first_update)
	RegisterScriptCallback("actor_on_sleep", actor_on_sleep)
	RegisterScriptCallback("on_key_release", on_key_release)
end

-- for MCM Support
function load_settings()
	if ui_mcm then
		HEALTH_BASED = ui_mcm.get("saturation/HEALTH_BASED")

		W_CLEAR1_SATURATION = ui_mcm.get("saturation/W_CLEAR1_SATURATION")
		W_CLEAR2_SATURATION = ui_mcm.get("saturation/W_CLEAR2_SATURATION")
		W_PARTLY1_SATURATION = ui_mcm.get("saturation/W_PARTLY1_SATURATION")
		W_PARTLY2_SATURATION = ui_mcm.get("saturation/W_PARTLY2_SATURATION")

		UNDERGROUND_MAP_SATURATION = ui_mcm.get("saturation/UNDERGROUND_MAP_SATURATION")
		DEBUG_MODE = ui_mcm.get("saturation/DEBUG_MODE")
	end
end

-- in order for the saturation to be more consistent
local FIRST_LEVEL_WEATHER = nil
function actor_on_first_update()
	if is_blowout_psistorm_weather() or DEBUG_MODE == true then
		FIRST_LEVEL_WEATHER = nil
	else
		FIRST_LEVEL_WEATHER = get_current_weather_file()
	end
	RemoveTimeEvent("reset_first_weather", "reset_first_weather")
end

function actor_on_update()
	if not (db.actor:alive()) then
		return
	end

	local saturation = 1
	local health = db.actor.health
	local level_name = level.name()
	local current_weather = get_current_weather_file()

	-- clear weather
	if current_weather == "w_clear1" then
		saturation = W_CLEAR1_SATURATION
	end
	if current_weather == "w_clear2" then
		saturation = W_CLEAR2_SATURATION
	end

	-- partly clear weather
	if current_weather == "w_partly1" then
		saturation = W_PARTLY1_SATURATION
	end
	if current_weather == "w_partly2" then
		saturation = W_PARTLY2_SATURATION
	end

	-- foggy weather
	if current_weather == "w_foggy1" then
		saturation = W_FOGGY1_SATURATION
	end
	if current_weather == "w_foggy2" then
		saturation = W_FOGGY2_SATURATION
	end

	-- rainy weather
	if current_weather == "w_rain1" then
		saturation = W_RAIN1_SATURATION
	end
	if current_weather == "w_rain2" then
		saturation = W_RAIN2_SATURATION
	end
	if current_weather == "w_rain3" then
		saturation = W_RAIN3_SATURATION
	end

	-- cloudy weather
	if current_weather == "w_cloudy1" then
		saturation = W_CLOUDY1_SATURATION
	end
	if current_weather == "w_cloudy2_dark" then
		saturation = W_CLOUDY2_DARK_SATURATION
	end

	-- stormy weather
	if current_weather == "w_storm1" then
		saturation = W_STORM1_SATURATION
	end
	if current_weather == "w_storm2" then
		saturation = W_STORM2_SATURATION
	end

	-- emission
	if current_weather == "fx_blowout_day" then
		saturation = FX_BLOWOUT_DAY_SATURATION
	end
	if current_weather == "fx_blowout_night" then
		saturation = FX_BLOWOUT_NIGHT_SATURATION
	end

	-- psi storm
	if current_weather == "fx_psi_storm_day" then
		saturation = FX_PSI_STORM_DAY_SATURATION
	end
	if current_weather == "fx_psi_storm_night" then
		saturation = FX_PSI_STORM_NIGHT_SATURATION
	end


	-- if the HEALTH_BASED option is true then the saturation will be multiplied
	-- to the actor health
	if HEALTH_BASED == true then
		get_console():execute("r__saturation " .. saturation * health)
	else
		get_console():execute("r__saturation " .. saturation)
	end
end

function actor_on_sleep()
	-- actor_on_first_update()
	CreateTimeEvent("reset_first_weather", "reset_first_weather", 3, actor_on_first_update)
end

function get_current_weather_file()
	return level.get_weather()
end

-- for debugging purposes
function on_key_release(key, stalker)
	if key == DIK_keys["DIK_9"] then
		utils_data.debug_write("----- health_and_weather_based_saturation.script debug section -----")
		utils_data.debug_write("get_current_weather_file() " .. get_current_weather_file())
		printf("FIRST_LEVEL_WEATHER %s", FIRST_LEVEL_WEATHER)

		local inside = GetEvent("current_safe_cover") and true or false
		printf("inside %s", inside)

		if is_bright_weather() then
			utils_data.debug_write("is_bright_weather() is TRUE")
			printf("Saturation %s", BRIGHT_WEATHER_SATURATION * db.actor.health)
		end

		if is_slightly_bright_weather() then
			utils_data.debug_write("is_slightly_bright_weather() is TRUE")
			printf("Saturation %s", SLIGHTLY_BRIGHT_WEATHER_SATURATION * db.actor.health)
		end

		if is_cloudy_weather() then
			utils_data.debug_write("is_cloudy_weather() is TRUE")
			printf("Saturation %s", CLOUDY_WEATHER_SATURATION * db.actor.health)
		end

		if is_stormy_rainy_weather() then
			utils_data.debug_write("is_stormy_rainy_weather() is TRUE")
			printf("Saturation %s", STORMY_RAINY_WEATHER_SATURATION * db.actor.health)
		end

		if is_blowout_psistorm_weather() then
			utils_data.debug_write("is_blowout_psistorm_weather() is TRUE")
			printf("Saturation %s", BLOWOUT_PSISTORM_WEATHER_SATURATION * db.actor.health)
		end

		if UNDERGROUND_MAPS[level.name()] then
			utils_data.debug_write("UNDERGROUND_MAPS is TRUE")
			printf("Saturation %s", UNDERGROUND_MAP_SATURATION * db.actor.health)
		end
	end
end

