//
//  PageViewController.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 21/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface RoomPageViewController : UIViewController
@property (nonatomic, strong) Event *selectedEvent;
@end
