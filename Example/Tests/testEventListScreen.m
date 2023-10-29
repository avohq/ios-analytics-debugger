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
- (IBAction)onClearButtonClick:(id)sender;
- (IBAction)onToggleFilter:(id)sender;
- (void)onIputFilter:(NSString*)newFilter;
- (NSArray *) filteredEvents;
@property (strong, nonatomic) IBOutlet UIButton *filterInput;
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
            // Load view controllers/views
            ac = [[AnalyticsDebugger alloc] init];

            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"SandboxViewController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:vcontroller];
            window = [[[UIApplication sharedApplication] delegate] window];
            
            NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
            NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];
            eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
            [eventsListViewController loadView];
            // Remove default 4 events in event list
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
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
            } else {
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-bubble", 0.02);
            }
        });

        it(@"Renders correctly when opened - bar", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-eventlist-bar");
            } else {
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-bar", 0.02);
            }
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
            } else {
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-closed", 0.1);
            }
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

        it(@"Test clear events", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            NSMutableArray * props = [NSMutableArray new];

            [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"id0 event" withValue:@"value 0"]];
            [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"id1 event" withValue:@"value 1"]];

            NSMutableArray * errors = [NSMutableArray new];

            [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"error in event id0"]];

            [ac publishEvent:@"Test IOS Debugger Event" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
                withProperties:props withErrors:errors];

            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

            NSMutableArray * events = [AnalyticsDebugger events];
            assert(events.count != 0);

            [eventsListViewController onClearButtonClick:@YES];

            assert([AnalyticsDebugger events].count == 0);
            if(recordReference == false){
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-cleared", 0.1);
            }
            else {
                expect(window).will.recordSnapshotNamed(@"render-eventlist-cleared");
            }
        });
        
        it(@"Test show and hide filter", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];
            
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

            [eventsListViewController onToggleFilter:@YES];

            assert([eventsListViewController.filterInput isHidden] == NO);
            
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            
            if(recordReference == false){
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-filter-visible", 0.1);
            }
            else {
                expect(window).will.recordSnapshotNamed(@"render-eventlist-filter-visible");
            }
            
            [eventsListViewController onToggleFilter:@YES];
            
            assert([eventsListViewController.filterInput isHidden] == YES);
            
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            
            if(recordReference == false){
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-filter-hidden", 0.1);
            }
            else {
                expect(window).will.recordSnapshotNamed(@"render-eventlist-filter-hidden");
            }
        });
        
        it(@"Shows subset of events based on filter", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            [ac publishEvent:@"sunset" withTimestamp:[NSNumber numberWithDouble:3.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"midnight" withTimestamp:[NSNumber numberWithDouble:4.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"sunrise" withTimestamp:[NSNumber numberWithDouble:1.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"midday" withTimestamp:[NSNumber numberWithDouble:2.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

            // 4 items in the debugger
            NSArray * filtered = [eventsListViewController filteredEvents];
            assert(filtered.count == 4);

            [eventsListViewController onToggleFilter:@YES];

            // When filter is set
            [eventsListViewController onIputFilter:@"mId"];

            // Then the content is filtered
            assert([eventsListViewController filteredEvents].count == 2);
            
            // When filter is hidden
            [eventsListViewController onToggleFilter:@YES];
            
            // 4 items in the debugger
            filtered = [eventsListViewController filteredEvents];
            assert(filtered.count == 4);

            // When filter is shown back
            [eventsListViewController onToggleFilter:@YES];
            
            // Then the content is filtered
            assert([eventsListViewController filteredEvents].count == 2);
            
            // When filter is reset
            [eventsListViewController onIputFilter:@""];
            
            // 4 items in the debugger
            assert([eventsListViewController filteredEvents].count == 4);
        });

        it(@"onInputFilter shows filtered data", ^{
            [vcontroller shoBarDebugger:self];
            [ac openEventsListScreen];

            [ac publishEvent:@"sunset" withTimestamp:[NSNumber numberWithDouble:3.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"midnight" withTimestamp:[NSNumber numberWithDouble:4.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"sunrise" withTimestamp:[NSNumber numberWithDouble:1.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [ac publishEvent:@"midday" withTimestamp:[NSNumber numberWithDouble:2.0]
                withProperties:[NSMutableArray new] withErrors:[NSMutableArray new]];
            
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

            // 4 items in the debugger
            NSArray * filtered = [eventsListViewController filteredEvents];
            assert(filtered.count == 4);

            [eventsListViewController onToggleFilter:@YES];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

            // When filter is set
            [eventsListViewController onIputFilter:@"mId"];
            
            // 2 items in the debugger
            filtered = [eventsListViewController filteredEvents];
            assert(filtered.count == 2);
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

            // Then the content is reloaded and shown
            if(recordReference == false){
                expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-filtered", 0.1);
            }
            else {
                expect(window).will.recordSnapshotNamed(@"render-eventlist-filtered");
            }
        });
    });
SpecEnd
