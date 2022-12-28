function on_mcm_load()
	op = {
		id = "saturation",
		sh = true,
		gr = {
			{id = "title", type = "slide", link = "ui_options_slider_player", text = "ui_mcm_health_and_weather_title", size = {512, 50}, spacing = 20 },
			{id = "HEALTH_BASED", type = "check", val = 1, def = true},
			{id = "divider", type = "line"},
			{id = "DEBUG_MODE", type = "check", val = 1, def = false},
		}
	}
	return op
end
