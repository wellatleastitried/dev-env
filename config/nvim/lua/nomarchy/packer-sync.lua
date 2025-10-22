vim.cmd [[packadd packer.nvim]]
require('nomarchy.packer')

vim.cmd [[autocmd User PackerComplete quitall]]
vim.cmd [[PackerSync]]
