//
//  DaysTableViewController.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/19/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@class DaysTableViewController;
@protocol DaysTableVCDelegate <NSObject>

- (void)daysTableVC:(DaysTableViewController *)daysVC didSelectDay:(Day *)day;

@end

@interface DaysTableViewController : UIViewController
@property id<DaysTableVCDelegate> delegate;
@end
