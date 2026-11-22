--[[
Clean-room JPLua bootstrap script (lua/init.lua) for JA++ WebAssembly.

Authored strictly from the GPLv2 C++ bindings in game/bg_lua*.cpp and
cgame/cg_lua*.cpp (without consulting any external/unlicensed asset packs).
License: GPLv2 (matching JA++ source).
]]

-- Database backend identifiers expected by ConnectToDB(dbType, ...)
-- Derived from game/bg_lua.cpp:ConnectToDB
DBType = {
    MYSQL  = 1,
    SQLITE = 2,
}

-- Event names accepted by AddListener(name, fn) / RemoveListener(name)
-- Derived from game/bg_luaevent.cpp:eventNames[]
Event = {
    UNLOAD                = "JPLUA_EVENT_UNLOAD",
    RUNFRAME              = "JPLUA_EVENT_RUNFRAME",
    CHATMSGRECV           = "JPLUA_EVENT_CHATMSGRECV",
    CHATMSGSEND           = "JPLUA_EVENT_CHATMSGSEND",
    CHATMSGPLUGIN         = "JPLUA_EVENT_CHATMSGPLUGIN",
    CLIENTBEGIN           = "JPLUA_EVENT_CLIENTBEGIN",
    CLIENTCOMMAND         = "JPLUA_EVENT_CLIENTCOMMAND",
    CLIENTCONNECT         = "JPLUA_EVENT_CLIENTCONNECT",
    CLIENTDISCONNECT      = "JPLUA_EVENT_CLIENTDISCONNECT",
    CLIENTINFO            = "JPLUA_EVENT_CLIENTINFO",
    CLIENTSPAWN           = "JPLUA_EVENT_CLIENTSPAWN",
    CLIENTUSERINFOCHANGED = "JPLUA_EVENT_CLIENTUSERINFOCHANGED",
    HUD                   = "JPLUA_EVENT_HUD",
    VEHICLEHUD            = "JPLUA_EVENT_VEHICLEHUD",
    CONNECTSCREEN         = "JPLUA_EVENT_CONNECTSCREEN",
    PAIN                  = "JPLUA_EVENT_PAIN",
    PLAYERDEATH           = "JPLUA_EVENT_PLAYERDEATH",
    PRIVATEDUEL           = "JPLUA_EVENT_PRIVATEDUEL",
    SABERTOUCH            = "JPLUA_EVENT_SABERTOUCH",
    KEYDOWN               = "JPLUA_EVENT_KEYDOWN",
}

-- Standard Quake 3 / Jedi Academy color escape codes
Color = {
    BLACK   = "^0",
    RED     = "^1",
    GREEN   = "^2",
    YELLOW  = "^3",
    BLUE    = "^4",
    CYAN    = "^5",
    MAGENTA = "^6",
    WHITE   = "^7",
}

-- Lightweight string helper utilities commonly useful to plugins
function string.split(str, sep)
    local result = {}
    if not str then
        return result
    end
    sep = sep or "%s"
    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        result[#result + 1] = part
    end
    return result
end

function string.trim(str)
    if not str then
        return ""
    end
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

local side = (JPLua and JPLua.isServer) and "server" or "client"
local ver = (JPLua and JPLua.version)
    and string.format("%d.%d.%d", JPLua.version.major, JPLua.version.minor, JPLua.version.patch)
    or "unknown"
print(string.format("^2JPLua:^7 clean-room init.lua loaded (%s, JPLua v%s)\n", side, ver))
