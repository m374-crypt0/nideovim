require("mason-lspconfig").setup()
require("lspconfig").clangd.setup({})
require("lspconfig").biome.setup({})
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		solidity = { "solidity_forge" },
		json = { "biome" },
		jsonc = { "biome" },
		toml = { "taplo" },
	},
	formatters = {
		solidity_forge = {
			stdin = false,
			command = "forge",
			args = { "fmt" },
			cwd = require("conform.util").root_file({ "foundry.toml" }),
			require_cwd = true,
		},
		taplo = {
			stdin = false,
			command = "taplo",
			args = { "fmt" },
		},
	},
})

require("render-markdown").setup({ latex = { enabled = false } })
