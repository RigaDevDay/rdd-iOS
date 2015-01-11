//
//  ScheduleTableViewCell.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    // Initialization code
//   
//    [self.buttonBookmark.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onBookmarkButtonPress:(id)sender {
    [self.delegate bookmarkButtonPressedOnCell:self];
}

@end
