//
//  SpeakerTableViewCell.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpeakerTableViewCell;
@protocol SpeakerTableViewCellDelegate <NSObject>

- (void)bookmarkButtonPressedOnCell:(SpeakerTableViewCell *)cell;

@end

@interface SpeakerTableViewCell : UITableViewCell

@property id<SpeakerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentation;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmark;

@end
