//
//  VenuePageViewController.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 23/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "VenuePageViewController.h"
#import "CAPSPageMenu.h"
#import "VenueViewController.h"
#import "UIColor+App.h"
#import "SWRevealViewController.h"
#import "Venue.h"
#import "DataManager.h"

@interface VenuePageViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iboMenuButton;
@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation VenuePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.iboMenuButton.target = self.revealViewController;
    self.iboMenuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self p_initViewControllers];
}

- (void)p_initViewControllers {
    [_pageMenu.view removeFromSuperview];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    NSArray *venues = [[DataManager sharedInstance] allVenues];
    for (Venue *venue in venues) {
        VenueViewController *venueVC =  (VenueViewController*)[storyboard instantiateViewControllerWithIdentifier:@"VenueVC"];
        venueVC.title = venue.name;
        venueVC.venue = venue;
        [controllers addObject:venueVC];
    }

    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor appBlack],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor appOrange],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllers frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
