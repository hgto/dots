require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Next Git hunk")
    map("n", "[g", function() gs.nav_hunk("prev") end, "Previous Git hunk")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>gb", gs.blame_line, "Blame line")
    map("n", "<leader>gt", gs.toggle_signs, "Toggle Git signs")
    map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<cr>", "Inner Git hunk")
    map({ "o", "x" }, "ag", ":<C-U>Gitsigns select_hunk<cr>", "Around Git hunk")
  end,
})

vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Fugitive status" })

local augend = require("dial.augend")
require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.constant.alias.bool,
    augend.constant.new({ elements = { "pick", "reword", "edit", "squash", "fixup", "exec" }, word = true, cyclic = true }),
  },
})
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { expr = true })
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { expr = true })
vim.keymap.set("x", "<C-a>", require("dial.map").inc_visual("visual"), { expr = true })
vim.keymap.set("x", "<C-x>", require("dial.map").dec_visual("visual"), { expr = true })
