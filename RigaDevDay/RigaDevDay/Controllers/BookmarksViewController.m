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

@interface BookmarksViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_bookmaredEventsArray;
    EventObject *_seletedEventObject;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    _bookmaredEventsArray = [[DataManager sharedInstance] getAllBookmarkedEvents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookmaredEventsArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (ScheduleTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventObject *event = _bookmaredEventsArray[indexPath.row];
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresentationCell"];
    cell.labelSpeakerName.text = [self getSpeakerStringFromArray:event.speakers];
    cell.labelPresentationSubTitle.text = event.subTitle;
    cell.labelPresentationDescription.text = event.eventDescription;
    cell.labelStartTime.text = event.startTime;
    
    return cell;
}

- (NSString *)getSpeakerStringFromArray:(NSArray *)speakersArray {
    NSString *returnString = @"";
    for (SpeakerObject *speaker in speakersArray) {
        returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
    }
    return [returnString substringToIndex:[returnString length] - 2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _seletedEventObject = _bookmaredEventsArray[indexPath.row];
    [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.speaker = [_seletedEventObject.speakers firstObject];
}

@end
