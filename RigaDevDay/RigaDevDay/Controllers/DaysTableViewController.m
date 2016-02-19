//
//  DaysTableViewController.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/19/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "DaysTableViewController.h"
#import "DataManager.h"

@interface DaysTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *iboTableView;
@property (nonatomic,strong) NSArray *pDays;
@end

@implementation DaysTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pDays = [[DataManager sharedInstance] allDays];
    [self.iboTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pDays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Day *day = self.pDays[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    cell.textLabel.text = day.title;
    
    Day *selectedDay = [[DataManager sharedInstance] selectedDay];
    if ([selectedDay isEqual:day]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}
- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(daysTableVC:didSelectDay:)]) {
        Day *day = self.pDays[indexPath.row];
        [self.delegate daysTableVC:self didSelectDay:day];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
