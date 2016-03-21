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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *iboActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *iboSpeakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *iboNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iboInfoLabel;

@end
