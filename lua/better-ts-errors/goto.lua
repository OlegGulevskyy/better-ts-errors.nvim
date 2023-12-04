local M = {}

M.get_word_under_cursor = function()
    return vim.fn.expand('<cword>')
end

M.find_and_goto_symbol = function(s)
    local params = vim.lsp.util.make_position_params()
    local bufnr = vim.api.nvim_get_current_buf()
    params.query = s or ""
    vim.lsp.buf_request(bufnr, 'workspace/symbol', params, function(err, result)
        if err then
            print('Error retrieving workspace symbols: ' .. err)
            return
        end

        if result then
            for _, symbol in ipairs(result) do
                local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or 'Unknown'
                local line = symbol.location.range.start.line + 1
                local name = symbol.name
                local uri = symbol.location.uri

                if name == s then
                    -- Convert the URI to a file path and open the file
                    local path = vim.uri_to_fname(uri)
                    vim.cmd('edit ' .. path)
                    vim.api.nvim_win_set_cursor(0, { line, 0 })
                    return
                end
            end
            print('Symbol not found in workspace')
        else
            print('No symbols found in workspace')
        end
    end)
end

return M
