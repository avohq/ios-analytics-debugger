//
//  MusicStorage.m
//  IosAnalyticsDebugger_Example
//
//  Created by Alex Verein on 11/11/2019.
//  Copyright © 2019 Alexey Verein. All rights reserved.
//

#import "MusicStorage.h"

@interface MusicStorage()

@property (strong, nonatomic) NSArray<NSString *> * tracks;

@end

@implementation MusicStorage

- (instancetype) init {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.tracks = @[@"cartoon_whistle.wav", @"greek_loop_mix.mp3", @"jingle_jungle_around_the_bot.wav"];
    return self;
}

- (NSArray<NSString *> *) trackInfo: (NSInteger) trackNumber {
    if (trackNumber < 0 || trackNumber >= [self.tracks count]) {
        return nil;
    }
    
    NSString * fullTrackName = [self.tracks objectAtIndex:trackNumber];
    NSString * trackName = [fullTrackName substringToIndex:[fullTrackName rangeOfString:@"." options:NSBackwardsSearch].location];
    NSString * trackExtention = [fullTrackName substringFromIndex:[fullTrackName rangeOfString:@"." options:NSBackwardsSearch].location];
    return @[trackName, trackExtention];
}

- (BOOL) hasNext: (NSInteger) fromPosition {
    if (fromPosition < [self.tracks count] - 1) {
          return YES;
    }
    return NO;
}

- (BOOL) hasPrev: (NSInteger) fromPosition {
    if (fromPosition > 0) {
          return YES;
    }
    return NO;
}

@end
