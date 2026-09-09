ARCHS = arm64 arm64e
TARGET = iphone:clang::15.0
THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MangoAuthBypass

MangoAuthBypass_FILES = Tweak.xm
MangoAuthBypass_CFLAGS = -fobjc-arc
MangoAuthBypass_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
