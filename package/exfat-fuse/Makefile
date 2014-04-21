#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=exfat
PKG_REV:=287
PKG_VERSION:=r287
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=svn
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=http://exfat.googlecode.com/svn/trunk/
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/exfat/template
  SECTION:=utils
  CATEGORY:=Utilities
  URL:=http://code.google.com/p/exfat/
  SUBMENU:=Filesystem
  DEPENDS:=+libfuse
endef

define Package/exfat
  $(call Package/exfat/template)
  TITLE:=exFAT Driver
endef

define Package/exfat/description
  Full-featured exFAT file system implementation for GNU/Linux other Unix-like systems as a FUSE module.
endef

define Package/exfat-utils
  $(call Package/exfat/template)
  TITLE:=exFAT utilities
endef

define Package/exfat-utilities/description
  exFAT utilities like fsck
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(FILES_DIR)/Makefile $(PKG_BUILD_DIR)/
endef

define Package/exfat/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(PKG_BUILD_DIR)/mount.exfat $(1)/sbin/
endef

define Package/exfat-utils/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(PKG_BUILD_DIR)/fsck.exfat $(1)/sbin/
endef

define Package/exfat/postinst
#!/bin/sh

if [ -z "$$(grep ^\\exfat: $${IPKG_INSTROOT}/etc/filesystems)" ]; then
	echo "exfat" >> $${IPKG_INSTROOT}/etc/filesystems
fi
endef

$(eval $(call BuildPackage,exfat))
$(eval $(call BuildPackage,exfat-utils))
