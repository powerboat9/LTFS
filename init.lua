local dir = ... or "/tmp"

local function pathToTable(s)
    if type(s) ~= "string" then
        error("Invalid path", 2)
    end
    local path = {struct = {""}, isRoot = (s:sub(1, 1) == "/")}
    local i = 2
    local isQuoted, isEscaped = false, false
    while i <= #s do
        local char = s:sub(i, i)
        if not isEscaped then
            if char == "\\" then
                isEscaped = true
            elseif char == "/" then
                if #path.struct > 1 and path.struct[#path.struct] == ".." then
                    for _ = 1, 2 do
                        path.struct[#path.struct] = nil
                    end
                elseif path.struct[#path.struct] == "." then
        
                path.struct[#path.struct + 1] = ""
