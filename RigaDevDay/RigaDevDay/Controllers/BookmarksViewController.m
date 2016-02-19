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
#import "SpeakerInfoViewController.h"
#import "DataManager.h"

@interface BookmarksViewController () <UITableViewDelegate, UITableViewDataSource, ScheduleTableViewCellDelegate>
@property (nonatomic, strong) NSArray *pBookmaredEvents;
@property (nonatomic, strong) Event *pSeletedEvent;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNoBookmarks;

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
    self.pBookmaredEvents = [[DataManager sharedInstance] allBookmarks];
    self.labelNoBookmarks.hidden = [self.pBookmaredEvents count] ? YES : NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pBookmaredEvents count];
}

- (ScheduleTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = self.pBookmaredEvents[indexPath.row];
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
    cell.labelSpeakerName.text = [self getSpeakerStringFromArray:event.speakers];
    cell.labelPresentationSubTitle.text = (event.subtitle.length) ? event.subtitle : @"Event";
    cell.labelPresentationDescription.text = event.eventDesc;
    cell.labelStartTime.text = event.interval.startTime;
    cell.labelStartTime.textColor = [self hasSameTimeEventAs:event] ? [UIColor redColor] : [UIColor grayColor];
    
           [cell.buttonImageView setImage:[event.isFavorite boolValue] ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];

    cell.delegate = self;
    
    return cell;
}

- (NSString *)getSpeakerStringFromArray:(NSSet *)speakers {
    NSString *returnString = @"";
    for (Speaker *speaker in speakers) {
        returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
    }
    return returnString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.pSeletedEvent = self.pBookmaredEvents[indexPath.row];
    [self performSegueWithIdentifier:@"EventSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.events = @[self.pSeletedEvent];
}


- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
    Event *event = [self.pBookmaredEvents objectAtIndex:[self.tableView indexPathForCell:cell].row];

    BOOL isFavorite = [[DataManager sharedInstance] changeFavoriteStatusForEvent:event];
    [cell.buttonImageView setImage:isFavorite ? [UIImage imageNamed:@"icon_bookmark.png"] : [UIImage imageNamed:@"icon_menu_bookmark.png"]];
     [self p_reloadBookmarks];
}
//
- (BOOL)hasSameTimeEventAs:(Event *)event {
#warning Compare conflicted times
//    for (Event *bEvent in self.pBookmaredEvents) {
//        if ([bEvent isEqual:event])continue;
//        if ([bEvent.startTime isEqualToString:event.startTime]) return YES;
//    }
    return NO;
}

@end
