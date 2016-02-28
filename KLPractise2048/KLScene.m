//
//  KLScene.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLScene.h"
#import "KLGameManager.h"
#import "KLGridView.h"

#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation KLScene {
    KLGameManager *_manager;
    BOOL _hasPendingSwipe;
    SKSpriteNode *_board;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _manager = [[KLGameManager alloc] init];
    }
    return self;
}

- (void)startNewGame {
    [_manager startNewSessionWithScene:self];
}

- (void)loadBoardWithGrid:(KLGrid *)grid {
    if (_board) {
        [_board removeFromParent];
    }
    UIImage *image = [KLGridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    _board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [_board setScale:1 / [UIScreen mainScreen].scale];
    _board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_board];
}

#pragma mark - Swipe handing

- (void)didMoveToView:(SKView *)view {
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    } else {
        for (UIPanGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    } else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation {
    if ( !_hasPendingSwipe ) return;
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) {
        return;
    }
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.x < 0 ? [_manager moveToDirection:KLDirectionLeft] :
        [_manager moveToDirection:KLDirectionRight];
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.y < 0 ? [_manager moveToDirection:KLDirectionUp] :
        [_manager moveToDirection:KLDirectionDown];
    }
    
    _hasPendingSwipe = NO;
}

@end
