//
//  Player.m
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import "Player.h"
#import <AVFoundation/AVFoundation.h>

@interface Player()

@property (strong, nonatomic, readwrite) AVAudioPlayer *audioPlayer;

@end

@implementation Player

- (BOOL) isPlaying {
    return [self.audioPlayer isPlaying];
}

- (void) loadPath: (NSString *) path {
    [self.audioPlayer stop];
    
     NSError *err = nil;
     self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
     
     if (!err) {
         self.audioPlayer.numberOfLoops = -1;
         [self.audioPlayer prepareToPlay];
     }
}

- (void) play {
    [self.audioPlayer play];
}

- (void) pause {
    [self.audioPlayer pause];
}

- (NSTimeInterval) trackLength {
    return [self.audioPlayer duration];
}

- (NSTimeInterval) currentTime {
    return [self.audioPlayer currentTime];
}

@end
