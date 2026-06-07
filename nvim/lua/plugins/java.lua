-- Java / Spring Boot 開発環境
-- nvim-jdtls (Eclipse JDT Language Server) + nvim-dap (デバッガ)
return {
  -- DAP core
  { "mfussenegger/nvim-dap", lazy = true },
  { "nvim-neotest/nvim-nio", lazy = true },

  -- DAP UI (変数・コールスタック・REPL パネル)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    lazy = true,
    config = function()
      local dapui = require("dapui")
      dapui.setup()
      -- デバッグ開始/終了時に UI を自動開閉
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Java LSP + DAP 統合 (Java ファイルを開いたときのみロード)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local jdtls = require("jdtls")
      local jdtls_setup = require("jdtls.setup")

      -- Nix ラッパーが注入した環境変数から JAR パスを解決
      local debug_dir = vim.env.JAVA_DEBUG_DIR or ""
      local debug_jar = vim.fn.glob(debug_dir .. "/com.microsoft.java.debug.plugin-*.jar", false, false)
      local lombok_jar = vim.env.LOMBOK_JAR or ""

      -- デバッグアダプタ JAR が存在する場合のみ bundles に追加
      local bundles = {}
      if debug_jar ~= "" then
        table.insert(bundles, debug_jar)
      end

      -- Lombok が存在する場合は JVM 引数に追加 (Spring Boot アノテーション処理)
      local jvm_args = {}
      if lombok_jar ~= "" and vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(jvm_args, "--jvm-arg=-javaagent:" .. lombok_jar)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local config = {
        cmd = vim.list_extend({ "jdtls" }, jvm_args),
        -- プロジェクトルートをビルドファイルから検出
        root_dir = jdtls_setup.find_root({
          "mvnw", "gradlew", "pom.xml",
          "build.gradle", "build.gradle.kts",
          "settings.gradle", "settings.gradle.kts",
          ".git",
        }),
        capabilities = capabilities,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = vim.env.JAVA_HOME,
                  default = true,
                },
              },
            },
            -- フォーマットは conform + google-java-format に委譲
            format = { enabled = false },
            saveActions = { organizeImports = false },
          },
        },
        init_options = { bundles = bundles },
        on_attach = function(_, bufnr)
          -- DAP セットアップ (デバッグ jar が存在する場合のみ)
          if #bundles > 0 then
            jdtls.setup_dap({ hotcodereplace = "auto" })
            jdtls_setup.add_commands()
          end

          local function opts(desc)
            return { buffer = bufnr, noremap = true, silent = true, desc = desc }
          end

          -- Java 固有コマンド
          vim.keymap.set("n", "<leader>lo", jdtls.organize_imports,
            opts("Java: Organize Imports"))
          vim.keymap.set("n", "<leader>lv", jdtls.extract_variable,
            opts("Java: Extract Variable"))
          vim.keymap.set("v", "<leader>lv", function()
            jdtls.extract_variable(true)
          end, opts("Java: Extract Variable"))
          vim.keymap.set("n", "<leader>lx", jdtls.extract_method,
            opts("Java: Extract Method"))

          -- DAP キーマップ
          local dap = require("dap")
          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,
            opts("DAP: Toggle Breakpoint"))
          vim.keymap.set("n", "<leader>dc", dap.continue,
            opts("DAP: Continue"))
          vim.keymap.set("n", "<leader>di", dap.step_into,
            opts("DAP: Step Into"))
          vim.keymap.set("n", "<leader>do", dap.step_over,
            opts("DAP: Step Over"))
          vim.keymap.set("n", "<leader>dO", dap.step_out,
            opts("DAP: Step Out"))
          vim.keymap.set("n", "<leader>dr", dap.repl.open,
            opts("DAP: Open REPL"))
          vim.keymap.set("n", "<leader>du", function()
            require("dapui").toggle()
          end, opts("DAP: Toggle UI"))
        end,
      }

      jdtls.start_or_attach(config)
    end,
  },
}
