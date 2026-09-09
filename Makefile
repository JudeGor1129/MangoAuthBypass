ARCHS = arm64 arm64e
# 改动：删掉中间的15.0，使用环境自带SDK，TARGET最后面的15.0代表最低支持iOS15
TARGET = iphone:clang::15.0

FILTER = MangoAuthBypass.plist
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MangoAuthBypass

MangoAuthBypass_FILES = Tweak.xm
MangoAuthBypass_CFLAGS = -fobjc-arc
MangoAuthBypass_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
