#include <substrate.h>
#import <UIKit/UIKit.h>

// ========== 在这里替换成白名单UDID ==========
static NSString* const FAKE_UDID = @"00008110-000230862152801E";
// ===========================================

%hook UIDevice
// iOS15芒果读取设备标识：identifierForVendor
- (NSString *)identifierForVendor {
    return FAKE_UDID;
}
%end

%hook MangoAuthManager
// 主授权校验
- (BOOL)isLicensed {
    return YES;
}
// UDID白名单校验
- (BOOL)checkUDIDValid {
    return YES;
}
%end

%ctor {
    %init();
}
