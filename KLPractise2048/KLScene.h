//
//  KLScene.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class KLViewController;
@class KLGrid;

@interface KLScene : SKScene

@property (nonatomic, weak) KLViewController *controller;

- (void)startNewGame;

- (void)loadBoardWithGrid:(KLGrid *)grid;

@end
