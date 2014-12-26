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
#import "SpeakerInfoViewController.h"
#import "DataManager.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, ScheduleTableViewCellDelegate> {
    NSArray *_currentHallSchedule;
    EventObject *_selectedEventObject;
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
    
    self.tabBarController.selectedImageTintColor = [UIColor whiteColor];
    [self.tabBarController setSelectedItem:[self.tabBarController.items firstObject]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
        cell.labelSpeakerName.text = [self getSpeakerStringFromArray:event.speakers];
        cell.labelPresentationSubTitle.text = event.subTitle;
        cell.labelPresentationDescription.text = event.eventDescription;
        cell.labelStartTime.text = event.startTime;
        SpeakerObject *speaker = [event.speakers firstObject];
        if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.id]) {
            [cell.buttonBookmark setImage:[[DataManager sharedInstance] getActiveBookmarkImage] forState:UIControlStateNormal];
        } else {
            [cell.buttonBookmark setImage:[[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO] forState:UIControlStateNormal];
        }
        
        cell.delegate = self;
        
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
        _selectedEventObject = _currentHallSchedule[indexPath.row];
        [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:item.tag];
    [self.tableView reloadData];
}

- (NSString *)getSpeakerStringFromArray:(NSArray *)speakersArray {
    NSString *returnString = @"";
    for (SpeakerObject *speaker in speakersArray) {
       returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
    }
    return [returnString substringToIndex:[returnString length] - 2];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.speaker = [_selectedEventObject.speakers firstObject];
}

- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
    EventObject *event = [_currentHallSchedule objectAtIndex:[self.tableView indexPathForCell:cell].row];
    SpeakerObject *speaker = [event.speakers firstObject];
    
    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.id];
    [cell.buttonBookmark setImage:isBookmarked ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO] : [[DataManager sharedInstance] getActiveBookmarkImage] forState:UIControlStateNormal];
    
    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:speaker.id];
}

@end
