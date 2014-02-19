--[[
RA-MOD
]]--

module("luci.controller.pdnsd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/pdnsd.conf") then
		return
	end

	local page
	page = entry({"admin", "RA-MOD", "pdnsd"}, cbi("pdnsd"), _("pdnsd"), 35)
	page.i18n = "pdnsd"
	page.dependent = true
end
