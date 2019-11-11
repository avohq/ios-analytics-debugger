//
//  EventTableViewCell.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 30/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsListScreenViewController.h"
#import "DebuggerEventItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTableViewCell : UITableViewCell <UITableViewDataSource>

@property (weak, nonatomic, readwrite) EventsListScreenViewController *eventsListScreenViewController;
@property (weak, nonatomic, readwrite) DebuggerEventItem *event;

- (void) populateWithEvent: (DebuggerEventItem *)event;
- (void) expend;
- (void) collapse;

- (void) showError:(BOOL) isError;

@end

NS_ASSUME_NONNULL_END
