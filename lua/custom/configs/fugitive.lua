-- Force close empty buffer tab after closing ':Git add --patch'
local local_group = vim.api.nvim_create_augroup('CustomFugitiveGroup', { clear = true })
local listed_bufs = {}

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { 'fugitive://*' },
  callback = function(ev)
    vim.api.nvim_buf_set_option(ev.buf, 'buflisted', false)

    local list_bufs = vim.api.nvim_list_bufs()
    listed_bufs = {}
    for _, bufnr in pairs(list_bufs) do
      if vim.fn.buflisted(bufnr) == 1 then
        table.insert(listed_bufs, bufnr)
      end
    end
  end,
  group = local_group,
})
vim.api.nvim_create_autocmd({ 'BufDelete' }, {
  pattern = { 'term://*/git*' },
  callback = function(ev)
    vim.cmd 'tabclose | Git'
    vim.cmd('bd ' .. (ev.buf + 1))

    for _, bufnr in ipairs(listed_bufs) do
      vim.api.nvim_buf_set_option(bufnr, 'buflisted', true)
    end
  end,
  group = local_group,
})

return {}
