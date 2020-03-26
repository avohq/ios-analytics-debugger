//
//  AVOVoidDestination.m
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import "AVODatascopeDestination.h"
#import <AvoInspector/AvoInspector.h>

@implementation AVODatascopeDestination

AvoInspector * avoInspector;

- (void)identify:(nonnull NSString *)userId {
    
}

- (void)logEvent:(nonnull NSString *)eventName withEventProperties:(nonnull NSDictionary *)eventProperties {
    [avoInspector trackSchemaFromEvent:eventName eventParams:eventProperties];
}

- (void)make:(AVOEnv)avoEnv {
    avoInspector = [[AvoInspector alloc] initWithApiKey:@"AKwAt6gmO8h4mBb2JcFn" env:AvoInspectorEnvDev];
}

- (void)setUserProperties:(nonnull NSString *)userId withUserProperties:(nonnull NSDictionary *)userProperties {
    
}

- (void)unidentify {
    
}

@end
