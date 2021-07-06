//
//  testSandbox.m
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

@interface SandboxViewController(Private)
- (IBAction)onSendErrorClick:(id)sender;
- (IBAction)onSendEventClick:(id)sender;
- (IBAction)onSendDelayedClick:(id)sender;
- (IBAction)shoBarDebugger:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;
@end


SpecBegin(AvoSandbox)
    
    describe(@"AvoSandbox", ^{
        
        __block UIStoryboard *storyboard;
        __block SandboxViewController *vcontroller;
        __block UIWindow *window;
        __block bool recordReference;
        __block EventsListScreenViewController *eventsListViewController;
        
        beforeEach(^{
        //        Load view controller/views
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"SandboxViewController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:vcontroller];
            window = [[[UIApplication sharedApplication] delegate] window];
            
            NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
            NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];
            eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
        //        Remove default 4 events from list
            if([[AnalyticsDebugger events] count] > 0){
                [AnalyticsDebugger.events removeAllObjects];
            }
            
            recordReference = false;
            [vcontroller showBubbleDebugger:self];
        });
        
        afterEach(^{
            [AnalyticsDebugger.events removeAllObjects];
        });
        
        it(@"Render sandbox mode correctly", ^{
            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-sandbox");
            }
            expect(window).will.haveValidSnapshotNamed(@"render-sandbox");
        });
        
        it(@"Render bubble debugger from sandbox mode correctly", ^{
            [vcontroller showBubbleDebugger:self];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-sandbox-bubble");
            }
            expect(window).will.haveValidSnapshotNamed(@"render-sandbox-bubble");
        });

        it(@"Render bar debugger from sandbox mode correctly", ^{
            [vcontroller shoBarDebugger:self];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-sandbox-bar");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-sandbox-bar", 0.01);
        });

        it(@"Render sending error to debugger - check if shows up", ^{
            [vcontroller shoBarDebugger:self];
            [vcontroller onSendErrorClick:self];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-sandbox-send-error");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-sandbox-send-error", 0.1);
        });

        it(@"Render sending valid event to debugger - check if shows up", ^{
            [vcontroller shoBarDebugger:self];
            [vcontroller onSendEventClick:self];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-sandbox-send-event");
            }
            expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-sandbox-send-event", 0.1);
        });

        it(@"Render sending error event delayed - check if renders", ^{
            [vcontroller shoBarDebugger:self];
            [vcontroller onSendDelayedClick:self];

            if(recordReference == true){
                expect(window).after(10).recordSnapshotNamed(@"render-sandbox-send-error-delayed");
            }
            expect(window).after(10).haveValidSnapshotNamedWithTolerance(@"render-sandbox-send-error-delayed", 0.1);
        });
        
    });
SpecEnd
