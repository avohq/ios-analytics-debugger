//
//  test_AvoDebugger.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 17/06/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerViewController.h"
#import "AnalyticsDebugger.h"
#import <Specta/Specta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface PlayerViewController(Private)
- (IBAction)showBubble:(id)sender;
- (IBAction)showBar:(id)sender;
- (IBAction)hideDebugger:(id)sender;
@end

SpecBegin(AvoDebuggerSpecs)

describe(@"AvoDebugger", ^{
    __block UIStoryboard *storyboard;
    __block PlayerViewController *vcontroller;
    __block UIWindow *window;
    __block bool recordReference;
    
    beforeEach(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
        window = [[[UIApplication sharedApplication] delegate] window];
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
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-debugger-gone", 0.01);
    });
});

SpecEnd
