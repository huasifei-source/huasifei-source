# TI BQ25790/BQ25792 I2C battery charger driver (out-of-tree kernel package)
#
# Source: TI's never-mainlined bq25790_charger.c (Seeed copy,
# github.com/Seeed-Studio/seeed-linux-dtoverlays), with "ti,bq25792"
# added to the match tables. Board: huasifei_trs_router_miniups
# (3S 18650 pack, I2C 0x6B, charge-enable CE on GPIO7 active-low via gpio-hog).

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=bq25792_charger
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

define KernelPackage/bq25792_charger
  SUBMENU:=Other modules
  TITLE:=TI BQ25790/BQ25792 I2C battery charger driver
  DEPENDS:=@TARGET_mediatek +kmod-i2c-core
  FILES:=$(PKG_BUILD_DIR)/bq25790_charger.ko
  AUTOLOAD:=$(call AutoProbe,bq25790_charger)
endef

define KernelPackage/bq25792_charger/description
  Linux power_supply class driver for the TI BQ25790/BQ25792 buck-boost
  charger. Reports battery voltage/current/status via /sys/class/power_supply.
  IRQ optional (works without the INT line, polled reads).
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/. $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,bq25792_charger))
