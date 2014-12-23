//
//  MKMapView+ZoomLevel.h
//  RigaDevDay
//
//  Created by Denis Kaibagarov on 12/23/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end