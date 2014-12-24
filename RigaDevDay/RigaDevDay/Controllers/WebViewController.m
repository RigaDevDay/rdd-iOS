//
//  WebViewController.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonMenu.target = self;
    self.buttonMenu.action = @selector(backButtonPress);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
