//
//  ScheduleTableViewCell.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScheduleTableViewCell;
@protocol ScheduleTableViewCellDelegate <NSObject>

- (void)bookmarkButtonPressedOnCell:(ScheduleTableViewCell *)cell;

@end

@interface ScheduleTableViewCell : UITableViewCell

@property id<ScheduleTableViewCellDelegate> delegate;
- (void)setEventTagNames:(NSArray *)tags;

@property (weak, nonatomic) IBOutlet UILabel *labelSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentationDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentationSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmark;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *iboTagsScrollView;

@end
