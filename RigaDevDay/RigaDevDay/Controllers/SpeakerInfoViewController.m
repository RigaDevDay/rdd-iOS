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
//@property (nonatomic, strong) Event *pEvent;
//    NSArray *_evenets;

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
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCountry;

@end

@implementation SpeakerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self;
    self.buttonMenu.action = @selector(backButtonPress);
    
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
//    if (self.reloadedObject) {
//        _event = self.reloadedObject;
//    } else {
//        _event = [[DataManager sharedInstance] getEventForSpeakerWithID:self.speaker.speakerID];
//    }
    [self setUpInfo];
    [self setAboutButtonSelected:NO];
    [self setSpeechButtonSelected:YES];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self refreshSpeakerSpeachForward:YES];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self refreshSpeakerSpeachForward:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    CGRect buttonFrame = self.buttonSpeech.frame;
//    buttonFrame.origin.y = self.imageViewBackground.frame.size.height;
//    self.buttonSpeech.frame = buttonFrame;
}

#pragma mark Buttons

- (void)backButtonPress {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTwitterButtonPress:(id)sender {
    Speaker *speaker = [self.event.speakers anyObject];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", speaker.twitterURL]]];
}

- (IBAction)onBookmarkButtonPress:(id)sender {
//    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:self.speaker.speakerID];
    [self.buttonBookmark setImage:[self.event.isFavorite boolValue] ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:YES] : [[DataManager sharedInstance] getActiveBookmarkImage] forState:UIControlStateNormal];
//    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:self.speaker.speakerID];
}
- (IBAction)onBlogButtonPress:(id)sender {
    Speaker *speaker = [self.event.speakers anyObject];
    if (speaker.blogURL) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:speaker.blogURL]];
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
    Speaker *speaker = [self.event.speakers anyObject];
    if (selected) self.textViewInformation.text = speaker.speakerDesc;
    [self.buttonAbout setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonAbout setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = selected;
    self.labelMainTitle.hidden = selected;
    self.buttonBlog.hidden = !selected;
    self.imageViewCountry.hidden = !selected;
}

- (void)setSpeechButtonSelected:(BOOL)selected {
    if (selected) self.textViewInformation.text = self.event.eventDesc;
    [self.buttonSpeech setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
    [self.buttonSpeech setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    self.labelTileAndLocation.hidden = !selected;
    self.labelMainTitle.hidden = !selected;
    self.buttonBlog.hidden = selected;
    self.imageViewCountry.hidden = selected;
}

- (void)setUpInfo {
    
    // Small UI improvements
    [self.buttonTwitter.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.buttonBookmark.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    Speaker *speaker = [self.event.speakers anyObject];
    // Speaker Info
    self.labelSpeakerName.text = speaker.name;
    self.labelWorkPlace.text = speaker.company;
    self.imageViewProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%li",(long)speaker.speakerID]];
    self.imageViewBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"backstage_%li.jpeg",(long)speaker.speakerID]];
    [self.buttonBlog setTitle:[self getBlogAndURLSrting] forState:UIControlStateNormal];
//    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:speaker.speakerID];
    [self.imageViewCountry setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",speaker.country]]];
    
    [self.buttonBookmark setImage:[self.event.isFavorite boolValue] ? [[DataManager sharedInstance] getActiveBookmarkImage] : [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:YES] forState:UIControlStateNormal];
    
    // Evnet Info
    self.labelTileAndLocation.text = [self getEventTimeAndLocationString];
    self.labelMainTitle.text = self.event.subtitle;
    self.textViewInformation.text = self.event.eventDesc;
}

- (NSString *)getEventTimeAndLocationString {
    return [NSString stringWithFormat:@"%@ - %@, %@",self.event.interval.startTime, self.event.interval.endTime, self.event.room.name];
}

- (NSString *)getBlogAndURLSrting {
    Speaker *speaker = [self.event.speakers anyObject];
    if (speaker.blogURL)  {
        return [NSString stringWithFormat:@"Blog %@", speaker.blogURL];
    }
    return @"";
}

- (void)refreshSpeakerSpeachForward:(BOOL)forward {
    if (!self.imageViewCountry.hidden) return; // not update speach while in info
//    
//    NSArray *events = [[DataManager sharedInstance] getEventsForSpeakerWithID:self.speaker.speakerID];
//    int arrayCount = (int)[events count];
//    int startPossition = (int)[events indexOfObject:_event];
//    self.reloadedObject = nil;
//    
//    if (forward) { // swipe left
//        for (; startPossition < arrayCount; startPossition++) {
//            Event *event = [events objectAtIndex:startPossition];
//            if (![event isEqual:_event]) {
//                self.reloadedObject = event;
//            }
//        }
//    } else { // swipe right
//        for (; startPossition >= 0; startPossition--) {
//            Event *event = [events objectAtIndex:startPossition];
//            if (![event isEqual:_event]) {
//                self.reloadedObject = event;
//            }
//        }
//    }
//    if (self.reloadedObject){
//        [self viewDidLoad];
//    }
}

@end
