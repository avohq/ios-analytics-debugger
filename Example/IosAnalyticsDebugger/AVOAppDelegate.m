//
//  AVOAppDelegate.m
//  IosAnalyticsDebugger
//
//  Copyright (c) 2019. All rights reserved.
//

#import "AVOAppDelegate.h"

static AnalyticsDebugger *debugger = nil;

@implementation AVOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debugger == nil) {
        debugger = [AnalyticsDebugger new];
    }
    
    return YES;
}

+ (AnalyticsDebugger *) debugger {
    return debugger;
}

@end
