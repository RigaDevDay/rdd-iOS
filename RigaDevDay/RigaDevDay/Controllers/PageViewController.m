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
#import "EventViewController.h"
#import "DaysTableViewController.h"
#import "DataManager.h"
#import "UIColor+App.h"
#import "AppDelegate.h"
#import "WebserviceManager.h"

@interface PageViewController () <DaysTableVCDelegate>
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *iboActivityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *iboRetryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iboDayBarButtonItem;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[WebserviceManager sharedInstance] isScheduleLoading]) {
        [self p_enableViews:NO];
    } else {
        [self p_enableViews:YES];
        [self p_reloadPageMenuWithDay:[DataManager sharedInstance].selectedDay];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scheduleLoadedNotification:)
                                                 name:kScheduleLoadedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorLoadingScheduleNotification:)
                                                 name:kErrorLoadingScheduleNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noInternetNotification:)
                                                 name:kNoInternetNotification
                                               object:nil];
    
    self.title = @"Schedule";
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (IBAction)retryButtonTapped:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate updateSchedule];
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
    if (day) {
        DataManager *dataManager= [DataManager sharedInstance];
        self.iboDayBarButtonItem.title = dataManager.selectedDay.title;
        NSArray *roomNames = [dataManager roomsForDay:day];
        [self p_initViewControllersWithRooms:roomNames];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DaysSegue"]) {
        DaysTableViewController *daysVC = segue.destinationViewController;
        daysVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EventSegue"]) {
        EventViewController *destController = [segue destinationViewController];
        destController.event = self.selectedEvent;
    }
}

- (void)p_enableViews:(BOOL)enable {
    if (enable) {
        self.pageMenu.view.userInteractionEnabled = YES;
        self.iboDayBarButtonItem.enabled = YES;
        self.buttonMenu.enabled = YES;
        [self.iboActivityIndicator stopAnimating];
    } else {
        self.pageMenu.view.userInteractionEnabled = NO;
        [self.iboActivityIndicator startAnimating];
        self.buttonMenu.enabled = NO;
        self.iboDayBarButtonItem.enabled = NO;
    }
}

#pragma mark - DaysTableVCDelegate

- (void)daysTableVC:(DaysTableViewController *)daysVC didSelectDay:(Day *)day {
    if (![[DataManager sharedInstance].selectedDay isEqual:day]) {
        [DataManager sharedInstance].selectedDay = day;
        [[DataManager sharedInstance] selectRoomWithOrder:1];
        
        [self p_reloadPageMenuWithDay:day];
    }
}

- (void)p_showCancelAlertWithText:(NSString *)text {
    if ([UIAlertController class]) {
        // use UIAlertController
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Riga Dev Days 2016"
                                   message:text
                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // use UIAlertView
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Riga Dev Days 2016"
                                                         message:text
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil];
        [dialog show];
    }
}

#pragma mark - NSNotification methods

- (void)scheduleLoadedNotification:(NSNotification *)notification {
    [self p_enableViews:YES];
    [self p_reloadPageMenuWithDay:[DataManager sharedInstance].selectedDay];
}

- (void)errorLoadingScheduleNotification:(NSNotification *)notification {
    self.iboRetryButton.hidden = NO;
    [self p_enableViews:NO];
    NSString *message = notification.userInfo[kNotificationErrorMessage];
    [self p_showCancelAlertWithText:message];
}

- (void)noInternetNotification:(NSNotification *)notification {
    self.iboRetryButton.hidden = NO;
    [self p_enableViews:NO];
    NSString *message = notification.userInfo[kNotificationErrorMessage];
    [self p_showCancelAlertWithText:message];
}

@end
