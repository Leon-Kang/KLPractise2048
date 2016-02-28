//
//  KLGameManager.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLGameManager.h"
#import "KLGrid.h"
#import "KLTile.h"
#import "KLScene.h"
#import "KLViewController.h"
#import "KLGlobalState.h"

BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower) {
    return countUp ? value < upper : value > upper;
}

@implementation KLGameManager {
    BOOL _over;
    BOOL _won;
    BOOL _keepPlaying;
    
    NSInteger _score;
    NSInteger _pendingScore;
    
    KLGrid *_grid;
    CADisplayLink *_addTileDisplayLink;
}

#pragma mark - Setup

- (void)startNewSessionWithScene:(KLScene *)scene {
    if (_grid) {
        [_grid removeAllTilesAnimated:NO];
    }
    if (!_grid || _grid.dimension != GSTATE.dimension) {
        _grid = [[KLGrid alloc] initWithDimension:GSTATE.dimension];
        _grid.scene = scene;
    }
    [scene loadBoardWithGrid:_grid];
    
    _score = 0; _over = NO; _won = NO; _keepPlaying = NO;
    
    _addTileDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addTwoRandomTiles)];
    [_addTileDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)addTwoRandomTiles {
    if (_grid.scene.children.count <= 1) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_addTileDisplayLink invalidate];
    }
}

# pragma mark - Actions
- (void)moveToDirection:(KLDirection)direction {
    __block KLTile *tile = nil;
    
    BOOL reverse = direction == KLDirectionUp || direction == KLDirectionRight;
    NSInteger unit = reverse ? 1 : -1;
    
    if (direction == KLDirectionUp || direction == KLDirectionDown) {
        [_grid forEach:^(KLPosition position) {
            if ([_grid tileAtPosition:position]) {
                NSInteger target = position.x;
                
                for (NSInteger i = position.x + unit; iterate(i, reverse, _grid.dimension, -1); i+=unit) {
                    KLTile *t = [_grid tileAtPosition:KLPositionMake(i, position.y)];
                    
                    if (!t) {
                        target = i;
                    } else {
                        NSInteger level = 0;
                        if (GSTATE.gameType == KLGameTypePowerOf3) {
                            KLPosition further = KLPositionMake(i + unit, position.y);
                            KLTile *ft = [_grid tileAtPosition:further];
                            
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            } else {
                                level = [tile mergeToTile:t];
                            }
                            
                            if (level) {
                                target = position.x;
                                _pendingScore = [GSTATE valueForLevel:level];
                            }
                            
                            break;
                        }
                    }
                    
                    if (target != position.x) {
                        [tile moveToCell:[_grid cellAtPosition:KLPositionMake(target, position.y)]];
                        _pendingScore++;
                    }
                    
                }
            }
        } reverseOrder:reverse];
    } else {
        [_grid forEach:^(KLPosition position) {
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.y;
                for (NSInteger i = position.y + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    KLTile *t = [_grid tileAtPosition:KLPositionMake(position.x, i)];
                    
                    if (!t) target = i;
                    
                    else {
                        NSInteger level = 0;
                        
                        if (GSTATE.gameType == KLGameTypePowerOf3) {
                            KLPosition further = KLPositionMake(position.x, i + unit);
                            KLTile *ft = [_grid tileAtPosition:further];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.y;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        
                        break;
                    }
                }
                
                // The current tile is movable.
                if (target != position.y) {
                    [tile moveToCell:[_grid cellAtPosition:KLPositionMake(position.x, target)]];
                    _pendingScore++;
                }
            }
        } reverseOrder:reverse];
    }
    
    // Cannot move to the given direction. Abort.
    if (!_pendingScore) return;
    
    // Commit tile movements.
    [_grid forEach:^(KLPosition position) {
        KLTile *tile = [_grid tileAtPosition:position];
        if (tile) {
            [tile commitPendingActions];
            if (tile.level >= GSTATE.winningLevel) _won = YES;
        }
    } reverseOrder:reverse];
    
    // Increment score.
    [self materializePendingScore];
    
    // Check post-move status.
    if (!_keepPlaying && _won) {
        // We set `keepPlaying` to YES. If the user decides not to keep playing,
        // we will be starting a new game, so the current state is no longer relevant.
        _keepPlaying = YES;
        [_grid.scene.controller endGame:YES];
    }
    
    // Add one more tile to the grid.
    [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    if (GSTATE.dimension == 5 && GSTATE.gameType == KLGameTypePowerOf3)
        [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    
    if (![self movesAvailable]) {
        [_grid.scene.controller endGame:NO];
    }

}

# pragma mark - Score
- (void)materializePendingScore {
    _score += _pendingScore;
    _pendingScore = 0;
    [_grid.scene.controller updateScore:_score];
}

# pragma mark - State checkers
- (BOOL)movesAvailable
{
    return [_grid hasAvailableCells] || [self adjacentMatchesAvailable];
}

- (BOOL)adjacentMatchesAvailable {
    for (NSInteger i = 0; i < _grid.dimension; i++) {
        for (NSInteger j = 0; j < _grid.dimension; j++) {
            KLTile *tile = [_grid tileAtPosition:KLPositionMake(i, j)];
            
            if (!tile) {
                continue;
            }
            
            if (GSTATE.gameType == KLGameTypePowerOf3) {
                if (([tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i + 1, j)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i + 2, j)]]) ||
                    ([tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i, j + 1)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i, j + 2)]])) {
                        return YES;
                    }
            } else {
                if ([tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i + 1, j)]] ||
                    [tile canMergeWithTile:[_grid tileAtPosition:KLPositionMake(i, j + 1)]]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}



@end

