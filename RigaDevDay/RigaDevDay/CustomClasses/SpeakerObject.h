//
//  SpeakerObject.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeakerObject : NSObject

@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSDictionary *contacts;
@property (strong, nonatomic) NSString *country;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger order;
@property (assign, nonatomic) NSInteger type;

@end
