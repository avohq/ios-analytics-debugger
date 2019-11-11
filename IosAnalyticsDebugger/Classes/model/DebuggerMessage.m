//
//  DebuggerMessage.m
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import "DebuggerMessage.h"

@implementation DebuggerMessage

- (instancetype)initWithTag:(NSString *)tag withPropertyId:(NSString *)propertyId withMessage:(NSString *)message withAllowedTypes:(NSArray *)allowedTypes withProvidedType:(NSString *)providedType
{
    self = [super init];
    if (self) {
        self.tag = tag;
        self.propertyId = propertyId;
        self.message = message;
        self.allowedTypes = allowedTypes;
        self.providedType = providedType;
    }
    return self;
}


@end
