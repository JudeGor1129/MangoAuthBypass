#import <substrate.h>
#import <mach-o/dyld.h>
#import <Foundation/Foundation.h>

static uintptr_t getSlide(const char *name) {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *path = _dyld_get_image_name(i);
        if (path && strstr(path, name)) {
            return (uintptr_t)_dyld_get_image_vmaddr_slide(i);
        }
    }
    return 0;
}

static uint64_t patched_check1(void) { return 1; }
static uint64_t patched_check2(void) { return 1; }

%ctor {
    @autoreleasepool {
        uintptr_t slide = getSlide("mangoos.dylib");
        if (slide == 0) return;
        MSHookFunction((void *)(slide + 0x712e0), (void *)patched_check1, NULL);
        MSHookFunction((void *)(slide + 0x74324), (void *)patched_check2, NULL);
    }
}
