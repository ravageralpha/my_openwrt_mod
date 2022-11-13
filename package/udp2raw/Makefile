#
# Copyright (C) 2014-2020 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=udp2raw
PKG_VERSION:=20220126
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/wangyu-/udp2raw.git
PKG_SOURCE_VERSION:=8ceaf27edaff70505948fbfaf8b9b864e3a11ee8
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/udp2raw
	SECTION:=net
	CATEGORY:=RA-MOD
	SUBMENU:=Package
	TITLE:=udp2raw
	URL:=https://github.com/wangyu-/udp2raw
	DEPENDS:=+libstdcpp +librt
endef

define Package/udp2raw/description
	A Tunnel which turns UDP Traffic into Encrypted FakeTCP/UDP/ICMP Traffic by using Raw Socket
endef

MAKE_FLAGS += arm_asm_aes

define Build/Configure
	$(call Build/Configure/Default)
	$(SED) 's/cc_arm[[:space:]]*=.*/cc_arm=$(TARGET_CXX)/' \
		-e 's/\\".*shell git rev-parse HEAD.*\\"/\\"$(PKG_SOURCE_VERSION)\\"/' \
		$(PKG_BUILD_DIR)/makefile
endef

define Package/udp2raw/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/udp2raw_arm_asm_aes $(1)/usr/bin/udp2raw
endef

$(eval $(call BuildPackage,udp2raw))