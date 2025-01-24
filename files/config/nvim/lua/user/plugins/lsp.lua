return { -- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		-- Useful status updates for LSP
		{
			'j-hui/fidget.nvim',
			tag="legacy",
		},
	},
	config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }

      buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

		-- Setup mason so it can manage external tooling
		require('mason').setup()

		local servers = {
      -- Languages
      'clangd',
      'pyright',
      'lua_ls',
      'cmake',
      'dockerls',
      -- Shell
      'bashls',
      -- Data Formats
      'jsonls',
      'yamlls',
      'marksman',
    }

		-- Ensure the servers above are installed
		require('mason-lspconfig').setup {
      ensure_installed = servers,
		}
		-- nvim-cmp supports additional completion capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		-- Turn on lsp status information
		require('fidget').setup()

    for _, server_name in ipairs(servers) do
      local lspconfig = require('lspconfig')
      local server = lspconfig[server_name]
      server.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end

		-- Make runtime files discoverable to the server
		local runtime_path = vim.split(package.path, ';')
		table.insert(runtime_path, 'lua/?.lua')
		table.insert(runtime_path, 'lua/?/init.lua')

    -- Additional LSP Setup
    -- Pyright (Python)
    require('lspconfig').pyright.setup {
      on_attach = on_attach,
      settings = {
        pyright = {
          autoImportCompletion = true,
        },
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = true,
            typeCheckingMode = 'off',
            extraPaths = {
              os.getenv('HOME') .. '/.local/lib/python3.10/site-packages',
            },
          },
        },
      },
    }

    -- Lua
		require('lspconfig').lua_ls.setup {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false
          },
        },
      },
		}

    -- Clangd
    local function find_build_dir()
      local cwd = vim.fn.getcwd()
      local build_dirs = { "build", "build/debug", "build/release" }
      for _, dir in ipairs(build_dirs) do
        local build_dir = cwd .. "/" .. dir
        if vim.fn.isdirectory(build_dir) == 1 then
          return build_dir
        end
      end
      return cwd
    end


    require('lspconfig').clangd.setup {
      cmd = { "clangd", "--compile-commands-dir=" .. find_build_dir(), "--log=verbose" },
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }

    vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'sh',
			callback = function()
				vim.lsp.start({
					name = 'bash-language-server',
					cmd = { 'bash-language-server', 'start' },
				})
			end,
		})
	end
}
