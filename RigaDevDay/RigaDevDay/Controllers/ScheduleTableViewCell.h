//
//  ScheduleTableViewCell.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentationDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentationSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;

@end
