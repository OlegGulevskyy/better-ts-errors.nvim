local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local M = {}
M.is_open = false

local popup = Popup({
    enter = true,
    focusable = true,
    border = {
        style = "rounded",
    },
    position = "50%",
    size = {
        width = "80%",
        height = "60%",
    },
})

M.show = function()
    popup:mount()
    M.is_open = true

    popup:on(event.BufLeave, function()
        M.hide()
    end)
end

M.hide = function()
    popup:unmount()
    M.is_open = false
end

M.toggle = function()
    if M.is_open then
        M.hide()
    else
        M.show()
    end
end

M.get_width = function()
    return popup.win_config.width
end

M.get_buffnr = function()
    return popup.bufnr
end

return M
