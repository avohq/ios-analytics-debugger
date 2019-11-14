//
//  Player.h
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Player : NSObject

- (void) loadPath: (NSString *) path;
- (void) play;
- (void) pause;
- (BOOL) isPlaying;
- (NSTimeInterval) trackLength;
- (NSTimeInterval) currentTime;

@end

NS_ASSUME_NONNULL_END
