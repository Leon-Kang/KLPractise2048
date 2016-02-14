//
//  KLScoreView.h
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLGlobalState.h"

@interface KLScoreView : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *score;

- (void)updateAppearance;

@end
