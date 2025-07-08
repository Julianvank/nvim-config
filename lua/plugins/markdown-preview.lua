return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	keys = {
        { "<leader>ms", ":MarkdownPreview<CR>", desc = 'Markdown preview [s]tart' },
        { "<leader>mS", ":MarkdownPreviewStop<CR>", desc = 'Markdown preview [S]top' },
        { "<leader>mt", ":MarkdownPreviewToggle<CR>", desc = 'Markdown preview [T]oggle' }
    }
}
