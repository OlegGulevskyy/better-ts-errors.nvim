local S = {}

local severity_map = {
    [1] = 'Error',
    [2] = 'Warning',
    [3] = 'Info',
    [4] = 'Hint',
    [5] = 'Deprecation',
}

S.get_severity = function(severity_code)
    return severity_map[severity_code]
end

return S
