//
//  SpeakerInfoViewController.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface SpeakerInfoViewController : UIViewController

@property (strong, nonatomic) SpeakerObject *speaker;
@property (strong, nonatomic) EventObject *reloadedObject;

@end
