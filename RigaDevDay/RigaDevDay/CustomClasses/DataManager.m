//
//  DataManager.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "DataManager.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Speaker.h"
#import "Event.h"
#import "Day.h"
#import "Interval.h"
#import "Tag.h"
#import "Room.h"

#define SCHEDULE_VERSION_KEY @"scheduleVersion"
#define SPEAKERS_VERSION_KEY @"speakersVersion"

@interface DataManager () {
    NSMutableArray *_speakersArray;
    NSMutableArray *_eventsCategoryArray;
    NSMutableSet *_bookmarkedSpeakers;
    
    UIImage *_bookMarkActive;
    UIImage *_bookmarkInActive;
    UIImage *_bookmarkInActiveForInfo;
    
    NSString *_schedulePath;
    NSString *_speakersPath;
    Reachability* _reach;
}

@end

@implementation DataManager

+ (DataManager *)sharedInstance {
    static DataManager *_sharedClient = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //        [self updateScheduleIfNeeded];
    }
    return self;
}

- (NSArray *)allSpeakers {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Speaker class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return @[];
}

- (Day *)selectedDay {
    if (!_selectedDay) {
        // Select first day by default
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Day class]) inManagedObjectContext: appDelegate.managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"order == 1"]];
        request.fetchLimit = 1;
        NSError *error = nil;
        
        NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        if (!error) {
            if ([results count]) {
                _selectedDay = [results firstObject];
            }
        }
    }
    return _selectedDay;
}
- (Room *)selectedRoom {
    if (!_selectedRoom) {
        // Select first room by default
        _selectedRoom = [self p_roomWithOrder:1];
    }
    return _selectedRoom;
}

- (Room *)p_roomWithOrder:(int)order {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ANY days == %@ && order == %@", self.selectedDay, [NSNumber numberWithInt:order]]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count]) {
             return [results firstObject];
        }
    }
    return nil;
}

- (NSString *)speakerStringFromSpeakers:(NSSet *)speakers {
    NSString *returnString = @"";
    if (speakers.count == 1) {
        return [[speakers anyObject] name];
    } else {
        for (int i = 0; i < speakers.count; i++) {
            Speaker *speaker = [speakers allObjects][i];
            if (speakers.count - 1  == i) {
                returnString = [returnString stringByAppendingFormat:@"%@",speaker.name];
            } else {
                returnString = [returnString stringByAppendingFormat:@"%@, ",speaker.name];
            }
            
        }
    }
    return returnString;
}

- (NSArray *)tagNamesForEvent:(Event *)event {
    NSMutableArray *tagNames = [NSMutableArray array];
    for (Tag *tag in event.tags) {
        [tagNames addObject:[tag.name uppercaseString]];
    }
    return tagNames;
}

- (Day *)dayWithOrder:(NSInteger)order {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Day class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"order == %@", [NSNumber numberWithInteger:order]]];
    request.fetchLimit = 1;
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count]) {
            return [results firstObject];
        }
    }
    return nil;
}

- (NSArray *)roomsForDay:(Day *)day {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ANY days == %@", day]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:@[@"name"]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return @[];
}

- (NSArray *)allDays {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Day class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return @[];
}

- (NSArray *)allBookmarks {
    NSArray *events  = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isFavorite == YES"]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"interval.order" ascending:YES]]];
//    [request setResultType:NSDictionaryResultType];
//     [request setPropertiesToFetch:@[@"title", @"subtitle", @"eventDesc", @"interval.startTime", @"interval.endTime", @"room.name", @"interval.day.title"]];
//    [request setPropertiesToGroupBy:@[@"interval.day.order", @"room.order", @"subtitle", @"title", @"eventDesc", @"interval.startTime", @"interval.endTime", @"room.name", @"interval.day.title"]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return events;
}

- (BOOL)changeFavoriteStatusForEvent:(Event *)event {
    event.isFavorite = [NSNumber numberWithBool:![event.isFavorite boolValue]];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    return [event.isFavorite boolValue];
}


- (NSArray *)eventsForDay:(Day *)day andRoom:(Room *)room {
    NSArray *events  = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"interval.day = %@ && (room = %@ || room == nil)", day, room]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"interval.order" ascending:YES]]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return events;
}

- (void)selectRoomWithOrder:(NSInteger)order {
    self.selectedRoom = [self p_roomWithOrder:(int)order];
}

//- (NSArray *)eventsForDayOrder:(int)dayOrder andRoomOrder:(int)roomOrder {
//    NSArray *events  = [NSArray array];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext: appDelegate.managedObjectContext]];
//    //    [request setPredicate:[NSPredicate predicateWithFormat:@"room.order == %@ AND interval.day.order == %@", roomOrder, dayOrder]];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"room.order = %@ && interval.day.order = %@", [NSNumber numberWithInt:roomOrder], [NSNumber numberWithInt:dayOrder]]];
//    NSError *error = nil;
//    
//    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
//    if (!error) {
//        return results;
//    }
//    return events;
//}

- (NSData *)dataFromJSONFileNamed:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    return jsonData;
}


- (NSArray *)getAllSpeakers {
    return _speakersArray;
}

- (void)parseData:(NSData *)data {
    _eventsCategoryArray = [NSMutableArray new];
    //    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
    //    if (![data length]) return;
    
    // Now create a NSDictionary from the JSON data
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        
        
        NSString *currentScheduleVersion = [[NSUserDefaults standardUserDefaults] stringForKey:SCHEDULE_VERSION_KEY];
        //Update Version
        NSString *latestScheduleVersion = [jsonDict[@"version"] stringValue];
        
        
        if (![currentScheduleVersion isEqualToString:latestScheduleVersion]) {
            // Save latest version
            [[NSUserDefaults standardUserDefaults] setValue:latestScheduleVersion forKey:SCHEDULE_VERSION_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //Parse new data
            NSArray *speakers = jsonDict[@"speakers"];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
            for (NSDictionary *speakerDict in speakers) {
                Speaker *speaker = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Speaker class])
                                                                 inManagedObjectContext:managedObjectContext];
                speaker.speakerID =  [NSNumber numberWithInteger:[speakerDict[@"id"] integerValue]];
                speaker.name = speakerDict[@"name"];
                speaker.country = speakerDict[@"country"];
                speaker.company = speakerDict[@"company"];
                speaker.jobTitle = (speakerDict[@"title"]) ? speakerDict[@"title"] : @"";
                speaker.imgPath = speakerDict[@"img"];
                speaker.twitterURL = (speakerDict[@"twitter"]) ? speakerDict[@"twitter"] : @"";
                speaker.blogURL = (speakerDict[@"blog"]) ? speakerDict[@"blog"] : @"";
                speaker.speakerDesc = speakerDict[@"description"];
            }
            [appDelegate saveContext];
            
            
            NSArray *days = jsonDict[@"days"];
            int order = 1;
            for (NSDictionary *dayDict in days) {
                Day *day = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Day class])
                                                         inManagedObjectContext:managedObjectContext];
                day.order = [NSNumber numberWithInt:order];
                order++;
                day.title = dayDict[@"title"];
                //                day.date = dayDict[@"date"];
                
                NSDictionary *scheduleDict = dayDict[@"schedule"];
                NSArray *roomNames = scheduleDict[@"roomNames"];
                int roomOrder = 1;
                
                for (NSString *roomName in roomNames) {
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    
                    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@ && order == %@", roomName, [NSNumber numberWithInt:roomOrder]]];
                    request.fetchLimit = 1;
                    NSError *error = nil;
                    
                    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
                    if (!error) {
                        Room *room;
                        if ([results count]) {
                            room = [results firstObject];
                        } else {
                            room = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Room class])
                                                                 inManagedObjectContext:managedObjectContext];
                            room.name = roomName;
                            room.order = [NSNumber numberWithInt:roomOrder];
                          
                        }
                        roomOrder++;
                        [room addDaysObject:day];
                        [appDelegate saveContext];
                    }
                    
                }
                
     
                
                NSArray *intervals = scheduleDict[@"schedule"];
                int intervalOrder = 1;
                for (NSDictionary *intervalDict in intervals) {
                    Interval *interval = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Interval class])
                                                                       inManagedObjectContext:managedObjectContext];
                    interval.order = [NSNumber numberWithInt:intervalOrder];
                    intervalOrder++;
                    interval.startTime = intervalDict[@"time"];
                    interval.endTime = intervalDict[@"endTime"];
                    interval.day = day;
                    
                    [appDelegate saveContext];
                    
                    int eventCount = 0;
                    NSArray *events = intervalDict[@"events"];
                    
                    if (events.count == 1) {
                        Event *event = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Event class])
                                                                     inManagedObjectContext:managedObjectContext];
                        event.title = events[0][@"title"];
                        event.subtitle = (events[0][@"subtitle"]) ? events[0][@"subtitle"] : nil;
                        event.interval = interval;
                        [appDelegate saveContext];
                    } else {
                        
                        for (NSDictionary *eventDict in events) {
                            Event *event = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Event class])
                                                                         inManagedObjectContext:managedObjectContext];
                            event.subtitle = eventDict[@"subtitle"];
                            event.eventDesc = eventDict[@"description"];
                            event.interval = interval;
                            
                            NSFetchRequest *request = [[NSFetchRequest alloc] init];
                            
                            [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
                            [request setPredicate:[NSPredicate predicateWithFormat:@"ANY days == %@ AND name LIKE %@ AND order == %@", day, roomNames[eventCount], [NSNumber numberWithInt:eventCount+1]]];
                            eventCount++;
                            request.fetchLimit = 1;
                            NSError *error = nil;
                            
                            NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
                            if (!error) {
                                if ([results count]) {
                                    event.room = [results firstObject];
                                }
                            }
                            [appDelegate saveContext];
                            
                            NSArray *speakers = eventDict[@"speakers"];
                            for (int i = 0; i < speakers.count; i++) {
                                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                
                                [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Speaker class]) inManagedObjectContext: appDelegate.managedObjectContext]];
                                [request setPredicate:[NSPredicate predicateWithFormat:@"speakerID == %@", speakers[i]]];
                                request.fetchLimit = 1;
                                NSError *error = nil;
                                
                                NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
                                if (!error) {
                                    if ([results count]) {
                                        [event addSpeakersObject:[results firstObject]] ;
                                    }
                                }
                            }
                            [appDelegate saveContext];
                            
                            NSArray *tags = eventDict[@"tags"];
                            for (NSString *tagName in tags) {
                                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                
                                [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Tag class]) inManagedObjectContext: appDelegate.managedObjectContext]];
                                [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", tagName]];
                                request.fetchLimit = 1;
                                NSError *error = nil;
                                
                                NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
                                if (!error) {
                                    Tag *tag;
                                    if ([results count]) {
                                        tag  = [results firstObject];
                                    } else {
                                        tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tag class])
                                                                            inManagedObjectContext:managedObjectContext];
                                        tag.name = tagName;
                                    }
                                    [event addTagsObject:tag];
                                }
                            }
                            [appDelegate saveContext];
                        }
                    }
                }
            }
            [appDelegate saveContext];
        }
    }
}

- (NSArray *)scheduleForHall:(Room *)room andDay:(Day *)day {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"room == %@ AND ANY interval.day == %@", room, day]];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return nil;
}

//- (Event *)getEventForSpeakerWithID:(NSInteger)speakerID {
//    for (Interval *eCategory in _eventsCategoryArray) {
//        for (Event *event in eCategory.events) {
//            for (Speaker *speaker in event.speakers) {
//                if (speaker.speakerID == speakerID) return event;
//            }
//        }
//    }
//    return nil;
//}
//
//- (NSArray *)getEventsForSpeakerWithID:(NSInteger)speakerID {
//    NSMutableArray *array = [NSMutableArray new];
//
//    for (Interval *eCategory in _eventsCategoryArray) {
//        for (Event *event in eCategory.events) {
//            for (Speaker *speaker in event.speakers) {
//                if (speaker.speakerID == speakerID) [array addObject:event];
//            }
//        }
//    }
//
//    return [array copy];
//}

//- (NSArray *)getScheduleForFirstHall {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        [returnArray addObject:eCategory.events[0]];
//    }
//    return returnArray;
//}
//
//- (NSArray *)getScheduleForSecondHall {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[1] : eCategory.events[0]];
//    }
//    return returnArray;
//}
//
//- (NSArray *)getScheduleForThirdHall {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[2] : eCategory.events[0]];
//    }
//    return returnArray;
//}
//
//- (NSArray *)getScheduleForFourthHall {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[3] : eCategory.events[0]];
//    }
//    return returnArray;
//}
//
//- (NSArray *)getScheduleForFifthhHall {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[4] : eCategory.events[0]];
//    }
//    return returnArray;
//}

#pragma mark Bookmarks

- (void)setupBookmarks {
    NSArray *bookmarks = (NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"BookmarksArrayKey"];
    if (!bookmarks) {
        _bookmarkedSpeakers = [NSMutableSet new];
    } else {
        _bookmarkedSpeakers = [NSMutableSet setWithArray:bookmarks];
    }
    
    _bookMarkActive = [UIImage imageNamed:@"icon_bookmark.png"];
    _bookmarkInActive = [UIImage imageNamed:@"icon_menu_bookmark.png"];
    _bookmarkInActiveForInfo = [UIImage imageNamed:@"icon_bookmark_empty.png"];
}

- (void)changeSpeakerBookmarkStateTo:(BOOL)saved forSpeakerID:(NSInteger)speakerID {
    
    if (saved) {
        [_bookmarkedSpeakers addObject:[NSNumber numberWithLong:speakerID]];
    } else {
        [_bookmarkedSpeakers removeObject:[NSNumber numberWithLong:speakerID]];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[_bookmarkedSpeakers allObjects]  forKey:@"BookmarksArrayKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isSpeakerBookmarkedWithID:(NSInteger)speakerID {
    return [_bookmarkedSpeakers containsObject:[NSNumber numberWithLong:speakerID]];
}

//- (NSArray *)getAllBookmarkedEvents {
//    NSMutableArray *returnArray = [NSMutableArray new];
//    for (Interval *eCategory in _eventsCategoryArray) {
//        for (Event *event in eCategory.events) {
//            for (Speaker *speaker in event.speakers) {
//                if ([_bookmarkedSpeakers containsObject:[NSNumber numberWithLong:speaker.speakerID]]) {
//                    [returnArray addObject:event];
//                }
//            }
//        }
//    }
//    return returnArray;
//}

- (UIImage *)getActiveBookmarkImage {
    return _bookMarkActive;
}

- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo {
    if (forInfo) return _bookmarkInActiveForInfo;
    return _bookmarkInActive;
}

//- (NSString *)getInfoStoryboardSegue {
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        CGSize result = [[UIScreen mainScreen] bounds].size;
//        CGFloat scale = [UIScreen mainScreen].scale;
//        result = CGSizeMake(result.width * scale, result.height * scale);
//
//        if(result.height == 1136){
//            return @"SPEAKER_SPEECH_INFO_SEGUEUE_4";
//
//        } else if(result.height == 1334){
//            return @"SPEAKER_SPEECH_INFO_SEGUEUE_4.7";
//        } else if(result.height == 2208){
//            return @"SPEAKER_SPEECH_INFO_SEGUEUE_5.5";
//        } else if(result.height == 960){
//            return @"SPEAKER_SPEECH_INFO_SEGUEUE_3.5";
//        }
//
//    } else {
//        return @"SPEAKER_SPEECH_INFO_SEGUEUE_ipad";
//    }
//    return nil;
//}

- (void)updateScheduleIfNeeded {
    [self checkForJSONs];
    // Copy to drive in needed
    //    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [path firstObject];
    //    _schedulePath = [documentsDirectory stringByAppendingPathComponent:@"schedule.json"];
    //
    //    // Check for schedule
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:_schedulePath]) {
    //        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    //        NSString *resourcePath = [bundle pathForResource:@"schedule" ofType:@"json"];
    //        NSError *error;
    //        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:_schedulePath error:&error];
    //        if (error) {
    //            NSLog(@"%@", [error localizedDescription]);
    //        }
    //        // update user defines
    //        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:SCHEDULE_VERSION_KEY];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
    
    
    
    
    //    // Check for Interner
    //    if(!_reach) {
    //        _reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    //    }
    //    // Set the blocks
    //    _reach.reachableBlock = ^(Reachability*reach)
    //    {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            NSLog(@"REACHABLE!");
    ////            [self checkForJSONs];
    //        });
    //    };
    //
    //    [_reach startNotifier];
    
    
    // Download JSON
    // Parse JSON
    // Check with Local Version
}

- (void)checkForJSONs {
    
    //    [_reach stopNotifier];
    //
    //    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/58b43589bbe2f24e39f8925117c31c20fac47037/assets/data/main.json"];
    //
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url
    //                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
    //                                         timeoutInterval:3.0];
    //
    //    // Get the data
    //    NSURLResponse *response;
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path firstObject];
    _schedulePath = [documentsDirectory stringByAppendingPathComponent:@"schedule.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_schedulePath]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *resourcePath = [bundle pathForResource:@"schedule" ofType:@"json"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:_schedulePath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        //            // update user defines
        //            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:SCHEDULE_VERSION_KEY];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
    if (![data length]) return;
    //    [data writeToFile:_schedulePath atomically:YES];
    
    [self parseData:data];
    
    
}

@end
