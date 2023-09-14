return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = true,
  opts = {
    start_in_insert = true,
    size = 15,
    open_mapping = "<C-\\>",
    hide_numbers = true,
    auto_chdir = true,
  },
  vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-W>h]]),
  vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>j]]),
  vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>k]]),
  vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-W>l]]),
}
