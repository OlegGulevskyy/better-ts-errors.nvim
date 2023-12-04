local hash_util = require("better-ts-errors.util.hash")
local strings_util = require("better-ts-errors.util.strings")

local M = {
    prettify_cache = {}
}

function allow_prettify()
    if _G.BetterTsErrors.config ~= nil then
        return _G.BetterTsErrors.config.enable_prettify
    end
    return false
end

function wrap_match_quotes(match)
    return "'" .. match .. "'"
end

M.get_variable_pos = function(line, current_line_num)
    local pattern = "'(.-)'"
    local matches = {}
    for match in string.gmatch(line, pattern) do
        -- Find the position of the current match
        local start_pos, end_pos = string.find(line, wrap_match_quotes(match), 1, true)

        -- Check if match is JS object, try to prettify it
        local is_js_object = string.find(match, "{", 1, true) ~= nil
        local match_res = (is_js_object and allow_prettify()) and prettify_string(match) or wrap_match_quotes(match)
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

function contains_union_type(str)
    return string.find(str, "|")
end

function string_to_temp_ts_type(str)
    return "type BTE_REPLACE_KEY = " .. str
end

-- Best effort for now
function temp_ts_type_to_string(str)
    local pattern = "^type BTE_REPLACE_KEY =[%s%S](.*)"
    local matched = string.match(str, pattern)
    return matched or str
end

function prettify_string(str)
    local hashed = hash_util.simpleHash(str)
    local has_union = contains_union_type(str)

    if has_union then
        str = string_to_temp_ts_type(str)
    end

    if M.prettify_cache[hashed] ~= nil then
        return M.prettify_cache[hashed]
    end

    local preprocess = str:gsub("(%.%.%.%;)", " BTE_REPLACE_KEY: null ")
    local command = "echo \"" .. preprocess .. "\" | prettier --parser typescript"

    -- Execute the command and check for errors
    local output = vim.fn.systemlist(command)
    if vim.v.shell_error == 0 then
        local postprocess = table.concat(output, "\n"):gsub("(BTE_REPLACE_KEY: null)", "...")
        if has_union then
            postprocess = temp_ts_type_to_string(postprocess)
        end
        -- postprocess = strings_util.trim_string(postprocess)

        M.prettify_cache[hashed] = postprocess
        return postprocess
    else
        -- Command failed, return the original string
        return wrap_match_quotes(str)
    end
end

return M
