include $(TOPDIR)/rules.mk

PKG_NAME:=ShadowVPN
PKG_VERSION:=0.1.5
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_URL:=https://github.com/clowwindy/ShadowVPN/releases/download/$(PKG_VERSION)
PKG_SOURCE:=shadowvpn-$(PKG_VERSION).tar.gz
PKG_MAINTAINER:=clowwindy <clowwindy42@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/shadowvpn-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ShadowVPN/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ShadowVPN
  DEPENDS:=+kmod-tun +ip
  URL:=https://github.com/clowwindy/ShadowVPN
endef

define Package/ShadowVPN
  $(call Package/ShadowVPN/Default)
endef

define Package/ShadowVPN/description
A fast, safe VPN based on libsodium
endef

define Package/ShadowVPN/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/shadowvpn $(1)/usr/bin
endef

$(eval $(call BuildPackage,ShadowVPN))
