//
//  Util.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DebuggerEventItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+(NSString *) timeString:(NSTimeInterval)timestamp;
+(BOOL) eventHaveErrors:(DebuggerEventItem *)event;
+(NSInteger) barBottomOffset;

@end

NS_ASSUME_NONNULL_END
