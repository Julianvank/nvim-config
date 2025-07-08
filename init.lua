require("config.lazy")

-- Basic settings
vim.o.number = true         -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.tabstop = 4           -- Number of spaces a tab represents
vim.o.shiftwidth = 4        -- Number of spaces for each indentation
vim.o.expandtab = true      -- Convert tabs to spaces
vim.o.smartindent = true    -- Automatically indent new lines
vim.o.wrap = false          -- Disable line wrapping
vim.o.cursorline = true     -- Highlight the current line
vim.o.termguicolors = true  -- Enable 24-bit RGB colors

-- Syntax highlighting and filetype plugins
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')


-- vim.keymap.set('n', '<leader>nt', ': Neotree<CR>', {
--    desc = "open NeoTree" })

-- Open binary files
vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*.pdf",
    callback = function()
        local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
        vim.cmd("silent !mupdf " .. filename .. " &")
        vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
    end
})

vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    callback = function()
        local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
        vim.cmd("silent !eyestalk " .. filename .. " &")
        vim.cmd("let tobedeleted = bufnr('%') | b# | exe \"bd! \" . tobedeleted")
    end
})

vim.g.mapleader = ' '

vim.keymap.set("n", "<leader>t", ":belowright new | resize 20 | terminal<CR>")
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>")


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format({ async = true, id = args.data.client_id })
                -- vim.lsp.buf.format({ bufnr = args.buf, async = true, id = args.data.client_id })
            end,
        })
    end
})


-- Path to your local copy of the Eisvogel template
-- local eisvogel_template = vim.fn.expand("~/pandoc-templates/eisvogel/eisvogel.tex")

-- Register the PandocPdf command
-- vim.api.nvim_create_user_command("PandocPdf", function(args)
--     vim.cmd(
--         "!pandoc -i "
--         .. vim.fn.fnameescape(vim.fn.expand("%"))
--         .. " -o "
--         .. vim.fn.fnameescape(vim.fn.expand("%:r"))
--         .. ".pdf"
--     )
-- end, {
--     nargs = 1,
-- })


vim.api.nvim_create_user_command("PandocPdf", function()
    local md  = vim.fn.fnameescape(vim.fn.expand("%"))
    local out = vim.fn.fnameescape(vim.fn.expand("%:r") .. ".pdf")

    local cmd = table.concat({
        "pandoc",
        md,
        "--from=markdown",
        "--template=eisvogel",
        "-V fontsize=12pt",
        "-V geometry:margin=1in",
        [[-V mainfont="Roboto Slab"]],
        -- [[-V header-right="Page \thepage\ of \pageref{LastPage}"]],
        [[-V footer-right="Page \thepage\ of \pageref{LastPage}"]],
        [[-V header-includes="\usepackage{lastpage}"]],
        "-o " .. out,
    }, " ")

    print(cmd)
    vim.fn.jobstart(cmd, { detach = false })
end, {
    nargs = 0,
    desc  = "Convert current Markdown to PDF via Pandoc + Eisvogel",
})
