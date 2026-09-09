#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <string.h>
#import <dlfcn.h>

static int (*orig_mgo_query_state)(void);
static int hooked_mgo_query_state(void) { return 1; }
static int (*orig_mgo_internal_verify)(void);
static int hooked_mgo_internal_verify(void) { return 1; }
static void (*orig_mgo_show_status)(int);
static void hooked_mgo_show_status(int c) { }

static void (*orig_hud_show)(id, SEL);
static void hooked_hud_show(id self, SEL _cmd) { return; }
static void (*orig_hud_hide)(id, SEL);
static void hooked_hud_hide(id self, SEL _cmd) { return; }
static void (*orig_hud_update)(id, SEL);
static void hooked_hud_update(id self, SEL _cmd) { return; }
static id (*orig_hud_hit)(id, SEL, CGPoint, id);
static id hooked_hud_hit(id self, SEL _cmd, CGPoint p, id e) { return nil; }

%ctor {
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    void *m = dlopen("/var/jb/Library/MobileSubstrate/DynamicLibraries/mango.dylib", RTLD_NOW);
    if (!m) m = dlopen("/Library/MobileSubstrate/DynamicLibraries/mango.dylib", RTLD_NOW);
    void *q = dlsym(m ? m : RTLD_DEFAULT, "_mgo_query_state");
    if (q) MSHookFunction(q, (void*)hooked_mgo_query_state, (void**)&orig_mgo_query_state);
    void *v = dlsym(m ? m : RTLD_DEFAULT, "_mgo_internal_verify");
    if (v) MSHookFunction(v, (void*)hooked_mgo_internal_verify, (void**)&orig_mgo_internal_verify);
    void *s = dlsym(m ? m : RTLD_DEFAULT, "_mgo_show_status");
    if (s) MSHookFunction(s, (void*)hooked_mgo_show_status, (void**)&orig_mgo_show_status);

    Class hud = NSClassFromString(@"MGFGHUDView");
    if (hud) {
        MSHookMessageEx(hud, @selector(show), (IMP)hooked_hud_show, (IMP*)&orig_hud_show);
        MSHookMessageEx(hud, @selector(hide), (IMP)hooked_hud_hide, (IMP*)&orig_hud_hide);
        MSHookMessageEx(hud, @selector(updateCountdown), (IMP)hooked_hud_update, (IMP*)&orig_hud_update);
    }
    Class win = NSClassFromString(@"MGFGHUDWindow");
    if (win) {
        MSHookMessageEx(win, @selector(hitTest:withEvent:), (IMP)hooked_hud_hit, (IMP*)&orig_hud_hit);
    }
});
}
