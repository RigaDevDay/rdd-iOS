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
#import "EventViewController.h"
#import "DataManager.h"
#import "SpeakerInfoViewController.h"

@interface SpeakersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *pSpeakers;
@property (nonatomic, strong) Speaker *pSelectedSpeaker;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.pSpeakers = [[DataManager sharedInstance] allSpeakers];
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
    self.pSpeakers = [[DataManager sharedInstance] allSpeakers];
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
    return [self.pSpeakers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Speaker *speaker = self.pSpeakers[indexPath.row];
    SpeakerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
    cell.iboNameLabel.text = speaker.name;
    cell.iboInfoLabel.text = [NSString stringWithFormat:@"%@, %@", speaker.company, speaker.jobTitle];
    UIImage *profileImage = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%@",speaker.speakerID]];
    cell.iboSpeakerImageView.image = (profileImage) ? profileImage : [UIImage imageNamed:@"speaker_0"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.pSelectedSpeaker = self.pSpeakers[indexPath.row];
    [self performSegueWithIdentifier:@"SpeakerSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.speaker = self.pSelectedSpeaker;
}


@end
