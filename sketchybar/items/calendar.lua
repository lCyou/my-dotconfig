local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

-- 時計
local cal_clock = sbar.add("item", {
	icon = {
		drawing = "off",
	},
	label = {
		color = colors.mono_white,
		padding_right = 0,
		align = "right",
		font = { family = settings.font.numbers },
		y_offset = 4,
	},
	position = "right",
	update_freq = 1,
	padding_left = -30,
	padding_right = 8,
})

local cal_day = sbar.add("item", {
	icon = {
		drawing = "off",
	},
	label = {
		color = colors.mono_white,
		padding_right = 0,
		align = "right",
		font = { family = settings.font.numbers },
		y_offset = -6,
	},
	position = "right",
	update_freq = 1,
	padding_left = 0,
	padding_right = 0,
})

-- 月
local cal_month = sbar.add("item", {
	icon = {
		drawing = "off",
	},
	label = {
		color = colors.mono_white,
		padding_right = 0,
		align = "right",
		font = { family = settings.font.numbers },
		y_offset = -6,
	},
	position = "right",
	update_freq = 1,
	padding_left = 0,
	padding_right = 0,
})


-- 曜日
local cal_day_of_week = sbar.add("item", {
	icon = {
		drawing = "off",
	},
	label = {
		color = colors.mono_white,
		padding_right = 0,
		align = "right",
		font = { family = settings.font.numbers },
		y_offset = -6,
	},
	position = "right",
	update_freq = 1,
	padding_left = 0,
	padding_right = 0,
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal_clock.name, cal_day.name, cal_month.name, cal_day_of_week.name }, {
	background = {
		color = colors.mono_bg,
		height = 28,
		border_color = colors.mono_border,
	},
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal_clock:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_clock:set({ label = os.date("%H:%M") })
end)

cal_month:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_month:set({ label = os.date("%b.") })
end)

cal_day_of_week:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_day_of_week:set({ label = os.date("%a.") })
end)

cal_day:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal_day:set({ label = os.date("%d") })
end)

-- add width
sbar.add("item", { position = "right", width = 0 })
