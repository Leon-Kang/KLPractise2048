//
//  KLGlobalState.h
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLPosition.h"

#define GSTATE [KLGlobalState state]
#define Settings [NSUserDefaults standardUserDefaults]
#define NotifCtr [NSNotificationCenter defaultCenter]

typedef NS_ENUM(NSInteger, KLGameType) {
    KLGameTypeFibonacci = 2,
    KLGameTypePowerOf2 = 0,
    KLGameTypePowerOf3 = 1
};

@interface KLGlobalState : NSObject

@property (nonatomic, readonly) NSInteger dimension;
@property (nonatomic, readonly) NSInteger winningLevel;

@property (nonatomic, readonly) NSInteger titleSize;
@property (nonatomic, readonly) NSInteger borderWidth;
@property (nonatomic, readonly) NSInteger cornerRadius;

@property (nonatomic, readonly) NSInteger horizontalOffset;
@property (nonatomic, readonly) NSInteger verticalOffset;

@property (nonatomic, readonly) NSTimeInterval animationDuration;
@property (nonatomic, readonly) KLGameType gameType;

@property (nonatomic) BOOL needRefresh;

// 单例方法
+ (KLGlobalState *)state;

- (void)loadGlobalState;

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2;

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2;

- (NSInteger)valueForLevel:(NSInteger)level;

- (UIColor *)colorForLevel:(NSInteger)level;


- (UIColor *)textColorForLevel:(NSInteger)level;

- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regularFontName;


- (CGFloat)textSizeForValue:(NSInteger)value;

- (CGPoint)locationOfPosition:(KLPosition)klPosition;

- (CGFloat)xLocationOfPosition:(KLPosition)klPosition;

- (CGFloat)yLocationOfPosition:(KLPosition)klPosition;



@end















