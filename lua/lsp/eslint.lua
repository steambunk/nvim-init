return function(lsp)
    lsp.eslint.setup({
        on_attach = function ()
            vim.cmd([[au BufWritePre <buffer> EslintFixAll]])
        end
    })
end
