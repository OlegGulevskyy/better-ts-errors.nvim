local parser = require("better-ts-errors.parser")
local codes = require("better-ts-errors.util.codes")
local severity = require("better-ts-errors.util.severity")
local strings_utils = require("better-ts-errors.util.strings")
local popup = require("better-ts-errors.popup")
local M = {}

-- Prepare header
M.handle_header = function(diag_severity, diag_code, diagnostics_count, current_line_num)
    local sev = severity.get_severity(diag_severity)
    local code = codes.get_code(diag_code)

    local pop_width = popup.get_width()
    local header_lines = { sev, code }

    -- To set highlights, we need line numbers that are indexed from 0
    local normalized_line_nr = (current_line_num == 0) and 0 or (current_line_num - 1)
    local severity_pos = {
        line = normalized_line_nr,
        col_start = 0,
        col_end = #sev,
    }

    local code_pos = {
        line = severity_pos.line + 1,
        col_start = 0,
        col_end = #code,
    }

    vim.api.nvim_buf_set_lines(popup.get_buffnr(), current_line_num, current_line_num + #header_lines, false,
        header_lines)
    return header_lines, severity_pos, code_pos
end

-- Prepare body
M.handle_body = function(message, diag_count, index, current_line_num)
    local normalized_line_nr = (current_line_num == 0) and 0 or (current_line_num - 1)
    local message_start_row = normalized_line_nr + 2

    local body_lines = strings_utils.break_new_lines(message)
    -- Ensure at least 2 rows for each message
    if #body_lines < 2 then
        table.insert(body_lines, "") -- Add an extra empty line
    end

    local new_body_lines = {}
    local vars = {}
    local added_lines_count = 0
    local prettified_lines = {}

    local line_index = 0
    for _, line in ipairs(body_lines) do
        local temp_vars = parser.get_variable_pos(line, message_start_row + line_index)
        local has_raw_object = false
        local identation_size = strings_utils.get_padding(line)

        for _, temp_var in ipairs(temp_vars) do
            if temp_var.is_raw_object then
                has_raw_object = true

                -- Split the line into two parts
                local part1 = string.sub(line, 1, temp_var.col_start)
                local part2 = string.sub(line, temp_var.col_end + 1)

                -- Calculate start position for prettified lines
                -- Determine the starting row for the prettified lines
                local prettified_start = message_start_row + #new_body_lines

                -- Insert the first part into new_body_lines
                if part1 ~= "" then
                    table.insert(new_body_lines, part1)
                end

                -- Insert the prettified lines
                local lines = strings_utils.break_new_lines(temp_var.match)


                for _, l in ipairs(lines) do
                    table.insert(new_body_lines, string.rep(" ", identation_size) .. l)
                end

                table.insert(prettified_lines, {
                    line_start = prettified_start + 2, -- +2 for the header
                    line_end = prettified_start + #lines - 1,
                    indentation = identation_size
                })

                -- Insert the second part into new_body_lines
                if part2 ~= "" and part2 ~= "." then
                    table.insert(new_body_lines, string.rep(" ", identation_size) .. part2)
                end

                added_lines_count = added_lines_count + #lines - 1
            else
                table.insert(vars, temp_var)
            end
        end

        -- If the line does not contain a raw object, add it as is
        if not has_raw_object then
            table.insert(new_body_lines, line)
        end

        line_index = line_index + 1
    end

    body_lines = new_body_lines
    local pop_width = popup.get_width()

    local new_vars = {}
    local line_i = 0
    for _, line in ipairs(body_lines) do
        local temp_vars = parser.get_variable_pos(line, message_start_row + line_i)
        for _, temp_var in ipairs(temp_vars) do
            table.insert(new_vars, temp_var)
        end
        line_i = line_i + 1
    end

    if index ~= diag_count then
        local separator = ""
        for i = 1, pop_width do
            separator = separator .. "_"
        end
        table.insert(body_lines, separator)
    end

    local message_end_pos = message_start_row + #body_lines
    vim.api.nvim_buf_set_lines(popup.get_buffnr(), message_start_row, message_end_pos, false, body_lines)
    return message_end_pos, new_vars, prettified_lines
end

M.show = function(is_enabled)
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = current_line })

    if is_enabled then
        popup.show()
    else
        popup.hide()
        return
    end

    local severity_hl_ranges = {}
    local code_hl_ranges = {}
    local vars_hl_ranges = {}
    local current_line_num = 0
    local prettified = nil

    for index, diagnostic in ipairs(diagnostics) do
        local header_lines, severity_pos, code_pos = M.handle_header(diagnostic.severity, diagnostic.code, #diagnostics,
            current_line_num)

        local message_end_pos, vars, prettified_ranges = M.handle_body(diagnostic.message, #diagnostics, index,
            current_line_num)
        prettified = prettified_ranges

        table.insert(severity_hl_ranges, severity_pos)
        table.insert(code_hl_ranges, code_pos)
        for _, var in ipairs(vars) do
            table.insert(vars_hl_ranges, var)
        end

        -- Update the current line number for the next diagnostic, adding an extra line for spacing
        current_line_num = current_line_num + math.max(#header_lines, message_end_pos) + 1 -- +1 for the extra space
    end

    for i, range in ipairs(severity_hl_ranges) do
        local sev = severity.get_severity(diagnostics[i].severity)
        local hl_group = "Diagnostic" .. sev
        vim.api.nvim_buf_add_highlight(popup.get_buffnr(), -1, hl_group, range.line, range.col_start, range.col_end)
    end

    for _, range in ipairs(code_hl_ranges) do
        local hl_group = "Comment"
        vim.api.nvim_buf_add_highlight(popup.get_buffnr(), -1, hl_group, range.line, range.col_start, range.col_end)
    end

    for _, range in ipairs(vars_hl_ranges) do
        local hl_group = "String"
        vim.api.nvim_buf_add_highlight(popup.get_buffnr(), -1, hl_group, range.line, range.col_start, range.col_end)
    end

    -- If we have some prettified objects, highlight them
    if prettified ~= nil then
        for _, range in ipairs(prettified) do
            local hl_group = "BufferDefaultCurrentADDED"
            for i = (range.line_start - 1), (range.line_end + 1) do
                vim.api.nvim_buf_add_highlight(popup.get_buffnr(), -1, hl_group, i, range.indentation, popup.get_width())
            end
        end
    end
end

return M
