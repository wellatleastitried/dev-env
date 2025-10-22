return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
    keys = {
      {
        "<leader>a",
        function()
          local harpoon = require("harpoon")
          harpoon:list():add()
        end,
        desc = "Add file to harpoon",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Toggle harpoon menu",
      },
      {
        "<C-h>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<C-j>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<C-k>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<C-l>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<C-i>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():select(5)
        end,
        desc = "Harpoon file 5",
      },
    },
  },
}