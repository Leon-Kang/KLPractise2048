//
//  KLTile.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#include <stdlib.h>
#import "KLTile.h"
#import "KLCell.h"
#import "KLGlobalState.h"

typedef void (^KLBlock)();

@interface KLTile ()

@property (nonatomic, strong) SKLabelNode *value;

@property (nonatomic, copy) NSMutableArray *pendingActions;

@property (nonatomic, assign) KLBlock pendingBlock;

@end

@implementation KLTile

+ (KLTile *)insertNewTileToCell:(KLCell *)cell {
    KLTile *tile = [[KLTile alloc] init];
    
    CGPoint origin = [GSTATE locationOfPosition:cell.position];
    tile.position = CGPointMake(origin.x + GSTATE.tileSize / 2, origin.y + GSTATE.tileSize / 2);
    [tile setScale:0];
    
    cell.tile = tile;
    
    return tile;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        CGRect rect = CGRectMake(0, 0, GSTATE.tileSize, GSTATE.tileSize);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        self.pendingActions = [[NSMutableArray alloc] init];
        
        self.value = [SKLabelNode labelNodeWithFontNamed:[GSTATE boldFontName]];
        self.value.position = CGPointMake(GSTATE.tileSize / 2, GSTATE.tileSize / 2);
        self.value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.value];
        
        if (GSTATE.gameType == KLGameTypeFibonacci) self.level = arc4random_uniform(100) < 40 ? 1 : 2;
        else self.level = arc4random_uniform(100) < 95 ? 1 : 2;
        
        [self refreshValue];
        
        
    }
    return self;
}


- (void)removeFromParentCell {
    if (self.cell.tile == self) {
        self.cell.tile = nil;
    }
}

- (BOOL)hasPendingMerge {
    return self.pendingActions.count > 1;
}

- (void)commitPendingActions {
    [self runAction:[SKAction sequence:self.pendingActions] completion:^{
        [self.pendingActions removeAllObjects];
        if (self.pendingActions) {
            self.pendingBlock();
            self.pendingBlock = nil;
        }
    }];
}

- (BOOL)canMergeWithTile:(KLTile *)tile {
    if (!tile) {
        return NO;
    }
    return [GSTATE isLevel:self.level mergeableWithLevel:tile.level];
}

- (NSInteger)mergeToTile:(KLTile *)tile {
    if (!tile || [tile hasPendingMerge]) {
        return 0;
    }
    
    NSInteger newLevel = [GSTATE mergeLevel:self.level withLevel:tile.level];
    if (newLevel > 0) {
        [self moveToCell:tile.cell];
        [tile removeWithDelay];
        [self updateLevelTo:newLevel];
        
        [self.pendingActions addObject:[self pop]];
    }
    
    return newLevel;
}

- (NSInteger)merge3ToTile:(KLTile *)tile andTile:(KLTile *)furtherTile {
    if (!tile || [tile hasPendingMerge] || [furtherTile hasPendingMerge]) {
        return 0;
    }
    
    NSUInteger newLevel = MIN([GSTATE mergeLevel:self.level withLevel:tile.level],
                              [GSTATE mergeLevel:tile.level withLevel:furtherTile.level]);
    if (newLevel > 0) {
        // 1. Move self to the destination cell AND move the intermediate tile to there too.
        [tile moveToCell:furtherTile.cell];
        [self moveToCell:furtherTile.cell];
        
        // 2. Remove the tile in the destination cell.
        [tile removeWithDelay];
        [furtherTile removeWithDelay];
        
        // 3. Update value and pop.
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}

- (void)updateLevelTo:(NSInteger)level {
    self.level = level;
    [self.pendingActions addObject:[SKAction runBlock:^{
        [self refreshValue];
    }]];
}

- (void)refreshValue {
    long value = [GSTATE valueForLevel:self.level];
    self.value.text = [NSString stringWithFormat:@"%ld", value];
    self.value.fontColor = [GSTATE textColorForLevel:self.level];
    self.value.fontSize = [GSTATE textSizeForValue:self.level];
    self.fillColor = [GSTATE colorForLevel:self.level];
    
}

- (void)moveToCell:(KLCell *)cell {
    [_pendingActions addObject:[SKAction moveTo:[GSTATE locationOfPosition:cell.position] duration:GSTATE.animationDuration]];
    self.cell.tile = nil;
    cell.tile = self;
}

- (void)removeAnimated:(BOOL)animated {
    if (animated) {
        [self.pendingActions addObject:[SKAction scaleTo:0 duration:GSTATE.animationDuration]];
        [self.pendingActions addObject:[SKAction removeFromParent]];
        
        __weak typeof(self) weakSelf = self;
        
        self.pendingBlock = ^{
            [weakSelf removeFromParent];
        };
    }
    [self commitPendingActions];
}

- (void)removeWithDelay {
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
    SKAction *remove = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[wait, remove]] completion:^{
        [self removeFromParentCell];
    }];
}

- (SKAction *)pop {
    CGFloat d = 0.15 * GSTATE.tileSize;
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration / 3];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:GSTATE.animationDuration / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:GSTATE.animationDuration / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:GSTATE.animationDuration / 1.5];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:GSTATE.animationDuration / 1.5];
    
    return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]],
                               [SKAction group:@[restore, moveBack]]]];
}

@end
