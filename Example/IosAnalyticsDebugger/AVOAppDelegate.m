//
//  AVOAppDelegate.m
//  IosAnalyticsDebugger
//
//  Copyright (c) 2019. All rights reserved.
//

#import "AVOAppDelegate.h"
#import "Avo.h"
#import "AVOVoidDestination.h"

static AnalyticsDebugger *debugger = nil;

@implementation AVOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debugger == nil) {
        debugger = [AnalyticsDebugger new];
    }
    [Avo initAvoWithEnv:AVOEnvDev customDestination:[AVOVoidDestination new] debugger:debugger];
    [Avo appOpened];
    
    return YES;
}

+ (AnalyticsDebugger *) debugger {
    return debugger;
}

@end
