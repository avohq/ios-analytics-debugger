//
//  DebuggerProp.m
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 29/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import "DebuggerProp.h"

@implementation DebuggerProp

- (instancetype)initWithId:(NSString *)id withName:(NSString *)name withValue:(id)value;
{
    self = [super init];
    if (self) {
        self.id = id;
        self.name = name;
        self.value = value;
    }
    return self;
}

@end
