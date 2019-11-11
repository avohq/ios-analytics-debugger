//
//  DebuggerEventItem.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebuggerEventItem : NSObject

@property (strong, nonatomic, readwrite) NSString *identifier;
@property NSTimeInterval timestamp;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSArray *messages;
@property (strong, nonatomic, readwrite) NSArray *eventProps;
@property (strong, nonatomic, readwrite) NSArray *userProps;

@end

NS_ASSUME_NONNULL_END
