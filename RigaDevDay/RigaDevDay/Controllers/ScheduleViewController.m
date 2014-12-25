//
//  ScheduleViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SWRevealViewController.h"
#import "ScheduleTableViewCell.h"
#import "GlobalMetupTableViewCell.h"
#import "DataManager.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate,UITabBarDelegate> {
    NSArray *_currentHallSchedule;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentHallSchedule count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventObject *event = _currentHallSchedule[indexPath.row];
    if (![event.subTitle isEqualToString:@""]) {
        ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
        cell.labelPresentationSubTitle.text = event.subTitle;
        cell.labelPresentationDescription.text = event.eventDescription;
        cell.labelStartTime.text = event.startTime;
        
        return cell;

    } else {
        GlobalMetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GlobalMetupCell"];
        cell.labelPresentationName.text = event.eventDescription;
        cell.labelStartTime.text = event.startTime;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ScheduleTableViewCell class]]) {
        [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:item.tag];
    [self.tableView reloadData];
}

@end
