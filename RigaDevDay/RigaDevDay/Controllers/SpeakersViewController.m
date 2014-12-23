//
//  SpeakersViewController.m
//  RigaDevDay
//
//  Created by Denis Kaibagarov on 12/23/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SpeakersViewController.h"
#import "SWRevealViewController.h"

@interface SpeakersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SPEAKER_SPEECH_INFO_SEGUEUE" sender:nil];
}


@end
