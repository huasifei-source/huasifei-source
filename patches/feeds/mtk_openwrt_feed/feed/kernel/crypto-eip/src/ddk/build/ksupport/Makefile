obj-$(CONFIG_RAMBUS_DDK) += crypto-eip-ddk-ksupport.o

ccflags-y += -I$(src)/../../inc
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/configs
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/configs/ksupport
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/shdevxs
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/umdevxs
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/device
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/device/lkm
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/device/lkm/of
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/dmares
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/firmware_api
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/builder/sa
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/builder/token
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/eip197
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/iotoken
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/list
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/kit/ring
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/log
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/libc
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/slad
ccflags-y += -I$(src)/../../inc/crypto-eip/ddk/slad/lkm

$(info not that bad!!!)
$(info ccflags: $(ccflags-y))

# Kernel Support
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_lkm.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_ofdev.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_chrdev.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_device.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_smbuf.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_bufadmin.o
crypto-eip-ddk-ksupport-y += ../../device/umdevxs/umdevxs_interrupt.o

crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_kernel_stub.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_kernel_lock.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_kernel_init.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_init.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_dmapool.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_irq.o
crypto-eip-ddk-ksupport-y += ../../device/shdevxs/shdevxs_prng.o

crypto-eip-ddk-ksupport-y += ../../slad/lkm/adapter_interrupts.o
crypto-eip-ddk-ksupport-y += ../../kit/log/log.o
crypto-eip-ddk-ksupport-y += ../../kit/eip197/eip201.o
crypto-eip-ddk-ksupport-y += ../../device/device_generic.o
crypto-eip-ddk-ksupport-y += ../../device/lkm/of/lkm.o
crypto-eip-ddk-ksupport-y += ../../device/lkm/of/device_lkm.o