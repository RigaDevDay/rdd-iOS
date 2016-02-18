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

@interface BookmarksViewController () <UITableViewDelegate, UITableViewDataSource, ScheduleTableViewCellDelegate> {
    NSArray *_bookmaredEventsArray;
    Event *_seletedEventObject;
}
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
    _bookmaredEventsArray = [[DataManager sharedInstance] getAllBookmarkedEvents];
    self.labelNoBookmarks.hidden = [_bookmaredEventsArray count] ? YES : NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookmaredEventsArray count];
}

//- (ScheduleTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    Event *event = _bookmaredEventsArray[indexPath.row];
//    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
//    cell.labelSpeakerName.text = [self getSpeakerStringFromArray:event.speakers];
//    cell.labelPresentationSubTitle.text = event.subTitle;
//    cell.labelPresentationDescription.text = event.eventDescription;
//    cell.labelStartTime.text = event.startTime;
//    cell.labelStartTime.textColor = [self hasSameTimeEventAs:event] ? [UIColor redColor] : [UIColor grayColor];
//    
//    Speaker *speaker = [event.speakers firstObject];
//    if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID]) {
//        [cell.buttonImageView setImage:[[DataManager sharedInstance] getActiveBookmarkImage]];
//    } else {
//        [cell.buttonImageView setImage:[[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO]];
//    }
//
//    cell.delegate = self;
//    
//    return cell;
//}

- (NSString *)getSpeakerStringFromArray:(NSArray *)speakersArray {
    NSString *returnString = @"";
    for (Speaker *speaker in speakersArray) {
        returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
    }
    return [returnString substringToIndex:[returnString length] - 2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _seletedEventObject = _bookmaredEventsArray[indexPath.row];
    [self performSegueWithIdentifier:@"EventSegue" sender:nil];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    SpeakerInfoViewController *destController = [segue destinationViewController];
//    destController.speaker = [_seletedEventObject.speakers firstObject];
//}
//
//#pragma mark Bookmakrs
//
//- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell {
//    Event *event = [_bookmaredEventsArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
//    Speaker *speaker = [event.speakers firstObject];
//    
//    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID];
//    [cell.buttonImageView setImage:isBookmarked ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO] : [[DataManager sharedInstance] getActiveBookmarkImage]];
//    
//    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:speaker.speakerID];
//    _bookmaredEventsArray = [[DataManager sharedInstance] getAllBookmarkedEvents];
//    self.labelNoBookmarks.hidden = [_bookmaredEventsArray count] ? YES : NO;
//    [self.tableView reloadData];
//}
//
//- (BOOL)hasSameTimeEventAs:(Event *)event {
//    for (Event *bEvent in _bookmaredEventsArray) {
//        if ([bEvent isEqual:event])continue;
//        if ([bEvent.startTime isEqualToString:event.startTime]) return YES;
//    }
//    return NO;
//}

@end
