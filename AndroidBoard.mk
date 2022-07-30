# Copyright (C) 2020 The LineageOS Project
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

ifeq ($(TARGET_PREBUILT_KERNEL),)
INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel
endif

EKS_DAT_SYMLINK := $(TARGET_OUT_VENDOR)/app/eks2/eks2.dat
$(EKS_DAT_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	$(hide) ln -sf /data/vendor/eks2/eks2.dat $@

ALL_DEFAULT_INSTALLED_MODULES += $(EKS_DAT_SYMLINK)

AVBTOOL_HOST := $(HOST_OUT_EXECUTABLES)/avbtool
INSTALLED_VBMETA_SKIP_TARGET := $(PRODUCT_OUT)/install/vbmeta_skip.img
$(INSTALLED_VBMETA_SKIP_TARGET): $(AVBTOOL_HOST)
	@$(AVBTOOL_HOST) make_vbmeta_image --flags 2 --padding_size 256 --output $@

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_VBMETA_SKIP_TARGET)
