//
//  NavigationViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "NavigationViewController.h"
static NSString *simpleTableIdentifier = @"TableCell";

@interface NavigationViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSArray *_navigationArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationArray = @[@"Speakers", @"Schedule", @"Venue", @"Organizers", @"My Bookmarks"];
     // Small UI Improvments
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(21, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_navigationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell %@ selected",[_navigationArray objectAtIndex:indexPath.row]);
}

@end
