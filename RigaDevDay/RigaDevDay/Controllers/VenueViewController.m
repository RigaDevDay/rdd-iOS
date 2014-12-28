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

@interface VenueViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;


@end

@implementation VenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonMenu.target = self.revealViewController;
    self.buttonMenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView setShowsUserLocation: YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
}

@end
