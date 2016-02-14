//
//  KLTile.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class KLCell;

@interface KLTile : SKShapeNode

@property (nonatomic) NSInteger level;

@property (nonatomic, weak) KLCell *cell;


+ (KLTile *)insertNewTileToCell:(KLCell *)cell;

- (void)commitPendingActions;

- (BOOL)canMergeWithTile:(KLTile *)tile;

- (NSInteger)mergeToTile:(KLTile *)tile;

- (NSInteger)merge3ToTile:(KLTile *)tile andTile:(KLTile *)furtherTile;

- (void)moveToCell:(KLCell *)cell;

- (void)removeAnimated:(BOOL)animated;


@end
