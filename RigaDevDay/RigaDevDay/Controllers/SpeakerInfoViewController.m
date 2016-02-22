//
//  SpeakerInfoViewController.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 22/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "SpeakerInfoViewController.h"
#import "DataManager.h"

@interface SpeakerInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iboProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *iboNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboJobTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iboLinkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *iboTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *iboBlogButton;
@property (weak, nonatomic) IBOutlet UITextView *iboAboutTexxtView;

@end

@implementation SpeakerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.iboNameLabel.text = self.speaker.name;
    self.iboJobTitleLabel.text = [NSString stringWithFormat:@"%@ at %@", self.speaker.jobTitle, self.speaker.company];
    self.iboAboutTexxtView.attributedText = [[DataManager sharedInstance] attributedStringFromHtml:self.speaker.speakerDesc withFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action methods

- (IBAction)linkedInButtonTapped:(id)sender {
#warning Add linkedIn

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
