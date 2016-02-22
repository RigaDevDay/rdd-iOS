//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 22/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "SpeakerInfoViewController.h"
#import "DataManager.h"
#import "WebserviceManager.h"

@interface SpeakerInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iboProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *iboNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboJobTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iboLinkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *iboTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *iboBlogButton;
@property (weak, nonatomic) IBOutlet UITextView *iboAboutTexxtView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *iboActivityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iboDescViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iboJobLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iboImageHeight;

@end

@implementation SpeakerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.iboLinkedInButton.hidden = !self.speaker.linkedInURL.length;
    self.iboBlogButton.hidden = !self.speaker.blogURL.length;
    self.iboTwitterButton.hidden = !self.speaker.twitterURL.length;
    
    self.title = self.speaker.name;
    self.iboNameLabel.text = self.speaker.name;
    self.iboJobTitleLabel.text = [NSString stringWithFormat:@"%@ at %@", self.speaker.jobTitle, self.speaker.company];
    self.iboAboutTexxtView.attributedText = [[DataManager sharedInstance] attributedStringFromHtml:self.speaker.speakerDesc withFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
//    [self.iboAboutTexxtView sizeToFit];
    [self.iboDescViewHeight setConstant:[self.iboAboutTexxtView sizeThatFits:CGSizeMake(self.view.frame.size.width - 22.0, CGFLOAT_MAX)].height];
    [self.iboJobTitleLabel sizeToFit];
    [self.iboProfileImageView.superview layoutIfNeeded];
    
    [self.iboActivityIndicator startAnimating];
    [[WebserviceManager sharedInstance] loadImage:self.speaker.imgPath withCompletionBlock:^(id data) {
        
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.iboActivityIndicator stopAnimating];
                self.iboProfileImageView.image = image;
                // calculate the correct height of the image given the current width of the image view.
                CGFloat multiplier = (CGRectGetWidth(self.iboProfileImageView.bounds) / image.size.width);
                
                // update the height constraint with the new known constant (height)
                [self.iboImageHeight setConstant:multiplier * image.size.height];
                [self.iboProfileImageView.superview layoutIfNeeded];
            });
        }
    } andErrorBlock:^(NSError *error) {
        self.iboProfileImageView.image = [UIImage imageNamed:@""];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action methods

- (IBAction)linkedInButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.speaker.linkedInURL]];
}

- (IBAction)twitterButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", self.speaker.twitterURL]]];
}

- (IBAction)blogButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.speaker.blogURL]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
