return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require('lspconfig')

        local on_attach = function(client, bufnr)
            local opts = { noremap=true, silent=true }
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        end

        -- Setup Marksman language server
        lspconfig.marksman.setup{
            on_attach = on_attach,
        }
    end,
}

