vim.g.airline_theme = 'minimalist'

-- Disable ALE or Syntastic warnings/errors in the status line
vim.g['airline#extensions#ale#enabled'] = 0
vim.g['airline#extensions#syntastic#enabled'] = 0

-- Customize the airline layout to remove file encoding and format
vim.g['airline#extensions#default#layout'] = {
  { 'a', 'b', 'c' },  -- Left section (mode, branch, etc.)
  { 'x', 'z' }        -- Right section (without 'y', which shows file encoding)
}
