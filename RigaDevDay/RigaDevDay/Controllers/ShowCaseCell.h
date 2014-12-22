//
//  ShowCaseCell.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/22/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCaseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *labelPresentationName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBookmark;

@end
