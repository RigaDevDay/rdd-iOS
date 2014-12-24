//
//  EventCategory.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventObject.h"

@interface EventCategory : NSObject

@property (strong, nonatomic) NSMutableArray *events;
@property (assign, nonatomic) NSInteger order;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@end
