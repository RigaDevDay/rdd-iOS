//
//  TwitterViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 1/11/15.
//  Copyright (c) 2015 Deniss Kaibagarovs. All rights reserved.
//

@import Social;
#import "TwitterViewController.h"
#import "SWRevealViewController.h"

@interface TwitterViewController () <UIWebViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@end

@implementation TwitterViewController


- (void)viewDidLoad {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mobile.twitter.com/rigadevday"]]];
    [self.activityIndicator startAnimating];
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onTweetButton:(id)sender {
    [self shareTwitterInViewController:self andText:@"@rigadevday "];
}

- (void)shareTwitterInViewController:(UIViewController *)viewController andText:(NSString *)text {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:text];
        [viewController presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter account" message:@"Please, sign into your twitter account in settings" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
////    if (buttonIndex == 0) {
////        // Cancel
////    } else {
////        if (&UIApplicationOpenSettingsURLString != NULL) {
////            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
////            [[UIApplication sharedApplication] openURL:appSettings];
////        }
////    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator removeFromSuperview];
}

@end
