local CreateTimeEvent = demonized_time_events.CreateTimeEvent
local RemoveTimeEvent = demonized_time_events.RemoveTimeEvent

-- change the default value in "health_and_weather_based_saturation_mcm.script"
local HEALTH_BASED
local DEBUG_MODE

local W_CLEAR1_SATURATION
local W_CLEAR2_SATURATION
local W_PARTLY1_SATURATION

local W_FOGGY1_SATURATION
local W_FOGGY2_SATURATION
local W_RAIN1_SATURATION
local W_PARTLY2_SATURATION

local W_CLOUDY1_SATURATION
local W_CLOUDY2_DARK_SATURATION

local W_STORM1_SATURATION
local W_STORM2_SATURATION
local W_RAIN2_SATURATION
local W_RAIN3_SATURATION

local FX_BLOWOUT_DAY_SATURATION
local FX_BLOWOUT_NIGHT_SATURATION
local FX_PSI_STORM_DAY_SATURATION
local FX_PSI_STORM_NIGHT_SATURATION

local UNDERGROUND_MAP_SATURATION
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

local WEATHER = {
	w_clear1 = true,
	w_clear2 = true,
	w_partly1 = true,
	w_partly2 = true,
	w_foggy1 = true,
	w_foggy2 = true,
	w_cloudy1 = true,
	w_cloudy2_dark = true,
	w_rain1 = true,
	w_rain2 = true,
	w_rain3 = true,
	w_storm1 = true,
	w_storm2 = true,
	fx_blowout_day = true,
	fx_blowout_night = true,
	fx_psi_storm_day = true,
	fx_psi_storm_night = true,
}

local WEATHER_SATURATION = {
	w_clear1 = W_CLEAR1_SATURATION,
	w_clear2 = W_CLEAR2_SATURATION,
	w_partly1 = W_PARTLY1_SATURATION,
	w_partly2 = W_PARTLY2_SATURATION,
	w_foggy1 = W_FOGGY1_SATURATION,
	w_foggy2 = W_FOGGY2_SATURATION,
	w_cloudy1 = W_CLOUDY1_SATURATION,
	w_cloudy2_dark = W_CLOUDY2_DARK_SATURATION,
	w_rain1 = W_RAIN1_SATURATION,
	w_rain2 = W_RAIN2_SATURATION,
	w_rain3 = W_RAIN3_SATURATION,
	w_storm1 = W_STORM1_SATURATION,
	w_storm2 = W_STORM2_SATURATION,
	fx_blowout_day = FX_BLOWOUT_DAY_SATURATION,
	fx_blowout_night = FX_BLOWOUT_NIGHT_SATURATION,
	fx_psi_storm_day = FX_PSI_STORM_DAY_SATURATION,
	fx_psi_storm_night = FX_PSI_STORM_NIGHT_SATURATION,
}

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
	if not ui_mcm then
		return
	end

	HEALTH_BASED = ui_mcm.get("saturation/HEALTH_BASED")
	DEBUG_MODE = ui_mcm.get("saturation/DEBUG_MODE")

	W_CLEAR1_SATURATION = ui_mcm.get("saturation/W_CLEAR1_SATURATION")
	W_CLEAR2_SATURATION = ui_mcm.get("saturation/W_CLEAR2_SATURATION")

	W_PARTLY1_SATURATION = ui_mcm.get("saturation/W_PARTLY1_SATURATION")
	W_PARTLY2_SATURATION = ui_mcm.get("saturation/W_PARTLY2_SATURATION")

	W_FOGGY1_SATURATION = ui_mcm.get("saturation/W_FOGGY1_SATURATION")
	W_FOGGY2_SATURATION = ui_mcm.get("saturation/W_FOGGY2_SATURATION")

	W_RAIN1_SATURATION = ui_mcm.get("saturation/W_RAIN1_SATURATION")
	W_RAIN2_SATURATION = ui_mcm.get("saturation/W_RAIN2_SATURATION")
	W_RAIN3_SATURATION = ui_mcm.get("saturation/W_RAIN3_SATURATION")

	W_CLOUDY1_SATURATION = ui_mcm.get("saturation/W_CLOUDY1_SATURATION")
	W_CLOUDY2_DARK_SATURATION = ui_mcm.get("saturation/W_CLOUDY2_DARK_SATURATION")

	W_STORM1_SATURATION = ui_mcm.get("saturation/W_STORM1_SATURATION")
	W_STORM2_SATURATION = ui_mcm.get("saturation/W_STORM2_SATURATION")

	FX_BLOWOUT_DAY_SATURATION = ui_mcm.get("saturation/FX_BLOWOUT_DAY_SATURATION")
	FX_BLOWOUT_NIGHT_SATURATION = ui_mcm.get("saturation/FX_BLOWOUT_NIGHT_SATURATION")

	FX_PSI_STORM_DAY_SATURATION = ui_mcm.get("saturation/FX_PSI_STORM_DAY_SATURATION")
	FX_PSI_STORM_NIGHT_SATURATION = ui_mcm.get("saturation/FX_PSI_STORM_NIGHT_SATURATION")

	UNDERGROUND_MAP_SATURATION = ui_mcm.get("saturation/UNDERGROUND_MAP_SATURATION")
end

-- in order for the saturation to be more consistent
local FIRST_LEVEL_WEATHER = nil
function actor_on_first_update()
	if is_blowout_psistorm_weather() or DEBUG_MODE then
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
	local current_weather = FIRST_LEVEL_WEATHER

	-- assign the corresponding saturation to the weather inside WEATHER[]
	if WEATHER[current_weather] then
		saturation = WEATHER_SATURATION[current_weather]
	end

	-- assign saturation on underground levels
	if UNDERGROUND_MAPS[level_name] then
		saturation = UNDERGROUND_MAP_SATURATION
	end

	-- if the HEALTH_BASED option is true then the saturation will be multiplied
	-- to the actor health
	if HEALTH_BASED == true then
		get_console():execute("r__saturation " .. saturation * health)
	else
		get_console():execute("r__saturation " .. saturation)
	end
end

function is_blowout_psistorm_weather()
	local weather = get_current_weather_file()
	if weather == "fx_blowout_day" or weather == "fx_blowout_night" or
		weather == "fx_psi_storm_day" or weather == "fx_psi_storm_night" then
		return true
	end
	return false
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
	if key ~= DIK_keys["DIK_9"] then
		return
	end

	utils_data.debug_write("----- health_and_weather_based_saturation.script debug section -----")
	utils_data.debug_write("get_current_weather_file() " .. get_current_weather_file())
	printf("FIRST_LEVEL_WEATHER %s", FIRST_LEVEL_WEATHER)

	local inside = GetEvent("current_safe_cover") and true or false
	printf("inside %s", inside)

	if UNDERGROUND_MAPS[level.name()] then
		utils_data.debug_write("UNDERGROUND_MAPS is TRUE")
		printf("Saturation %s", UNDERGROUND_MAP_SATURATION * db.actor.health)
	end
end

