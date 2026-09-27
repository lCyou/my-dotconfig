-- 補完設定 (nvim-cmp)
return {
  -- LuaSnip: スニペットエンジン
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
  },

  -- nvim-cmp: 補完エンジン本体
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP補完ソース
      "hrsh7th/cmp-buffer",      -- バッファ補完ソース
      "hrsh7th/cmp-path",        -- パス補完ソース
      "L3MON4D3/LuaSnip",        -- スニペットエンジン
      "saadparwaiz1/cmp_luasnip", -- LuaSnipとcmpの連携
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        -- スニペットエンジンの設定
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- 補完ウィンドウの設定
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- キーマップの設定
        mapping = cmp.mapping.preset.insert({
          -- Tab: 次の候補へ
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift-Tab: 前の候補へ
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Enter: 補完を確定
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Ctrl-Space: 補完メニューを手動で開く
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Ctrl-e: 補完をキャンセル
          ["<C-e>"] = cmp.mapping.abort(),

          -- Ctrl-b/f: ドキュメントをスクロール
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),

        -- 補完ソースの設定（優先順位順）
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- LSPからの補完（最優先）
          { name = "luasnip" },   -- スニペット
          { name = "buffer" },    -- バッファ内のテキスト
          { name = "path" },      -- ファイルパス
        }),

        -- 補完候補の表示フォーマット
        formatting = {
          format = function(entry, vim_item)
            -- 補完ソースの表示名
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
}
