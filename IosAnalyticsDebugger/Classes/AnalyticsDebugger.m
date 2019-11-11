//
//  Debugger.m
//  IosAnalyticsDebugger
//
//  Created by Alex Verein on 21/10/2019.
//  Copyright © 2019 Alex Verein. All rights reserved.
//

#import "AnalyticsDebugger.h"
#import "BubbleDebuggerView.h"
#import "BarDebuggerView.h"
#import "EventsListScreenViewController.h"
#import "Util.h"

static UIView<DebuggerView> *debuggerView = nil;

@interface AnalyticsDebugger ()

@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation AnalyticsDebugger

CGFloat screenHeight;
CGFloat screenWidth;

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
}

- (void) drugBar:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView:debuggerView];
    
    CGFloat statusBarHeight = [self statusBarHeight:debuggerView];
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
}

- (void) drugBubble:(UIPanGestureRecognizer*)sender {
    CGPoint translation = [sender translationInView:debuggerView];
    
    CGFloat statusBarHeight = [self statusBarHeight:debuggerView];
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

- (CGFloat) statusBarHeight:(UIView*)view {
    CGSize statusBarSize;
    if (@available(iOS 13.0, *)) {
        statusBarSize = [[[[view window] windowScene] statusBarManager] statusBarFrame].size;
    } else {
        statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    }
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (void) hideDebugger {
    if (debuggerView != nil) {
        [debuggerView removeFromSuperview];
        debuggerView = nil;
    }
}

- (void) publishEvent:(NSString *) eventName withTimestamp:(NSTimeInterval) timestamp
            withId:(NSString *) eventId withMessages:(NSArray *) messages
            withEventProps:(NSArray *) eventProps withUserProps:(NSArray *) userProps {
    DebuggerEventItem * event = [DebuggerEventItem new];
    event.name = eventName;
    event.identifier = eventId;
    event.timestamp = timestamp;
    event.messages = messages;
    event.eventProps = eventProps;
    event.userProps = userProps;
    
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
