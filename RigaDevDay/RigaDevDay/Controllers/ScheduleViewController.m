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
#import "EventViewController.h"
#import "DataManager.h"
#import "Event.h"
#import "DaysTableViewController.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, ScheduleTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iboTableView;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iboTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.iboTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = self.events[indexPath.row];
    if (event.room == nil && !event.speakers.count) {
        GlobalMetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GlobalMetupCell"];
        cell.labelPresentationName.text = (event.title.length) ? event.title : (event.subtitle.length) ? event.subtitle : @"Event";
        cell.labelStartTime.text = event.interval.startTime;
        return cell;
    } else {
        ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
        cell.labelSpeakerName.text = [[DataManager sharedInstance] speakerStringFromSpeakers:[event speakers]];
        cell.labelPresentationSubTitle.text = event.subtitle;
        cell.labelPresentationDescription.text = event.eventDesc;
        cell.labelStartTime.text = event.interval.startTime;
        [cell.buttonImageView setImage:[event.isFavorite boolValue] ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
        [cell setEventTagNames:[[DataManager sharedInstance] tagNamesForEvent:event]];
        cell.delegate = self;
        
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = self.events[indexPath.row];
    if (event.room == nil && !event.speakers.count) {
        return 50.0f;
    } else {
        return 80.0f;
    }
}

#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ScheduleTableViewCell class]]) {
        self.pageVC.selectedEvent = self.events[indexPath.row];
        [self.pageVC performSegueWithIdentifier:@"EventSegue" sender:nil];
    }
}

#pragma mark - ScheduleTableViewCellDelegate methods

- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
    Event *event = [self.events objectAtIndex:[self.iboTableView indexPathForCell:cell].row];
    if (event) {
        BOOL isFavorite = [[DataManager sharedInstance] changeFavoriteStatusForEvent:event];
        [cell.buttonImageView setImage:isFavorite ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
    }
}

@end
