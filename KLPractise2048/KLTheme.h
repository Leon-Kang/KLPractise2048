//
//  KLTheme.h
//  KLPractise2048
//
//  Created by 康梁 on 16/2/1.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KLTheme <NSObject>

+ (UIColor *)boardColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)scoreBoardColor;

+ (UIColor *)buttonColor;

+ (NSString *)boldFontName;

+ (NSString *)regularFontName;


+ (UIColor *)colorForLevel:(NSInteger)level;

+ (UIColor *)textColorForLevel:(NSInteger)level;

@end



@interface KLTheme : NSObject


+ (Class)themeClassForType:(NSInteger)type;


@end
