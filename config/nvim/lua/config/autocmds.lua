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

vim.api.nvim_create_autocmd({"BufEnter", "BufNew"}, {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "forth", "fth", "4th" },
  callback = function()
    vim.lsp.start({
      name = "forth-lsp",
      cmd = { "forth-lsp" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})
