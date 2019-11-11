//
//  SandboxViewController.m
//  IosAnalyticsDebugger_Example
//
//  Created by Alex Verein on 11/11/2019.
//  Copyright © 2019 Alexey Verein. All rights reserved.
//

#import "SandboxViewController.h"
#import "AVOAppDelegate.h"
#import <DebuggerProp.h>
#import <DebuggerMessage.h>

@interface AnalyticsDebugger(MyAdditions)
-(void) publishEvent:(NSString *) eventName withTimestamp:(NSTimeInterval) timestamp
            withId:(NSString *) eventId withMessages:(NSArray *) messages
      withEventProps:(NSArray *) eventProps withUserProps:(NSArray *) userProps;

-(BOOL) isEnabled;
@end

@interface SandboxViewController ()
- (IBAction)onSendErrorClick:(id)sender;
- (IBAction)pnSendEventClick:(id)sender;
- (IBAction)onSendDelayedClick:(id)sender;
- (IBAction)shoBarDebugger:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onSendErrorClick:(id)sender {
    NSArray * eventProps = @[[[DebuggerProp alloc] initWithId:@"id23gfds3" withName:@"Event Id" withValue:@"YES"],
           [[DebuggerProp alloc] initWithId:@"id321343" withName:@"Event Name" withValue:@"Commented"]];
    NSArray * userProps = @[[[DebuggerProp alloc] initWithId:@"id235523" withName:@"User Name" withValue:@"Vasily"],
        [[DebuggerProp alloc] initWithId:@"id2rert" withName:@"User Id" withValue:@"0"]];
    
    NSArray * messages = @[[[DebuggerMessage alloc] initWithTag:@"tt" withPropertyId:@"id23gfds3" withMessage:@"Event Id must be a NSString or char* but was a BOOL." withAllowedTypes:@[@"NSString", @"char*"] withProvidedType:@"BOOL"]];
    
    [[AVOAppDelegate debugger] publishEvent:@"Error Event" withTimestamp:[[NSDate date] timeIntervalSince1970] withId:@"asd23qd" withMessages:messages withEventProps:eventProps withUserProps:userProps];
}

- (IBAction)pnSendEventClick:(id)sender {
    NSArray * eventProps = @[[[DebuggerProp alloc] initWithId:@"id23gfds3" withName:@"Event Id" withValue:@"4354565"],
           [[DebuggerProp alloc] initWithId:@"id321343" withName:@"Event Name" withValue:@"Commented"]];
    NSArray * userProps = @[[[DebuggerProp alloc] initWithId:@"id235523" withName:@"User Name" withValue:@"Vasily"],
        [[DebuggerProp alloc] initWithId:@"id2rert" withName:@"User Id" withValue:@"0"]];
    [[AVOAppDelegate debugger] publishEvent:@"Correct event" withTimestamp:[[NSDate date] timeIntervalSince1970] withId:@"weew342" withMessages:nil withEventProps:eventProps withUserProps:userProps];
}

- (IBAction)onSendDelayedClick:(id)sender {
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [[AVOAppDelegate debugger] publishEvent:@"Delayed" withTimestamp:[[NSDate date] timeIntervalSince1970] withId:@"dela345" withMessages:nil withEventProps:@[] withUserProps:@[]];
    }];
}

- (IBAction)shoBarDebugger:(id)sender {
    [[AVOAppDelegate debugger] showBarDebugger];
}

- (IBAction)showBubbleDebugger:(id)sender {
    [[AVOAppDelegate debugger] showBubbleDebugger];
}

@end
