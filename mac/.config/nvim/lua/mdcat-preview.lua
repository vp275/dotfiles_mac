local M = {}

local function open_preview(renderer, executable, cursorline, build_command)
  if vim.bo.filetype ~= "markdown" then
    vim.notify(renderer .. " preview is only available for Markdown files", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable(executable) == 0 then
    vim.notify(executable .. " is not installed", vim.log.levels.ERROR)
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Save the Markdown file before previewing it", vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then
    vim.notify("Previewing the last saved version", vim.log.levels.INFO)
  end

  local zen_ok, zen = pcall(require, "zen-mode.view")
  if zen_ok and zen.is_open() then
    require("zen-mode").close()
  end

  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()
  local width = math.max(80, vim.o.columns - 1)
  local job = vim.fn.jobstart(build_command(width, path), {
    term = true,
    on_exit = function()
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
          vim.api.nvim_win_set_cursor(win, { 1, 0 })
        end
      end)
    end,
  })

  if job <= 0 then
    vim.cmd("tabclose")
    vim.notify("Unable to start " .. renderer, vim.log.levels.ERROR)
    return
  end

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.cursorline = cursorline
  vim.wo.cursorlineopt = "line"
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", {
    buffer = buf,
    desc = "Close Markdown preview",
  })
end

function M.open()
  open_preview("mdcat", "mdcat", false, function(width, path)
    return {
      "mdcat",
      "--local",
      "--theme",
      "dark",
      "--columns",
      tostring(width),
      path,
    }
  end)
end

function M.open_pandoc()
  open_preview("Pandoc", "pandoc", true, function(width, path)
    return {
      "pandoc",
      "--from=gfm",
      "--to=rst",
      "--wrap=auto",
      "--columns=" .. tostring(width),
      path,
    }
  end)
end

function M.open_glow()
  open_preview("Glow", "glow", true, function(width, path)
    return {
      "glow",
      "--style=dark",
      "--width=" .. tostring(width),
      path,
    }
  end)
end

return M
