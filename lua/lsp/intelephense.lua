return function(lsp)
    lsp.intelephense.setup({})
    local util = require 'lspconfig.util'

local bin_name = 'intelephense'
local cmd = { bin_name, '--stdio' }


if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'php' },
    root_dir = function(pattern)

      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
}
end
