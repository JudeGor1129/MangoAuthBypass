export ARCHS = arm64 arm64e
export TARGET = iphone:latest:15.0
export THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MangoAuthBypass
MangoAuthBypass_FILES = Tweak.xm
MangoAuthBypass_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
