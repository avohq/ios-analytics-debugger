//
//  AVOViewController.m
//  IosAnalyticsDebugger
//
//  Copyright (c) 2019. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicPlayerLogic.h"
#import <AnalyticsDebugger.h>
#import "AVOAppDelegate.h"
#import "Avo.h"


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
    
    self.musicPlayerLogic = [MusicPlayerLogic new];
    [self.musicPlayerLogic loadCurrentTrack];
    [self showCurrentTrack];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
     [[AVOAppDelegate debugger] showBubbleDebugger];
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
    [[AVOAppDelegate debugger] showBubbleDebugger];
}

- (IBAction)showBar:(id)sender {
    [[AVOAppDelegate debugger] showBarDebugger];
}

- (IBAction)hideDebugger:(id)sender {
    [[AVOAppDelegate debugger] hideDebugger];
}
- (IBAction)playPause:(id)sender {
    if ([[self.playPauseButton currentTitle] isEqual:@"PLAY"]) {
        [self play];
        [Avo playWithCurrentSongName:[self.musicPlayerLogic currentTrackName]];
    } else {
        [self pause];
        [Avo pauseWithCurrentSongName:[self.musicPlayerLogic currentTrackName]];
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
    NSString * currentTrackBeforeSwitching = [self.musicPlayerLogic currentTrackName];
    NSString * upcomingTrackBeforeSwitching = [self.musicPlayerLogic nextTrackName];
    
    if ([self.musicPlayerLogic loadNextTrack]) {
        [self pause];
        [self showCurrentTrack];
        [Avo playNextTrackWithCurrentSongName:currentTrackBeforeSwitching upcomingTrackName:upcomingTrackBeforeSwitching];
    }
}

- (IBAction)prevTrack:(id)sender {
    NSString * currentTrackBeforeSwitching = [self.musicPlayerLogic currentTrackName];
    NSString * upcomingTrackBeforeSwitching = [self.musicPlayerLogic prevTrackName];
    
    if ([self.musicPlayerLogic loadPrevTrack]) {
        [self pause];
        [self showCurrentTrack];
        [Avo playPreviousTrackWithCurrentSongName:currentTrackBeforeSwitching upcomingTrackName:upcomingTrackBeforeSwitching];
    }
}


@end
