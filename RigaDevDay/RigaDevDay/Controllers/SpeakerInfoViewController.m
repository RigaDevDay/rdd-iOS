//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SpeakerInfoViewController.h"
#import "SWRevealViewController.h"

@interface SpeakerInfoViewController () {
    EventObject *_event;
}
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
@property (weak, nonatomic) IBOutlet UIButton *buttonBlog;

@end

@implementation SpeakerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self;
    self.buttonMenu.action = @selector(backButtonPress);
    _event = [[DataManager sharedInstance] getEventForSpeakerWithID:self.speaker.id];
    [self setUpInfo];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",self.speaker.twitter]]];
}

- (IBAction)onBookmarkButtonPress:(id)sender {
    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:YES forSpeakerID:self.speaker.id];
}
- (IBAction)onBlogButtonPress:(id)sender {
    if (self.speaker.blog) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.speaker.blog]];
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
    if (selected) self.textViewInformation.text = self.speaker.bio;
    [self.buttonAbout setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonAbout setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = selected;
    self.labelMainTitle.hidden = selected;
    self.buttonBlog.hidden = !selected;
}

- (void)setSpeechButtonSelected:(BOOL)selected {
    if (selected) self.textViewInformation.text = _event.eventDescription;
    [self.buttonSpeech setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonSpeech setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = !selected;
    self.labelMainTitle.hidden = !selected;
    self.buttonBlog.hidden = selected;
}

- (void)setUpInfo {
    // Speaker Info
    self.labelSpeakerName.text = self.speaker.name;
    self.labelWorkPlace.text = self.speaker.company;
    self.imageViewProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%li",(long)self.speaker.id]];
    self.imageViewBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"backstage_%li.jpeg",(long)self.speaker.id]];
    [self.buttonBlog setTitle:[self getBlogAndURLSrting] forState:UIControlStateNormal];
    
    // Evnet Info
    self.labelTileAndLocation.text = [self getEventTimeAndLocationString];
    self.labelMainTitle.text = _event.subTitle;
    self.textViewInformation.text = _event.eventDescription;
}

- (NSString *)getEventTimeAndLocationString {
    return [NSString stringWithFormat:@"%@ - Hall %li",_event.startTime, (long)_event.hallID];
}

- (NSString *)getBlogAndURLSrting {
    if (self.speaker.blog)  {
        return [NSString stringWithFormat:@"Blog %@",self.speaker.blog];
    }
    return @"";
}

@end
