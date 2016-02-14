//
//  KLCell.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLPosition.h"
#import "KLTile.h"

@interface KLCell : NSObject

@property (nonatomic) KLPosition position;

@property (nonatomic, strong) KLTile *tile;

- (instancetype)initWithPosition:(KLPosition)position;

@end
