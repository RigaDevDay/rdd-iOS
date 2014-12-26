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
    SpeakerObject *_selectedSpeaker;
    UIImage *bookMarkActive;
    UIImage *bookmarkInActive;
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
    
    bookMarkActive = [UIImage imageNamed:@"icon_bookmark.png"];
    bookmarkInActive = [UIImage imageNamed:@"icon_menu_bookmark.png"];
    
    _speakersArray = [[DataManager sharedInstance] getAllSpeakers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_speakersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpeakerObject *speaker = _speakersArray[indexPath.row];
    SpeakerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
    cell.delegate = self;
    cell.labelName.text = speaker.name;
    cell.labelPresentation.text = speaker.bio;
    if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.id]) {
        [cell.buttonBookmark setImage:bookMarkActive forState:UIControlStateNormal];
    } else {
        [cell.buttonBookmark setImage:bookmarkInActive forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedSpeaker = _speakersArray[indexPath.row];
    [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.speaker = _selectedSpeaker;
}

- (void)bookmarkButtonPressedOnCell:(SpeakerTableViewCell *)cell {
    SpeakerObject *speaker = [_speakersArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
    if ([[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.id]) {
        [cell.buttonBookmark setImage:bookmarkInActive forState:UIControlStateNormal];
        [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:NO forSpeakerID:speaker.id];
    } else {
        [cell.buttonBookmark setImage:bookMarkActive forState:UIControlStateNormal];
        [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:YES forSpeakerID:speaker.id];
    }

}
@end
