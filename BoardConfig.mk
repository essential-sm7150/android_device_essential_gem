#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/essential/gem

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := gem
TARGET_NO_BOOTLOADER := true

# Kernel
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := \
    androidboot.hardware=qcom \
    service_locator.enable=1 \
    lpm_levels.sleep_disabled=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    firmware_class.path=/vendor/firmware_mnt/image
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_KERNEL_CONFIG := \
    vendor/sdmsteppe-perf_defconfig \
    vendor/gem.config
TARGET_KERNEL_NO_GCC := true
TARGET_KERNEL_SOURCE := kernel/essential/sm7150

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := sm6150

# Include the proprietary files BoardConfig.
include vendor/essential/gem/BoardConfigVendor.mk
