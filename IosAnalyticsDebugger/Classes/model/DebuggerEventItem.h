//
//  DebuggerEventItem.h
//  IosAnalyticsDebugger
//
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebuggerEventItem : NSObject

@property (strong, nonatomic, readwrite) NSString *identifier;
@property NSTimeInterval timestamp;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSMutableArray *messages;
@property (strong, nonatomic, readwrite) NSMutableArray *eventProps;
@property (strong, nonatomic, readwrite) NSMutableArray *userProps;

@end

NS_ASSUME_NONNULL_END
