//
//  KLViewController.m
//  KLPractise2048
//
//  Created by 康梁 on 16/1/28.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLViewController.h"
#import "KLScoreView.h"

@interface KLViewController ()

@property (weak, nonatomic) IBOutlet KLScoreView *bestView;
@property (weak, nonatomic) IBOutlet KLScoreView *scoreView;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;

@property (weak, nonatomic) IBOutlet UIImageView *overlayBackground;

@end

@implementation KLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




@end
