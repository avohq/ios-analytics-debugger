//
//  MusicPlayerLogic.h
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicPlayerLogic : NSObject

@property (strong, nonatomic) Player* player;

- (BOOL) loadPrevTrack;
- (BOOL) loadNextTrack;
- (void) loadCurrentTrack;
- (NSString *) prevTrackName;
- (NSString *) nextTrackName;
- (NSString *) currentTrackName;
- (BOOL) hasNextTrack;
- (BOOL) hasPrevTrack;

@end

NS_ASSUME_NONNULL_END
