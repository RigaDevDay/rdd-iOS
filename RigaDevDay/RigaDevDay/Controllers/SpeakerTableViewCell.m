//
//  SpeakerTableViewCell.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/24/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "SpeakerTableViewCell.h"

@implementation SpeakerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onBookmarkButtonPress:(id)sender {
    [self.delegate bookmarkButtonPressedOnCell:self];
}

@end
