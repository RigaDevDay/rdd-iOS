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
#import "DaysTableViewController.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, ScheduleTableViewCellDelegate, DaysTableVCDelegate>
@property (nonatomic, strong) NSArray *pEvents;
@property (nonatomic, strong) Event *pSelectedEvent;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UITableView *iboTableView;
@property (weak, nonatomic) IBOutlet UITabBar *iboTabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iboDayBarButtonItem;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self p_reloadSchedule];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadScheduleData)
                                                 name:@"UpdateSchedule" object:nil];
    // Do any additional setup after loading the view.
}

- (void)p_reloadSchedule {
    DataManager *dataManager = [DataManager sharedInstance];
    self.pEvents = [dataManager eventsForDay:dataManager.selectedDay andRoom:dataManager.selectedRoom];
    self.title = dataManager.selectedRoom.name;
    self.iboDayBarButtonItem.title = dataManager.selectedDay.title;
    self.iboTabBar.selectedImageTintColor = [UIColor whiteColor];
    [self.iboTabBar setSelectedItem:[self.iboTabBar.items firstObject]];
    
    NSArray *roomNames = [dataManager roomsForDay:dataManager.selectedDay];
    self.iboTabBar.itemPositioning = UITabBarItemPositioningCentered;
    //    self.iboTabBar.itemSpacing = 1.0;
    self.iboTabBar.itemWidth = self.view.bounds.size.width / roomNames.count;
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < roomNames.count; i++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:roomNames[i][@"name"] image:nil tag:i+1];
        [item setImage:[UIImage imageNamed:[self p_imageNameForRoomName:roomNames[i][@"name"]]]];
        [items addObject:item];
    }
    [self.iboTabBar setItems:items];
    if (items.count) {
        [self.iboTabBar setSelectedItem:[items firstObject]];
    }
    
}
- (IBAction)dayButtonTapped:(UIBarButtonItem *)sender {
    
}

- (NSString *)p_imageNameForRoomName:(NSString *)roomName {
    if ([roomName isEqualToString:@"Room 1"]) {
        return @"icn-1";
    } else if ([roomName isEqualToString:@"Room 2"]) {
        return @"icn-2";
    } else if ([roomName isEqualToString:@"Room 3"]) {
        return @"icn-3";
    } else if ([roomName isEqualToString:@"Room 5"]) {
        return @"icn-5";
    } else if ([roomName isEqualToString:@"Room 6"]) {
        return @"icn-6";
    } else if ([roomName isEqualToString:@"Room 10"]) {
        return @"icn-10";
    } else if ([roomName isEqualToString:@"Room 13"]) {
        return @"icn-13";
    }
    return @"Hall_imag";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.iboTableView reloadData];
}

- (void)reloadScheduleData {
    //TODO
    //    _currentHallSchedule = [[DataManager sharedInstance] getScheduleForHall:1];
    [self.iboTableView reloadData];
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
        cell.labelSpeakerName.text = [[DataManager sharedInstance] speakerStringFromSpeakers:[event speakers]];
        cell.labelPresentationSubTitle.text = event.subtitle;
        cell.labelPresentationDescription.text = event.eventDesc;
        cell.labelStartTime.text = event.interval.startTime;
        [cell.buttonImageView setImage:[event.isFavorite boolValue] ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
        cell.delegate = self;
        
        return cell;
    } else {
        GlobalMetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GlobalMetupCell"];
        cell.labelPresentationName.text = (event.title.length) ? event.title : (event.subtitle.length) ? event.subtitle : @"Event";
        cell.labelStartTime.text = event.interval.startTime;
        //                cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor lightGrayColor] : [UIColor whiteColor];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = self.pEvents[indexPath.row];
    if (event.title == nil) {
        return 70.0f;
    } else {
        return 50.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ScheduleTableViewCell class]]) {
        self.pSelectedEvent = self.pEvents[indexPath.row];
        [self performSegueWithIdentifier:@"EventSegue" sender:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    DataManager *dataManager = [DataManager sharedInstance];
    [dataManager selectRoomWithOrder:item.tag];
    self.pEvents = [dataManager eventsForDay:dataManager.selectedDay andRoom:dataManager.selectedRoom];
    self.title = dataManager.selectedRoom.name;
    [self.iboTableView reloadData];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DaysSegue"]) {
        DaysTableViewController *daysVC = segue.destinationViewController;
        daysVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EventSegue"]) {
        SpeakerInfoViewController *destController = [segue destinationViewController];
        destController.events = @[self.pSelectedEvent];
    }
}
//
- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
    Event *event = [self.pEvents objectAtIndex:[self.iboTableView indexPathForCell:cell].row];
    if (event) {
        BOOL isFavorite = [[DataManager sharedInstance] changeFavoriteStatusForEvent:event];
        [cell.buttonImageView setImage:isFavorite ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
    }
}

#pragma mark - DaysTableVCDelegate

- (void)daysTableVC:(DaysTableViewController *)daysVC didSelectDay:(Day *)day {
    [DataManager sharedInstance].selectedDay = day;
    [[DataManager sharedInstance] selectRoomWithOrder:1];
    [self p_reloadSchedule];
}

@end
