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
#import "Venue.h"

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
}

#pragma mark - Public methods - Venue

- (NSArray *)allVenues {
    NSMutableArray *venues = [NSMutableArray array];
    Venue *venue1 = [[Venue alloc] init];
    venue1.name = @"Kino Citadele";
    venue1.venueDesc = @"Kino Citadele - main conference venue, the largest cinema complex in the very centre of Riga.";
    venue1.address = @"13 Janvara street, 8";
    venue1.webURL = @"http://www.forumcinemas.lv";
    venue1.googleMapsURL = @"https://www.google.com/maps/place/Forum+Cinemas+%22Kino+Citadele%22/@56.9461196,24.1147513,17z/data=!3m1!4b1!4m2!3m1!1s0x46eecfd48a65f113:0x45e2f9b438f63703";
    [venues addObject:venue1];
    
    Venue *venue2 = [[Venue alloc] init];
    venue2.name = @"Mercure Hotel";
    venue2.venueDesc = @"Workshops will take place at Mercure Hotel.<br><br>Please mention conference code <b>RIGADEVDAY</b> when you request the reservation at the hotel.<br><br>Classic Single room - 68.00 EUR per night.<br>Classic Double room - 73.00 EUR per night.<br><br>Price includes a rich breakfast buffet, free WIFI and VAT<br><br>Make your reservation online at Mercure Hotel Riga (http://mercureriga.lv/en/hotel.html) or by reservations e-mail H9436@accor.com.";
    venue2.address = @"Elizabetes street, 101";
    venue2.webURL = @"http://mercureriga.lv/en/hotel.html";
    venue2.googleMapsURL = @"https://www.google.com/maps/place/Hotel+Mercure+Riga+Centre/@56.947663,24.1211103,17z/data=!3m1!4b1!4m2!3m1!1s0x46eece2cb098446f:0x4ec855f9f6f64474";
    [venues addObject:venue2];
    
    Venue *venue3 = [[Venue alloc] init];
    venue3.name = @"RockCafe";
    venue3.venueDesc = @"The official afterparty location after the fist conference day on Wednesday (March 2nd). Everyone is invited!";
    venue3.address = @"Marstalu iela 2/4";
    venue3.webURL = @"http://rockcafe.lv/";
    venue3.googleMapsURL = @"https://www.google.com/maps/place/Latvijas+Pirma+Rokkafejnīca+-+Reiterna+nams/@56.9468666,24.1086241,17.06z/data=!4m2!3m1!1s0x46eecfd428188ce5:0xb212ba4381473440";
    [venues addObject:venue3];
    
    Venue *venue4 = [[Venue alloc] init];
    venue4.name = @"Avalon Hotel";
    venue4.venueDesc = @"Please mention conference code RIGADEVDAY when you request the reservation at the hotel.<br><br>Standard Single room EUR 55.00 per night.<br>Standard Double room EUR 60.00 per night.<br>Superior Single room EUR 60.00 per night.<br>Superior Double room EUR 70.00 per night.<br><br>Price includes a rich breakfast \"buffet\", high speed WIFI and VAT.<br>Additional discount for stays of 3 nights min 15%.<br><br>Make your reservation online at Avalon Hotel (http://www.hotelavalon.eu) or by e-mail Reservations@hotelavalon.eu.";
    venue4.address = @"13.Janvara street, 19";
    venue4.webURL = @"http://www.hotelavalon.eu";
    venue4.googleMapsURL = @"https://www.google.com/maps/place/Avalon+hotel/@56.9454923,24.1098326,17z/data=!3m1!4b1!4m2!3m1!1s0x46eecfd5b5c3cc05:0xa226af01150b5eac";
    [venues addObject:venue4];
    
    return venues;
}

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

- (NSArray *)speakersWithNameOrCompanyOrJobWithName:(NSString *)name {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([Speaker class]) inManagedObjectContext: appDelegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) OR (company CONTAINS[cd] %@) OR (jobTitle CONTAINS[cd] %@)", name, name, name]];
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
                speaker.linkedInURL = (speakerDict[@"linkedin"]) ? speakerDict[@"linkedin"] : @"";
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
