//
//  KLPosition.h
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//
#ifndef KLPractise2048_KLPosition_h
#define KLPractise2048_KLPosition_h

#import <CoreGraphics/CoreGraphics.h>

typedef struct Position {
    NSInteger x;
    NSInteger y;
} KLPosition;

CG_INLINE KLPosition KLPositionMake(NSInteger x, NSInteger y) {
    KLPosition position;
    position.x = x;
    position.y = y;
    
    return position;
}

#endif /* KLPosition_h */
