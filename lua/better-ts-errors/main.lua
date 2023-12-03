local D = require("better-ts-errors.util.debug")
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

return BetterTsErrors
