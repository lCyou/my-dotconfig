return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { {'nvim-tree/nvim-web-devicons'}},
  config = function()
    -- ヘッダーのハイライト設定（紫色）
    vim.api.nvim_set_hl(0, 'DashboardHeader', {
      fg = '#957FB8',  -- kanagawaのoniViolet（紫）
      bg = 'NONE',     -- 背景透明
    })
    
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '  ⢀⣾⣷⠀⣾⠇⢹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                   ',
          '⠀⠀⢸⡇⠛⣧⢹⡆⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠏⠀⠀⠀                                                   ',
          '⠀⠀⢸⡇⠀⡿⠀⣿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠃⠀⠀⠀⠀                                                   ',
          '⠀⠀⢸⡇⠀⣷⠀⣿⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⡟⠁⠀⠀⠀⠀⠀                                                   ',
          '⠀⠀⠈⣿⠀⣿⣷⣿⠀⢸⡿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⣽⠏⠀⠀⠀⠀⠀⠀⠀                                                   ',
          '⠀⠀⢀⣽⡿⠛⠉⠏⠀⠸⠃⠀⠙⣷⡄⠀⠀⠀⠀⣠⡾⢫⡾⠃⠀⠀⠀⠀⠀⠀⠀⠀                                                   ',
          '⠀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡀⠀⢠⡾⠋⣴⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                   ',
          '⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⢐⣿⣤⡾⣡⡶⠿⠛⠻⣦⡀⠀⠀⠀⠀⠀                                                   ',
          '⢹⣧⠀⣴⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⣿⣿⡿⢛⣫⣴⠾⠛⢛⠻⢷⣄⡀⠀⠀⠀ __    _  _______  _______  __   __  ___   __   __ ',
          '⠈⣿⡄⢸⣿⣷⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⢛⣛⣭⣴⠶⣻⣿⡿⠺⠟⠋⠀⠀⠀|  |  | ||       ||       ||  | |  ||   | |  |_|  |',
          '⠀⠹⣷⠀⠻⣿⠇⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣏⣉⣩⣴⡾⣛⣿⠟⠁⠀⠀⠀⠀⠀|   |_| ||    ___||   _   ||  |_|  ||   | |       |',
          '⠀⠀⠹⣧⣀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣟⠁⠀⠀⠀⠀⠀⠀⠀|       ||   |___ |  | |  ||       ||   | |       |',
          '⠀⠀⠀⠈⠛⠿⠿⠿⠛⠙⢿⣿⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀|  _    ||    ___||  |_|  ||       ||   | |       |',
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⣿⡿⠋⠁⠈⠛⠃⠀⠀⠀⠀⠀⠀⠀| | |   ||   |___ |       | |     | |   | | ||_|| |',
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿ ⠀⠀   ⠀⠀⠀⠀⠀⠀⠀|_|  |__||_______||_______|  |___|  |___| |_|   |_|',
          '',
          '',
          '',
        },
        center = {
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Recent Files                    ',
            desc_hl = 'String',
            key = 'r',
            keymap = 'SPC f r',
            key_hl = 'Number',
            action = 'Telescope oldfiles'
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find Files                      ',
            desc_hl = 'String',
            key = 'f',
            keymap = 'SPC f f',
            key_hl = 'Number',
            action = 'Telescope find_files'
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Settings                        ',
            desc_hl = 'String',
            key = 's',
            keymap = 'SPC s',
            key_hl = 'Number',
            action = 'edit $MYVIMRC'
          },
          {
            icon = '󰩈 ',
            icon_hl = 'Title',
            desc = 'Quit                            ',
            desc_hl = 'String',
            key = 'q',
            keymap = 'SPC q',
            key_hl = 'Number',
            action = 'quit'
          },
        },
        footer = {
          '',
          '俺の勝利が非現実的なら、俺は全力で現実から逃避する。',
	  '現実逃避は俺自身への期待だ。俺が俺を諦めていない姿勢だ。'
        }
      }
    }
  end,
}
