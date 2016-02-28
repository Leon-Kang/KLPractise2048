//
//  KLGrid.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCell.h"
@class KLScene;

typedef void (^IteratorBlock)(KLPosition);

@interface KLGrid : NSObject

@property (nonatomic, readonly) NSInteger dimension;

@property (nonatomic, weak) KLScene *scene;


/**
 * Initializes a new grid with the given dimension.
 *
 * @param dimension The desired dimension, i.e. # cells in a row or column.
 */
- (instancetype)initWithDimension:(NSInteger)dimension;


/**
 * Iterates over the grid and calls the block, which takes in the M2Position
 * of the current cell. Has the option to iterate in the reverse order.
 *
 * @param block The block to be applied to each cell position.
 * @param reverse If YES, iterate in the reverse order.
 */
- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse;


/**
 * Returns the cell at the specified position.
 *
 * @param position The position we are interested in.
 * @return The cell at the position. If position out of bound, returns nil.
 */
- (KLCell *)cellAtPosition:(KLPosition)position;


/**
 * Returns the tile at the specified position.
 *
 * @param position The position we are interested in.
 * @return The tile at the position. If position out of bound or cell empty, returns nil.
 */
- (KLTile *)tileAtPosition:(KLPosition)position;


/**
 * Whether there are any available cells in the grid.
 *
 * @return YES if there are at least one cell available.
 */
- (BOOL)hasAvailableCells;


/**
 * Inserts a new tile at a randomly chosen position that's available.
 *
 * @param delay If YES, adds twice `animationDuration` long delay before the insertion.
 */
- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay;


/**
 * Removes all tiles in the grid from the scene.
 *
 * @param animated If YES, animate the removal.
 */
- (void)removeAllTilesAnimated:(BOOL)animated;

@end
