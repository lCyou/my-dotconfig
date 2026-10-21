local M = {}

local log_path = vim.fn.stdpath('data') .. '/keylog.jsonl'
local session_id = tostring(math.floor(vim.uv.hrtime() / 1e6))
local _buf = {}
local _buf_n = 0
local FLUSH_EVERY = 20

local function flush()
  if _buf_n == 0 then return end
  local f = io.open(log_path, 'a')
  if f then
    f:write(table.concat(_buf, '\n') .. '\n')
    f:close()
  end
  _buf = {}
  _buf_n = 0
end

local ns = vim.api.nvim_create_namespace('keylogger')

vim.on_key(function(key)
  -- マクロ再生中はスキップ
  if vim.fn.reg_executing() ~= '' then return end
  local readable = vim.fn.keytrans(key)
  if readable == '' then return end

  _buf_n = _buf_n + 1
  _buf[_buf_n] = vim.json.encode({
    t = math.floor(vim.uv.hrtime() / 1e6), -- ミリ秒タイムスタンプ
    k = readable,
    m = vim.api.nvim_get_mode().mode,
    ft = vim.bo.filetype,
    sid = session_id,
  })

  if _buf_n >= FLUSH_EVERY then flush() end
end, ns)

local aug = vim.api.nvim_create_augroup('keylogger', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', { group = aug, callback = flush })

local scripts_dir = vim.fn.stdpath('config') .. '/scripts'

vim.api.nvim_create_user_command('KeyReport', function(opts)
  local days = opts.args ~= '' and opts.args or '7'
  local report_path = vim.fn.stdpath('data') .. '/keylog_report.md'
  vim.fn.system(string.format(
    'bash %s/analyze_keys.sh %s full > %s 2>&1',
    scripts_dir, days, report_path
  ))
  vim.cmd.edit(report_path)
end, { nargs = '?', desc = 'キー操作レポートを生成して開く (引数: 日数, デフォルト7)' })

return M
