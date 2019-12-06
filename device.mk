#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Kernel
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true
PRODUCT_ENABLE_UFFD_GC := true
OVERRIDE_ENABLE_UFFD_GC := true

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 28

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/essential/gem/gem-vendor.mk)
