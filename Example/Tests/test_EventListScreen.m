//
//  test_EventListScreen.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 18/06/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxViewController.h"
#import "AnalyticsDebugger.h"
#import "EventsListScreenViewController.h"
#import <Specta/Specta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "DebuggerAnalytics.h"

@interface SandboxViewController(Private)
- (IBAction)shoBarDebugger:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;
@end

@interface AnalyticsDebugger(Private)
- (void) openEventsListScreen;
@end

@interface EventsListScreenViewController(Private)
- (void) dismissSelf;
@end

SpecBegin(AvoEventListScreenSpecs)

describe(@"AvoEventListScreenSpecs", ^{
    __block UIStoryboard *storyboard;
    __block SandboxViewController *vcontroller;
    __block UIWindow *window;
    __block bool recordReference;
    
    beforeEach(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"SandboxViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:vcontroller];
        window = [[[UIApplication sharedApplication] delegate] window];
        recordReference = false;
        
    });
    
    afterEach(^{
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac hideDebugger];
        [AnalyticsDebugger.events removeAllObjects];
    });

    xit(@"Renders correctly when opened - bubble", ^{
        [vcontroller showBubbleDebugger:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        if(recordReference == true){
            expect(window).after(2).recordSnapshotNamed(@"render-eventlist-bubble");
        }
        expect(window).after(2).haveValidSnapshotNamedWithTolerance(@"render-eventlist-bubble", 0.01);
    });

    xit(@"Renders correctly when opened - bar", ^{
        [vcontroller shoBarDebugger:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        if(recordReference == true){
            expect(window).will.recordSnapshotNamed(@"render-eventlist-bar");
        }
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-eventlist-bar", 0.01);
    });
    
    xit(@"Toggle opens and closes event list", ^{
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [vcontroller shoBarDebugger:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        if(recordReference == false){
            expect(window).after(2).haveValidSnapshotNamedWithTolerance(@"render-eventlist-open", 0.1);
        }
        else {
            expect(window).after(2).recordSnapshotNamed(@"render-eventlist-open");
        }

        NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
        NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];

        EventsListScreenViewController *eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
        [eventsListViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [rootViewController presentViewController:eventsListViewController animated:YES completion:nil];
        
        [eventsListViewController dismissSelf];
        if(recordReference == false){
            expect(window).after(2).haveValidSnapshotNamedWithTolerance(@"render-eventlist-closed", 0.01);
        }
        else{
            expect(window).after(2).recordSnapshotNamed(@"render-eventlist-closed");
        }
    });
    
    xit(@"Test posting event works", ^{
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [vcontroller shoBarDebugger:self];
            AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
            [ac openEventsListScreen];

            NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
            NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];

            EventsListScreenViewController *eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
            [eventsListViewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [rootViewController presentViewController:eventsListViewController animated:YES completion:nil];

            NSMutableArray * props = [NSMutableArray new];

            [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"id0 event" withValue:@"value 0"]];
            [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"id1 event" withValue:@"value 1"]];

            NSMutableArray * errors = [NSMutableArray new];

            [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"error in event id0"]];

            [ac publishEvent:@"Test IOS Debugger Event" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
                withProperties:props withErrors:errors];
            if(recordReference == false){
                expect(window).after(3).haveValidSnapshotNamedWithTolerance(@"render-eventlist-postevent", 0.1);
            }
            else {
                expect(window).after(3).recordSnapshotNamed(@"render-eventlist-postevent");
            }
        });
    
    
});

SpecEnd
