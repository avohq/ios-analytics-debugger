//
//  Util.m
//  IosAnalyticsDebugger
//
//  Copyright © 2019. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSString *) timeString:(NSTimeInterval)timestamp; {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
    
    return [formatter stringFromDate:date];
}

+(BOOL) eventHaveErrors:(DebuggerEventItem *)event; {
    if (event.messages != nil && event.messages.count > 0) {
        return YES;
    }
    
    return NO;
}

+ (NSInteger) barBottomOffset {
    BOOL hasNotch = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top > 20.0;
    
    if (hasNotch) {
        return 30;
    } else {
        return 0;
    }
}

@end
