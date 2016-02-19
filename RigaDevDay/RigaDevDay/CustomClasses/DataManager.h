//
//  DataManager.h
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Interval.h"
#import "Speaker.h"
#import "Day.h"
#import "Room.h"

@interface DataManager : NSObject

+ (DataManager *)sharedInstance;
@property (strong, nonatomic) Day *selectedDay;
@property (strong, nonatomic) Room *selectedRoom;

- (NSArray *)allDays;
- (BOOL)changeFavoriteStatusForEvent:(Event *)event;
- (void)selectRoomWithOrder:(NSInteger)order;
- (NSArray *)allSpeakers;
- (NSArray *)allBookmarks;
- (NSArray *)roomsForDay:(Day *)day;

- (NSArray *)eventsForDay:(Day *)day andRoom:(Room *)room;
- (NSArray *)eventsForDayOrder:(int)dayOrder andRoomOrder:(int)roomOrder;

- (NSArray *)getAllSpeakers;
- (NSArray *)getScheduleForHall:(NSInteger)roomID;
- (Event *)getEventForSpeakerWithID:(NSInteger)speakerID;
- (NSArray *)getEventsForSpeakerWithID:(NSInteger)speakerID;

- (void)changeSpeakerBookmarkStateTo:(BOOL)saved forSpeakerID:(NSInteger)speakerID;
- (BOOL)isSpeakerBookmarkedWithID:(NSInteger)speakerID;
//- (NSArray *)getAllBookmarkedEvents;


- (UIImage *)getActiveBookmarkImage;
- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo;

//- (NSString *)getInfoStoryboardSegue;

- (void)updateScheduleIfNeeded;

@end
