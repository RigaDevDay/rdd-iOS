/*
 Copyright (c) 2014 The Board of Trustees of The University of Alabama All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the University nor the names of the contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
//
//  CAPSPageMenu.h
//  
//
//  Created by Jin Sasaki on 2015/05/30.
//
//

#import <UIKit/UIKit.h>

@class CAPSPageMenu;

#pragma mark - Delegate functions
@protocol CAPSPageMenuDelegate <NSObject>

@optional
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index;
@end

@interface MenuItemView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *menuItemSeparator;

- (void)setUpMenuItemView:(CGFloat)menuItemWidth menuScrollViewHeight:(CGFloat)menuScrollViewHeight indicatorHeight:(CGFloat)indicatorHeight separatorPercentageHeight:(CGFloat)separatorPercentageHeight separatorWidth:(CGFloat)separatorWidth separatorRoundEdges:(BOOL)separatorRoundEdges menuItemSeparatorColor:(UIColor *)menuItemSeparatorColor;

- (void)setTitleText:(NSString *)text;

@end

@interface CAPSPageMenu : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIScrollView *controllerScrollView;

@property (nonatomic, readonly) NSArray *controllerArray;
@property (nonatomic, readonly) NSArray *menuItems;
@property (nonatomic, readonly) NSArray *menuItemWidths;

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) NSInteger lastPageIndex;

@property (nonatomic) CGFloat menuHeight;
@property (nonatomic) CGFloat menuMargin;
@property (nonatomic) CGFloat menuItemWidth;
@property (nonatomic) CGFloat selectionIndicatorHeight;
@property (nonatomic) NSInteger scrollAnimationDurationOnMenuItemTap;

@property (nonatomic) UIColor *selectionIndicatorColor;
@property (nonatomic) UIColor *selectedMenuItemLabelColor;
@property (nonatomic) UIColor *unselectedMenuItemLabelColor;
@property (nonatomic) UIColor *scrollMenuBackgroundColor;
@property (nonatomic) UIColor *viewBackgroundColor;
@property (nonatomic) UIColor *bottomMenuHairlineColor;
@property (nonatomic) UIColor *menuItemSeparatorColor;

@property (nonatomic) UIFont *menuItemFont;
@property (nonatomic) CGFloat menuItemSeparatorPercentageHeight;
@property (nonatomic) CGFloat menuItemSeparatorWidth;
@property (nonatomic) BOOL menuItemSeparatorRoundEdges;

@property (nonatomic) BOOL addBottomMenuHairline;
@property (nonatomic) BOOL menuItemWidthBasedOnTitleTextWidth;
@property (nonatomic) BOOL useMenuLikeSegmentedControl;
@property (nonatomic) BOOL centerMenuItems;
@property (nonatomic) BOOL enableHorizontalBounce;
@property (nonatomic) BOOL hideTopMenuBar;

@property (nonatomic, weak) id <CAPSPageMenuDelegate> delegate;

- (void)addPageAtIndex:(NSInteger)index;
- (void)moveToPage:(NSInteger)index;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options;

extern NSString * const CAPSPageMenuOptionSelectionIndicatorHeight;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorWidth;
extern NSString * const CAPSPageMenuOptionScrollMenuBackgroundColor;
extern NSString * const CAPSPageMenuOptionViewBackgroundColor;
extern NSString * const CAPSPageMenuOptionBottomMenuHairlineColor;
extern NSString * const CAPSPageMenuOptionSelectionIndicatorColor;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorColor;
extern NSString * const CAPSPageMenuOptionMenuMargin;
extern NSString * const CAPSPageMenuOptionMenuHeight;
extern NSString * const CAPSPageMenuOptionSelectedMenuItemLabelColor;
extern NSString * const CAPSPageMenuOptionUnselectedMenuItemLabelColor;
extern NSString * const CAPSPageMenuOptionUseMenuLikeSegmentedControl;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorRoundEdges;
extern NSString * const CAPSPageMenuOptionMenuItemFont;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorPercentageHeight;
extern NSString * const CAPSPageMenuOptionMenuItemWidth;
extern NSString * const CAPSPageMenuOptionEnableHorizontalBounce;
extern NSString * const CAPSPageMenuOptionAddBottomMenuHairline;
extern NSString * const CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth;
extern NSString * const CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap;
extern NSString * const CAPSPageMenuOptionCenterMenuItems;
extern NSString * const CAPSPageMenuOptionHideTopMenuBar;

@end
