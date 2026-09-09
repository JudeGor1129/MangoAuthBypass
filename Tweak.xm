#import <substrate.h>
#import <mach-o/dyld.h>
%hook MGFGHUDView
- (void)show { return; }
- (void)hide { return; }
%end
%hook MGFGHUDWindow
- (id)hitTest:(struct CGPoint)p withEvent:(id)e { return nil; }
%end
%ctor {
dispatch_source_t t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
dispatch_source_set_timer(t, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
dispatch_source_set_event_handler(t, ^{
for (uint32_t i = 0; i < _dyld_image_count(); i++) {
const char *n = _dyld_get_image_name(i);
if (n && strstr(n, "mangoos.dylib")) {
volatile char *b = (volatile char *)(_dyld_get_image_vmaddr_slide(i) + 0xa7000);
b[0xfd8] = 1; b[0xfe2] = 1; b[0xfdd] = 1; b[0xfd9] = 1;
break;
}
}
});
dispatch_resume(t);
%init;
}
