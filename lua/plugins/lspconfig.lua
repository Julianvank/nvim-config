return {
    {
        "mason-org/mason-lspconfig.nvim",
        -- event = "BufReadPost",
        opts = {
            ensure_installed = { "hls", "lua_ls" }
            -- ensure_installed = { "haskell-language-server" }
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        -- VIM LSP
        vim.lsp.config("hls", {
            filetypes = { "haskell", "hs", "lhaskell", "cabal", "stack" },
            settings = {
                haskell = {
                    cabalFormattingProvider = "cabalfmt",
                    formattingProvider = "floskell",
                }
            },
            cmd = { "stack", "exec", "haskell-language-server-wrapper", "--", "--lsp" }
        }),
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime     = {
                        version = "LuaJIT"
                    },
                    diagnostics = {
                        globals = {
                            "vim",
                        },
                    },
                    workspace   = {
                        library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
                    },
                    telemetry   = {
                        enable = false
                    },
                }
            }
        })
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },
}
