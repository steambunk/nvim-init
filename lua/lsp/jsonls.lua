function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
end

return function(lsp)
    lsp.jsonls.setup({
        capabilities = get_capabilities(),
        settings = {
            json = {
                schemas = {
                    { fileMatch = {'tsconfig.json'}, url = 'http://json.schemastore.org/tsconfig' },
                    { fileMatch = {'.eslintrc.json'}, url = 'http://json.schemastore.org/eslintrc' }
                }
            }
        }
    })
end
