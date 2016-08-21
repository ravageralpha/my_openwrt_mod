#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fuse-exfat
PKG_VERSION:=1.2.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/relan/exfat/releases/download/v$(PKG_VERSION)/
PKG_MD5SUM:=1ed881862bea9616003398cb6eab9903

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/fuse-exfat/template
  SECTION:=utils
  CATEGORY:=RA-MOD
  SUBMENU:=Package
  DEPENDS:=+libfuse
endef

define Package/fuse-exfat
  $(call Package/fuse-exfat/template)
  TITLE:=exFAT Driver
endef

define Package/fuse-exfat/description
  Full-featured exFAT file system implementation for GNU/Linux other Unix-like systems as a FUSE module.
endef

define Package/fuse-exfat/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(PKG_BUILD_DIR)/fuse/mount.exfat-fuse $(1)/sbin/mount.exfat
endef

define Package/fuse-exfat/postinst
#!/bin/sh

if [ -z "$$(grep ^\\exfat: $${IPKG_INSTROOT}/etc/filesystems)" ]; then
	echo "exfat" >> $${IPKG_INSTROOT}/etc/filesystems
fi
endef

$(eval $(call BuildPackage,fuse-exfat))
