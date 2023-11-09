//
//  SandboxViewController.m
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import "SandboxViewController.h"
#import "AVOAppDelegate.h"
#import <DebuggerProp.h>
#import <DebuggerMessage.h>

@interface SandboxViewController ()
- (IBAction)onSendErrorClick:(id)sender;
- (IBAction)onSendEventClick:(id)sender;
- (IBAction)onSendDelayedClick:(id)sender;
- (IBAction)shoBarDebugger:(id)sender;
- (IBAction)showBubbleDebugger:(id)sender;

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onSendErrorClick:(id)sender {
    BOOL isEnabled = [[AVOAppDelegate debugger] performSelector:@selector(isEnabled)];
    
    if (isEnabled) {
        NSArray<NSDictionary *> * eventProps = @[@{@"id" : @"id23gfds3", @"name": @"Event Id", @"value": @"Commented very long description of value of this particular event that does not fite single line and expends to multiple lines because of its containing number of characters"},
                                                 @{@"id" : @"id321343", @"name": @"Event Name", @"value": @"Commented"}];
        
        NSArray<NSDictionary *> * userProps = @[@{@"id" : @"id235523", @"name": @"User Name", @"value": @"Vasily"},
                                                @{@"id" : @"id2rert", @"name": @"User Id", @"value": @"0"}];
        
        NSArray<NSDictionary *> * messages = @[@{@"tag" : @"tt", @"propertyId": @"id23gfds3", @"message": @"Event Id must be a NSString or char* but was a BOOL.",
                                                 @"allowedTypes": @"NSString,char*", @"providedType": @"BOOL"}];
        
        [[AVOAppDelegate debugger] performSelector:@selector(publishEvent:withParams:) withObject:@"Error event" withObject:@{@"timestamp" : [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"id": @"weew342", @"messages": messages, @"eventProps": eventProps, @"userProps": userProps}];
    }
}

- (IBAction)onSendEventClick:(id)sender {
    NSArray<NSDictionary *> * eventProps = @[@{@"id" : @"id23gfds3", @"name": @"X Event Id", @"value": @"{ some: thing, \n other : thing }"},
                                             @{@"id" : @"id321343", @"name": @"A Event Name", @"value": @"Commentedverylongdescriptionofvalueofthisparticulareventthatdoesnotfit single line and expends to multiple lines because of its containing number of characters"}];
    
    NSArray<NSDictionary *> * userProps = @[@{@"id" : @"id235523", @"name": @"A User Name User Name User Name User Name User Name User Name", @"value": @"Vasily"},
                                            @{@"id" : @"id2rert", @"name": @"B User Id", @"value": @"0"}];
    
    [[AVOAppDelegate debugger] publishEvent:@"Correct event" withParams:@{@"timestamp" : [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"id": @"weew342", @"messages": @[], @"eventProps": eventProps, @"userProps": userProps}];
}

- (IBAction)onSendDelayedClick:(id)sender {
   [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
      [[AVOAppDelegate debugger] publishEvent:@"Delayed event" withParams:@{@"timestamp" : [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"id": @"weew342", @"messages": @[], @"eventProps": @[], @"userProps": @[]}];
   }];
}

- (IBAction)shoBarDebugger:(id)sender {
    [[AVOAppDelegate debugger] showBarDebugger];
}

- (IBAction)showBubbleDebugger:(id)sender {
    [[AVOAppDelegate debugger] showBubbleDebugger];
}

@end
