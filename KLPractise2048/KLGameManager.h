//
//  KLGameManager.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KLScene;
@class KLGrid;

typedef NS_ENUM(NSInteger, KLDirection) {
    KLDirectionUp,
    KLDirectionLeft,
    KLDirectionDown,
    KLDirectionRight
};

@interface KLGameManager : NSObject

- (void)startNewSessionWithScene:(KLScene *)scene;

- (void)moveToDirection:(KLDirection)direction;

@end
