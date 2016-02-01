//
//  KLGlobalState.m
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLGlobalState.h"
#import "KLTheme.h"

#define kGameType  @"Game Type"
#define kTheme     @"Theme"
#define kBoardSize @"Board Size"
#define kBestScore @"Best Score"


@interface KLGlobalState ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, readwrite) NSInteger winningLevel;
@property (nonatomic, readwrite) NSInteger tileSize;
@property (nonatomic, readwrite) NSInteger borderWidth;
@property (nonatomic, readwrite) NSInteger cornerRadius;
@property (nonatomic, readwrite) NSInteger horizontalOffset;
@property (nonatomic, readwrite) NSInteger verticalOffset;
@property (nonatomic, readwrite) NSTimeInterval animationDuration;
@property (nonatomic, readwrite) KLGameType gameType;

@property (nonatomic) NSInteger theme;


@end


@implementation KLGlobalState


+ (KLGlobalState *)state {
    static KLGlobalState *state = nil;
    
    static dispatch_once_t once;
    // dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的，这就意味着你不需要使用诸如@synchronized之类的来防止使用多个线程或者队列时不同步的问题。
    dispatch_once (&once, ^{
        state = [[KLGlobalState alloc] init];
    });
    
    return state;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefaultState];
        [self loadGlobalState];
    }
    return self;
}

- (void)setupDefaultState {
    NSDictionary *defautValue = @{kGameType: @0, kTheme: @0, kBoardSize: @1, kBestScore: @0};
    [Settings registerDefaults:defautValue];
}

- (void)loadGlobalState {
    self.dimension = [Settings integerForKey:kBoardSize] + 3;
    self.borderWidth = 5;
    self.cornerRadius = 4;
    self.animationDuration = 0.1;
    self.gameType = [Settings integerForKey:kGameType];
    self.horizontalOffset = [self horizontalOffset];
    self.verticalOffset = [self verticalOffset];
    self.theme = [Settings integerForKey:kTheme];
    self.needRefresh = NO;
}

- (NSInteger)titleSize {
    return self.dimension <= 4 ? 66 : 56;
}

- (NSInteger)horizontalOffset {
    CGFloat width = self.dimension * (self.titleSize + self.borderWidth) + self.borderWidth;
    return ([UIScreen mainScreen].bounds.size.width - width) / 2;
}

- (NSInteger)verticalOffset {
    CGFloat height = self.dimension * (self.tileSize + self.borderWidth) + self.borderWidth + 120;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}


- (NSInteger)winningLevel {
    if (GSTATE.gameType == KLGameTypePowerOf3) {
        switch (self.dimension) {
            // 因为返回的是return，所以不需要break
            case 3:
                return 4;
            case 4:
                return 5;
            case 5:
                return 6;
                
            default:
                return 5;
        }
    }
    
    NSInteger level = 11;
    if (self.dimension == 3) {
        return level - 1;
    }
    if (self.dimension == 5) {
        return level + 2;
    }
    
    return level;
}

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2 {
    if (self.gameType == KLGameTypeFibonacci) {
        return labs((level1 - level2)) == 1;
    }
    return level1 == level2;
}

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2 {
    if (![self isLevel:level1 mergeableWithLevel:level2]) {
        return 0;
    }
    if (self.gameType == KLGameTypeFibonacci) {
        return (level1 + 1 == level2) ? level2 + 1 : level1 + 1;
    }
    return level1 + 1;
}

- (NSInteger)valueForLevel:(NSInteger)level {
    if (self.gameType == KLGameTypeFibonacci) {
        NSInteger a = 1, b = 1;
        for (NSInteger i = 0; i < level; i++) {
            NSInteger c = a + b;
            a = b;
            b = c;
        }
        return b;
    } else {
        NSInteger value = 1;
        NSInteger base = self.gameType == KLGameTypePowerOf2 ? 2 : 3;
        for (NSInteger i = 0; i < level; i++) {
            value *= base;
        }
        return value;
    }
}


#pragma mark ---Appearance
- (UIColor *)colorForLevel:(NSInteger)level {
    return [[KLTheme themeClassForType:self.theme] colorForLevel:level];
}

- (UIColor *)textColorForLevel:(NSInteger)level {
    return [[KLTheme themeClassForType:self.theme] textColorForLevel:level];
}

- (UIColor *)backgroundColor {
    return [[KLTheme themeClassForType:self.theme] backgroundColor];
}

- (UIColor *)boardColor {
    return [[KLTheme themeClassForType:self.theme] scoreBoardColor];
}

- (UIColor *)scoreBoardColor {
    return [[KLTheme themeClassForType:self.theme] scoreBoardColor];
}

- (UIColor *)buttonColor {
    return [[KLTheme themeClassForType:self.theme] buttonColor];
}

- (NSString *)boldFontName {
    return [[KLTheme themeClassForType:self.theme] boldFontName];
}

- (NSString *)regularFontName {
    return [[KLTheme themeClassForType:self.theme] regularFontName];
}


- (CGFloat)textSizeForValue:(NSInteger)value {
    NSInteger offset = self.dimension == 5 ? 2 : 0;
    if (value < 100) {
        return 32 - offset;
    } else if (value < 1000) {
        return 28 - offset;
    } else if (value < 10000) {
        return 24 - offset;
    } else if (value < 100000) {
        return 20 - offset;
    } else if (value < 1000000) {
        return 16 - offset;
    } else {
        return 13 - offset;
    }
}

- (CGPoint)locationOfPosition:(KLPosition)position {
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset,
                       [self yLocationOfPosition:position] + self.verticalOffset);
}

- (CGFloat)xLocationOfPosition:(KLPosition)position {
    return position.y * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

- (CGFloat)yLocationOfPosition:(KLPosition)position {
    return position.x * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}



@end
