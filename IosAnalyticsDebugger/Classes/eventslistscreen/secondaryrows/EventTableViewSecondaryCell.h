//
//  EventTableViewSecondaryCell.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 06/11/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DebuggerProp.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventTableViewSecondaryCell : UITableViewCell

- (void) populateWithProp: (DebuggerProp *) prop;
- (void) showError: (NSAttributedString *) errorMessage;

@end

NS_ASSUME_NONNULL_END
