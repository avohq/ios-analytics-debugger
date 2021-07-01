//
//  test_EventListCell.m
//  IosAnalyticsDebugger_Tests
//
//  Created by Roberts Brālis on 28/06/2021.
//  Copyright © 2021 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxViewController.h"
#import "AnalyticsDebugger.h"
#import "EventTableViewCell.h"
#import "EventsListScreenViewController.h"
#import <Specta/Specta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface SandboxViewController(Private)
- (IBAction)onSendEventClick:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;
@end

@interface AnalyticsDebugger(Private)
- (void) openEventsListScreen;
@end

@interface EventsListScreenViewController(Private)
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@end

@interface EventTableViewCell(Private)
- (void) toggleExpend;
@end

SpecBegin(AvoEventListCellSpecs)

describe(@"AvoEventListCellSpecs", ^{
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

    xit(@"Expands on click", ^{
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [vcontroller showBubbleDebugger:self];
        [vcontroller onSendEventClick:self];
        AnalyticsDebugger *ac = [[AnalyticsDebugger alloc] init];
        [ac openEventsListScreen];

        NSURL *bundleURL = [[[NSBundle bundleForClass:EventsListScreenViewController.class] resourceURL] URLByAppendingPathComponent:@"IosAnalyticsDebugger.bundle"];
        NSBundle *resBundle = [NSBundle bundleWithURL:bundleURL];
        EventsListScreenViewController *eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:resBundle];
        [eventsListViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [rootViewController presentViewController:eventsListViewController animated:YES completion:nil];
//        Push an event
        NSMutableArray * props = [NSMutableArray new];

        [props addObject:[[DebuggerProp alloc] initWithId:@"id0" withName:@"id0 event" withValue:@"value 0"]];
        [props addObject:[[DebuggerProp alloc] initWithId:@"id1" withName:@"id1 event" withValue:@"value 1"]];

        NSMutableArray * errors = [NSMutableArray new];

        [errors addObject:[[DebuggerPropError alloc] initWithPropertyId:@"id0" withMessage:@"error in event id0"]];

        [ac publishEvent:@"Test IOS Debugger Event" withTimestamp:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
            withProperties:props withErrors:errors];

//      Expect the cell to be expanded
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            EventTableViewCell *cell = (EventTableViewCell *)[eventsListViewController tableView:eventsListViewController.eventsTableView cellForRowAtIndexPath:indexPath];
            [cell toggleExpend];
        });

        if(recordReference == true){
            expect(window).after(5).recordSnapshotNamed(@"render-eventcell-expand");
        }
        expect(window).after(5).haveValidSnapshotNamedWithTolerance(@"render-eventcell-expand", 0.01);
    });
    
});

SpecEnd
