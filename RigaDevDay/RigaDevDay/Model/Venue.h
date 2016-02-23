//
//  Venue.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 23/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *webURL;
@property (strong, nonatomic) NSString *venueDesc;
@property (strong, nonatomic) NSString *googleMapsURL;

@end
