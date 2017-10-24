#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=exfat-utils
PKG_VERSION:=1.2.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/relan/exfat/releases/download/v$(PKG_VERSION)/
PKG_MD5SUM:=c70d295a9a2e4ec16af21c0b7d02743c

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/exfat-utils/template
  SECTION:=utils
  CATEGORY:=RA-MOD
  SUBMENU:=Package
  DEPENDS:=+libfuse
endef

define Package/exfat-utils
  $(call Package/exfat-utils/template)
  TITLE:=exFAT utilities
endef

define Package/exfat-utils/description
  exFAT utilities like fsck
endef

define Package/exfat-utils/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(PKG_BUILD_DIR)/fsck/exfatfsck $(1)/sbin/fsck.exfat
endef

$(eval $(call BuildPackage,exfat-utils))
