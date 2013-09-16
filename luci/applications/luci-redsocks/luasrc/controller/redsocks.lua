--[[
RA-MOD
]]--

module("luci.controller.redsocks", package.seeall)

function index()

	local page
	page = entry({"admin", "RA-MOD", "redsocks"}, cbi("redsocks"), _("redsocks"), 50)
	page.i18n = "redsocks"
	page.dependent = true
end
