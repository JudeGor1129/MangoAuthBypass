#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <string.h>
#import <mach-o/dyld.h>

//屏蔽弹窗浮窗
%hook MGFGHUDView
- (void)show { return; }
- (void)hide { return; }
- (void)updateCountdown { return; }
%end
%hook MGFGHUDWindow
- (id)hitTest:(struct CGPoint)point withEvent:(id)event { return nil; }
%end

static int (*orig_mgo_query_state)(void);
static int hooked_mgo_query_state(void)
{
    //强制返回已授权
    return 1;
}

%ctor {
    //查找芒果dylib中的授权校验函数
    void *queryFunc = dlsym(RTLD_DEFAULT, "_mgo_query_state");
    if (queryFunc)
    {
        MSHookFunction(queryFunc, (void *)hooked_mgo_query_state, (void **)&orig_mgo_query_state);
    }
    %init;
}
