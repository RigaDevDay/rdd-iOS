//
//  SpeakersViewController.m
//  RigaDevDay
//
//  Created by Denis Kaibagarov on 12/23/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SpeakersViewController.h"
#import "SWRevealViewController.h"
#import "SpeakerTableViewCell.h"
#import "SpeakerInfoViewController.h"
#import "DataManager.h"

@interface SpeakersViewController () <UITableViewDataSource, UITableViewDelegate, SpeakerTableViewCellDelegate> {
    NSArray *_speakersArray;
    Speaker *_selectedSpeaker;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _speakersArray = [[DataManager sharedInstance] getAllSpeakers];
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
    _speakersArray = [[DataManager sharedInstance] getAllSpeakers];
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
    return [_speakersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Speaker *speaker = _speakersArray[indexPath.row];
    SpeakerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
    cell.delegate = self;
    cell.labelName.text = speaker.name;
//    cell.labelPresentation.text = speaker.bio;
    if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID]) {
        [cell.buttonImage setImage:[[DataManager sharedInstance] getActiveBookmarkImage]];
    } else {
        [cell.buttonImage setImage:[[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedSpeaker = _speakersArray[indexPath.row];
    [self performSegueWithIdentifier:@"EventSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpeakerInfoViewController *destController = [segue destinationViewController];
//    destController.event = self.ps;
}

- (void)bookmarkButtonPressedOnCell:(SpeakerTableViewCell *)cell {
    Speaker *speaker = [_speakersArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID];
    [cell.buttonImage setImage:isBookmarked ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:NO] : [[DataManager sharedInstance] getActiveBookmarkImage]];
    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:speaker.speakerID];
}

@end
