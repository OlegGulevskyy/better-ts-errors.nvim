local BetterTsErrors = {}

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
BetterTsErrors.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
    enable_prettify = false,
}

--- Define your better-ts-errors setup.
---
---@param options table Module config table. See |BetterTsErrors.options|.
---
---@usage `require("better-ts-errors").setup()` (add `{}` with your |BetterTsErrors.options| table)
function BetterTsErrors.setup(options)
    options = options or {}

    BetterTsErrors.options = vim.tbl_deep_extend("keep", options, BetterTsErrors.options)

    return BetterTsErrors.options
end

return BetterTsErrors
