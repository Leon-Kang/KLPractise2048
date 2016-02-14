//
//  KLGridView.h
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLGrid;

@interface KLGridView : UIView

+ (UIImage *)gridImageWithGrid:(KLGrid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
