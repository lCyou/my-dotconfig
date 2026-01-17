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
			highlight_color = colors.mono_bg,
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

-- 全スペースを囲むブラケット（削除または調整が必要な場合はコメントアウト）
-- 注: 空のワークスペースを非表示にする場合、ブラケットは使わない方が良い
-- local bracket_items = {}
-- for _, workspace_name in ipairs(aerospace_workspaces) do
-- 	table.insert(bracket_items, spaces[workspace_name].name)
-- end
-- 
-- sbar.add("bracket", bracket_items, {
-- 	background = {
-- 		color = colors.mono_bg,
-- 		border_color = colors.mono_border,
-- 		border_width = 2,
-- 	},
-- })

-- スペースの状態を更新する関数
local function update_spaces()
	-- まず全てのワークスペースを非表示にする
	for _, workspace_name in ipairs(aerospace_workspaces) do
		spaces[workspace_name]:set({ drawing = false })
		sbar.set("aerospace.space.padding." .. workspace_name, { drawing = false })
	end

	-- 現在フォーカスされているワークスペースを取得
	sbar.exec("aerospace list-workspaces --focused --format '%{workspace}'", function(focused_output)
		local focused_workspace = focused_output:match("^%s*(.-)%s*$") -- trim whitespace
		
		-- 空でないワークスペース（ウィンドウがあるワークスペース）を取得
		sbar.exec("aerospace list-workspaces --monitor all --empty no", function(workspaces_output)
			local active_workspaces = {}
			
			-- アクティブなワークスペース一覧を作成
			for workspace_name in workspaces_output:gmatch("[^\r\n]+") do
				if workspace_name and workspace_name ~= "" then
					active_workspaces[workspace_name] = true
				end
			end
			
			-- フォーカスされているワークスペースも追加（空でも表示するため）
			if focused_workspace and focused_workspace ~= "" then
				active_workspaces[focused_workspace] = true
			end
			
			-- アクティブなワークスペースのみ処理
			for workspace_name, _ in pairs(active_workspaces) do
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
						drawing = true,
						label = { 
							string = icon_line,
							highlight = is_selected,
						},
						icon = { highlight = is_selected },
						background = {
							height = is_selected and 25 or 22,
							border_color = is_selected and colors.mono_white or colors.transparent,
							color = is_selected and colors.mono_white or colors.transparent,
							corner_radius = is_selected and 6 or 0,
						},
					})

						-- パディングも表示
						sbar.set("aerospace.space.padding." .. workspace_name, {
							drawing = true,
						})
					end
				)
			end
		end)
	end)
end

-- カスタムイベントを作成（Aerospaceのコールバックから呼び出される）
sbar.add("event", "aerospace_workspace_change")

-- イベントリスナーを追加
local event_listener = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Aerospaceのワークスペース切り替え時に更新
event_listener:subscribe("aerospace_workspace_change", function(env)
	update_spaces()
end)

-- アプリケーション切り替え時にも更新（ウィンドウが開いた/閉じた可能性があるため）
event_listener:subscribe("front_app_switched", function(env)
	update_spaces()
end)

-- 初期更新
update_spaces()

return spaces
