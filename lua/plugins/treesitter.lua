return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "elixir", 
                "heex",
                "javascript",
                "html",
                "markdown",
                "haskell",
                "java",
                "sql",
                },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        }
}
