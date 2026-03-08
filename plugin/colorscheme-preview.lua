local group = vim.api.nvim_create_augroup('colorscheme-preview', { clear = true })
local saved_colors_name = nil
vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
  desc = 'Preview colorscheme during :colorscheme, restore if aborted',
  group = group,
  callback = function(ev)
    local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
    if not ok or parsed.cmd ~= 'colorscheme' or #parsed.args ~= 1 then
      return
    end

    local colorscheme = parsed.args[1]
    if not colorscheme then
      return
    end

    if not saved_colors_name then
      saved_colors_name = vim.g.colors_name or 'default'
    end

    if ev.event == 'CmdlineLeave' then
      if vim.v.event.abort then
        colorscheme = saved_colors_name
      end
      saved_colors_name = nil
    end

    if not pcall(vim.cmd.colorscheme, colorscheme) then
      vim.cmd.colorscheme(saved_colors_name)
    end
    vim.cmd.redraw()
  end,
})
