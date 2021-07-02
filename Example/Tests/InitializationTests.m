//
//  InitializationTests.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 29/06/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>
#import "DebuggerAnalytics.h"
#import "DebuggerAnalyticsDestination.h"
#import "AnalyticsDebugger.h"


@interface DebuggerAnalytics(Private)
+ (void)avoLoggerLogEventSent:(NSString *)eventName eventProperties:(NSDictionary *)eventProperties userProperties:(NSDictionary *)userProperties;
@end

SpecBegin(AvoDebuggerUnitSpecs)

    describe(@"AvoDebuggerUnitSpecs", ^{
        __block NSString *version;
        __block AnalyticsDebugger *ad;
        
        beforeEach(^{
            version = [[[NSBundle bundleForClass:[AnalyticsDebugger class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            ad = [[AnalyticsDebugger alloc] init];
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

        it(@"Initializes with custom debugger", ^{
            NSObject *debuggerDummy = [[NSObject alloc] init];
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new] debugger:debuggerDummy];
            }).notTo.raiseAny();
        });

        it(@"Initializes with custom debugger in strict mode", ^{
            NSObject *debuggerDummy = [[NSObject alloc] init];
            expect(^{
                [DebuggerAnalytics initAvoWithEnv:AVOEnvDev version:version customNodeJsDestination:[DebuggerAnalyticsDestination new] strict:YES debugger:debuggerDummy];
            }).notTo.raiseAny();
        });

        it(@"Bar debugger calls debug initialization", ^{
            id myMock = [OCMockObject mockForClass:[DebuggerAnalytics class]];
            [[myMock expect] debuggerStartedWithFrameLocation:[OCMArg any] schemaId:[OCMArg isKindOfClass:[NSString class]]];
            AnalyticsDebugger *ad = [[AnalyticsDebugger alloc] init];

            XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
            [ad showBarDebugger];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [expectation fulfill];
            });

            [self waitForExpectationsWithTimeout:5 handler:nil];
            [myMock verify];
            [ad hideDebugger];
            [myMock stopMocking];
        });

        it(@"Bubble debugger calls debug initialization", ^{
            id myMock = [OCMockObject mockForClass:[DebuggerAnalytics class]];
            [[myMock expect] debuggerStartedWithFrameLocation:nil schemaId:[OCMArg isKindOfClass:[NSString class]]];
            AnalyticsDebugger *ad = [[AnalyticsDebugger alloc] init];

            XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
            [ad showBubbleDebugger];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [expectation fulfill];
            });

            [self waitForExpectationsWithTimeout:5 handler:nil];
            [myMock verify];
            [ad hideDebugger];
            [myMock stopMocking];
        });

        it(@"Set system properties with specific version", ^{
            NSString *myVersion = @"10.0.101";
            id myMock = [OCMockObject mockForClass:[DebuggerAnalytics class]];
            [[myMock expect] setSystemPropertiesWithVersion:myVersion];

            [DebuggerAnalytics initAvoWithEnv:AVOEnvProd version:myVersion customNodeJsDestination:[DebuggerAnalyticsDestination new]];
            XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [expectation fulfill];
            });

            [self waitForExpectationsWithTimeout:5 handler:nil];
            [myMock verify];
            [myMock stopMocking];
        });
});

SpecEnd
