--[[
RA-MOD
]]--

module("luci.controller.lighttpd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/lighttpd/lighttpd.conf") then
		return
	end

	local page
	page = entry({"admin", "RA-MOD", "lighttpd"}, cbi("lighttpd"), _("lighttpd"), 20)
	page.i18n = "lighttpd"
	page.dependent = true
end
