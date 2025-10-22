return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Grep string",
      },
    },
  },
}