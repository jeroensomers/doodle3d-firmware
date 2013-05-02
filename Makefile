##############################################
# OpenWrt Makefile for Doodle3D WifiBox firmware
##############################################
include $(TOPDIR)/rules.mk

# Name and release number of this package
PKG_NAME:=wifibox
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

# This specifies the directory where we're going to build the program.  
# The root build directory, $(BUILD_DIR), is by default the build_mipsel 
# directory in your OpenWrt SDK directory
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/wifibox
	SECTION:=mods
	CATEGORY:=Miscellaneous
	MENU:=1
#	DEFAULT:=y
	TITLE:=Doodle3D WifiBox firmware
	URL:=http://www.doodle3d.com/wifibox
	DEPENDS:=+lua +libuci-lua +libiwinfo-lua +uhttpd
endef

define Package/wifibox/description
	Doodle3D WifiBox firmware
	Web interface to draw doodles and print them with ease.
	Automatically connects to known network or provide one to connect with.
	Intended to be used on TP-Link WR703n or MR3020.
endef

define Package/wifibox/config
	source "$(SOURCE)/Config.in"
endef

# Specify what needs to be done to prepare for building the package.
# In our case, we need to copy the source files to the build directory.
# This is NOT the default.  The default uses the PKG_SOURCE_URL and the
# PKG_SOURCE which is not defined here to download the source from the web.
# In order to just build a simple program that we have just written, it is
# much easier to do it this way.
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) -r ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Configure
#	no configuration necessary
endef

define Build/Compile directives
#	no compilation necessary (although possible with luac?)
endef

# The $(1) variable represents the root directory on the router running 
# OpenWrt. The $(INSTALL_DIR) variable contains a command to prepare the install 
# directory if it does not already exist.  Likewise $(INSTALL_BIN) contains the 
# command to copy the binary file from its current location (in our case the build
# directory) to the install directory.
define Package/wifibox/install
	
### create required directories
	
#	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi
	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi/admin
#	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi/ext
#	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi/ext/www
	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi/ext/www/cgi-bin
	$(INSTALL_DIR) $(1)/etc/rc.d
	$(INSTALL_DIR) $(1)/www/cgi-bin
	
	
### create all files in /usr/share/lua/autowifi
	
	$(CP) $(PKG_BUILD_DIR)/*.lua $(1)/usr/share/lua/autowifi/
	$(CP) $(PKG_BUILD_DIR)/admin/* $(1)/usr/share/lua/autowifi/admin/
	
	$(CP) $(PKG_BUILD_DIR)/ext/autowifi.js $(1)/usr/share/lua/autowifi/ext
	$(CP) $(PKG_BUILD_DIR)/ext/autowifi_init $(1)/usr/share/lua/autowifi/ext
	$(CP) $(PKG_BUILD_DIR)/ext/wfcf $(1)/usr/share/lua/autowifi/ext
	
	$(CP) $(PKG_BUILD_DIR)/ext/www/.autowifi-inplace $(1)/usr/share/lua/autowifi/ext/www
	$(CP) $(PKG_BUILD_DIR)/ext/www/index.html $(1)/usr/share/lua/autowifi/ext/www
	$(LN) -s /usr/share/lua/autowifi/admin $(1)/usr/share/lua/autowifi/ext/www
	$(LN) -s /usr/share/lua/autowifi/ext/wfcf $(1)/usr/share/lua/autowifi/ext/www/cgi-bin
	
ifeq ($(CONFIG_WIFIBOX_DEVEL_PACKAGE),y)
	$(INSTALL_DIR) $(1)/usr/share/lua/autowifi/misc
	$(CP) $(PKG_BUILD_DIR)/misc/collect-code.sh $(1)/usr/share/lua/autowifi/misc/
endif
	
	
### create links elsewhere in the system
	
	$(LN) -s /usr/share/lua/autowifi/ext/wfcf $(1)/www/cgi-bin
	$(LN) -s /usr/share/lua/autowifi/admin $(1)/www
	$(LN) -s /usr/share/lua/autowifi/ext/autowifi_init $(1)/etc/rc.d/S18autowifi_init
endef


$(eval $(call BuildPackage,wifibox))
