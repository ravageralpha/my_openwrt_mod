--[[
RA-MOD
]]--

module("luci.controller.vsftpd", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/vsftpd.conf") then
		return
	end

	local page
	page = node("admin", "RA-MOD")
	page.target = firstchild()
	page.title = _("RA-MOD")
	page.order  = 65

	page = entry({"admin", "RA-MOD", "vsftpd"}, cbi("vsftpd"), _("vsftpd"), 50)
	page.i18n = "vsftpd"
	page.dependent = true
end
