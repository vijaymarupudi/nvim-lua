if not pcall(require, "fzf-lua") then
  return
end

local M = {}

-- require'fzf-lua'.setup({})
local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  win_height          = 0.85,         -- window height
  win_width           = 0.80,         -- window width
  win_row             = 0.30,         -- window row position (0=top, 1=bottom)
  win_col             = 0.50,         -- window col position (0=left, 1=right)
  win_border          = true,         -- window border?
  fzf_layout          = 'reverse',    -- fzf '--layout='
  preview_cmd         = '',           -- 'head -n $FZF_PREVIEW_LINES',
  preview_border      = 'border',     -- border|noborder
  preview_wrap        = 'nowrap',     -- wrap|nowrap
  preview_vertical    = 'down:45%',   -- up|down:size
  preview_horizontal  = 'right:60%',  -- right|left:size
  preview_layout      = 'flex',       -- horizontal|vertical|flex
  flip_columns        = 120,          -- #cols to switch to horizontal on flex
  bat_theme           = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
  bat_opts            = '--style=numbers,changes --color always',
  files = {
    prompt            = 'Files❯ ',
    cmd               = '',           -- "find . -type f -printf '%P\n'",
    git_icons         = true,         -- show git icons?
    file_icons        = true,         -- show file icons?
    color_icons       = true,         -- colorize file|git icons
    actions = {
      ["default"]     = actions.file_edit,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["ctrl-q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    }
  },
  grep = {
    prompt            = 'Rg❯ ',
    input_prompt      = 'Grep For❯ ',
    -- cmd               = "rg --vimgrep",
    git_icons         = true,         -- show git icons?
    file_icons        = true,         -- show file icons?
    color_icons       = true,         -- colorize file|git icons
    actions = {
      ["default"]     = actions.file_edit,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["ctrl-q"]      = actions.file_sel_to_qf,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    }
  },
  oldfiles = {
    prompt            = 'History❯ ',
    cwd_only          = false,
  },
  git = {
    prompt            = 'GitFiles❯ ',
    cmd               = 'git ls-files --exclude-standard',
    git_icons         = true,         -- show git icons?
    file_icons        = true,         -- show file icons?
    color_icons       = true,         -- colorize file|git icons
  },
  buffers = {
    prompt            = 'Buffers❯ ',
    file_icons        = true,         -- show file icons?
    color_icons       = true,         -- colorize file|git icons
    sort_lastused     = true,         -- sort buffers() by last used
    actions = {
      ["default"]     = actions.buf_edit,
      ["ctrl-s"]      = actions.buf_split,
      ["ctrl-v"]      = actions.buf_vsplit,
      ["ctrl-t"]      = actions.buf_tabedit,
      ["ctrl-x"]      = actions.buf_del,
    }
  },
  colorschemes = {
    prompt            = 'Colorschemes❯ ',
    live_preview      = true,
    actions = {
      ["default"]     = actions.colorscheme,
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    },
    winopts = {
      win_height       = 0.55,
      win_width        = 0.30,
      window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
      end,
    },
    post_reset_cb    = function()
      require('feline').reset_highlights()
    end,
  },
  quickfix = {
    cwd               = vim.loop.cwd(),
    file_icons        = true,
  },
  -- placeholders for additional user customizations
  loclist = {},
  helptags = {},
  manpages = {},
  file_icon_colors = {                -- override colors for extensions
    ["lua"]   = "blue",
  },
  git_icons = {                       -- override colors for git icons
    ["M"]     = "M", --"★",
    ["D"]     = "D", --"✗",
    ["A"]     = "A", --"+",
    ["?"]     = "?"
  },
  git_icon_colors = {                 -- override colors for git icon colors
    ["M"]     = "yellow",
    ["D"]     = "red",
    ["A"]     = "green",
    ["?"]     = "magenta"
  },
  fzf_binds           = {             -- fzf '--bind=' options
    'f2:toggle-preview',
    'f3:toggle-preview-wrap',
    'shift-down:preview-page-down',
    'shift-up:preview-page-up',
    'ctrl-d:half-page-down',
    'ctrl-u:half-page-up',
    'ctrl-f:page-down',
    'ctrl-b:page-up',
    'ctrl-a:toggle-all',
    'ctrl-u:clear-query',
  },
  window_on_create = function()         -- nvim window options override
    vim.cmd("set winhl=Normal:Normal")  -- popup bg match normal windows
  end
}



function M.edit_neovim(opts)
  if not opts then opts = {} end
  opts.prompt = "< VimRC > "
  opts.cwd = "$HOME/.config/nvim"
  require'fzf-lua'.files(opts)
end

function M.edit_dotfiles(opts)
  if not opts then opts = {} end
  opts.prompt = "~ dotfiles ~ "
  opts.cwd = "~/dots"
  require'fzf-lua'.files(opts)
end

function M.edit_zsh(opts)
  if not opts then opts = {} end
  opts.prompt = "~ zsh ~ "
  opts.cwd = "$HOME/.config/zsh"
  require'fzf-lua'.files(opts)
end

function M.installed_plugins(opts)
  if not opts then opts = {} end
  opts.prompt = 'Plugins❯ '
  opts.cwd = vim.fn.stdpath "data" .. "/site/pack/packer/"
  require'fzf-lua'.files(opts)
end

return setmetatable({}, {
  __index = function(_, k)
    -- reloader()

    if M[k] then
      return M[k]
    else
      return require('fzf-lua')[k]
    end
  end,
})
