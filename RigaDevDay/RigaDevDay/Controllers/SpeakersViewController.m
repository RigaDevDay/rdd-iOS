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

@interface SpeakersViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_speakersArray;
    SpeakerObject *_selectedSpeaker;
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
    SpeakerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
    cell.labelName.text = [(SpeakerObject*)_speakersArray[indexPath.row] name];
    cell.labelPresentation.text = [(SpeakerObject*)_speakersArray[indexPath.row] bio];
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

@end
