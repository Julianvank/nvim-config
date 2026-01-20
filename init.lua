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


vim.api.nvim_create_user_command("PandocPdf", function()
    local md  = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r") .. ".pdf"
    local log = vim.fn.expand("%:p:r") .. ".pandoc.log"

    -- Create a temporary header.tex to avoid complex escaping of LaTeX in -V
    local header_tex = vim.fn.expand("%:p:r") .. ".header.tex"
    local header_contents = table.concat({
        "\\usepackage{lastpage}",
        "\\usepackage{listings}",
        "\\usepackage{float}",
        "\\renewcommand{\\lstlistingname}{Code}",
        "\\lstset{numbers=left,numberstyle=\\tiny,captionpos=b,float}"
    }, "\n")
    local hf = io.open(header_tex, "w")
    if not hf then
        vim.notify("Failed to write header tex: " .. header_tex, vim.log.levels.ERROR)
        return
    end
    hf:write(header_contents)
    hf:close()

    local args = {
        "pandoc",
        md,
        "--from=markdown",
        "--template=eisvogel",
        "--syntax-highlighting=idiomatic",
        "-V", "fontsize=12pt",
        "-V", "geometry:margin=1in",
        "-V", 'mainfont=Roboto Slab',
        -- footer-right needs the LaTeX commands verbatim; pass as a single arg
        "-V", [[footer-right=Page \thepage\ of \pageref{LastPage}]],
        -- use -H to include the header tex file
        "-H", header_tex,
        "-o", out,
    }

    -- Print command for quick debugging (safe: shows args joined by spaces)
    print(table.concat(args, " "))

    local stdout_lines = {}
    local stderr_lines = {}

    vim.fn.jobstart(args, {
        detach = false,
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data, _)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then table.insert(stdout_lines, line) end
                end
            end
        end,
        on_stderr = function(_, data, _)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then table.insert(stderr_lines, line) end
                end
            end
        end,
        on_exit = vim.schedule_wrap(function(_, code, _)
            local f = io.open(log, "w")
            if f then
                f:write("pandoc command:\n", table.concat(args, " "), "\n\n")
                f:write("exit code: ", tostring(code), "\n\n")
                if #stdout_lines > 0 then
                    f:write("=== STDOUT ===\n", table.concat(stdout_lines, "\n"), "\n\n")
                end
                if #stderr_lines > 0 then
                    f:write("=== STDERR ===\n", table.concat(stderr_lines, "\n"), "\n\n")
                end
                f:close()
                vim.notify("Pandoc log written to: " .. log, vim.log.levels.INFO)
            else
                vim.notify("Failed to open log file: " .. log, vim.log.levels.ERROR)
            end

            if code == 0 then
                vim.notify("PandocPdf succeeded: " .. out, vim.log.levels.INFO)
            else
                vim.notify("PandocPdf failed (exit code " .. tostring(code) .. "), see " .. log, vim.log.levels.ERROR)
            end
        end),
    })
end, {
    nargs = 0,
    desc  = "Convert current Markdown to PDF via Pandoc + Eisvogel",
})

function OpenDocument(path)
    vim.ui.open(path)
end

