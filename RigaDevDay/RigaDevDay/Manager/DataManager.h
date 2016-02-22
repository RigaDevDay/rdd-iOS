//
//  DataManager.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 21/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
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

//Day
- (NSArray *)allDays;
- (Day *)dayWithOrder:(NSInteger)order;

//Event
- (BOOL)changeFavoriteStatusForEvent:(Event *)event;
- (NSArray *)allBookmarks;
- (NSArray *)eventsForDay:(Day *)day andRoom:(Room *)room;
- (NSAttributedString *)attributedStringFromHtml:(NSString *)html withFont:(UIFont *)font;

//Room
- (void)selectRoomWithOrder:(NSInteger)order;
- (NSArray *)roomsForDay:(Day *)day;

//Tag
- (NSArray *)tagNamesForEvent:(Event *)event;

//Speaker
- (NSArray *)allSpeakers;
- (NSString *)speakerStringFromSpeakers:(NSSet *)speakers;

//Bookmark images
- (UIImage *)getActiveBookmarkImage;
- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo;

- (void)updateScheduleIfNeededWithData:(NSData *)data;

@end
