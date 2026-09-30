# TI BQ25790/BQ25792 I2C battery charger driver (out-of-tree kernel package)
#
# Source: mainline bq257xx MFD split (torvalds/linux master, merged 6.19):
#   drivers/mfd/bq257xx.c                 -> src/bq257xx_mfd.c
#   include/linux/mfd/bq257xx.h           -> src/bq257xx.h
#   drivers/power/supply/bq257xx_charger.c -> src/bq257xx_charger.c
# Local changes: include path only (<linux/mfd/bq257xx.h> -> "bq257xx.h").
# Vendor patch in bq257xx_charger.c: PRESENT property (REG1D bit0),
# TS_IGNORE set at hw_init (charging gated manually via the CE pin).
# Requires CONFIG_MFD_CORE=y (target/linux/generic/config-6.18).
# Board: huasifei_trs_router_miniups (3S 18650 pack, I2C 0x6B,
# charge-enable CE on GPIO7 active-low via gpio-export).

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=bq25792_charger
PKG_RELEASE:=3
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

define KernelPackage/bq25792_charger
  SUBMENU:=Other modules
  TITLE:=TI BQ25792 I2C battery charger driver (mainline bq257xx MFD)
  DEPENDS:=@TARGET_mediatek +kmod-i2c-core
  FILES:=$(PKG_BUILD_DIR)/bq257xx_mfd.ko $(PKG_BUILD_DIR)/bq257xx_charger.ko
endef

define KernelPackage/bq25792_charger/description
  Mainline bq257xx MFD + charger driver for the TI BQ25792 buck-boost
  charger. Two modules: bq257xx-mfd (I2C core, spawns bq257xx-charger
  platform device) and bq257xx_charger (power_supply class driver).
  Reports battery voltage/current/status via /sys/class/power_supply.
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

# Not autoloaded at boot: files/etc/init.d/bq25792-gate loads the
# modules only when a battery was detected (board has no hot-plug).
define KernelPackage/bq25792_charger/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/bq25792-gate $(1)/etc/init.d/bq25792-gate
endef

$(eval $(call KernelPackage,bq25792_charger))
