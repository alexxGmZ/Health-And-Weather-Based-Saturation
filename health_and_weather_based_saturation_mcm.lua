function on_mcm_load()
	op = {
		id = "saturation",
		sh = true,
		gr = {
			{id = "title", type = "slide", link = "ui_options_slider_player", text = "ui_mcm_health_and_weather_title", size = {512, 50}, spacing = 20 },

			{id = "current_weather",
				type = "desc",
				text = "Current Weather: " .. get_current_weather()
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

function on_game_start()
	RegisterScriptCallback("actor_on_first_update", get_current_weather)
end

function get_current_weather()
	return level.get_weather()
end
