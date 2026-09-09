#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

static int (*orig_mgo_internal_verify)(void);
static int my_mgo_internal_verify(void) {
    return 1;
}
static int (*orig_mgo_query_state)(void);
static int my_mgo_query_state(void) {
    return 1;
}
static int (*orig_mgo_show_status)(int code);
static int my_mgo_show_status(int code) {
    return 0;
}

typedef CFTypeRef (*MGCopyAnswerFunc)(CFStringRef key);
static MGCopyAnswerFunc orig_MGCopyAnswer = NULL;
CFTypeRef my_MGCopyAnswer(CFStringRef key) {
    NSString *k = (__bridge NSString *)key;
    if ([k isEqualToString:@"UniqueDeviceID"] || [k isEqualToString:@"SerialNumber"]) {
        return (__bridge CFTypeRef)@"00000000-1111-2222-3333-444455556666";
    }
    if (orig_MGCopyAnswer) return orig_MGCopyAnswer(key);
    return NULL;
}

%hook MGFGHUDView
- (void)show { return; }
- (void)hide { return; }
- (void)updateCountdown { return; }
%end
%hook MGFGHUDWindow
- (id)hitTest:(struct CGPoint)point withEvent:(id)event { return nil; }
%end

%ctor {
    void *mango = dlopen("/var/jb/Library/MobileSubstrate/DynamicLibraries/mango.dylib", RTLD_NOW);
    if (!mango) mango = dlopen("/Library/MobileSubstrate/DynamicLibraries/mango.dylib", RTLD_NOW);
    if (mango) {
        void *f1 = dlsym(mango, "_mgo_internal_verify");
        if (f1) MSHookFunction(f1, (void*)&my_mgo_internal_verify, (void**)&orig_mgo_internal_verify);
        void *f2 = dlsym(mango, "_mgo_query_state");
        if (f2) MSHookFunction(f2, (void*)&my_mgo_query_state, (void**)&orig_mgo_query_state);
        void *f3 = dlsym(mango, "_mgo_show_status");
        if (f3) MSHookFunction(f3, (void*)&my_mgo_show_status, (void**)&orig_mgo_show_status);
    }
    void *mg = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
    if (!mg) mg = dlopen("/System/Library/PrivateFrameworks/MobileGestalt.framework/MobileGestalt", RTLD_LAZY);
    if (mg) {
        orig_MGCopyAnswer = (MGCopyAnswerFunc)dlsym(mg, "MGCopyAnswer");
        if (orig_MGCopyAnswer) {
            MSHookFunction((void*)orig_MGCopyAnswer, (void*)&my_MGCopyAnswer, (void**)&orig_MGCopyAnswer);
        }
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *p in @[@"/var/mobile/Documents/mangofreegogo",
                          @"/var/mobile/Library/Preferences/mangofreegogo"]) {
        if (![fm fileExistsAtPath:p]) {
            [@"1" writeToFile:p atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    %init;
}
