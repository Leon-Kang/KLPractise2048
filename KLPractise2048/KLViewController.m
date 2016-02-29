//
//  KLViewController.m
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLViewController.h"
#import "KLScoreView.h"
#import "KLOverlay.h"
#import "KLScene.h"
#import "KLGridView.h"

@interface KLViewController ()

@property (weak, nonatomic) IBOutlet KLScoreView *bestView;
@property (weak, nonatomic) IBOutlet KLScoreView *scoreView;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;

@property (weak, nonatomic) IBOutlet UIImageView *overlayBackground;
@property (weak, nonatomic) IBOutlet KLOverlay *overlay;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *targetScore;

@property (nonatomic, strong) KLScene *scene;

@end

@implementation KLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
    
    _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
    _restartButton.layer.masksToBounds = YES;
    
    _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
    _settingsButton.layer.masksToBounds = YES;
    
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    KLScene * scene = [KLScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.controller = self;
}

- (void)updateState {
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    _restartButton.backgroundColor = [GSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _settingsButton.backgroundColor = [GSTATE buttonColor];
    _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winningLevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    } else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    } else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat:@"%ld", target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!", target];
    
    _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
    _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
}

- (void)updateScore:(NSInteger)score {
    self.scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    if ([Settings integerForKey:@"Best Score"] < score) {
        [Settings setInteger:score forKey:@"Best Score"];
        self.bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((SKView *)self.view).paused = YES;
}

- (IBAction)restart:(id)sender {
    [self hideOverlay];
    [self updateScore:0];
    [_scene startNewGame];
}

- (IBAction)keepPlaying:(id)sender {
    [self hideOverlay];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    ((SKView *)self.view).paused = NO;
    if (GSTATE.needRefresh) {
        [GSTATE loadGlobalState];
        [self updateState];
        [self updateScore:0];
        [_scene startNewGame];
    }
}

- (void)endGame:(BOOL)won {
    self.overlay.hidden = NO;
    self.overlay.alpha = 0;
    self.overlayBackground.hidden = NO;
    self.overlayBackground.alpha = 0;
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        _overlay.message.text = @"Game Over";
    } else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"You Win!";
    }
    
    // Fake the overlay background as a mask on the board.
    _overlayBackground.image = [KLGridView gridImageWithOverlay];
    
    // Center the overlay in the board.
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
    
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        _overlayBackground.alpha = 1;
    } completion:^(BOOL finished) {
        // Freeze the current game.
        ((SKView *)self.view).paused = YES;
    }];
}

- (void)hideOverlay {
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished) {
            _overlayBackground.hidden = YES;
            _overlay.hidden = YES;
        }];
    }
}

@end
