local fs = require "nixio.fs"

local running=(luci.sys.call("pidof udp2raw > /dev/null") == 0)
if running then	
	m = Map("udp2raw", translate("udp2raw"), translate("udp2raw is running"))
else
	m = Map("udp2raw", translate("udp2raw"), translate("udp2raw is not running"))
end

s = m:section(TypedSection, "udp2raw", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

options = s:option(Value, "args", translate("Args"))
options.optional = false;

return m
