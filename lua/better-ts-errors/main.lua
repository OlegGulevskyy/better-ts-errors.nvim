local D = require("better-ts-errors.util.debug")
local Gt = require("better-ts-errors.goto")
local diagnostics = require("better-ts-errors.diagnostics")

-- internal methods
local BetterTsErrors = {}

-- state
local S = {
    -- Boolean determining if the plugin is enabled or not.
    enabled = false,
}

---Toggle the plugin by calling the `enable`/`disable` methods respectively.
---@private
function BetterTsErrors.toggle()
    if S.enabled then
        return BetterTsErrors.disable()
    end

    return BetterTsErrors.enable()
end

---Initializes the plugin.
---@private
function BetterTsErrors.enable()
    if S.enabled then
        return S
    end

    diagnostics.show(true)
    S.enabled = true
    return S
end

---Disables the plugin and reset the internal state.
---@private
function BetterTsErrors.disable()
    if not S.enabled then
        return S
    end

    -- reset the state
    S.enabled = false

    diagnostics.show(false)
    return S
end

function BetterTsErrors.goToDefinition()
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local word = Gt.get_word_under_cursor()

    if S.enabled then
        BetterTsErrors.disable()
    end

    Gt.find_and_goto_symbol(word)
end

return BetterTsErrors
