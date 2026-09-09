#import <substrate.h>
#import <UIKit/UIKit.h>
%ctor {
    [@"mango_tweak_loaded" writeToFile:@"/var/jb/var/mobile/mango_test.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
