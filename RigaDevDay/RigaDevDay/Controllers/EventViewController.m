//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "EventViewController.h"
#import "SWRevealViewController.h"

@interface EventViewController ()
//@property (nonatomic, strong) Event *pEvent;
//    NSArray *_evenets;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
//@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
//@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
//@property (strong, nonatomic) IBOutlet UILabel *labelSpeakerName;
//@property (strong, nonatomic) IBOutlet UILabel *labelWorkPlace;
//@property (strong, nonatomic) IBOutlet UIButton *buttonTwitter;
//@property (strong, nonatomic) IBOutlet UIButton *buttonBookmark;
//@property (strong, nonatomic) IBOutlet UIButton *buttonSpeech;
//@property (strong, nonatomic) IBOutlet UIButton *buttonAbout;
//@property (strong, nonatomic) IBOutlet UILabel *labelTileAndLocation;
//@property (strong, nonatomic) IBOutlet UILabel *labelMainTitle;
//@property (strong, nonatomic) IBOutlet UITextView *textViewInformation;
//@property (weak, nonatomic) IBOutlet UIButton *buttonBlog;
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewCountry;
@property (weak, nonatomic) IBOutlet UIScrollView *iboScrollView;
@property (weak, nonatomic) IBOutlet UILabel *iboTimeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboEventTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *iboEventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboSpeakersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iboImageView;

@property (strong, nonatomic) Speaker *pSpeaker;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self;
    self.buttonMenu.action = @selector(backButtonPress);
    
    [self p_setupUI];
//    self.pSpeaker = (self.events.count) ? [[[self.events firstObject] speakers] anyObject] : nil;
    
//    [self setUpInfo];
//    [self setAboutButtonSelected:NO];
//    [self setSpeechButtonSelected:YES];
//    [self p_layoutScrollView];
}

- (void)p_setupUI {
    self.iboTimeLocationLabel.text = (self.event.room) ? [NSString stringWithFormat:@"%@ - %@, %@", self.event.interval.startTime, self.event.interval.endTime, self.event.room.name] : [NSString stringWithFormat:@"%@ - %@", self.event.interval.startTime, self.event.interval.endTime];
    self.iboEventTitleLabel.text = (self.event.title.length) ? self.event.title : self.event.subtitle;
    self.iboEventDescriptionLabel.attributedText = [[DataManager sharedInstance] attributedStringFromHtml:self.event.eventDesc withFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self.iboEventDescriptionLabel sizeToFit];
    self.iboSpeakersLabel.text = [[DataManager sharedInstance] speakerStringFromSpeakers:self.event.speakers];
    UIImage *backstageImage = [UIImage imageNamed:[NSString stringWithFormat:@"backstage_%@.jpeg",self.event.interval.order]];
    self.iboImageView.image = (backstageImage) ? backstageImage : [UIImage imageNamed:@"backstage_1.jpeg"];
    [self.iboScrollView layoutIfNeeded];
}



//- (void)p_layoutScrollView {
//
//    int width = 0;
//    SpeakerView *speakerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SpeakerView class]) owner:self options:nil] firstObject];
//    speakerView.frame = CGRectMake(width, 100, 234, 198);
//    NSMutableArray *speakers = [NSMutableArray array];
//    for (Event *event in self.events) {
//        for (Speaker *speaker in event.speakers) {
//            [speakers addObject:speaker];
//            //            SpeakerView *speakerView = [[SpeakerView alloc] initWithFrame:CGRectMake(width, 0, 234, 198)];
//            
//            
//            width += speakerView.bounds.size.width;
//            UIImage *profileImage = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%@",self.pSpeaker.speakerID]];
//            speakerView.iboPhotoImageView.image = (profileImage) ? profileImage : [UIImage imageNamed:@"speaker_0"];
//            speakerView.iboNameLabel.text = speaker.name;
//            speakerView.iboJobLabel.text = speaker.jobTitle;
//            speakerView.iboCompanyLabel.text = speaker.company;
//            //            speakerView.iboTwitterButton
//            //            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//            [self.iboScrollView addSubview:speakerView];
//        }
//    }
//    
//    //    self.iboScrollView.backgroundColor = [UIColor redColor];
//    
//    CGSize pagesScrollViewSize = self.iboScrollView.frame.size;
//    self.iboScrollView.contentSize = CGSizeMake(234.0 * [speakers count], pagesScrollViewSize.height);
//    //    [self.iboScrollView sizeToFit];
//    
//}

//- (void)p_layoutScrollView {
//    CGFloat width = 0.0;
//    UIView *previousView = nil;
//    
//    // Remove all previuos tags from tag scroll view
//    for (UIView *subview in self.iboScrollView.subviews) {
//        [subview removeFromSuperview];
//    }
//    
//    [previousView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.iboScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    int tag = 0;
//    

//    NSMutableArray *speakers = [NSMutableArray array];
//    for (Event *event in self.events) {
//        for (Speaker *speaker in event.speakers) {
//            [speakers addObject:speaker];
//            //            SpeakerView *speakerView = [[SpeakerView alloc] initWithFrame:CGRectMake(width, 0, 234, 198)];
//            
//            SpeakerView *speakerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SpeakerView class]) owner:self options:nil] firstObject];
//            speakerView.frame = CGRectMake(width, 100, 234, 198);
//            width += speakerView.bounds.size.width;
//            UIImage *profileImage = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%@",self.pSpeaker.speakerID]];
//            speakerView.iboPhotoImageView.image = (profileImage) ? profileImage : [UIImage imageNamed:@"speaker_0"];
//            speakerView.iboNameLabel.text = speaker.name;
//            speakerView.iboJobLabel.text = speaker.jobTitle;
//            speakerView.iboCompanyLabel.text = speaker.company;
//            
//            
//            [speakerView setTranslatesAutoresizingMaskIntoConstraints:NO];
//            speakerView.tag = tag;
//            [self.iboScrollView addSubview:speakerView];
//
//            // Center vertically single type label container view in labels container view
//            NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:speakerView
//                                                                                 attribute:NSLayoutAttributeCenterY
//                                                                                 relatedBy:NSLayoutRelationEqual
//                                                                                    toItem:self.iboScrollView
//                                                                                 attribute:NSLayoutAttributeCenterY
//                                                                                multiplier:1.0
//                                                                                  constant:0.0];
//            // Fixed single type label container view height
//            NSArray *labelContainerHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tagLabelView(==198)]"
//                                                                                    options:0
//                                                                                    metrics:nil
//                                                                                      views:@{@"tagLabelView" : speakerView}];
//        
//            // Single label container view left spacing to previous label container view
//            NSArray *leftLabelContainerSpace = nil;
//            if (previousView) {
//                leftLabelContainerSpace  = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-(==5)-[tagLabelView]"
//                                                                                   options:0
//                                                                                   metrics:nil
//                                                                                     views:@{@"tagLabelView" : speakerView,
//                                                                                             @"previousView" : previousView}];
//            } else {
//                leftLabelContainerSpace  = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[tagLabelView]"
//                                                                                   options:0
//                                                                                   metrics:nil
//                                                                                     views:@{@"tagLabelView" : speakerView
//                                                                                             }];
//            }
//            
//            [self.iboScrollView layoutIfNeeded];
//            
//            [self.iboScrollView addConstraint:centerYConstraint];
//            [self.iboScrollView addConstraints:leftLabelContainerSpace];
//            [speakerView addConstraints:labelContainerHeight];
//
//            tag++;
//            previousView = speakerView;
//        }
//        
//        // Last single label container right space to superview
//        if (previousView) {
//            [self.iboScrollView addConstraints:
//             [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lasttagLabelView]-(5)-|"
//                                                     options:0 metrics:nil
//                                                       views:@{@"lasttagLabelView":previousView}]];
//            width += previousView.bounds.size.width + 5;
//        }
//        [self.iboScrollView layoutIfNeeded];
//    }
////        self.iboScrollView.contentSize = CGSizeMake(width, self.iboScrollView.bounds.size.height);
//}


//
//-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
//{
//    [self refreshSpeakerSpeachForward:YES];
//}
//
//- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer {
//    [self refreshSpeakerSpeachForward:NO];
//}


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

//- (IBAction)onTwitterButtonPress:(id)sender {
//    if (self.pSpeaker) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", self.pSpeaker.twitterURL]]];
//    }
//    
//}

//- (IBAction)onBookmarkButtonPress:(id)sender {
//    //    BOOL isBookmarked = [[DataManager sharedInstance] isSpeakerBookmarkedWithID:self.speaker.speakerID];
//    if (self.events.count == 1) {
//        Event *event = [self.events firstObject];
//        [self.buttonBookmark setImage:[event.isFavorite boolValue] ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:YES] : [[DataManager sharedInstance] getActiveBookmarkImage] forState:UIControlStateNormal];
//    }
//    
//    //    [[DataManager sharedInstance] changeSpeakerBookmarkStateTo:!isBookmarked forSpeakerID:self.speaker.speakerID];
//}
//- (IBAction)onBlogButtonPress:(id)sender {
//    if (self.pSpeaker) {
//        if (self.pSpeaker.blogURL) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pSpeaker.blogURL]];
//        } else {
//        }
//    }
//}
//
//- (IBAction)onSpeechButtonPress:(id)sender {
//    [self setSpeechButtonSelected:YES];
//    [self setAboutButtonSelected:NO];
//}
//- (IBAction)onAboutButtonPress:(id)sender {
//    [self setAboutButtonSelected:YES];
//    [self setSpeechButtonSelected:NO];
//}

//- (void)setAboutButtonSelected:(BOOL)selected {
//    if (selected) {
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.pSpeaker.speakerDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        self.textViewInformation.attributedText = attributedString;
//    }
//    [self.buttonAbout setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
//    [self.buttonAbout setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
//    self.labelTileAndLocation.hidden = selected;
//    self.labelMainTitle.hidden = selected;
//    self.buttonBlog.hidden = !selected;
//    self.imageViewCountry.hidden = !selected;
//}
//
//- (void)setSpeechButtonSelected:(BOOL)selected {
//#warning TODO: add all speakers event descriptions
//    if (self.events.count) {
//        if (selected) {
//            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[[[self.events firstObject] eventDesc] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            self.textViewInformation.attributedText = attributedString;
//        }
//    }
//    
//    [self.buttonSpeech setBackgroundColor: selected ? [UIColor whiteColor] : [UIColor blackColor]];
//    [self.buttonSpeech setTitleColor:selected ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
//    self.labelTileAndLocation.hidden = !selected;
//    self.labelMainTitle.hidden = !selected;
//    self.buttonBlog.hidden = selected;
//    self.imageViewCountry.hidden = selected;
//}

//- (void)setUpInfo {
//    
//    // Small UI improvements
//    [self.buttonTwitter.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.buttonBookmark.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    
//    
//    // Speaker Info
//    self.labelSpeakerName.text = self.pSpeaker.name;
//    self.labelWorkPlace.text = self.pSpeaker.company;
//    
//    UIImage *profileImage = [UIImage imageNamed:[NSString stringWithFormat:@"speaker_%@",self.pSpeaker.speakerID]];
//    self.imageViewProfile.image = (profileImage) ? profileImage : [UIImage imageNamed:@"speaker_0"];
//    UIImage *backstageImage = [UIImage imageNamed:[NSString stringWithFormat:@"backstage_%@.jpeg",self.pSpeaker.speakerID]];
//    self.imageViewBackground.image = (backstageImage) ? backstageImage : [UIImage imageNamed:@"backstage_1.jpeg"];
//    [self.buttonBlog setTitle:[self getBlogAndURLSrting] forState:UIControlStateNormal];
//    [self.imageViewCountry setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.pSpeaker.country]]];
//    
//#warning TODO: add all speakers event descriptions
//    if (self.events.count == 1) {
//        Event *event = [self.events firstObject];
//        [self.buttonBookmark setImage:[event.isFavorite boolValue] ? [[DataManager sharedInstance] getInActiveBookmarkImageForInfo:YES] : [[DataManager sharedInstance] getActiveBookmarkImage] forState:UIControlStateNormal];
//        // Evnet Info
//        self.labelTileAndLocation.text = [self getTimeAndLocationStringForEvent:event];
//        self.labelMainTitle.text = event.subtitle;
//        
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[event.eventDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        self.textViewInformation.attributedText = attributedString;
//    }
//}
//
//- (NSString *)getTimeAndLocationStringForEvent:(Event *)event {
//    return [NSString stringWithFormat:@"%@ - %@, %@", event.interval.startTime, event.interval.endTime, event.room.name];
//}
//
//- (NSString *)getBlogAndURLSrting {
//    if (self.pSpeaker.blogURL)  {
//        return [NSString stringWithFormat:@"Blog %@", self.pSpeaker.blogURL];
//    }
//    return @"";
//}
//
//- (void)refreshSpeakerSpeachForward:(BOOL)forward {
//    if (!self.imageViewCountry.hidden) return; // not update speach while in info
//    //
//    //    NSArray *events = [[DataManager sharedInstance] getEventsForSpeakerWithID:self.speaker.speakerID];
//    //    int arrayCount = (int)[events count];
//    //    int startPossition = (int)[events indexOfObject:_event];
//    //    self.reloadedObject = nil;
//    //
//    //    if (forward) { // swipe left
//    //        for (; startPossition < arrayCount; startPossition++) {
//    //            Event *event = [events objectAtIndex:startPossition];
//    //            if (![event isEqual:_event]) {
//    //                self.reloadedObject = event;
//    //            }
//    //        }
//    //    } else { // swipe right
//    //        for (; startPossition >= 0; startPossition--) {
//    //            Event *event = [events objectAtIndex:startPossition];
//    //            if (![event isEqual:_event]) {
//    //                self.reloadedObject = event;
//    //            }
//    //        }
//    //    }
//    //    if (self.reloadedObject){
//    //        [self viewDidLoad];
//    //    }
//}

@end
