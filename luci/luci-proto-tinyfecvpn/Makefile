include $(TOPDIR)/rules.mk

APP_NAME=tinyfecvpn
PKG_NAME:=luci-proto-$(APP_NAME)
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/Default
	SECTION:=luci
	CATEGORY:=RA-MOD
	SUBMENU:=LuCI
	TITLE:=LuCI Support for $(APP_NAME)
	PKGARCH:=all
endef

define Package/$(PKG_NAME)
	$(call Package/$(PKG_NAME)/Default)
	DEPENDS:=+luci-compat +tinyfecVPN
endef

define Package/$(PKG_NAME)/description
	LuCI Support for $(APP_NAME).
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/luci-$(APP_NAME) ]; then
		( . /etc/uci-defaults/luci-$(APP_NAME) ) && \
		rm -f /etc/uci-defaults/luci-$(APP_NAME)
	fi
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(APP_NAME).*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/network
	$(INSTALL_DATA) ./luci/model/cbi/network/*.lua $(1)/usr/lib/lua/luci/model/cbi/network/
	$(INSTALL_DIR) $(1)/www/luci-static/resources/protocol
	$(INSTALL_DATA) ./luci/htdocs/luci-static/resources/protocol/*.js $(1)/www/luci-static/resources/protocol/
	$(INSTALL_DIR) $(1)/; \
	  cp -pR ./root/* $(1)/;
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
