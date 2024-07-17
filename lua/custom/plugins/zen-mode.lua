return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  config = function()
    require('no-neck-pain').setup {
      width = 120,
      autocmds = {
        enableOnVimEnter = false,
      },
    }
    vim.api.nvim_set_keymap('n', '<leader>nn', ':NoNeckPain<CR>', { noremap = true, silent = true })
  end,
}
