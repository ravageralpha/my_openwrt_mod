--[[
RA-MOD
]]--

module("luci.controller.shadowsocks", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/config/shadowsocks") then
		return
	end

	local page
	page = node("admin", "RA-MOD")
	page.target = firstchild()
	page.title = _("RA-MOD")
	page.order  = 65

	page = entry({"admin", "RA-MOD", "shadowsocks"}, cbi("shadowsocks"), _("shadowsocks"), 45)
	page.i18n = "shadowsocks"
	page.dependent = true
end
