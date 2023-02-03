#
# Copyright (C) 2023 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_TEGRA_VARIANT    ?= common

TARGET_TEGRA_AUDIO    ?= nvaudio
TARGET_TEGRA_BT       ?= bcm
TARGET_TEGRA_CAMERA   ?= nvcamera
TARGET_TEGRA_KERNEL   ?= 4.9
TARGET_TEGRA_KEYSTORE ?= software
TARGET_TEGRA_MEMTRACK ?= nvmemtrack
TARGET_TEGRA_OMX      ?= nvmm
TARGET_TEGRA_PHS      ?= nvphs
TARGET_TEGRA_POWER    ?= aosp
TARGET_TEGRA_WIDEVINE ?= true
TARGET_TEGRA_WIFI     ?= bcm

TARGET_TEGRA_WIREGUARD ?= compat

include device/nvidia/t210-common/t210.mk

# Properties
include $(LOCAL_PATH)/properties.mk

PRODUCT_CHARACTERISTICS   := tablet
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi
PRODUCT_AAPT_PREF_CONFIG  := xhdpi

$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

$(call inherit-product, device/google/sphynx/vendor/sphynx-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    device/google/sphynx/overlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += device/google/sphynx

# Init related
PRODUCT_PACKAGES += \
    fstab.dragon \
    init.dragon.rc \
    init.loki_foster_e_common.rc \
    init.recovery.dragon.rc \
    power.dragon.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

# Audio
ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
PRODUCT_PACKAGES += \
    audio_effects.xml \
    audio_policy_configuration.xml \
    nvaudio_conf.xml \
    nvaudio_fx.xml
endif

# Boot Animation
TARGET_SCREEN_HEIGHT := 2560
TARGET_SCREEN_WIDTH  := 1800

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4-service.clearkey \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm@1.4.vendor

# Keylayouts
PRODUCT_PACKAGES += \
    gpio-keys.kl

# Light
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service-nvidia

# Loadable kernel modules
PRODUCT_PACKAGES += \
    init.lkm.rc \
    lkm_loader \
    lkm_loader_target

# Media config
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_ODM)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_ODM)/etc/media_codecs_google_video.xml
PRODUCT_PACKAGES += \
    media_codecs.xml
ifneq (,$(findstring nvmm,$(TARGET_TEGRA_OMX)))
PRODUCT_PACKAGES += \
    media_codecs_performance.xml \
    media_profiles_V1_0.xml \
    enctune.conf
endif

# PHS
ifeq ($(TARGET_TEGRA_PHS),nvphs)
PRODUCT_PACKAGES += \
    nvphsd.conf
endif

# Power
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups_28.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    system/core/libprocessgroup/profiles/task_profiles_28.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Shipping API
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_m.mk)

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-service-nvidia \
    thermalhal.dragon.xml

# Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# VBoot
$(call inherit-product, build/target/product/vboot.mk)
