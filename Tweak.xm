#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

%hook MGFGHUDView
- (void)show { return; }
- (void)hide { return; }
%end
%hook MGFGHUDWindow
- (id)hitTest:(struct CGPoint)point withEvent:(id)event { return nil; }
%end

%ctor {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        uint32_t count = _dyld_image_count();
        for (uint32_t i = 0; i < count; i++) {
            const char *name = _dyld_get_image_name(i);
            if (name && strstr(name, "mangoos.dylib")) {
                intptr_t slide = _dyld_get_image_vmaddr_slide(i);
                volatile char *base = (volatile char *)(slide + 0xa7000);
                base[0xfd8] = 1;  // fff#
g;f
base[0xfdd] = 1; // ff base[0xfe2] = 1; // 
i*h/forg6f b base[0xfd9] = 1; // g6f
f ?                break;
            }
        }
    });
    dispatch_resume(timer);
    %init;
}
