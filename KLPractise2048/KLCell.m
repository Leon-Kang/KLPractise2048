//
//  KLCell.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLCell.h"

@implementation KLCell

- (instancetype)initWithPosition:(KLPosition)position {
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}


- (void)setTile:(KLTile *)tiles {
    _tile = tiles;
    if (tiles) {
        tiles.cell = self;
    }
}

@end
