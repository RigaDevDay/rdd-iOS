//
//  VenueViewController.m
//  RigaDevDay
//
//  Created by Denis Kaibagarov on 12/23/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

@import MapKit;

#import "VenueViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "SWRevealViewController.h"
#import "DataManager.h"

@interface VenueViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    BOOL _updateStartLocation;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *iboNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *iboWebLinkButton;
@property (weak, nonatomic) IBOutlet UIButton *iboMapButton;
@property (weak, nonatomic) IBOutlet UITextView *iboDescriptionTextView;



@end

@implementation VenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iboNameLabel.text = self.venue.name;
    self.iboAddressLabel.text = self.venue.address;
    self.iboDescriptionTextView.attributedText = [[DataManager sharedInstance] attributedStringFromHtml:self.venue.venueDesc withFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [self.iboWebLinkButton setTitle:self.venue.webURL forState:UIControlStateNormal];
}

- (IBAction)mapButtonTapped:(id)sender {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.venue.googleMapsURL]];
}
- (IBAction)webButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:self.venue.webURL]];
}

@end
