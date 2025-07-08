return
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
        window = {
            position = "right"
        },
        -- action = "focus",
        source = "filesystem",
        filesystem = {
            filtered_items = {
                visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
                hide_dotfiles = false,
                hide_gitignored = true,
            },
        }
    },




    keys = function()
        local function open_neo_tree_at_file_or_cwd()
            local reveal_file = vim.fn.expand('%:p')
            if reveal_file == '' then
                reveal_file = vim.fn.getcwd()
            else
                local f = io.open(reveal_file, "r")
                if not f then
                    reveal_file = vim.fn.getcwd()
                else
                    f:close()
                end
            end
            require('neo-tree.command').execute({
                action = "focus",
                source = "filesystem",
                position = "right",
                reveal_file = reveal_file,
                reveal_force_cwd = true,
            })
        end
        local function open_neoTree()
            require('neo-tree.command').execute({
                action = "focus",
                source = "filesystem",
                position = "right",
            })
        end

        return {
            {
                '-', open_neo_tree_at_file_or_cwd,
                { desc = "Open neo-tree at current file or working directory" }
            },
            {
                '<leader>nt', open_neoTree,
                { desc = "Open NeoTree on the right side" }
            }
        }
    end
}
