local M = {}

M.get_variable_pos = function(line, current_line_num)
    local pattern = "'(.-)'"
    local matches = {}
    for match in string.gmatch(line, pattern) do
        -- Find the position of the current match
        local start_pos, end_pos = string.find(line, "'" .. match .. "'", 1, true)

        -- Check if match is JS object, try to prettify it
        local is_js_object = string.find(match, "{", 1, true) ~= nil
        local match_res = is_js_object and prettify_string(match) or match
        table.insert(matches,
            {
                match = match_res,
                col_start = start_pos - 1,
                col_end = end_pos,
                line = current_line_num,
                is_raw_object =
                    is_js_object
            })
    end
    return matches
end

function prettify_string(str)
    -- If JS object is too big, it will have "...;" in its children
    -- Need to replace those temporarily, otherwise prettier will fail
    local preprocess = str:gsub("(%.%.%.%;)", " REPLACE_KEY: null ")
    local command = "echo \"" .. preprocess .. "\" | prettier --parser typescript"

    -- Execute the command and check for errors
    local output, status = vim.fn.systemlist(command)

    if vim.v.shell_error == 0 then
        -- Command executed successfully, process the output
        local postprocess = table.concat(output, "\n"):gsub("(REPLACE_KEY: null)", "...")
        return postprocess
    else
        -- Command failed, return the original string
        return "'" .. str .. "'"
    end
end

return M
