LOCAL_PATH := $(call my-dir)
OPTEE_TEST_PATH := $(shell pwd)/$(LOCAL_PATH)

VERSION = $(shell git describe --always --dirty=-dev 2>/dev/null || echo Unknown)
OPTEE_CLIENT_PATH ?= $(LOCAL_PATH)/client_export
TA_DEV_KIT_DIR ?= $(OPTEE_TEST_PATH)/export-user_ta
-include $(TA_DEV_KIT_DIR)/host_include/conf.mk

ifeq (1,$(strip $(shell expr $(PLATFORM_VERSION) \>= 8)))
ifeq ($(strip $(TARGET_ARCH)), arm64)
CLIENT_LIB_PATH ?= $(shell pwd)/vendor/rockchip/common/security/optee/v1/lib/arm64
else
CLIENT_LIB_PATH ?= $(shell pwd)/vendor/rockchip/common/security/optee/v1/lib/arm
endif
else
ifeq ($(strip $(TARGET_ARCH)), arm64)
CLIENT_LIB_PATH ?= $(shell pwd)/vendor/rockchip/common/security/optee/lib/arm64
else
CLIENT_LIB_PATH ?= $(shell pwd)/vendor/rockchip/common/security/optee/lib/arm
endif
endif

################################################################################
# Build rkdemo                                                                 #
################################################################################
include $(CLEAR_VARS)
LOCAL_CFLAGS += -DANDROID_BUILD -DUSER_SPACE
LOCAL_LDFLAGS += $(CLIENT_LIB_PATH)/libteec.so
LOCAL_LDFLAGS += -llog

LOCAL_SRC_FILES += host/rkdemo/rkdemo_ca.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/ta/testapp/include \
		$(OPTEE_CLIENT_PATH)/public

LOCAL_MODULE := testapp
LOCAL_MODULE_TAGS := optional
ifeq (1,$(strip $(shell expr $(PLATFORM_VERSION) \>= 8)))
LOCAL_PROPRIETARY_MODULE := true
endif
include $(BUILD_EXECUTABLE)

################################################################################
# Build rkdemo_storage                                                         #
################################################################################
include $(CLEAR_VARS)
LOCAL_CFLAGS += -DANDROID_BUILD -DUSER_SPACE
LOCAL_LDFLAGS += $(CLIENT_LIB_PATH)/libteec.so
LOCAL_LDFLAGS += -llog

LOCAL_SRC_FILES += host/rkdemo/rkdemo_storage_ca.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/ta/testapp_storage/include \
		$(OPTEE_CLIENT_PATH)/public

LOCAL_MODULE := testapp_storage
LOCAL_MODULE_TAGS := optional
ifeq (1,$(strip $(shell expr $(PLATFORM_VERSION) \>= 8)))
LOCAL_PROPRIETARY_MODULE := true
endif
include $(BUILD_EXECUTABLE)

include $(LOCAL_PATH)/ta/Android.mk
