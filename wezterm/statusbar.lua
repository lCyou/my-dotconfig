local wezterm = require("wezterm")

-- 定数定義
local DEFAULT_BG = { Color = 'rgba(0, 0, 0, 0)' }
local DEFAULT_FG = { Color = '#ffffff' }
local SPACE_1 = ' '
local SPACE_3 = '   '

local HEADER_HOST = { Foreground = { Color = '#75b1a9' }, Text = wezterm.nerdfonts.fa_laptop .. ' ' }
local HEADER_CWD = { Foreground = { Color = '#92aac7' }, Text = wezterm.nerdfonts.cod_folder_opened }
local HEADER_DATE = { Foreground = { Color = '#ffccac' }, Text = wezterm.nerdfonts.md_calendar_multiselect }
local HEADER_TIME = { Foreground = { Color = '#bcbabe' }, Text = wezterm.nerdfonts.fa_clock_o }
local HEADER_BATTERY = { Foreground = { Color = '#dfe166' }, Text = wezterm.nerdfonts.fa_battery_3 }

local function AddElement(elems, header, str)
  table.insert(elems, { Foreground = header.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = header.Text .. SPACE_1 })

  table.insert(elems, { Foreground = DEFAULT_FG })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = str .. SPACE_3 })
end


local function GetHostAndCwd(elems, pane)
  local uri = pane:get_current_working_dir()

  if not uri then
    return
  end

  local cwd_uri = uri:sub(8)
  local slash = cwd_uri:find '/'

  if not slash then
    return
  end

  local host = cwd_uri:sub(1, slash - 1)
  local dot = host:find '[.]'

  AddElement(elems, HEADER_HOST, dot and host:sub(1, dot - 1) or host)
  AddElement(elems, HEADER_CWD, cwd_uri:sub(slash))
end

local function GetDate(elems)
  AddElement(elems, HEADER_DATE, wezterm.strftime '%a %b %-d')
end

local function GetTime(elems)
  AddElement(elems, HEADER_TIME, wezterm.strftime '%H:%M')
end

local function GetBattery(elems, window)
  for _, b in ipairs(wezterm.battery_info()) do
    AddElement(elems, HEADER_BATTERY, string.format('%.0f%%', b.state_of_charge * 100))
  end
end

local function LeftUpdate(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_left_status(name or "")
end

local function RightUpdate(window, pane)
  local elems = {}

  GetBattery(elems, window)
  GetDate(elems)
  GetTime(elems)

  window:set_right_status(wezterm.format(elems))
end

wezterm.on('update-status', function(window, pane)
  LeftUpdate(window, pane)
  RightUpdate(window, pane)
end)

return {}

