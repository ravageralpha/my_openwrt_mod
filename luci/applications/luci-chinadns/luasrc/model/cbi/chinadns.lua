--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local running=(luci.sys.call("pidof chinadns > /dev/null") == 0)
if running then	
	m = Map("chinadns", translate("chinadns"), translate("chinadns is running"))
else
	m = Map("chinadns", translate("chinadns"), translate("chinadns is not running"))
end

s = m:section(TypedSection, "chinadns", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

upstream = s:option(Value, "dns", translate("Upstream DNS Server"))
upstream.optional = false
upstream.default = "114.114.114.114,8.8.8.8"

port = s:option(Value, "port", translate("Port"))
port.datatype = "range(0,65535)"
port.optional = false

iplist = s:option(Value, "iplist", translate("IP blacklist"), "")
iplist.template = "cbi/tvalue"
iplist.size = 30
iplist.rows = 10
iplist.wrap = "off"

function iplist.cfgvalue(self, section)
	return fs.readfile("/etc/chinadns_iplist.txt") or ""
end
function iplist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/chinadns_iplist.txt", value)
	end
end

chn = s:option(Value, "chn", translate("CHNroute"), "")
chn.template = "cbi/tvalue"
chn.size = 30
chn.rows = 10
chn.wrap = "off"

function chn.cfgvalue(self, section)
	return fs.readfile("/etc/chinadns_chnroute.txt") or ""
end
function chn.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/chinadns_chnroute.txt", value)
	end
end

return m
