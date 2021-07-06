//
//  testAvoDebugger.m
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
- (IBAction)showBar:(id)sender;
- (IBAction)hideDebugger:(id)sender;
@end

SpecBegin(AvoDebugger)
    
    describe(@"AvoDebugger", ^{
        __block UIStoryboard *storyboard;
        __block PlayerViewController *vcontroller;
        __block UIWindow *window;
        __block bool recordReference;
        
        beforeEach(^{
    //        Load view controllers/views
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
            window = [[[UIApplication sharedApplication] delegate] window];
    //         Remove default 4 events in event list
            if([[AnalyticsDebugger events] count] > 0){
                [AnalyticsDebugger.events removeAllObjects];
            }
            recordReference = false;
        });
        
        afterEach(^{
            [AnalyticsDebugger.events removeAllObjects];
        });
        
        it(@"Hide debugger renders correctly - hides debugger UI", ^{
            [vcontroller showBar:self];
            [vcontroller hideDebugger:self];
            
            if(recordReference == true){
                expect(window).will.recordSnapshotNamed(@"render-debugger-gone");
            }
            expect(window).toNot.recordSnapshotNamed(@"render-debugger-gone");
            expect(window).will.haveValidSnapshotNamed(@"render-debugger-gone");
        });
    });
SpecEnd

