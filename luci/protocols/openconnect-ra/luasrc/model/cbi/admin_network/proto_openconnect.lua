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

local username, password, server, port, serverhash, authgroup,
	  cafile, usercert_switch, usercert, privatekey

local config = net.sid
local ca_file = "/etc/openconnect/ca-vpn-" .. config .. ".pem"
local usercert_file = "/etc/openconnect/user-cert-vpn-" .. config .. ".pem"
local privatekey_file = "/etc/openconnect/user-key-vpn-" .. config .. ".pem"

server = section:taboption("general", Value, "server", translate("VPN Server"))
server.datatype = "host"

port = section:taboption("general", Value, "port", translate("Port"))
port.default = "443"
port.datatype = "port"

username = section:taboption("general", Value, "username", translate("Username"))

password = section:taboption("general", Value, "password", translate("Password"))
password.password = true

authgroup = section:taboption("general", Value, "authgroup", translate("Authentication Login Group"))

serverhash = section:taboption("general", Value, "serverhash", translate("Server SHA1 Fingerprint"))

ca_switch = section:taboption("general", Flag, "ca_switch", translate("CA Authentication"))
ca_switch.default = false

function ca_switch.write(self, section, value)
	if value == "0" then
		fs.remove(ca_file)
	end
	Flag.write(self, section, value)
end

cafile = section:taboption("general", TextValue, "cafile", translate("CA Certificate"))
cafile.template = "cbi/tvalue"
cafile.rows = 15
cafile:depends("ca_switch", 1)

function cafile.cfgvalue(self, section)
	return fs.readfile(ca_file) or ""
end

function cafile.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.mkdirr("/etc/openconnect")
		fs.writefile(ca_file, value)
	end
end

usercert_switch = section:taboption("general", Flag, "usercert_switch", translate("Certificate Authentication"))
usercert_switch.default = false

function usercert_switch.write(self, section, value)
	if value == "0" then
		fs.remove(usercert_file)
		fs.remove(privatekey_file)
	end
	Flag.write(self, section, value)
end

usercert = section:taboption("general", TextValue, "usercert", translate("User Certificate"))
usercert.template = "cbi/tvalue"
usercert.rows = 15
usercert:depends("usercert_switch", 1)

function usercert.cfgvalue(self, section)
	return fs.readfile(usercert_file) or ""
end

function usercert.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.mkdirr("/etc/openconnect")
		fs.writefile(usercert_file, value)
	end
end

privatekey = section:taboption("general", TextValue, "privatekey", translate("User Private Key"))
privatekey.template = "cbi/tvalue"
privatekey.rows = 15
privatekey:depends("usercert_switch", 1)

function privatekey.cfgvalue(self, section)
	return fs.readfile(privatekey_file) or ""
end

function privatekey.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.mkdirr("/etc/openconnect")
		fs.writefile(privatekey_file, value)
	end
end
