return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  
    keys = function()
    local builtin = require('telescope.builtin')
    return {
      { '<leader>ff', builtin.find_files, desc = 'Telescope find files' },
      { '<leader>fg', builtin.live_grep, desc = 'Telescope live grep' },
      { '<leader>fb', builtin.buffers, desc = 'Telescope buffers' },
      { '<leader>fh', builtin.help_tags, desc = 'Telescope help tags' },
    }
  end
}
    
