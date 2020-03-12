//
//  BarDebuggerView.m
//  IosAnalyticsDebugger
//
//  Copyright © 2019. All rights reserved.
//

#import "BarDebuggerView.h"
#import "DebuggerEventItem.h"
#import "Util.h"

@interface BarDebuggerView ()

@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dragHandle;
@property (weak, nonatomic) IBOutlet UIView *background;

@end

@implementation BarDebuggerView

-(instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self loadViewFromNib];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadViewFromNib];
    }
    
    return self;
}

-(void)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UINib *nib = [UINib nibWithNibName:@"BarDebugger" bundle:bundle];
    NSArray *views = [nib instantiateWithOwner:self options:nil];
    UIView *view = [views objectAtIndex:0];
    view.frame = self.bounds;
    [self addSubview:view];
}

- (void) showEvent:(DebuggerEventItem *)event {
    self.eventNameLabel.text = event.name;
    self.eventTimeLabel.text = [Util timeString:event.timestamp];

    if ([Util eventHaveErrors:event]) {
        [self setError:YES];
    }
}

- (void) onClick {
    [self setError:NO];
}

- (void) setError:(BOOL) hasError {
    NSBundle *selfBundle = [NSBundle bundleForClass:self.class];
    if (hasError) {
        [self.statusIcon setImage:[UIImage imageNamed:@"white_warning" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.dragHandle setImage:[UIImage imageNamed:@"drag_handle" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.background setBackgroundColor:[UIColor colorWithRed:0.851 green:0.271 blue:0.325 alpha:1]];
         //[UIColor colorNamed:@"error_color" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.eventTimeLabel setTextColor:[UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1]];
            //    colorNamed:@"light_grey_text_color" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.eventNameLabel setTextColor:[UIColor whiteColor]];
    } else {
        [self.statusIcon setImage:[UIImage imageNamed:@"tick" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.dragHandle setImage:[UIImage imageNamed:@"drag_handle_grey" inBundle:selfBundle compatibleWithTraitCollection:nil]];
        [self.background setBackgroundColor:[UIColor whiteColor]];
        [self.eventTimeLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self.eventNameLabel setTextColor:[UIColor blackColor]];
    }
}

@end
