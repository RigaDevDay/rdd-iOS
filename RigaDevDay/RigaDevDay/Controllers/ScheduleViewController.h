//
//  ScheduleViewController.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface ScheduleViewController : UIViewController
@property (nonatomic, strong) PageViewController *pageVC;
@property (nonatomic, strong) NSArray *events;
@end
