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
    local on_attach = function(_, bufnr)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      vim.keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
    end

		-- Setup mason so it can manage external tooling
		require('mason').setup()

		local servers = {
      -- Languages
      'clangd',
      'pyright',
      'lua_ls',
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
