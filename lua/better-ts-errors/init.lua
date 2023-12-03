local M = require("better-ts-errors.main")
local BetterTsErrors = {}

-- Toggle the plugin by calling the `enable`/`disable` methods respectively.
function BetterTsErrors.toggle()
    -- when the config is not set to the global object, we set it
    if _G.BetterTsErrors.config == nil then
        _G.BetterTsErrors.config = require("better-ts-errors.config").options
    end

    _G.BetterTsErrors.state = M.toggle()
end

-- starts BetterTsErrors and set internal functions and state.
function BetterTsErrors.enable()
    if _G.BetterTsErrors.config == nil then
        _G.BetterTsErrors.config = require("better-ts-errors.config").options
    end

    local state = M.enable()

    if state ~= nil then
        _G.BetterTsErrors.state = state
    end

    return state
end

-- disables BetterTsErrors and reset internal functions and state.
function BetterTsErrors.disable()
    _G.BetterTsErrors.state = M.disable()
end

-- setup BetterTsErrors options and merge them with user provided ones.
function BetterTsErrors.setup(opts)
    _G.BetterTsErrors.config = require("better-ts-errors.config").setup(opts)
end

_G.BetterTsErrors = BetterTsErrors

return _G.BetterTsErrors
