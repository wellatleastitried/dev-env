vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "=", "ggVG!xmllint --format -<CR>", { noremap = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.exists(":Neotree") == 2 then
      vim.cmd("Neotree close")
    end
  end,
})