-- lazy.nvim plugin manager 
local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You can "comment out" the line below after lazy.nvim is installed
  -- lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

-- Install plugins with lazy.nvim
lazy.setup({
   {'folke/tokyonight.nvim'},
   {'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
   {'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }},
   {'nvim-orgmode/orgmode' },
   {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}
})

require('lualine').setup()
require('orgmode').setup({
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
})

-- settings
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.modeline = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

-- keymaps
vim.keymap.set('n', '<leader>D', 'a<C-R>=strftime("%Y-%m-%dT%H:%M:%S%z")<CR><Esc>', { desc = 'Append date' })
vim.keymap.set('n', '<leader>C', 'i# vi: set textwidth=80 noundofile noswapfile nobackup:<Esc>', { desc = 'Insert vi modeline' })
