//
//  unitTests.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 06/07/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "DebuggerAnalytics.h"
#import "DebuggerAnalyticsDestination.h"
#import "AnalyticsDebugger.h"

@interface DebuggerAnalytics(Private)
+ (void)avoLoggerLogEventSent:(NSString *)eventName eventProperties:(NSDictionary *)eventProperties userProperties:(NSDictionary *)userProperties;
@end

SpecBegin(AvoDebuggerUnit)
    describe(@"AvoDebuggerUnit", ^{
        __block NSString *version;
        __block AnalyticsDebugger *ad;
        
        beforeEach(^{
            version = [[[NSBundle bundleForClass:[AnalyticsDebugger class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            ad = [[AnalyticsDebugger alloc] init];
        });
        
        afterEach(^{
            
        });
        
        it(@"Does not throw exceptions", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvProd version:version customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            }).notTo.raiseAny();
        });


        it(@"Initializes with dev env", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            }).notTo.raiseAny();
        });

        it(@"Initializes with prod env", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvProd version:version customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            }).notTo.raiseAny();
        });

        it(@"Initializes with unknown env", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:999 version:version customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            }).notTo.raiseAny();
        });

        it(@"Initializes with app version", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            }).notTo.raiseAny();
        });

        it(@"Initializes with strict mode", ^{
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new] strict:YES];
            }).notTo.raiseAny();
        });

        it(@"Initializes with debugger", ^{
            AnalyticsDebugger *debuggerDummy = [[AnalyticsDebugger alloc] init];
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new] debugger:debuggerDummy];
            }).notTo.raiseAny();
        });

        it(@"Initializes with debugger in strict mode", ^{
            AnalyticsDebugger *debuggerDummy = [[AnalyticsDebugger alloc] init];
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new] strict:YES debugger:debuggerDummy];
            }).notTo.raiseAny();
        });

    });
SpecEnd
