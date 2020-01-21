//
//  Debugger.m
//  IosAnalyticsDebugger
//
//  Copyright © 2019. All rights reserved.
//

#import "AnalyticsDebugger.h"
#import "BubbleDebuggerView.h"
#import "BarDebuggerView.h"
#import "EventsListScreenViewController.h"
#import "Util.h"
#import "DebuggerMessage.h"
#import "DebuggerProp.h"
#import <Foundation/Foundation.h>

static UIView<DebuggerView> *debuggerView = nil;

@interface AnalyticsDebugger ()

@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation AnalyticsDebugger

CGFloat screenHeight;
CGFloat screenWidth;

NSString *currentSchemaId;

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    analyticsDebuggerEvents = [NSMutableArray new];
    return self;
}

-(void) showBarDebugger {
    if (debuggerView != nil) {
        [self hideDebugger];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
     
    NSInteger bottomOffset = [Util barBottomOffset];
    debuggerView = [[BarDebuggerView alloc] initWithFrame: CGRectMake(0, screenHeight - 30 - bottomOffset, screenWidth, 30) ];
 
    [[[UIApplication sharedApplication] keyWindow] addSubview:debuggerView];
     
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(drugBar:)];
    
    [debuggerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEventsListScreen)]];
    [debuggerView addGestureRecognizer:self.panGestureRecognizer];
    
    if ([analyticsDebuggerEvents count] > 0) {
        [debuggerView showEvent:[analyticsDebuggerEvents objectAtIndex:0]];
    }
    
    [self trackDebuggerStarted];
}

- (void) trackDebuggerStarted {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                       initWithURL:[NSURL URLWithString:@"https://api.avo.app/c/v1/track"]];
    [request setHTTPMethod:@"POST"];
    
    [self writeTrackingCallHeader:request];

    [self writeTrackingCallBody:request];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];

    [postDataTask resume];
}

- (void) writeTrackingCallHeader:(NSMutableURLRequest *) request {
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void) writeTrackingCallBody:(NSMutableURLRequest *) request {
    NSString *version = [[[NSBundle bundleForClass:[AnalyticsDebugger class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
       
    NSMutableDictionary *eventProperties = [NSMutableDictionary new];
    [eventProperties setValue:(currentSchemaId != nil ? currentSchemaId : @"n/a") forKey:@"schemaId"];
    [eventProperties setValue:@"Ios Debugger" forKey:@"client"];
    [eventProperties setValue:version forKey:@"version"];
       
    UIDevice *device = [UIDevice currentDevice];
    NSString  *deviceId = [[device identifierForVendor]UUIDString];
       
    NSMutableDictionary *body = [NSMutableDictionary new];
    [body setValue:deviceId forKey:@"deviceId"];
    [body setValue:@"Debugger Started" forKey:@"eventName"];
    [body setValue:eventProperties forKey:@"eventProperties"];
       
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&error];
    [request setHTTPBody:bodyData];
}

- (void) drugBar:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView:debuggerView];
    
    CGFloat statusBarHeight = [Util statusBarHeight];
    NSInteger bottomOffset = [Util barBottomOffset];
    
    CGFloat newY = MIN(debuggerView.center.y + translation.y, screenHeight - bottomOffset);
    newY = MAX(statusBarHeight + (CGRectGetHeight(debuggerView.bounds) / 2), newY);
    debuggerView.center = CGPointMake(debuggerView.center.x, newY);
    [sender setTranslation:CGPointZero inView:debuggerView];
}

-(void) showBubbleDebugger {
    if (debuggerView != nil) {
        [self hideDebugger];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    NSInteger bottomOffset = [Util barBottomOffset];
    
    debuggerView = [[BubbleDebuggerView alloc] initWithFrame: CGRectMake(screenWidth - 40, screenHeight - 40 - bottomOffset, 40, 40) ];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:debuggerView];
     
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(drugBubble:)];
     
    [debuggerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEventsListScreen)]];
    [debuggerView addGestureRecognizer:self.panGestureRecognizer];
    
    for (int index = (int)[analyticsDebuggerEvents count] - 1; index >= 0; index--) {
        DebuggerEventItem * event = [analyticsDebuggerEvents objectAtIndex:index];
        [debuggerView showEvent:event];
    }
    
    [self trackDebuggerStarted];
}

- (void) drugBubble:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView:debuggerView];
    
    CGFloat statusBarHeight = [Util statusBarHeight];
    NSInteger bottomOffset = [Util barBottomOffset];
    
    CGFloat newY = MIN(debuggerView.center.y + translation.y, screenHeight - bottomOffset);
    newY = MAX(statusBarHeight + (CGRectGetHeight(debuggerView.bounds) / 2), newY);
    
    CGFloat newX = MIN(debuggerView.center.x + translation.x, screenWidth);
    newX = MAX((CGRectGetWidth(debuggerView.bounds) / 2), newX);
    
    debuggerView.center = CGPointMake(newX, newY);
    [sender setTranslation:CGPointZero inView:debuggerView];
}

- (void) openEventsListScreen {
    if (debuggerView != nil) {
        [debuggerView onClick];
        
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        EventsListScreenViewController *eventsListViewController = [[EventsListScreenViewController alloc] initWithNibName:@"EventsListScreenViewController" bundle:[NSBundle bundleForClass:[EventsListScreenViewController class]]];
        [eventsListViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [rootViewController presentViewController:eventsListViewController animated:YES completion:nil];
    }
}

- (void) hideDebugger {
    if (debuggerView != nil) {
        [debuggerView removeFromSuperview];
        debuggerView = nil;
    }
}

- (void) setSchemaId:(NSString *)schemaId {
    currentSchemaId = schemaId;
}

- (void) publishEvent:(NSString *) eventName withParams:(NSDictionary *) params {
    
    NSNumber * timestamp = [params objectForKey: @"timestamp"];
    NSString * eventId = [params objectForKey: @"id"];
    NSArray<NSDictionary *> * messages = [params objectForKey: @"messages"];
    NSArray<NSDictionary *> * eventProps = [params objectForKey: @"eventProps"];
    NSArray<NSDictionary *> * userProps = [params objectForKey: @"userProps"];
    
    DebuggerEventItem * event = [DebuggerEventItem new];
    event.name = eventName;
    event.identifier = eventId;
    event.timestamp = [timestamp doubleValue];
    event.messages = [NSMutableArray new];
    for (id message in messages) {
        DebuggerMessage * debuggerMessage = [self createMessageWithDictionary:message];

        if (debuggerMessage != nil) {
            [event.messages addObject:debuggerMessage];
        }
    }
    event.eventProps = [NSMutableArray new];
    for (id prop in eventProps) {
        DebuggerProp * eventProp = [self createPropWithDictionary:prop];

        if (eventProp != nil) {
            [event.eventProps addObject:eventProp];
        }
    }
    event.userProps = [NSMutableArray new];
    for (id prop in userProps) {
        DebuggerProp * userProp = [self createPropWithDictionary:prop];

        if (userProp != nil) {
            [event.userProps addObject:userProp];
        }
    }
    
    NSInteger insertIndex = 0;
    for (int i = 0; i < [analyticsDebuggerEvents count]; i++) {
        DebuggerEventItem *presentEvent = [analyticsDebuggerEvents objectAtIndex:i];
        
        if (presentEvent.timestamp > event.timestamp) {
            insertIndex += 1;
        } else {
            break;
        }
    }
    [analyticsDebuggerEvents insertObject:event atIndex:insertIndex];
    
    if (debuggerView != nil) {
        [debuggerView showEvent:event];
    }
    
    if (onNewEventCallback != nil) {
        onNewEventCallback(event);
    }
}

- (DebuggerMessage *) createMessageWithDictionary: (NSDictionary *) messageDict {
    NSString * tag = [messageDict objectForKey:@"tag"];
    NSString * propertyId = [messageDict objectForKey:@"propertyId"];
    NSString * message = [messageDict objectForKey:@"message"];

    if (tag == nil || propertyId == nil || message == nil) {
        return nil;
    }

    NSArray * allowedTypes = [[NSArray alloc] init];
    NSString * allowedTypesString = [messageDict objectForKey:@"allowedTypes"];
    if (allowedTypesString != nil) {
        allowedTypes = [allowedTypesString componentsSeparatedByString: @","];
    }

    return [[DebuggerMessage alloc] initWithTag:tag withPropertyId:propertyId withMessage:message withAllowedTypes:allowedTypes
                               withProvidedType:[messageDict objectForKey:@"providedType"]];
}

- (DebuggerProp *) createPropWithDictionary: (NSDictionary *) propDict {
    NSString * id = [propDict objectForKey:@"id"];
    NSString * name = [propDict objectForKey:@"name"];
    NSString * value = [propDict objectForKey:@"value"];
    
    if (id == nil || name == nil || value == nil) {
        return nil;
    }
    
    return [[DebuggerProp alloc] initWithId:id withName:name withValue:value];
}

- (BOOL) isEnabled {
    return debuggerView != nil;
}

+ (NSMutableArray*) events {
    return analyticsDebuggerEvents;
}

+(void) setOnNewEventCallback:(nullable OnNewEventCallback) callback {
    onNewEventCallback = callback;
}

@end
