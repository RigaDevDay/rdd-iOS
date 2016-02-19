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

- (void)setEventTagNames:(NSArray *)tags {
    CGFloat width = 0.0;
    UIView *previousView = nil;
    
    // Remove all previuos tags from tag scroll view
    for (UIView *subview in self.iboTagsScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    [previousView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.iboTagsScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    int tag = 0;
    
    for (NSString *eventTag in tags) {
        UIView *tagLabelContainerView = [[UIView alloc] init];
        tagLabelContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tagLabelContainerView.layer.masksToBounds = YES;
        tagLabelContainerView.layer.cornerRadius = 5;
        tagLabelContainerView.backgroundColor = [UIColor lightGrayColor];
        tagLabelContainerView.clipsToBounds = YES;
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.text = eventTag;
        tagLabel.backgroundColor = [UIColor clearColor];
        [tagLabel sizeToFit];
        
        [tagLabelContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [tagLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [tagLabelContainerView addSubview:tagLabel];
        [tagLabelContainerView sizeToFit];
        tagLabelContainerView.tag = tag;
        [self.iboTagsScrollView addSubview:tagLabelContainerView];
        width += tagLabel.frame.size.width + 28;
        
        
        // Center vertically single type label container view in labels container view
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:tagLabelContainerView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.iboTagsScrollView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0
                                                                              constant:0.0];
        // Fixed single type label container view height
        NSArray *labelContainerHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tagLabelView(==20)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{@"tagLabelView" : tagLabelContainerView}];
        
        // Single label container view left spacing to previous label container view
        NSArray *leftLabelContainerSpace = nil;
        if (previousView) {
            leftLabelContainerSpace  = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-(==5)-[tagLabelView]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"tagLabelView" : tagLabelContainerView,
                                                                                         @"previousView" : previousView}];
        } else {
            leftLabelContainerSpace  = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[tagLabelView]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"tagLabelView" : tagLabelContainerView
                                                                                         }];
        }
        
        [self.iboTagsScrollView layoutIfNeeded];
        
        [self.iboTagsScrollView addConstraint:centerYConstraint];
        [self.iboTagsScrollView addConstraints:leftLabelContainerSpace];
        [tagLabelContainerView addConstraints:labelContainerHeight];
        
        NSArray *verticalSpacing = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[tagLabel]-(==0)-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"tagLabel" : tagLabel}];
        NSArray *horizontalSpacing = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[tagLabel]-(==5)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"tagLabel" : tagLabel}];
        [tagLabelContainerView addConstraints:verticalSpacing];
        [tagLabelContainerView addConstraints:horizontalSpacing];

        tag++;
        previousView = tagLabelContainerView;
    }
    
    // Last single label container right space to superview
    if (previousView) {
        [self.iboTagsScrollView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lasttagLabelView]-(5)-|"
                                                 options:0 metrics:nil
                                                   views:@{@"lasttagLabelView":previousView}]];
        width += previousView.bounds.size.width + 5;
    }
    [self.iboTagsScrollView layoutIfNeeded];
}


@end
