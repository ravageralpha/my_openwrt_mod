--[[
LuCI - Lua Configuration Interface

Copyright 2011 RA <ravageralpha@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local map, section, net = ...
local fs = require "nixio.fs"

local server, remote, ifname, localnet, udprelay, opts, localdns

server = section:taboption("general", Value, "server", translate("Socks Server"))
server.placeholder = "127.0.0.1:1080"
server.optional = false

remote = section:taboption("general", Value, "remote", translate("Actual Server IP Address"))
remote.datatype = ipaddr
remote.optional = false

udprelay = section:taboption("general", Flag, "udprelay", translate("Enable UDP Relay"))

localnet = section:taboption("general", Value, "localnet", translate("Local Address"))
localnet.default = "10.0.0.2/24"
localnet.placeholder = "10.0.0.2/24"
localnet.optional = false

localdns = section:taboption("general", Value, "localdns", translate("Local DNS"))
localdns.rmempty = true
localdns.optional = true

opts = section:taboption("general", Value, "opts", translate("Extra Options"))
opts.rmempty = true
opts.optional = true

ifname = section:taboption("general", Value, "interface", translate("Output Interface"))
ifname.template = "cbi/network_netlist"

clientup = section:taboption("advanced", TextValue, "clientup", "client_up.sh")
clientup.template = "cbi/tvalue"
clientup.rows = 15

function clientup.cfgvalue(self, section)
	return fs.readfile("/etc/tun2socks/client_up.sh") or ""
end

function clientup.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/tun2socks/client_up.sh", value)
	end
end

clientdown = section:taboption("advanced", TextValue, "clientdown", "client_down.sh")
clientdown.template = "cbi/tvalue"
clientdown.rows = 15

function clientdown.cfgvalue(self, section)
	return fs.readfile("/etc/tun2socks/client_down.sh") or ""
end

function clientdown.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/tun2socks/client_down.sh", value)
	end
end
