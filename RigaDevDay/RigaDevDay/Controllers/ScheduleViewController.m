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
#import "Event.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, ScheduleTableViewCellDelegate>
@property (nonatomic, strong) NSArray *pEvents;
@property (nonatomic, strong) Event *pSelectedEvent;

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
    
    DataManager *dataManager = [DataManager sharedInstance];
    self.pEvents = [dataManager eventsForDay:dataManager.selectedDay andRoom:dataManager.selectedRoom];
    
    self.tabBarController.selectedImageTintColor = [UIColor whiteColor];
    [self.tabBarController setSelectedItem:[self.tabBarController.items firstObject]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadScheduleData)
                                                 name:@"UpdateSchedule" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)reloadScheduleData {
    //TODO
//    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:1];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = self.pEvents[indexPath.row];
    if (event.title == nil) {
        ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
        cell.labelSpeakerName.text = [self speakerStringFromSpeakers:event.speakers];
        cell.labelPresentationSubTitle.text = event.subtitle;
        cell.labelPresentationDescription.text = event.eventDesc;
        cell.labelStartTime.text = event.interval.startTime;
//        Speaker *speaker = [event.speakers firstObject];
//        if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID]) {
//            [cell.buttonImageView setImage:[[DataManager sharedInstance] getActiveBookmarkImage]];
//        } else {
//            [cell.buttonImageView setImage:[[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO]];
//        }
        
        cell.delegate = self;
        
        return cell;
    } else {
        GlobalMetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GlobalMetupCell"];
        cell.labelPresentationName.text = (event.title.length) ? event.title : (event.subtitle.length) ? event.subtitle : @"Event";
        cell.labelStartTime.text = event.interval.startTime;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ScheduleTableViewCell class]]) {
        self.pSelectedEvent = self.pEvents[indexPath.row];
       [self performSegueWithIdentifier:[[DataManager sharedInstance] getInfoStoryboardSegue] sender:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    DataManager *dataManager = [DataManager sharedInstance];
    self.pEvents = [dataManager eventsForDayOrder:1 andRoomOrder:(int)item.tag];
//    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:item.tag];
    [self.tableView reloadData];
}

- (NSString *)speakerStringFromSpeakers:(NSSet *)speakers {
    NSString *returnString = @"";
    for (Speaker *speaker in [speakers allObjects]) {
       returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
    }
    return returnString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.event = self.pSelectedEvent;
}

//- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
//    Event *event = [_currentHallSchedule objectAtIndex:[self.tableView indexPathForCell:cell].row];
//    Speaker *speaker = [event.speakers firstObject];
//    
//    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID];
//    [cell.buttonImageView setImage:isBookmarked ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO] : [[DataManager sharedInstance] getActiveBookmarkImage]];
//    
//    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:speaker.speakerID];
//}

@end
