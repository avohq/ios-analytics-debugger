//
//  AVOAppDelegate.m
//  IosAnalyticsDebugger
//
//  Copyright (c) 2019. All rights reserved.
//

#import "AVOAppDelegate.h"
#import "Avo.h"
#import "AVODatascopeDestination.h"

static AnalyticsDebugger *debugger = nil;

@implementation AVOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debugger == nil) {
        debugger = [AnalyticsDebugger new];
    }
    [Avo initAvoWithEnv:AVOEnvDev customDestination:[AVODatascopeDestination new] debugger:debugger];
    [Avo appOpened];
    
    [self sendTestEventToDebugger];
    
    return YES;
}

- (void)sendTestEventToDebugger
{
    NSMutableArray * props = [NSMutableArray new];
    
    [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"Property with error" withValue:@"unknown"]];
    [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"Good property" withValue:@"true"]];
    
    NSMutableArray * errors = [NSMutableArray new];
    
    [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"'Unknown' value is not supported in this property. 'Unknown' value is not supported in this property. 'Unknown' value is not supported in this property. 'Unknown' value is not supported in this property."]];
    
    [debugger publishEvent:@"Event with Error" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
            withProperties:props withErrors:errors];
}

+ (AnalyticsDebugger *) debugger {
    return debugger;
}

@end
