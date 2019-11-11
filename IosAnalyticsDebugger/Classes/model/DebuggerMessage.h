//
//  DebuggerMessage.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebuggerMessage : NSObject

@property (strong, nonatomic, readwrite) NSString *tag;
@property (strong, nonatomic, readwrite) NSString *propertyId;
@property (strong, nonatomic, readwrite) NSString *message;
@property (strong, nonatomic, readwrite) NSArray *allowedTypes;
@property (strong, nonatomic, readwrite) NSString *providedType;

- (instancetype)initWithTag:(NSString *)tag withPropertyId:(NSString *)propertyId withMessage:(NSString *)message withAllowedTypes:(NSArray *)allowedTypes withProvidedType:(NSString *)providedType;

@end

NS_ASSUME_NONNULL_END
