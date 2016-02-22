//
//  BookmarksViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "BookmarksViewController.h"
#import "SWRevealViewController.h"
#import "ScheduleTableViewCell.h"
#import "EventViewController.h"
#import "DataManager.h"
#import "NSArray+LinqExtensions.h"

@interface BookmarksViewController () <UITableViewDelegate, UITableViewDataSource, ScheduleTableViewCellDelegate>
//@property (nonatomic, strong) NSArray *pBookmaredEvents;
@property (nonatomic, strong) Event *pSeletedEvent;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNoBookmarks;

@property (nonatomic, strong) NSMutableDictionary *pGroupedEvents;// by Day name
@property (nonatomic, strong) NSMutableArray *pHeaderNames;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self p_reloadBookmarks];
}

- (void)p_reloadBookmarks {
    NSArray *bookmarkedEvents = [[DataManager sharedInstance] allBookmarks];

 self.pGroupedEvents = [[bookmarkedEvents linq_groupBy:^id(Event *event) {
        return event.interval.day.order;
    }] mutableCopy];
     self.pHeaderNames = [[[self.pGroupedEvents allKeys] linq_sort] mutableCopy];

    
    self.labelNoBookmarks.hidden = [self.pHeaderNames count] ? YES : NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Event *)p_eventForIndexPath:(NSIndexPath *)indexPath {
    NSString *headerName = self.pHeaderNames[(NSUInteger) indexPath.section];
    NSArray *eventsForHeader = self.pGroupedEvents[headerName];
    return eventsForHeader[(NSUInteger)indexPath.row];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.pBookmaredEvents count];
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Day *day = [[DataManager sharedInstance] dayWithOrder:[self.pHeaderNames[section] integerValue]];
    if (day) {
        return day.title;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.pHeaderNames count]) {
        NSString *headerName =  self.pHeaderNames[(NSUInteger) section];
        NSArray *imagesForHeader = self.pGroupedEvents[headerName];
        return imagesForHeader.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([self.pHeaderNames count]) ? [self.pHeaderNames count] : 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return  (self.pPreferenceModel.activitiesGroupingType == StoreGrouping) ? self.pHeaderNames[(NSUInteger) section] : [self.pHeaderNames[(NSUInteger)section] dateStringWithFormat:@"dd MMM yyyy"];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

- (ScheduleTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//      Image *image = [self p_imageForIndexPath:indexPath];
    Event *event = [self p_eventForIndexPath:indexPath];
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
    cell.labelSpeakerName.text = [[DataManager sharedInstance] speakerStringFromSpeakers:event.speakers];
    cell.labelPresentationSubTitle.text = (event.subtitle.length) ? event.subtitle : @"Event";
   [cell setEventTagNames:[[DataManager sharedInstance] tagNamesForEvent:event]];
    cell.labelStartTime.text = (event.room) ? [NSString stringWithFormat:@"%@, %@", event.room.name, event.interval.startTime] : [NSString stringWithFormat:@" %@", event.interval.startTime];
//    cell.labelStartTime.textColor = [self hasSameTimeEventAs:event] ? [UIColor redColor] : [UIColor grayColor];
    
           [cell.buttonImageView setImage:[event.isFavorite boolValue] ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];

    cell.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.pSeletedEvent = [self p_eventForIndexPath:indexPath];
    [self performSegueWithIdentifier:@"EventSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EventViewController *destController = [segue destinationViewController];
//    destController.events = @[self.pSeletedEvent];
}


- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
//    Event *event = [self.pBookmaredEvents objectAtIndex:[self.tableView indexPathForCell:cell].row];
    Event *event = [self p_eventForIndexPath:[self.tableView indexPathForCell:cell]];
    BOOL isFavorite = [[DataManager sharedInstance] changeFavoriteStatusForEvent:event];
    [cell.buttonImageView setImage:isFavorite ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
     [self p_reloadBookmarks];
}


@end
