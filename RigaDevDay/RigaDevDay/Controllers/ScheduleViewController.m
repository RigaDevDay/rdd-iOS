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
#import "DataManager.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *firstHallSchedule;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    firstHallSchedule = [[DataManager sharedInstance] getScheduleForHall:1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [firstHallSchedule count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventObject *event = firstHallSchedule[indexPath.row];
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.labelPresentationDescription.text = event.eventDescription;
    cell.labelPresentationSubTitle.text = event.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
}

@end
