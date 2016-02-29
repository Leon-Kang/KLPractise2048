//
//  KLGridView.m
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLGridView.h"
#import "KLGlobalState.h"
#import "KLGrid.h"

@implementation KLGridView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GSTATE scoreBoardColor];
        self.layer.cornerRadius = GSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init {
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(GSTATE.horizontalOffset, verticalOffset - side, side, side)];
}


+ (UIImage *)gridImageWithGrid:(KLGrid *)grid {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = GSTATE.backgroundColor;
    
    KLGridView *view = [[KLGridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(KLPosition position) {
        CALayer *layer = [CALayer layer];
        CGPoint point = [GSTATE locationOfPosition:position];
        
        CGRect frame = layer.frame;
        frame.size = CGSizeMake(GSTATE.tileSize, GSTATE.tileSize);
        frame.origin = CGPointMake(point.x, [[UIScreen mainScreen] bounds].size.height - point.y - GSTATE.tileSize);
        layer.frame = frame;
        
        layer.backgroundColor = [GSTATE boardColor].CGColor;
        layer.cornerRadius = [GSTATE cornerRadius];
        
    } reverseOrder:NO];
    
    return [KLGridView snapshotWithView:backgroundView];
}

+ (UIImage *)gridImageWithOverlay {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    KLGridView *view = [[KLGridView alloc] init];
    view.backgroundColor = [[GSTATE backgroundColor] colorWithAlphaComponent:0.8];
    [backgroundView addSubview:view];
    
    return [KLGridView snapshotWithView:backgroundView];
}

+ (UIImage *)snapshotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    return image;
}


@end
