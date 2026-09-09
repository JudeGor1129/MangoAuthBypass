ARCHS = arm64 arm64e
TARGET = iphone:clang:15.0:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

# 关键！告诉Theos过滤器plist名字
FILTER = MangoAuthBypass.plist

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MangoAuthBypass

MangoAuthBypass_FILES = Tweak.xm
MangoAuthBypass_CFLAGS = -fobjc-arc
MangoAuthBypass_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
