//
//  DataManager.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "DataManager.h"

@interface DataManager () {
    NSMutableArray *_speakersArray;
    NSMutableArray *_eventsCategoryArray;
    NSMutableSet *_bookmarkedSpeakers;
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
        [self setupSpeakers];
        [self setupEventArray];
        [self setupBookmarks];
    }
    return self;
}

- (void)setupSpeakers {
    
    _speakersArray = [NSMutableArray new];
    
    // Create a NSURLRequest with the given URL
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/master/data/speakers.json"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    
    // Get the data
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // Now create a NSDictionary from the JSON data
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    for (NSDictionary *info in jsonArray) {
        SpeakerObject *newSpeaker = [SpeakerObject new];
        newSpeaker.bio = info[@"bio"];
        newSpeaker.bio = [newSpeaker.bio stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
        newSpeaker.company = info[@"company"];
        newSpeaker.country = info[@"country"];
        newSpeaker.id = [info[@"id"] integerValue];
        newSpeaker.name = info[@"name"];
        newSpeaker.order = [info[@"order"] integerValue];
        NSDictionary *contacts = info[@"contacts"];
        if (contacts[@"twitter"]) newSpeaker.twitter = contacts[@"twitter"];
        if (contacts[@"blog"]) newSpeaker.blog = contacts[@"blog"];
        [_speakersArray addObject:newSpeaker];
    }
}

- (NSArray *)getAllSpeakers {
    return _speakersArray;
}

- (void)setupEventArray {
    _eventsCategoryArray = [NSMutableArray new];
    
    // Create a NSURLRequest with the given URL
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/master/data/schedule.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    
    // Get the data
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // Now create a NSDictionary from the JSON data
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary *scheduleArray = jsonDict[@"schedule"];
    int order = 0;
    
    for (NSDictionary *eventCategory in scheduleArray) {
        EventCategory *eCategory = [EventCategory new];
        eCategory.events = [NSMutableArray new];
        NSArray *events = eventCategory[@"events"];
        NSInteger hallID = 1;
        for (NSDictionary *event in events) {
            EventObject *eventObject = [EventObject new];
            eventObject.startTime = eventCategory[@"time"];
            eventObject.eventDescription = event[@"title"] ? event[@"title"] :
            event[@"description"];
            eventObject.eventDescription = [eventObject.eventDescription stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
            eventObject.subTitle = event[@"subtitle"] ? event[@"subtitle"] : @"";
            if (event[@"speakers"]) {
                NSArray *speakersIDArray = event[@"speakers"];
                eventObject.speakers = [NSMutableArray new];
                for (NSString *speakerIDSTR in speakersIDArray) {
                    SpeakerObject *speaker = [self getSpeakerWithID:[speakerIDSTR integerValue]];
                    [eventObject.speakers addObject:speaker];
                };
            }
            eventObject.hallID = hallID++;
            [eCategory.events addObject:eventObject];
        }
        eCategory.order = order++;
        [_eventsCategoryArray addObject:eCategory];
    }
    NSLog(@"something");
}

- (SpeakerObject *)getSpeakerWithID:(NSInteger)speakerID {
    for (SpeakerObject *speaker in _speakersArray) {
        if (speaker.id == speakerID) return speaker;
    }
    return nil;
}

- (NSArray *)getScheduleForHall:(NSInteger)roomID {
    
    switch (roomID) {
        case 1:
            return [self getScheduleForFirstHall];
            break;
        case 2:
            return [self getScheduleForSecondHall];
            break;
        case 3:
            return [self getScheduleForThirdHall];
            break;
        case 4:
            return [self getScheduleForFourthHall];
            break;
        case 5:
            return [self getScheduleForFifthhHall];
            break;
        default:
            break;
    }
    return nil;
}

- (EventObject *)getEventForSpeakerWithID:(NSInteger)speakerID {
    for (EventCategory *eCategory in _eventsCategoryArray) {
        for (EventObject *event in eCategory.events) {
            for (SpeakerObject *speaker in event.speakers) {
                if (speaker.id == speakerID) return event;
            }
        }
    }
    return nil;
}

- (NSArray *)getScheduleForFirstHall {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        [returnArray addObject:eCategory.events[0]];
    }
    return returnArray;
}

- (NSArray *)getScheduleForSecondHall {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[1] : eCategory.events[0]];
    }
    return returnArray;
}

- (NSArray *)getScheduleForThirdHall {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[2] : eCategory.events[0]];
    }
    return returnArray;
}

- (NSArray *)getScheduleForFourthHall {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[3] : eCategory.events[0]];
    }
    return returnArray;
}

- (NSArray *)getScheduleForFifthhHall {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        [returnArray addObject:[eCategory.events count] > 1 ? eCategory.events[4] : eCategory.events[0]];
    }
    return returnArray;
}

- (void)setupBookmarks {
     NSArray *bookmarks = (NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"BookmarksArrayKey"];
    if (!bookmarks) {
        _bookmarkedSpeakers = [NSMutableSet new];
    } else {
        _bookmarkedSpeakers = [NSMutableSet setWithArray:bookmarks];
    }
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

- (NSArray *)getAllBookmarkedEvents {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (EventCategory *eCategory in _eventsCategoryArray) {
        for (EventObject *event in eCategory.events) {
            for (SpeakerObject *speaker in event.speakers) {
                if ([_bookmarkedSpeakers containsObject:[NSNumber numberWithLong:speaker.id]]) {
                    [returnArray addObject:event];
                }
            }
        }
    }
    return returnArray;
}

@end
