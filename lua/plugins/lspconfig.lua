return {
    { 
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
    },
    { "williamboman/mason.nvim", opts = {
        opts = function()
            --require("mason").setup()
            mason_lspconfig.setup({
                ensure_installed = {
                    "java_language_server"
                }
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        on_attach = require("shared").on_attach,
                    }
                end
            })
        end
        }
    }
}
