//
//  DataManager.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 21/02/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
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
    }
    return self;
}

#pragma mark - Public methods

- (NSAttributedString *)attributedStringFromHtml:(NSString *)html withFont:(UIFont *)font {
    NSDictionary *dictAttrib = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:dictAttrib documentAttributes:nil error:nil];
    [attrib beginEditing];
    
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            // remove old font
            [attrib removeAttribute:NSFontAttributeName range:range];
            //replace your font with new.
            [attrib addAttribute:NSFontAttributeName value:font range:range];
        }
    }];
    [attrib endEditing];
    return attrib;
}

- (void)updateScheduleIfNeededWithData:(NSData *)data {
    [self p_parseDataAndSaveToDB:data];
    
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
}



//- (void)checkForJSONs {
//    
//    //    [_reach stopNotifier];
//    //
//    //    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/58b43589bbe2f24e39f8925117c31c20fac47037/assets/data/main.json"];
//    //
//    //    NSURLRequest *request = [NSURLRequest requestWithURL:url
//    //                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//    //                                         timeoutInterval:3.0];
//    //
//    //    // Get the data
//    //    NSURLResponse *response;
//    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [path firstObject];
//    _schedulePath = [documentsDirectory stringByAppendingPathComponent:@"schedule.json"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:_schedulePath]) {
//        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//        NSString *resourcePath = [bundle pathForResource:@"schedule" ofType:@"json"];
//        NSError *error;
//        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:_schedulePath error:&error];
//        if (error) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//    }
//    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
//    if (![data length]) return;
//    //    [data writeToFile:_schedulePath atomically:YES];
//    
//    [self p_parseDataAndSaveToDB:data];
//}

#pragma mark - Public methods - Day

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

#pragma mark - Public methods - Room

- (Room *)selectedRoom {
    if (!_selectedRoom) {
        // Select first room by default
        _selectedRoom = [self p_roomWithOrder:1];
    }
    return _selectedRoom;
}

- (void)selectRoomWithOrder:(NSInteger)order {
    self.selectedRoom = [self p_roomWithOrder:(int)order];
}

- (NSArray *)roomsForDay:(Day *)day {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ANY days == %@", day]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    //    [request setResultType:NSDictionaryResultType];
    //    [request setPropertiesToFetch:@[@"name"]];
    NSError *error = nil;
    
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return results;
    }
    return @[];
}

#pragma mark - Public methods - Speaker

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

#pragma mark - Public methods - Tag

- (NSArray *)tagNamesForEvent:(Event *)event {
    NSMutableArray *tagNames = [NSMutableArray array];
    for (Tag *tag in event.tags) {
        [tagNames addObject:[tag.name uppercaseString]];
    }
    return tagNames;
}

#pragma mark - Public methods - Event

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

- (NSArray *)allBookmarks {
    NSArray *events  = [NSArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isFavorite == YES"]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"interval.order" ascending:YES]]];
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


#pragma  mark - Private methods

- (NSData *)p_localSchedule {
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
    }
    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
    return data;
}

- (NSData *)p_dataFromJSONFileNamed:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    return jsonData;
}

- (void)p_parseDataAndSaveToDB:(NSData *)data {
    //    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
    if (![data length]) {
        data = [self p_localSchedule];
    }
//     data = [self p_localSchedule];
    
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
        
        
        if ([appDelegate deleteDataBase]) {
            
        }
//        return;
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
                        event.title = (events[0][@"title"]) ? events[0][@"title"] : @"";
                        event.subtitle = (events[0][@"subtitle"]) ? events[0][@"subtitle"] : @"";
                        event.eventDesc = (events[0][@"description"]) ? events[0][@"description"] : @"";
                        event.interval = interval;
                         [appDelegate saveContext];
                        
                        [self p_addSpeakers:events[0][@"speakers"] toEvent:event];
//                         [appDelegate saveContext];
                        [self p_addTags:events[0][@"tags"] toEvent:event];
                        
//                        [appDelegate saveContext];
                    } else {
                        
                        for (NSDictionary *eventDict in events) {
                            Event *event = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Event class])
                                                                         inManagedObjectContext:managedObjectContext];
                            event.subtitle = eventDict[@"subtitle"];
                            event.eventDesc = eventDict[@"description"];
                            event.interval = interval;
//                             [appDelegate saveContext];
                            [self p_addRoomWithName:roomNames[eventCount] order:++eventCount day:day toEvent:event];
//                             [appDelegate saveContext];
                            [self p_addSpeakers:eventDict[@"speakers"] toEvent:event];
//                             [appDelegate saveContext];
                            [self p_addTags:eventDict[@"tags"] toEvent:event];
//                             [appDelegate saveContext];
                        }
                        
                        
                    }
                    [appDelegate saveContext];
                }
            }
            [appDelegate saveContext];
        }
    }
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

- (void)p_addRoomWithName:(NSString *)name order:(int)order day:(Day *)day toEvent:(Event *)event {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Room class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ANY days == %@ AND name LIKE %@ AND order == %@", day, name, [NSNumber numberWithInt:order]]];
    request.fetchLimit = 1;
    NSError *error = nil;
    NSArray *results;
//    @synchronized(appDelegate.managedObjectContext) {
        results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
//    }

    if (!error) {
        if ([results count]) {
            event.room = [results firstObject];
        }
    }
}

- (void)p_addTags:(NSArray *)tags toEvent:(Event *)event {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
                                                    inManagedObjectContext:appDelegate.managedObjectContext];
                tag.name = tagName;
            }
            [event addTagsObject:tag];
        }
    }
}

- (void)p_addSpeakers:(NSArray *)speakers toEvent:(Event *)event {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
}

#pragma mark Bookmarks

- (void)setupBookmarks {
    _bookMarkActive = [UIImage imageNamed:@"icon_bookmark.png"];
    _bookmarkInActive = [UIImage imageNamed:@"icon_menu_bookmark.png"];
    _bookmarkInActiveForInfo = [UIImage imageNamed:@"icon_bookmark_empty.png"];
}

- (UIImage *)getActiveBookmarkImage {
    return _bookMarkActive;
}

- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo {
    if (forInfo) return _bookmarkInActiveForInfo;
    return _bookmarkInActive;
}

@end
