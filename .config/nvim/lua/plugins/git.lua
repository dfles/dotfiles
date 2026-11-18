local function close_split_diff()
  local closed = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):match("^gitsigns://") then
      vim.api.nvim_win_close(win, false)
      closed = true
    end
  end
  return closed
end

local function toggle_split_diff(base)
  if not close_split_diff() then
    require("gitsigns").diffthis(base)
  end
end

local function toggle_inline_diff()
  local gs = require("gitsigns")
  local on = gs.toggle_deleted()
  gs.toggle_linehl(on)
  gs.toggle_word_diff(on)
end

return {
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git-conflict").setup({
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
        disable_diagnostics = true,
      })
    end,
    keys = {
      { "<leader>gp", "<Plug>(git-conflict-prev-conflict)", desc = "Previous conflict" },
      { "<leader>gn", "<Plug>(git-conflict-next-conflict)", desc = "Next conflict" },
      { "<leader>go", "<Plug>(git-conflict-ours)", desc = "Conflict: Keep current" },
      { "<leader>gt", "<Plug>(git-conflict-theirs)", desc = "Conflict: Keep incoming" },
      { "<leader>gb", "<Plug>(git-conflict-both)", desc = "Conflict: Keep both" },
      { "<leader>gx", "<Plug>(git-conflict-none)", desc = "Conflict: Remove conflict" },
      { "<leader>gc", "<cmd>GitConflictListQf<CR>", desc = "Conflicts to quickfix" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol", -- eol/right_align
      },
      current_line_blame_formatter = "        <author>, <author_time:%Y-%m-%d> - <summary>",
    },
    keys = {
      { "<leader>gi", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle blame" },
      {
        "<leader>gI",
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "gitsigns-blame" then
              vim.api.nvim_win_close(win, false)
              return
            end
          end
          require("gitsigns").blame()
        end,
        desc = "Toggle full blame",
      },
      {
        "]h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Next hunk",
      },
      {
        "[h",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Previous hunk",
      },
      { "<leader>gh", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk inline" },
      { "<leader>gd", function() toggle_split_diff() end, desc = "Toggle diff vs index" },
      { "<leader>gD", function() toggle_split_diff("main") end, desc = "Toggle diff vs main" },
      { "<leader>gu", toggle_inline_diff, desc = "Toggle inline diff" },
    },
  },
}
