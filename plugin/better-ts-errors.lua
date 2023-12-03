-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.BetterTsErrorsLoaded then
    return
end

_G.BetterTsErrorsLoaded = true

vim.api.nvim_create_user_command("BetterTsErrors", function()
    require("better-ts-errors").toggle()
end, {})
