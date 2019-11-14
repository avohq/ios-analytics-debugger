//
//  AVOAppDelegate.h
//  IosAnalyticsDebugger
//
//  Copyright (c) 2019. All rights reserved.
//

#import <AnalyticsDebugger.h>

@import UIKit;

@interface AVOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AnalyticsDebugger *) debugger;

@end
