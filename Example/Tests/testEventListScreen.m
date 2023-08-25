//
//  testEventListScreen.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 06/07/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <Expecta_Snapshots/EXPMatchers+FBSnapshotTest.h>

#import "SandboxViewController.h"
#import "AnalyticsDebugger.h"
#import "EventsListScreenViewController.h"
#import "DebuggerAnalytics.h"

@interface EventsListScreenViewController(Private)
- (void) dismissSelf;
@end

@interface SandboxViewController(Private)
- (IBAction)shoBarDebugger:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;
@end

@interface AnalyticsDebugger(Private)
- (void) openEventsListScreen;
@end

SpecBegin(AvoEventListScreen)
    describe(@"AvoEventListScreen", ^{
        __block UIStoryboard *storyboard;
        __block SandboxViewController *vcontroller;
        __block UIWindow *window;
        __block bool recordReference;
        __block EventsListScreenViewController *eventsListViewController;
        __block AnalyticsDebugger *ac;
        
        beforeEach(^{
            //        Load view controllers/views
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"SandboxViewController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:vcontroller];
            window = [[[UIApplication sharedApplication] delegate] window];
            
            NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
            NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];
            eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
    //         Remove default 4 events in event list
            ac = [[AnalyticsDebugger alloc] init];
            if([[AnalyticsDebugger events] count] > 0){
                [AnalyticsDebugger.events removeAllObjects];
            }
            
            [vcontroller showBubbleDebugger:self];
            recordReference = false;
            [Expecta setAsynchronousTestTimeout:10];
        });
        
        afterEach(^{
            [eventsListViewController dismissSelf];
            [AnalyticsDebugger.events removeAllObjects];
        });
        
        it(@"Renders correctly when opened - bubble", ^{
            [vcontroller showBubbleDebugger:self];
            [ac openEventsListScreen];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-eventlist-bubble");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-bubble", 0.02);
        });

        it(@"Renders correctly when opened - bar", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-eventlist-bar");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-bar", 0.02);
        });

        it(@"Toggle opens and closes event list", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-eventlist-open");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-open", 0.1);
            
            [eventsListViewController dismissSelf];
            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-eventlist-closed");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-closed", 0.1);
        });
        
        it(@"Test posting event works", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            NSMutableArray * props = [NSMutableArray new];

            [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"id0 event" withValue:@"value 0"]];
            [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"id1 event" withValue:@"value 1"]];

            NSMutableArray * errors = [NSMutableArray new];

            [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"error in event id0"]];

            [ac publishEvent:@"Test IOS Debugger Event" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
                withProperties:props withErrors:errors];
            if(recordReference == false){
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-postevent", 0.1);
            }
            else {
                expect(window).will.recordSnapshotNamed(@"render-eventlist-postevent");
            }
        });
    });
SpecEnd
