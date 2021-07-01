//
//  test_AvoBubble.m
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
- (IBAction)hideDebugger:(id)sender;
@end

@interface AnalyticsDebugger(Private)
- (void) openEventsListScreen;
@end

SpecBegin(AvoBubbleSpecs)

describe(@"AvoBuble", ^{
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
    
    xit(@"Renders correctly on main screen", ^{
        [vcontroller showBubble:self];

        if(recordReference == true){
            expect(window).will.recordSnapshotNamed(@"render-bubble");
        }
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-bubble", 0.01);
    });
    
    it(@"Renders correctly when opened", ^{
        [vcontroller showBubble:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        if(recordReference == true){
            expect(window).will.recordSnapshotNamed(@"render-bubble-open");
        }
        expect(window).will.haveValidSnapshotNamedWithTolerance(@"render-bubble-open", 0.01);
    });
});

SpecEnd
