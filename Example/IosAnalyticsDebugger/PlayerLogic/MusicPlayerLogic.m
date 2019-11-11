//
//  MusicPlayerLogic.m
//  IosAnalyticsDebugger_Example
//
//  Created by Alex Verein on 11/11/2019.
//  Copyright © 2019 Alexey Verein. All rights reserved.
//

#import "MusicPlayerLogic.h"
#import "MusicStorage.h"

@interface MusicPlayerLogic ()

@property (strong, nonatomic) MusicStorage * musicStorage;
@property NSInteger currentTrackPosition;

@end

@implementation MusicPlayerLogic

- (instancetype) init {
    self = [super init];
    if (self) {
        self.player = [Player new];
        self.musicStorage = [MusicStorage new];
        self.currentTrackPosition = 0;
    }
    return self;
}

- (BOOL) loadPrevTrack {
    if ([self.musicStorage hasPrev:self.currentTrackPosition]) {
        self.currentTrackPosition -= 1;
        [self loadCurrentTrack];
        return YES;
    }
    
    return NO;
}

- (BOOL) loadNextTrack {
     if ([self.musicStorage hasNext:self.currentTrackPosition]) {
           self.currentTrackPosition += 1;
           [self loadCurrentTrack];
           return YES;
       }
       
       return NO;
}

- (void) loadCurrentTrack {
    NSArray<NSString *> * currentTrackInfo = [self.musicStorage trackInfo:self.currentTrackPosition];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:currentTrackInfo[0] ofType:currentTrackInfo[1]];
    
    [self.player loadPath:soundPath];
}

- (NSString *) prevTrackName {
    return [self trackName:self.currentTrackPosition - 1];
}

- (NSString *) nextTrackName {
    return [self trackName:self.currentTrackPosition + 1];
}

- (NSString *) currentTrackName {
    return [self trackName:self.currentTrackPosition];
}

- (NSString *) trackName: (NSInteger) index {
    NSArray * trackInfo = [self.musicStorage trackInfo:index];
      
    if (trackInfo) {
        return [trackInfo objectAtIndex:0];
    } else {
        return nil;
    }
}

- (BOOL) hasNextTrack {
    return [self.musicStorage hasNext:self.currentTrackPosition];
}
- (BOOL) hasPrevTrack {
    return [self.musicStorage hasPrev:self.currentTrackPosition];
}

@end
