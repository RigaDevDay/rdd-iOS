//
//  EventObject.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObject : NSObject

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *subTitle;
@property (assign, nonatomic) NSInteger hallID; // 1, 2, 3, 4, 5
@property (strong, nonatomic) NSMutableArray *speakers;


@end
