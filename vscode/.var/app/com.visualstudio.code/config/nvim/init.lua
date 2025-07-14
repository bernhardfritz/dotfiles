local vscode = require('vscode')

function cmdAndCenter(command)
  return function()
    vim.cmd(command)
    local curline = vim.fn.line('.')
    vscode.call('revealLine', { args = { lineNumber = curline, at = 'center' } })
  end
end

vim.g.clipboard = vim.g.vscode_clipboard
vim.cmd('set clipboard=unnamedplus')
vim.cmd('set ignorecase')
vim.keymap.set('n', '<Space>', '')
vim.keymap.set('n', '*', cmdAndCenter(':norm! *'))
vim.keymap.set('n', 'n', cmdAndCenter(':norm! n'))
vim.keymap.set('n', 'N', cmdAndCenter(':norm! N'))
