-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"



-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "bamboo" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})


-- Setup lspconfig
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- vim.keymap.set("i", "<Tab>", "<Tab>", { silent = true })
-- vim.keymap.set("i", "<S-Tab>", "<S-Tab>", { silent = true })

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true
})

vim.keymap.set("i", "<C-Space>", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "")
end, { silent = true })

vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
    else 
        return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    end
end, { expr = true, silent = true })

vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
    else
        return vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
    end
end, { expr = true, silent = true })


vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- vim.cmd("set completeopt+=noselect")

vim.diagnostic.config({
    virtual_lines = true
    -- virtual_lines = {
    --     current_line = true,
    -- }
})
