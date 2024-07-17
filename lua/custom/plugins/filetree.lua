-- File: lua/custom/plugins/filetree.lua

-- return {
--   'nvim-neo-tree/neo-tree.nvim',
--   branch = 'v3.x',
--   dependencies = {
--     'nvim-lua/plenary.nvim',
--     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
--     'MunifTanjim/nui.nvim',
--   },
--   config = function()
--     require('neo-tree').setup {
--       popup_border_style = 'rounded',
--       window = {
--         position = 'float',
--         mappings = {
--           ['l'] = 'open',
--           ['h'] = 'close_node',
--         },
--       },
--       filesystem = {
--         filtered_items = {
--           visible = false, -- when true, they will just be displayed differently than normal items
--           hide_dotfiles = false,
--           hide_gitignored = false,
--           hide_hidden = false, -- only works on Windows for hidden files/directories
--           hide_by_name = {
--             -- ".DS_Store",
--             -- "thumbs.db",
--             --"node_modules",
--           },
--           hide_by_pattern = {
--             --"*.meta",
--             --"*/src/*/tsconfig.json",
--           },
--           always_show = { -- remains visible even if other settings would normally hide it
--             --".gitignored",
--           },
--           never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
--             --".DS_Store",
--             --"thumbs.db",
--           },
--           never_show_by_pattern = { -- uses glob style patterns
--             --".null-ls_*",
--           },
--         },
--       },
--     }
--   end,
-- }

local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'l', edit_or_open, opts 'Edit or open')
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Collapse')
end

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local HEIGHT_RATIO = 0.8 -- You can change this
    local WIDTH_RATIO = 0.5 -- You can change this too
    require('nvim-tree').setup {
      on_attach = my_on_attach,
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
      update_focused_file = {
        enable = true,
      },
    }
  end,
}
