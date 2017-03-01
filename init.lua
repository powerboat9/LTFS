local dir = ... or "/tmp"

local maps = {}
local lookup = {}
local autofillCache

local function addRaw(filePath, funct, m, errLevel)
    if type(filePath) ~= "string" then
        error("Invalid filename", errLevel or 2)
    elseif type(funct) ~= "function" then
        error("Invalid function", errLevel or 2)
    end
    filePath = shell.resolve(filePath)
    local i = #maps + 1
    maps[i] = {
    	m = m or -1,
        filePath = filePath,
        funct = funct,
        data = {}
    }
    lookup[filePath] = i
    return i
end

local function addFile(filePath, funct)
    return addRaw(filePath, funct, 0, 3)
end

local function addDir(filePath, funct)
    return addRaw(filePath, funct, 1, 3)
end

local function removeNode(i)
    local lookedUp = lookup[i]
    if lookedUp then
        lookup[i] = nil
        maps[lookedUp] = nil
    elseif type(i) == "number" then
        lookup[maps[i].filePath] = nil
        maps[i] = nil
    else
        error("Invalid index", 2)
    end
end

local oldFS = _G.fs
local newFS = {}

function newFS.open(filePath, mode)
    if type(filePath) ~= "string" then
        error("Invalid filename", 2)
    end
    filePath = shell.resolve(filePath)
    local i = lookup[filePath]
    if i then
        local node = maps[i]
        if node.m ~= 0 and node.m ~= -1 then
            error("Could not open file, not a file", 2)
        end
        return node.funct(data, "open", filePath, mode)
    else
        return oldFS.open(filePath, mode)
    end
end

function newFS.list(path)
    if path == nil
        path = ""
    elseif type(path) ~= "string" then
        error("Invalid path", 2)
    end
    path = oldResolve
    local results, ri = nil, 1
    local i = lookup[pa
    elseif oldFS.isDir(path) then
        results = fs.list(path)
    else
        results = {}
    end
    for i, node in pairs(maps) do
        local cmp = node.filePath
        if #cmp < #path and path:sub(1, #cmp) == cmp and not path:sub(#cmp + 1):find("/") then
            results[ri] = path:sub(#cmp + 1)
            ri++
        end
    end