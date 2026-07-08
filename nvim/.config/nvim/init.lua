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
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

-- Install plugins with lazy.nvim
lazy.setup({
   {
     "obsidian-nvim/obsidian.nvim",
     version = "*", -- use latest release, remove to use latest commit
     ---@module 'obsidian'
     ---@type obsidian.config
     opts = {
       legacy_commands = false, -- this will be removed in 4.0.0
       ui = { enable = false },
       workspaces = {
         {
           name = "work",
           path = "~/Documents/vaults/work",
         },
         {
           name = "personal",
           path = "~/Documents/vaults/personal",
         },
       },
       note_id_func = function(title)
         if title ~= nil then
           return title
         end
         local suffix = ""
         for _ = 1, 4 do
           suffix = suffix .. string.char(math.random(65, 90))
         end
         return tostring(os.time()) .. "-" .. suffix
       end,
      },
     },
   {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
   },
   {'rebelot/kanagawa.nvim'},
   {'folke/tokyonight.nvim'},
   {'ellisonleao/gruvbox.nvim'},
   {'sainnhe/gruvbox-material'},
   {'nvim-lualine/lualine.nvim', dependencies = {'nvim-tree/nvim-web-devicons'}},
   {'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = {'nvim-lua/plenary.nvim'}},
	 {"nvim-telescope/telescope-file-browser.nvim", dependencies = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}},
   {'nvim-orgmode/orgmode'},
   -- {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
   { "nvim-treesitter/nvim-treesitter", branch = "main",build = ":TSUpdate", config = function() require("nvim-treesitter").setup({}) end, },
   {"lervag/vimtex", lazy = false, init = function() vim.g.vimtex_view_method = "zathura" vim.g.vimtex_compiler_method = "latexmk" end}
})

require('lualine').setup()
require('orgmode').setup({
      org_agenda_files = '~/Documents/orgfiles/**/*',
      org_archive_location = '~/Documents/orgfiles/archives/%s_archive::',
      org_default_notes_file = '~/Documents/orgfiles/inbox.org',
      org_todo_keywords = {'TODO','WAITING','|','DONE'},
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
vim.opt.inccommand = "split"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop=2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.exrc = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.cmd.colorscheme('gruvbox-material')
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "org" },
  callback = function() vim.opt_local.textwidth = 80 end,
})
-- keymaps
vim.keymap.set('n', '<leader>D', 'a<C-R>=strftime("%Y-%m-%dT%H:%M:%S%z")<CR><Esc>', { desc = 'Append date' })
vim.keymap.set('n', '<leader>C', 'i# vi: set textwidth=80 noundofile noswapfile nobackup nowritebackup clipboard= noshelltemp:<Esc>', { desc = 'Insert more "secure" modeline' })
