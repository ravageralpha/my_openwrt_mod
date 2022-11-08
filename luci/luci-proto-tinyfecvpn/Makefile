# Copyright 2017 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for tinyfecVPN
LUCI_DEPENDS:=+luci-compat +tinyfecVPN +ip-full
LUCI_PKGARCH:=all

include ../../../luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
