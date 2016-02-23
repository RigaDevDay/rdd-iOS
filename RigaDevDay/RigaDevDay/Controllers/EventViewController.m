//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "EventViewController.h"
#import "SWRevealViewController.h"
#import "SpeakerInfoViewController.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *iboScrollView;
@property (weak, nonatomic) IBOutlet UILabel *iboTimeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboEventTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *iboEventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboSpeakersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iboImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iboTextViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *iboFirstSpeakerButton;
@property (weak, nonatomic) IBOutlet UILabel *iboAndLabel;
@property (weak, nonatomic) IBOutlet UIButton *iboSecondSpeakerButton;

@property (nonatomic, strong) Speaker *pSelectedSpeaker;
@property (strong, nonatomic) NSArray *pSpeakers;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
}

- (void)p_setupUI {
    self.title = @"Event";
    self.iboTimeLocationLabel.text = (self.event.room) ? [NSString stringWithFormat:@"%@ - %@, %@", self.event.interval.startTime, self.event.interval.endTime, self.event.room.name] : [NSString stringWithFormat:@"%@ - %@", self.event.interval.startTime, self.event.interval.endTime];
    self.iboEventTitleLabel.text = (self.event.title.length) ? self.event.title : self.event.subtitle;
    self.iboEventDescriptionLabel.attributedText = [[DataManager sharedInstance] attributedStringFromHtml:self.event.eventDesc withFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self.iboEventDescriptionLabel sizeToFit];
    self.iboSpeakersLabel.text = [[DataManager sharedInstance] speakerStringFromSpeakers:self.event.speakers];
    UIImage *backstageImage = [UIImage imageNamed:[NSString stringWithFormat:@"backstage_%@.jpeg",self.event.interval.order]];
    self.iboImageView.image = (backstageImage) ? backstageImage : [UIImage imageNamed:@"backstage_1.jpeg"];
    self.pSpeakers = [self.event.speakers allObjects];
    //    [self.iboEventDescriptionLabel sizeToFit];
    //    [self.iboTextViewHeight setConstant:self.iboEventDescriptionLabel.contentSize.height];
    [self.iboTextViewHeight setConstant:[self.iboEventDescriptionLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 20.0, CGFLOAT_MAX)].height];
    if ([self.pSpeakers count] == 1) {
        self.iboFirstSpeakerButton.hidden = NO;
         [self.iboFirstSpeakerButton setTitle:[self.pSpeakers[0] name] forState:UIControlStateNormal];
        self.iboSecondSpeakerButton.hidden = YES;
        self.iboAndLabel.hidden = YES;
    }  else if ([self.pSpeakers count] == 2) {
        self.iboFirstSpeakerButton.hidden = NO;
        [self.iboFirstSpeakerButton setTitle:[self.pSpeakers[0] name] forState:UIControlStateNormal];
        self.iboSecondSpeakerButton.hidden = NO;
        [self.iboSecondSpeakerButton setTitle:[self.pSpeakers[1] name] forState:UIControlStateNormal];
        self.iboAndLabel.hidden = NO;
    } else {
        self.iboFirstSpeakerButton.hidden = YES;
        self.iboSecondSpeakerButton.hidden = YES;
        self.iboAndLabel.hidden = YES;
    }
    [self.iboScrollView layoutIfNeeded];
}

- (IBAction)firstSpeakerButtonTapped:(id)sender {
    self.pSelectedSpeaker = [self.pSpeakers firstObject];
    [self performSegueWithIdentifier:@"SpeakerSegue" sender:nil];
}

- (IBAction)secondSpeakerButtonTapped:(id)sender {
    self.pSelectedSpeaker = [self.pSpeakers objectAtIndex:1];
    [self performSegueWithIdentifier:@"SpeakerSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SpeakerInfoViewController *destController = [segue destinationViewController];
    destController.speaker = self.pSelectedSpeaker;
}


@end
