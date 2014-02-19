--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local running=(luci.sys.call("pidof pdnsd > /dev/null") == 0)
if running then	
	m = Map("pdnsd", translate("pdnsd"), translate("pdnsd is running"))
else
	m = Map("pdnsd", translate("pdnsd"), translate("pdnsd is not running"))
end

s = m:section(TypedSection, "pdnsd", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

editconf = s:option(Value, "_data", " ")
editconf.template = "cbi/tvalue"
editconf.rows = 25
editconf.wrap = "off"

function editconf.cfgvalue(self, section)
	return fs.readfile("/etc/pdnsd.conf") or ""
end
function editconf.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/pdnsd.conf", value)
		if (luci.sys.call("cmp -s /tmp/pdnsd.conf /etc/pdnsd.conf") == 1) then
			fs.writefile("/etc/pdnsd.conf", value)
		end
		fs.remove("/tmp/pdnsd.conf")
	end
end

return m
