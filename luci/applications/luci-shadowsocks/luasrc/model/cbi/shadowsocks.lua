--[[
RA-MOD
]]--

local fs = require "nixio.fs"

local sslocal =(luci.sys.call("pidof ss-local > /dev/null") == 0)
local ssredir =(luci.sys.call("pidof ss-redir > /dev/null") == 0)
if sslocal or ssredir then	
	m = Map("shadowsocks", translate("shadowsocks"), translate("shadowsocks is running"))
else
	m = Map("shadowsocks", translate("shadowsocks"), translate("shadowsocks is not running"))
end

c = {
	"table",
	"rc4",
	"rc4-md5",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"bf-cfb",
	"cast5-cfb",
	"des-cfb",
	"camellia-128-cfb",
	"camellia-192-cfb",
	"camellia-256-cfb",
	"idea-cfb",
	"rc2-cfb",
	"seed-cfb",
	"chacha20",
	"salsa20",
}

server = m:section(TypedSection, "shadowsocks", translate("Server Setting"))
server.anonymous = true

remote_server = server:option(Value, "remote_server", translate("Server Address"))
remote_server.datatype = ipaddr
remote_server.optional = false

remote_port = server:option(Value, "remote_port", translate("Server Port"))
remote_port.datatype = "range(0,65535)"
remote_port.optional = false

password = server:option(Value, "password", translate("Password"))
password.password = true
password.optional = false

timeout = server:option(Value, "timeout", translate("Timeout"))
timeout.default = "60"
timeout.optional = false

ota = server:option(Flag, "ota_enabled", translate("OneTime Authentication"))

cipher = server:option(ListValue, "cipher", translate("Cipher Method"))
for i,v in ipairs(c) do
	cipher:value(v)
end

alt_enabled = server:option(Flag, "alt_enabled", translate("Alternate Server For UDP Traffic"))
alt_enabled.rmempty = false

alt_server = server:option(Value, "alt_server", translate("Alternate Server Address"))
alt_server:depends("alt_enabled", 1)
alt_server.optional = false
alt_server.datatype = ipaddr

alt_port = server:option(Value, "alt_port", translate("Alternate Port"))
alt_port:depends("alt_enabled", 1)
alt_port.optional = false

alt_passwd = server:option(Value, "alt_passwd", translate("Alternate Password"))
alt_passwd:depends("alt_enabled", 1)
alt_passwd.password = true
alt_passwd.optional = false

alt_cipher = server:option(ListValue, "alt_cipher", translate("Alternate Cipher Method"))
alt_cipher:depends("alt_enabled", 1)
alt_cipher.optional = false
for i,v in ipairs(c) do
	alt_cipher:value(v)
end

alt_timeout = server:option(Value, "alt_timeout", translate("Alternate Timeout"))
alt_timeout:depends("alt_enabled", 1)
alt_timeout.default = "60"
alt_timeout.optional = false

alt_ota = server:option(Flag, "alt_ota_enabled", translate("Alternate OneTime Authentication"))
alt_ota:depends("alt_enabled", 1)

socks5 = m:section(TypedSection, "shadowsocks", translate("SOCKS5 Proxy"))
socks5.anonymous = true

switch = socks5:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

local_port = socks5:option(Value, "local_port", translate("Local Port"))
local_port.datatype = "range(0,65535)"
local_port.optional = false

tunnel = m:section(TypedSection, "shadowsocks", translate("Forwarding Tunnel"))
tunnel.anonymous = true

tunnel_enable = tunnel:option(Flag, "tunnel_enabled", translate("Enable"))
tunnel_enable.rmempty = false

tunnel_port = tunnel:option(Value, "tunnel_port", translate("Tunnel Local Port"))
tunnel_port.datatype = "range(0,65535)"
tunnel_port.default = 5353

tunnel_forward = tunnel:option(Value, "tunnel_forward", translate("Forwarding Port"))
tunnel_forward.default = "8.8.8.8:53"

redir = m:section(TypedSection, "shadowsocks", translate("Transparent Proxy"))
redir.anonymous = true

redir_enable = redir:option(Flag, "redir_enabled", translate("Enable"))
redir_enable.default = false

redir_port = redir:option(Value, "redir_port", translate("Local Port"))
redir_port.datatype = "range(0,65535)"
redir_port.optional = false

tproxy_enable = redir:option(Flag, "udp_enabled", translate("UDP Traffic"))
tproxy_enable.default = false
tproxy_enable.optional = false

alt_redir_port = redir:option(Value, "alt_redir_port", translate("Alternate Local Port"))
alt_redir_port:depends("udp_enabled", 1)
alt_redir_port.datatype = "range(0,65535)"
alt_redir_port.optional = false

blacklist_enable = redir:option(Flag, "blacklist_enabled", translate("Bypass Lan IP"))
blacklist_enable.default = false

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


