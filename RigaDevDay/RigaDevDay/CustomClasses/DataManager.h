//
//  DataManager.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EventCategory.h"
#import "SpeakerObject.h"
#import "ScheduleObject.h"

@interface DataManager : NSObject

+ (DataManager *)sharedInstance;

- (NSArray *)getAllSpeakers;
- (NSArray *)getScheduleForHall:(NSInteger)roomID;
- (EventObject *)getEventForSpeakerWithID:(NSInteger)speakerID;


- (void)changeSpeakerBookmarkStateTo:(BOOL)saved forSpeakerID:(NSInteger)speakerID;
- (BOOL)isSpeakerBookmarkedWithID:(NSInteger)speakerID;
- (NSArray *)getAllBookmarkedEvents;


- (UIImage *)getActiveBookmarkImage;
- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo;

- (NSString *)getInfoStoryboardSegue;

@end
