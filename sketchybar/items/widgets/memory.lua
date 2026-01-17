local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "memory_update" for
-- the memory load data, which is fired every 1.0 second.
sbar.exec(
	"killall memory_load >/dev/null; $CONFIG_DIR/helpers/event_providers/memory_load/bin/memory_load memory_update 1.0"
)

local memory_graph = sbar.add("graph", "widgets.memory.graph", 60, {
	position = "right",
	height = 27,
	graph = {
		color = colors.mono_white,
		-- fill_color = colors.mono_white,
		line_width = 1.0,
	},
	y_offset = 4,
	padding_right = 0,
	padding_left = -10,
})

local memory = sbar.add("item", "widgets.memory", {
	position = "right",
	background = {
		height = 22,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = {
		string = icons.memory,
		font = { size = 23 },
		color = colors.mono_white,
	},
	label = {
		string = "??%",
		color = colors.mono_white,
		font = {
			family = settings.font.numbers,
			-- style = settings.font.style_map["Bold"],
		},
		align = "right",
	},
	padding_right = 0,
	padding_left = 5,
})

-- Background around the memory item
local bracket = sbar.add("bracket", "widgets.memory.bracket", { memory_graph.name, memory.name }, {
	background = { color = colors.mono_bg, border_color = colors.mono_border },
})
memory_graph:subscribe("memory_update", function(env)
	-- Fetch the used memory percentage from the event provider
	local used_percentage = tonumber(env.used_percentage)
	-- Due what height is not enabled to be set in the graph, divide the value by 150.0
	memory_graph:push({ used_percentage / 150.0 })

	local alpha = 0.4
	local color = colors.mono_white
	local fill_color = colors.with_alpha(colors.mono_white, alpha)
	if used_percentage > 30 then
		if used_percentage < 60 then
			color = colors.mono_light_gray
			fill_color = colors.with_alpha(colors.mono_light_gray, alpha)
		elseif used_percentage < 80 then
			color = colors.mono_gray
			fill_color = colors.with_alpha(colors.mono_gray, alpha)
		else
			color = colors.mono_dark_gray
			fill_color = colors.with_alpha(colors.mono_dark_gray, alpha)
		end
	end

	memory_graph:set({
		graph = { color = color, fill_color = fill_color },
	})
	memory:set({
		label = {
			string = string.format("%d", math.floor(used_percentage)) .. "%",
			color = color,
		},

		icon = { color = color },
	})
	bracket:set({ background = { border_color = color } })
end)

memory:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Activity Monitor'")
end)

-- Padding around the memory item
sbar.add("item", "widgets.memory.padding", {
	position = "right",
	width = settings.group_paddings,
})

sbar.add("item", { position = "right", width = 6 })
