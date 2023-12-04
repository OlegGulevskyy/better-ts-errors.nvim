local M = require("better-ts-errors.main")

local BetterTsErrors = {}
local DefaultToggleKeyMap = "<leader>dd"
local DefaultGoToDefinitionKeyMap = "<leader>dx"

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
BetterTsErrors.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
    keymaps = {
        toggle = DefaultToggleKeyMap,
        go_to_definition = DefaultGoToDefinitionKeyMap,
    },
    enable_prettify = true,
}

--- Define your better-ts-errors setup.
---
---@param options table Module config table. See |BetterTsErrors.options|.
---
---@usage `require("better-ts-errors").setup()` (add `{}` with your |BetterTsErrors.options| table)
function BetterTsErrors.setup(options)
    options = options or {}

    BetterTsErrors.options = vim.tbl_deep_extend("keep", options, BetterTsErrors.options)

    local keymap = BetterTsErrors.options.keymaps or
        { toggle = DefaultToggleKeyMap, go_to_definition = DefaultGoToDefinitionKeyMap }

    vim.api.nvim_set_keymap('n', keymap.toggle, '<cmd>lua BetterTsErrors.toggle()<CR>',
        { noremap = true, silent = true, desc = 'Show Better TS Error' })

    vim.api.nvim_set_keymap('n', keymap.go_to_definition, '<cmd>lua BetterTsErrors.goToDefinition()<CR>',
        { noremap = true, silent = true, desc = 'Go to Error Definition' })

    return BetterTsErrors.options
end

return BetterTsErrors
