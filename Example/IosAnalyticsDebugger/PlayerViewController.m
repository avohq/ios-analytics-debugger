//
//  AVOViewController.m
//  IosAnalyticsDebugger
//
//  Created by Alexey Verein on 11/08/2019.
//  Copyright (c) 2019 Alexey Verein. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicPlayerLogic.h"
#import <AnalyticsDebugger.h>

static AnalyticsDebugger *debugger = nil;

@interface PlayerViewController ()

- (IBAction)showBubble:(id)sender;
- (IBAction)showBar:(id)sender;
- (IBAction)hideDebugger:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *playTime;

- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)prevTrack:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextTrackButton;
@property (weak, nonatomic) IBOutlet UIButton *prevTrackButton;

@property (strong, nonatomic) MusicPlayerLogic *musicPlayerLogic;
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (debugger == nil) {
        debugger = [AnalyticsDebugger new];
    }
    
    self.musicPlayerLogic = [MusicPlayerLogic new];
    [self.musicPlayerLogic loadCurrentTrack];
    [self showCurrentTrack];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self pause];
}

- (void) handleEnteredBackground:(UIApplication *)application {
    [self pause];
}

- (void) showCurrentTrack {
    [self.trackName setText:[self.musicPlayerLogic currentTrackName]];
    [self showTrackTime];
}

- (void) showTrackTime {
    NSNumberFormatter * formatter =  [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];
    
    NSString * currentTime = [NSString stringWithFormat:@"%@ / %@", [formatter stringFromNumber: @([self.musicPlayerLogic.player currentTime])],
                              [formatter stringFromNumber:@([self.musicPlayerLogic.player trackLength])]];
    [self.playTime setText:currentTime];
}

- (IBAction)showBubble:(id)sender {
    [debugger showBubbleDebugger];
}

- (IBAction)showBar:(id)sender {
    [debugger showBarDebugger];
}

- (IBAction)hideDebugger:(id)sender {
    [debugger hideDebugger];
}
- (IBAction)playPause:(id)sender {
    if ([[self.playPauseButton currentTitle] isEqual:@"PLAY"]) {
        [self play];
    } else {
        [self pause];
    }
}

- (void) pause {
    [self.playPauseButton setTitle:@"PLAY" forState:UIControlStateNormal];
    
    [self.musicPlayerLogic.player pause];
    
    [self.timer invalidate];
}

- (void) play {
    [self.playPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    
    [self.musicPlayerLogic.player play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTrackTime) userInfo:nil repeats:YES];
}

- (IBAction)nextTrack:(id)sender {
    if ([self.musicPlayerLogic loadNextTrack]) {
        [self pause];
        [self showCurrentTrack];
    }
}

- (IBAction)prevTrack:(id)sender {
    if ([self.musicPlayerLogic loadPrevTrack]) {
        [self pause];
        [self showCurrentTrack];
    }
}


@end
