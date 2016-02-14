//
//  KLSettingViewController.m
//  KLPractise2048
//
//  Created by 康梁 on 16/2/13.
//  Copyright © 2016年 LeonKang. All rights reserved.
//

#import "KLSettingViewController.h"
#import "KLSettingDetailViewController.h"
#import "KLGlobalState.h"

@interface KLSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *options;
@property (nonatomic, copy) NSArray *optionSelections;
@property (nonatomic, copy) NSArray *optionNotes;

@end

@implementation KLSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.options = @[@"Game Type", @"Board Size", @"Theme"];
    
    self.optionSelections = @[@[@"Powers of 2", @"Powers of 3", @"Fibonacci"],
                          @[@"3 x 3", @"4 x 4", @"5 x 5"],
                          @[@"Default", @"Vibrant", @"Joyful"]];
    
    self.optionNotes = @[@"For Fibonacci games, a tile can be joined with a tile that is one level above or below it, but not to one equal to it. For Powers of 3, you need 3 consecutive tiles to be the same to trigger a merge!",
                      @"The smaller the board is, the harder! For 5 x 5 board, two tiles will be added every round if you are playing Powers of 2.",
                      @"Choose your favorite appearance and get your own feeling of 2048! More (and higher quality) themes are in the works so check back regularly!"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Settings Detail Segue"]) {
        KLSettingDetailViewController *sdvc = segue.destinationViewController;
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        sdvc.title = [self.options objectAtIndex:index];
        sdvc.options = [self.optionSelections objectAtIndex:index];
        sdvc.footer = [self.optionNotes objectAtIndex:index];
    }
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 1 : self.options.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section) {
        return @"";
    }
    return @"Please note: Changing the settings above would restart the game.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Settings Cell"];
    if (indexPath.section) {
        cell.textLabel.text = @"About 2048";
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
        
        NSInteger index = [Settings integerForKey:[self.options objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [[_optionSelections objectAtIndex:indexPath.row] objectAtIndex:index];
        cell.detailTextLabel.textColor = [GSTATE scoreBoardColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        [self performSegueWithIdentifier:@"About Segue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"Settings Detail Segue" sender:nil];
    }
}

@end
