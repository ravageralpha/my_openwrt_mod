--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local sslocal =(luci.sys.call("pidof ss-local > /dev/null") == 0)
local ssredir =(luci.sys.call("pidof ss-redir > /dev/null") == 0)

local button =""

if sslocal or ssredir then	
	m = Map("shadowsocks", translate("shadowsocks"), translate("shadowsocks is running"))
else
	m = Map("shadowsocks", translate("shadowsocks"), translate("shadowsocks is not running"))
end

server = m:section(TypedSection, "shadowsocks", translate("Server Setting"))
server.anonymous = true

remote_server = server:option(Value, "remote_server", translate("Server Address"))
remote_server.datatype = ipaddr
remote_server.optional = false

remote_port = server:option(Value, "remote_port", translate("Server Port"))
remote_port.datatype = "range(0,65535)"
remote_port.optional = false

cipher = server:option(ListValue, "cipher", translate("Cipher Method"))
cipher:value("table")
cipher:value("rc4")
cipher:value("aes-128-cfb")
cipher:value("aes-192-cfb")
cipher:value("aes-256-cfb")
cipher:value("bf-cfb")
cipher:value("cast5-cfb")
cipher:value("des-cfb")
cipher:value("camellia-128-cfb")
cipher:value("camellia-192-cfb")
cipher:value("camellia-256-cfb")
cipher:value("idea-cfb")
cipher:value("rc2-cfb")
cipher:value("seed-cfb")

socks5 = m:section(TypedSection, "shadowsocks", translate("SOCKS5 Proxy"))
socks5.anonymous = true

switch = socks5:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

local_port = socks5:option(Value, "local_port", translate("Local Port"))
local_port.datatype = "range(0,65535)"
local_port.optional = false

password = socks5:option(Value, "password", translate("Password"))
password.password = true

redir = m:section(TypedSection, "shadowsocks", translate("Transparent Proxy"))
redir.anonymous = true

redir_enable = redir:option(Flag, "redir_enabled", translate("Enable"))
redir_enable.default = false

redir_port = redir:option(Value, "redir_port", translate("Transparent Proxy Local Port"))
redir_port.datatype = "range(0,65535)"
redir_port.optional = false
redir_port:depends("redir_enabled", 1)

blacklist_enable = redir:option(Flag, "blacklist_enabled", translate("Bypass Lan IP"))
blacklist_enable.default = false
blacklist_enable:depends("redir_enabled", 1)

blacklist = redir:option(TextValue, "blacklist", " ", "")
blacklist.template = "cbi/tvalue"
blacklist.size = 30
blacklist.rows = 10
blacklist.wrap = "off"
blacklist:depends("blacklist_enabled", 1)

function blacklist.cfgvalue(self, section)
	return fs.readfile("/etc/ipset/blacklist") or ""
end
function blacklist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/blacklist", value)
		fs.mkdirr("/etc/ipset")
		if (fs.access("/etc/ipset/blacklist") ~= true or luci.sys.call("cmp -s /tmp/blacklist /etc/ipset/blacklist") == 1) then
			fs.writefile("/etc/ipset/blacklist", value)
		end
		fs.remove("/tmp/blacklist")
	end
end

whitelist_enable = redir:option(Flag, "whitelist_enabled", translate("Bypass IP Whitelist"))
whitelist_enable.default = false
whitelist_enable:depends("redir_enabled", 1)

whitelist = redir:option(TextValue, "whitelist", " ", "")
whitelist.template = "cbi/tvalue"
whitelist.size = 30
whitelist.rows = 10
whitelist.wrap = "off"
whitelist:depends("whitelist_enabled", 1)

function whitelist.cfgvalue(self, section)
	return fs.readfile("/etc/ipset/whitelist") or ""
end
function whitelist.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/tmp/whitelist", value)
		fs.mkdirr("/etc/ipset")
		if (fs.access("/etc/ipset/whitelist") ~= true or luci.sys.call("cmp -s /tmp/whitelist /etc/ipset/whitelist") == 1) then
			fs.writefile("/etc/ipset/whitelist", value)
		end
		fs.remove("/tmp/whitelist")
	end
end

return m


