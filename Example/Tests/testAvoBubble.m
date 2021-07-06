//
//  testAvoBubble.m
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

#import "PlayerViewController.h"
#import "AnalyticsDebugger.h"

@interface PlayerViewController(Private)
- (IBAction)showBubble:(id)sender;
@end

SpecBegin(AvoBubble)
    
    describe(@"AvoBubble", ^{
        __block UIStoryboard *storyboard;
        __block PlayerViewController *vcontroller;
        __block UIWindow *window;
        __block bool recordReference;
        
        beforeEach(^{
            //      Load view controller/views
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
            window = [[[UIApplication sharedApplication] delegate] window];
            //      Remove default 4 events in AnalyticsDebugger.events
            if([[AnalyticsDebugger events] count] > 0){
                [AnalyticsDebugger.events removeAllObjects];
            }
            recordReference = false;
        });
        
        afterEach(^{
            [AnalyticsDebugger.events removeAllObjects];
        });
        
        it(@"Renders correctly on main screen", ^{
            [vcontroller showBubble:self];

            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-bubble");
            }
            expect(window).toNot.recordSnapshotNamed(@"render-bubble");
            expect(window).will.haveValidSnapshotNamed(@"render-bubble");
        });
    });
SpecEnd
