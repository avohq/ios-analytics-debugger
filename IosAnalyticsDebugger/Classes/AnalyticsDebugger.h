//
//  Debugger.h
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 21/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSMutableArray *analyticsDebuggerEvents;

@interface AnalyticsDebugger : NSObject

+(NSMutableArray*) events;

-(void) showBarDebugger;
-(void) showBubbleDebugger;
-(void) hideDebugger;
-(BOOL) isEnabled;

@end

NS_ASSUME_NONNULL_END
