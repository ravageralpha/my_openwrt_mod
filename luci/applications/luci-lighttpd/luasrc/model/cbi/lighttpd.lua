--[[
RA-MOD
]]--
local fs = require "nixio.fs"

m = Map("lighttpd", translate("lighttpd"))

s = m:section(TypedSection, "lighttpd", "")
s.anonymous = true

editconf = s:option(Value, "_data", "")
editconf.template = "cbi/tvalue"
editconf.rows = 25
editconf.wrap = "off"

function editconf.cfgvalue(self, section)
	return fs.readfile("/etc/lighttpd/lighttpd.conf") or ""
end
function editconf.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/lighttpd.conf", value)
		if (luci.sys.call("cmp -s /tmp/lighttpd.conf /etc/lighttpd/lighttpd.conf") == 1) then
			fs.writefile("/etc/lighttpd/lighttpd.conf", value)
		end
		fs.remove("/tmp/lighttpd.conf")
	end
end

return m
