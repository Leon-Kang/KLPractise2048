//
//  KLGrid.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//
#include "stdlib.h"

#import "KLGrid.h"
#import "KLTile.h"
#import "KLScene.h"
#import "KLGlobalState.h"

@interface KLGrid ()

@property (nonatomic, readwrite) NSInteger dimension;

@end

@implementation KLGrid {
    NSMutableArray *_grid;
}

- (instancetype)initWithDimension:(NSInteger)dimension {
    if (self = [super init]) {
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [arr addObject:[[KLCell alloc] initWithPosition:KLPositionMake(i, j)]];
            }
            [_grid addObject:arr];
        }
        self.dimension = dimension;
    }
    return self;
}

#pragma mark - Iterator
- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse {
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++) {
            for (NSInteger j = 0; j < self.dimension; j++) {
                block(KLPositionMake(i, j));
            }
        }
    } else {
        for (NSInteger i = self.dimension - 1; i >= 0; i--) {
            for (NSInteger j = self.dimension; j>=0; j--) {
                block(KLPositionMake(i, j));
            }
        }
    }
}

#pragma mark - Position helpers
- (KLCell *)cellAtPosition:(KLPosition)position {
    if (position.x >= self.dimension || position.y >= self.dimension ||
        position.x < 0 || position.y < 0) return nil;
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}

- (KLTile *)tileAtPosition:(KLPosition)position {
    KLCell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

#pragma mark - Cell availability
- (BOOL)hasAvailableCells {
    return [self availableCells].count != 0;
}

- (KLCell *)randomAvailableCell {
    NSArray *availableArray = [self availableCells];
    if (availableArray.count) {
        return [availableArray objectAtIndex:arc4random_uniform((int)availableArray.count)];
    }
    return nil;
}

- (NSArray *)availableCells  {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
    [self forEach:^(KLPosition position) {
        KLCell *cell = [self cellAtPosition:position];
        if (!cell.tile) {
            [array addObject:cell];
        }
    } reverseOrder:NO];
    return array;
}

#pragma mark - Cell manipulation
- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay {
    KLCell *cell = [self randomAvailableCell];
    if (cell) {
        KLTile *tile = [KLTile insertNewTileToCell:cell];
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] :
        [SKAction waitForDuration:0];
        SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.tileSize / 2, - GSTATE.tileSize / 2)
                                 duration:GSTATE.animationDuration];
        SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
        [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move, scale]]]]];
    }
    
}

- (void)removeAllTilesAnimated:(BOOL)animated {
    [self forEach:^(KLPosition position) {
        KLTile *tile = [self tileAtPosition:position];
        if (tile) {
            [tile removeAnimated:animated];
        }
    } reverseOrder:NO];
}


@end
