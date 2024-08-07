local pattern = "typescript"
local root_markers = { "eslint.config.mjs" }

vim.api.nvim_create_autocmd("FileType", {
	pattern = pattern,
	callback = function(args)
		local match = vim.fs.find(root_markers, { path = args.file, upward = true })[1]
		local root_dir = match and vim.fn.fnamemodify(match, ":p:h") or nil

		vim.lsp.start({
			name = "tsserver",
			init_options = { hostInfo = "neovim" },
			cmd = { "./node_modules/.bin/typescript-language-server", "--stdio" },
			root_dir = root_dir,
		})

		vim.lsp.start({
			name = "eslint-ls",
			cmd = { "./node_modules/.bin/vscode-eslint-language-server", "--stdio" },
			root_dir = root_dir,
			settings = {
				validate = "on",
				packageManager = nil,
				useESLintClass = false,
				experimental = {
					useFlatConfig = false,
				},
				onIgnoredFiles = "off",
				rulesCustomizations = {},
				run = "onType",
				problems = {
					shortenToSingleLine = false,
				},
				-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
				-- This path is relative to the workspace folder (root dir) of the server instance.
				nodePath = "",
				-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
				workingDirectory = { mode = "location" },
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
			},
		})
	end,
})
