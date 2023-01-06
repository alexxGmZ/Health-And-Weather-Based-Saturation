local FIRST_LEVEL_WEATHER = nil
local DEBUG_MODE

function on_game_start()
	RegisterScriptCallback("on_option_change", load_settings)
	RegisterScriptCallback("actor_on_first_update", load_settings)

	RegisterScriptCallback("actor_on_first_update", actor_on_first_update)
	RegisterScriptCallback("actor_on_sleep", actor_on_sleep)
	RegisterScriptCallback("actor_on_update", real_engine_weather)
end

-- determine debug mode option
function load_settings()
	if not ui_mcm then
		return
	end

	DEBUG_MODE = ui_mcm.get("saturation/DEBUG_MODE")
end

-- put a value for FIRST_LEVEL_WEATHER
function actor_on_first_update()
	if is_blowout_psistorm_weather() or DEBUG_MODE then
		FIRST_LEVEL_WEATHER = nil
	else
		FIRST_LEVEL_WEATHER = get_current_weather()
	end
	RemoveTimeEvent("mcm_first_weather", "mcm_first_weather")
end

-- reset first level weather
function actor_on_sleep()
	CreateTimeEvent("mcm_first_weather", "mcm_first_weather", 3, actor_on_first_update)
end

-- when it is blowout or psi storm, this weather will be used
function real_engine_weather()
	return get_current_weather()
end

function on_mcm_load()
	op = {
		id = "saturation",
		sh = true,
		gr = {
			{id = "title", type = "slide", link = "ui_options_slider_player", text = "ui_mcm_health_and_weather_title", size = {512, 50}, spacing = 20 },

			{id = "current_weather",
				type = "desc",
				text = "Current Weather: " .. FIRST_LEVEL_WEATHER
			},

			{id = "HEALTH_BASED", type = "check", val = 1, def = true},
			{id = "DEBUG_MODE", type = "check", val = 1, def = false},
			{id = "divider", type = "line"},

			-- clear weather
			{id = "W_CLEAR1_SATURATION",
				type = "track",
				val = 2,
				def = 1.5,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_CLEAR2_SATURATION",
				type = "track",
				val = 2,
				def = 1.5,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- partly weather
			{id = "W_PARTY1_SATURATION",
				type = "track",
				val = 2,
				def = 1.5,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_PARTY2_SATURATION",
				type = "track",
				val = 2,
				def = 1.3,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- foggy weather
			{id = "W_FOGGY1_SATURATION",
				type = "track",
				val = 2,
				def = 1.3,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_FOGGY2_SATURATION",
				type = "track",
				val = 2,
				def = 1.3,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- rainy weather
			{id = "W_RAIN1_SATURATION",
				type = "track",
				val = 2,
				def = 1.3,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_RAIN2_SATURATION",
				type = "track",
				val = 2,
				def = 0.8,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_RAIN3_SATURATION",
				type = "track",
				val = 2,
				def = 0.8,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- cloudy weather
			{id = "W_CLOUDY1_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_CLOUDY2_DARK_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- stormy weather
			{id = "W_STORM1_SATURATION",
				type = "track",
				val = 2,
				def = 0.8,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "W_STORM2_SATURATION",
				type = "track",
				val = 2,
				def = 0.8,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- psi storm weather
			{id = "FX_PSI_STORM_DAY_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "FX_PSI_STORM_NIGHT_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},

			-- emission
			{id = "FX_BLOWOUT_DAY_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},
			{id = "FX_BLOWOUT_NIGHT_SATURATION",
				type = "track",
				val = 2,
				def = 1,
				min = 0.02,
				max = 2,
				step = 0.01
			},
		}
	}
	return op
end

function get_current_weather()
	return level.get_weather()
end

-- determine if weather is psi storm or emission
function is_blowout_psistorm_weather()
	local weather = get_current_weather()
	if weather == "fx_blowout_day" or weather == "fx_blowout_night" or
		weather == "fx_psi_storm_day" or weather == "fx_psi_storm_night" then
		return true
	end
	return false
end
