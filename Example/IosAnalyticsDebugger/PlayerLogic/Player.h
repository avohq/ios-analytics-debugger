//
//  Player.h
//  IosAnalyticsDebugger_Example
//
//  Created by Alex Verein on 11/11/2019.
//  Copyright © 2019 Alexey Verein. All rights reserved.
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
