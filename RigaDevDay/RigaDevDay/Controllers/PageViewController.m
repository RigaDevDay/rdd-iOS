//
//  PageViewController.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 21/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "PageViewController.h"
#import "CAPSPageMenu.h"
#import "ScheduleViewController.h"
#import "SWRevealViewController.h"
#import "SpeakerInfoViewController.h"
#import "DaysTableViewController.h"
#import "DataManager.h"
#import "UIColor+App.h"

@interface PageViewController () <DaysTableVCDelegate>
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iboDayBarButtonItem;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Schedule";
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self p_reloadPageMenuWithDay:[DataManager sharedInstance].selectedDay];
}

- (void)p_didTapGoToLeft {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pageMenu moveToPage:currentIndex - 1];
    }
}

- (void)p_didTapGoToRight {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex < self.pageMenu.controllerArray.count) {
        [self.pageMenu moveToPage:currentIndex + 1];
    }
}

- (void)p_initViewControllersWithRooms:(NSArray *)rooms {
    [_pageMenu.view removeFromSuperview];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSMutableArray *controllers = [NSMutableArray array];
    for (Room *room in rooms) {
        ScheduleViewController *scheduleVC =  (ScheduleViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
        scheduleVC.title = room.name;
        DataManager *dataManager = [DataManager sharedInstance];
       scheduleVC.events = [dataManager eventsForDay:dataManager.selectedDay andRoom:room];
        scheduleVC.pageVC = self;
        [controllers addObject:scheduleVC];
    }
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor appBlack],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor appOrange],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllers frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
    
}

- (void)p_reloadPageMenuWithDay:(Day *)day {
    DataManager *dataManager= [DataManager sharedInstance];
    self.iboDayBarButtonItem.title = dataManager.selectedDay.title;
    NSArray *roomNames = [dataManager roomsForDay:day];
    [self p_initViewControllersWithRooms:roomNames];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DaysSegue"]) {
        DaysTableViewController *daysVC = segue.destinationViewController;
        daysVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EventSegue"]) {
        SpeakerInfoViewController *destController = [segue destinationViewController];
        destController.events = self.selectedEvents;
    }
}

#pragma mark - DaysTableVCDelegate

- (void)daysTableVC:(DaysTableViewController *)daysVC didSelectDay:(Day *)day {
    [DataManager sharedInstance].selectedDay = day;
    [[DataManager sharedInstance] selectRoomWithOrder:1];
    
    [self p_reloadPageMenuWithDay:day];
}

@end
