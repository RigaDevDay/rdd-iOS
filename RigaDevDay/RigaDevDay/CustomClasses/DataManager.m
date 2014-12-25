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
        newSpeaker.company = info[@"company"];
        newSpeaker.country = info[@"country"];
        newSpeaker.id = [info[@"id"] integerValue];
        newSpeaker.name = info[@"name"];
        newSpeaker.order = [info[@"order"] integerValue];
        newSpeaker.contacts = info[@"contacts"];
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
//        eCategory.endTime = eventCategory[@"endTime"];
//        eCategory.startTime = eventCategory[@"time"];
        eCategory.events = [NSMutableArray new];
        NSArray *events = eventCategory[@"events"];
        for (NSDictionary *event in events) {
            EventObject *eventObject = [EventObject new];
            eventObject.startTime = eventCategory[@"time"];
            eventObject.eventDescription = event[@"title"] ? event[@"title"] :
            event[@"description"];
            eventObject.subTitle = event[@"subtitle"] ? event[@"subtitle"] : @"";
            if (event[@"speakers"]) {
                eventObject.speakers = event[@"speakers"];
            }
            [eCategory.events addObject:eventObject];
        }
        eCategory.order = order++;
        [_eventsCategoryArray addObject:eCategory];
    }
    NSLog(@"something");
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

@end
