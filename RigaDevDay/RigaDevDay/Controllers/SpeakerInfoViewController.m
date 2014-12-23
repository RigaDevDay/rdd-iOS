//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SpeakerInfoViewController.h"
#import "SWRevealViewController.h"

@interface SpeakerInfoViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelSpeakerName;
@property (strong, nonatomic) IBOutlet UILabel *labelWorkPlace;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwitter;
@property (strong, nonatomic) IBOutlet UIButton *buttonBookmark;
@property (strong, nonatomic) IBOutlet UIButton *buttonSpeech;
@property (strong, nonatomic) IBOutlet UIButton *buttonAbout;
@property (strong, nonatomic) IBOutlet UILabel *labelTileAndLocation;
@property (strong, nonatomic) IBOutlet UILabel *labelMainTitle;
@property (strong, nonatomic) IBOutlet UITextView *textViewInformation;

@end

@implementation SpeakerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self;
    self.buttonMenu.action = @selector(backButtonPress);
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Buttons

- (void)backButtonPress {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTwitterButtonPress:(id)sender {
    
}
- (IBAction)onBookmarkButtonPress:(id)sender {
    
}
- (IBAction)onSpeechButtonPress:(id)sender {
    [self setSpeechButtonSelected:YES];
    [self setAboutButtonSelected:NO];
}
- (IBAction)onAboutButtonPress:(id)sender {
    [self setAboutButtonSelected:YES];
    [self setSpeechButtonSelected:NO];
}

- (void)setAboutButtonSelected:(BOOL)selected {
    [self.buttonAbout setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonAbout setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = selected;
}

- (void)setSpeechButtonSelected:(BOOL)selected {
    [self.buttonSpeech setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonSpeech setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = !selected;
}

@end
