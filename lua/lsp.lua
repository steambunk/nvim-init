function set_completion(cmp)
    cmp.setup({
        sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' }
        },
        formatting = {
            format = require('lspkind').cmp_format({
                with_text = true,
                maxwidth = 50
            })
        }
    })
end

function configure(lsp, servers)
    vim.api.nvim_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
    vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
    vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {})
    for _, server in ipairs(servers) do
        require('lsp/' .. server)(lsp)
    end
end

return function()
    configure(require('lspconfig'), {
        'eslint',
        'intelephense',
        'jsonls',
        'pylsp',
        'tsserver',
        'vimls'
    })
end
