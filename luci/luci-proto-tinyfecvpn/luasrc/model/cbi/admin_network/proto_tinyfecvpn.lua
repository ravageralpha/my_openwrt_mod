local map, section, net = ...
local fs = require "nixio.fs"

local server, passwd, fec, subnet, extra

server = section:taboption("general", Value, "server", translate("Server"))
server.optional = false

passwd = section:taboption("general", Value, "passwd", translate("Password"))
passwd.password = true
passwd.optional = false

fec = section:taboption("general", Value, "fec", translate("FEC"))
fec.default = "20:10"
fec.placeholder = "20:10"

subnet = section:taboption("general", Value, "subnet", translate("Subnet"))
subnet.default = "10.0.0.0"
subnet.placeholder = "10.0.0.0"
subnet.optional = false

extra = section:taboption("general", Value, "extra", translate("Extra Options"))

clientup = section:taboption("advanced", TextValue, "clientup", "client_up.sh")
clientup.template = "cbi/tvalue"
clientup.rows = 15

function clientup.cfgvalue(self, section)
	return fs.readfile("/etc/tinyfecvpn/client_up.sh") or ""
end

function clientup.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/tinyfecvpn/client_up.sh", value)
	end
end

clientdown = section:taboption("advanced", TextValue, "clientdown", "client_down.sh")
clientdown.template = "cbi/tvalue"
clientdown.rows = 15

function clientdown.cfgvalue(self, section)
	return fs.readfile("/etc/tinyfecvpn/client_down.sh") or ""
end

function clientdown.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/tinyfecvpn/client_down.sh", value)
	end
end
