include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocks-libev-git
PKG_VERSION:=2.5.6
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/madeye/shadowsocks-libev.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=aca5f5ddb46c1555b3fde61f95ccf0d6271ed607
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MAINTAINER:=Max Lv <max.c.lv@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocks-libev-git/Default
  SECTION:=net
  CATEGORY:=RA-MOD
  SUBMENU:=Package
  TITLE:=Lightweight Secured Socks5 Proxy
  URL:=https://github.com/madeye/shadowsocks-libev
endef

define Package/shadowsocks-libev-git
  $(call Package/shadowsocks-libev-git/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread +libpcre
endef

define Package/shadowsocks-libev-polarssl-git
  $(call Package/shadowsocks-libev-git/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread +libpcre
endef

define Package/shadowsocks-libev-mbedtls-git
  $(call Package/shadowsocks-libev-git/Default)
  TITLE+= (mbedTLS)
  VARIANT:=mbedtls
  DEPENDS:=+libmbedtls +libpthread +libpcre
endef

define Package/shadowsocks-libev-git/description
Shadowsocks-libev is a lightweight secured scoks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocks-libev-polarssl-git/description=$(Package/shadowsocks-libev-git/description)
Package/shadowsocks-libev-mbedtls-git/description=$(Package/shadowsocks-libev-git/description)

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

define Package/shadowsocks-libev-git/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
endef

Package/shadowsocks-libev-polarssl-git/install=$(Package/shadowsocks-libev-git/install)

$(eval $(call BuildPackage,shadowsocks-libev-git))
$(eval $(call BuildPackage,shadowsocks-libev-polarssl-git))
$(eval $(call BuildPackage,shadowsocks-libev-mbedtls-git))
