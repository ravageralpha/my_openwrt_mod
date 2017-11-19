include $(TOPDIR)/rules.mk

PKG_NAME:=ShadowVPN
PKG_VERSION:=0.2.0
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ravageralpha/ShadowVPN.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=05c10207691bb5a42dc7ef9a80f99cc627b9d39f
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MAINTAINER:=clowwindy <clowwindy42@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ShadowVPN/Default
  SECTION:=net
  CATEGORY:=RA-MOD
  SUBMENU:=Package
  TITLE:=ShadowVPN
  DEPENDS:=+kmod-tun
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
