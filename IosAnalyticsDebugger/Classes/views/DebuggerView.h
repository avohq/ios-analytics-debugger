//
//  Header.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import "DebuggerEventItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DebuggerView

- (void) showEvent:(DebuggerEventItem *)event;
- (void) onClick;

@end

NS_ASSUME_NONNULL_END
