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

@interface VenueViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    BOOL _updateStartLocation;
}
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
    
    _updateStartLocation = NO;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self setupPins];
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
    if(_updateStartLocation) return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1500, 1500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    _updateStartLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
}

- (void)setupPins {
    NSMutableArray* annotations=[[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D rigaPlazaCoord;
    rigaPlazaCoord.latitude = 56.9253666;
    rigaPlazaCoord.longitude = 24.102882;
    
    MKPointAnnotation *rigaPlazaAnnotation = [[MKPointAnnotation alloc] init];
    rigaPlazaAnnotation.coordinate = rigaPlazaCoord;
    rigaPlazaAnnotation.title = @"Riga Plaza";
    rigaPlazaAnnotation.subtitle = @"Conference Place";
    [annotations addObject:rigaPlazaAnnotation];

    [self.mapView addAnnotations:annotations];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}


- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id <MKAnnotation >)annotation
{
    
    if (![annotation subtitle]) return nil;
    static NSString *reuseId = @"StandardPin";
    
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[sender
                                                         dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (aView == nil)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:reuseId];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.canShowCallout = YES;
    }
    
    aView.annotation = annotation;
    
    return aView;   
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", view.annotation.coordinate.latitude,view.annotation.coordinate.longitude];
    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
