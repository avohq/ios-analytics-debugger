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
    
    [self sendTestEventToDebugger];
    
    return YES;
}

- (void)sendTestEventToDebugger {
    NSMutableArray * props = [NSMutableArray new];
    
    [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"id0 event" withValue:@"value 0"]];
    [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"id1 event" withValue:@"value 1"]];
    
    NSMutableArray * errors = [NSMutableArray new];
    
    [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"error in event id0"]];
    
    [debugger publishEvent:@"Test Event" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
            withProperties:props withErrors:errors];
}


+ (AnalyticsDebugger *) debugger {
    return debugger;
}

@end
