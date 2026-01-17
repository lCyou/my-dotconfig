local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.icon_map")

-- Aerospaceのワークスペース設定
local aerospace_workspaces = {
	"1", "2", "3", "4", "5", "6", "7", "8", "9",
	"A", "B", "C", "D", "E", "F", "G", 
	"I", "M", "N", "O", "P", "Q", "R", "S", "T", 
	"U", "V", "W", "X", "Y", "Z"
}

local spaces = {}

-- 各ワークスペースのアイテムを作成
for i, workspace_name in ipairs(aerospace_workspaces) do
	local space = sbar.add("item", "aerospace.space." .. workspace_name, {
		icon = {
			font = {
				family = settings.font.numbers,
				size = 14,
			},
			string = workspace_name,
			padding_left = 5,
			padding_right = 0,
			color = colors.mono_white,
			highlight_color = colors.mono_bg,
		},
		label = {
			padding_right = 10,
			padding_left = 3,
			color = colors.mono_white,
			font = "sketchybar-app-font-bg:Regular:21.0",
			y_offset = -2,
		},
		padding_right = 4,
		padding_left = 4,
		background = {
			color = colors.transparent,
			height = 22,
			border_width = 0,
			border_color = colors.transparent,
		},
	})

	spaces[workspace_name] = space

	-- クリックでワークスペースを切り替え
	space:subscribe("mouse.clicked", function(env)
		sbar.exec("aerospace workspace " .. workspace_name)
	end)

	-- パディングスペース
	sbar.add("item", "aerospace.space.padding." .. workspace_name, {
		width = settings.group_paddings,
	})
end

-- 全スペースを囲むブラケット
local bracket_items = {}
for _, workspace_name in ipairs(aerospace_workspaces) do
	table.insert(bracket_items, spaces[workspace_name].name)
end

sbar.add("bracket", bracket_items, {
	background = {
		color = colors.mono_bg,
		border_color = colors.mono_border,
		border_width = 2,
	},
})

-- スペースの状態を更新する関数
local function update_spaces()
	-- 現在フォーカスされているワークスペースを取得
	sbar.exec("aerospace list-workspaces --focused --format '%{workspace}'", function(focused_output)
		local focused_workspace = focused_output:match("^%s*(.-)%s*$") -- trim whitespace
		
		-- 各ワークスペースのウィンドウを取得してアイコンを更新
		for _, workspace_name in ipairs(aerospace_workspaces) do
			sbar.exec(
				"aerospace list-windows --workspace " .. workspace_name .. " --format '%{app-name}'",
				function(windows_output)
					local icon_line = ""
					local app_count = {}
					local no_app = true

					-- 各行（アプリ名）を処理
					for app_name in windows_output:gmatch("[^\r\n]+") do
						if app_name and app_name ~= "" then
							no_app = false
							app_count[app_name] = (app_count[app_name] or 0) + 1
						end
					end

					-- アイコン文字列を作成
					for app_name, _ in pairs(app_count) do
						local lookup = app_icons[app_name]
						local icon = ((lookup == nil) and app_icons["default"] or lookup)
						icon_line = icon_line .. " " .. icon
					end

					-- アプリがない場合
					if no_app then
						icon_line = "—"
					end

					-- ワークスペースが選択されているかチェック
					local is_selected = (workspace_name == focused_workspace)

					-- 表示を更新
					spaces[workspace_name]:set({
						label = { string = icon_line },
						icon = { highlight = is_selected },
						background = {
							height = is_selected and 25 or 22,
							border_color = is_selected and colors.mono_white or colors.transparent,
							color = is_selected and colors.mono_white or colors.transparent,
							corner_radius = is_selected and 6 or 0,
						},
					})
				end
			)
		end
	end)
end

-- 定期的に更新（2秒ごと）
sbar.add("item", {
	position = "right",
	drawing = false,
	update_freq = 2,
}):subscribe("routine", function()
	update_spaces()
end)

-- 初期更新
update_spaces()

return spaces
