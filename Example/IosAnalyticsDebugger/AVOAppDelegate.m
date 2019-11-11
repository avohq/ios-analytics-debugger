//
//  AVOAppDelegate.m
//  IosAnalyticsDebugger
//
//  Created by Alexey Verein on 11/08/2019.
//  Copyright (c) 2019 Alexey Verein. All rights reserved.
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
