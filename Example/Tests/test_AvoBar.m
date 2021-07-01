//
//  test_AvoBar.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 15/06/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerViewController.h"
#import "AnalyticsDebugger.h"
#import <Specta/Specta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface PlayerViewController(Private)
- (IBAction)showBar:(id)sender;
@end

@interface AnalyticsDebugger(Private)
- (void) openEventsListScreen;
@end

SpecBegin(AvoBarSpecs)

describe(@"AvoBar", ^{
    
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
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac hideDebugger];
        [AnalyticsDebugger.events removeAllObjects];
    });
    
    it(@"Renders correctly on main screen", ^{
        [vcontroller showBar:self];

        if(recordReference == true){
            expect(window).will.recordSnapshotNamed(@"render-bar");
        }
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-bar", 0.01);
    });
    
    it(@"Renders correctly when opened", ^{
        [vcontroller showBar:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        if(recordReference == true){
            expect(window).will.recordSnapshotNamed(@"render-bar-open");
        }
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-bar-open", 0.01);
    });
});

SpecEnd
