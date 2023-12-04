local M = require("better-ts-errors.main")

local BetterTsErrors = {}
local DefaultKeyMap = "<leader>dd"

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
BetterTsErrors.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
    keymap = nil,
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

    local keymap = BetterTsErrors.options.keymap or DefaultKeyMap

    vim.api.nvim_set_keymap('n', keymap, '<cmd>lua BetterTsErrors.toggle()<CR>',
        { noremap = true, silent = true, desc = 'Show Better TS Error' })
    return BetterTsErrors.options
end

return BetterTsErrors
