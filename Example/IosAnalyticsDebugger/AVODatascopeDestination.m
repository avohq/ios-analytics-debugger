//
//  AVOVoidDestination.m
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import "AVODatascopeDestination.h"
#import <AvoStateOfTracking/AvoStateOfTracking.h>

@implementation AVODatascopeDestination

AvoStateOfTracking * avoSot;

- (void)identify:(nonnull NSString *)userId {
    
}

- (void)logEvent:(nonnull NSString *)eventName withEventProperties:(nonnull NSDictionary *)eventProperties {
    [avoSot trackSchemaFromEvent:eventName eventParams:eventProperties];
}

- (void)make:(AVOEnv)avoEnv {
    avoSot = [[AvoStateOfTracking alloc] initWithApiKey:@"AKwAt6gmO8h4mBb2JcFn" isDev: avoEnv == AVOEnvDev];
}

- (void)setUserProperties:(nonnull NSString *)userId withUserProperties:(nonnull NSDictionary *)userProperties {
    
}

- (void)unidentify {
    
}

@end
