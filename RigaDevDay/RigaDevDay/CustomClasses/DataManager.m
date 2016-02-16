//
//  DataManager.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "DataManager.h"
#import "Reachability.h"

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
        [self updateScheduleIfNeeded];
        [self setupSpeakers];
        [self setupEventArray];
        [self setupBookmarks];
    }
    return self;
}

- (NSData *)dataFromJSONFileNamed:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    return jsonData;
}


- (void)setupSpeakers {
    
    _speakersArray = [NSMutableArray new];
     NSData *data = [NSData dataWithContentsOfFile:_speakersPath];
    if (![data length]) return;
    
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
    NSData *data = [NSData dataWithContentsOfFile:_schedulePath];
    if (![data length]) return;
    
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

- (NSArray *)getEventsForSpeakerWithID:(NSInteger)speakerID {
    NSMutableArray *array = [NSMutableArray new];
    
    for (EventCategory *eCategory in _eventsCategoryArray) {
        for (EventObject *event in eCategory.events) {
            for (SpeakerObject *speaker in event.speakers) {
                if (speaker.id == speakerID) [array addObject:event];
            }
        }
    }
    
    return [array copy];;
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

- (UIImage *)getActiveBookmarkImage {
    return _bookMarkActive;
}

- (UIImage *)getInActiveBookmarkImageForInfo:(BOOL)forInfo {
    if (forInfo) return _bookmarkInActiveForInfo;
    return _bookmarkInActive;
}

- (NSString *)getInfoStoryboardSegue {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            return @"SPEAKER_SPEECH_INFO_SEGUEUE_4";
            
        } else if(result.height == 1334){
            return @"SPEAKER_SPEECH_INFO_SEGUEUE_4.7";
        } else if(result.height == 2208){
            return @"SPEAKER_SPEECH_INFO_SEGUEUE_5.5";
        } else if(result.height == 960){
            return @"SPEAKER_SPEECH_INFO_SEGUEUE_3.5";
        }
        
    } else {
        return @"SPEAKER_SPEECH_INFO_SEGUEUE_ipad";
    }
    return nil;
}

- (void)updateScheduleIfNeeded {
    // Copy to drive in needed
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path firstObject];
    _schedulePath = [documentsDirectory stringByAppendingPathComponent:@"schedule.json"];
    _speakersPath = [documentsDirectory stringByAppendingPathComponent:@"speakers.json"];
    
    // Check for schedule
    if (![[NSFileManager defaultManager] fileExistsAtPath:_schedulePath]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *resourcePath = [bundle pathForResource:@"schedule" ofType:@"json"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:_schedulePath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        // update user defines
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:SCHEDULE_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // Check for speakers
    if (![[NSFileManager defaultManager] fileExistsAtPath:_speakersPath]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *resourcePath = [bundle pathForResource:@"speakers" ofType:@"json"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:_speakersPath error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        // Update user defines
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:SPEAKERS_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // Check for Interner
    if(!_reach) {
        _reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    }
    // Set the blocks
    _reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            [self checkForJSONs];
        });
    };
    
    [_reach startNotifier];
    
   
    // Download JSON
    // Parse JSON
    // Check with Local Version
}

- (void)checkForJSONs {
    
    [_reach stopNotifier];
    // Check JSONS version
    NSString *currentScheduleVersion = [[NSUserDefaults standardUserDefaults] valueForKey:SCHEDULE_VERSION_KEY];
    NSString *currentSpeakersVersion = [[NSUserDefaults standardUserDefaults] valueForKey:SPEAKERS_VERSION_KEY];

    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/2015/master/data/version.json"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:3.0];

    // Get the data
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (![data length]) return;
    // Now create a NSDictionary from the JSON data
    NSError *error;
    NSDictionary *versionDirct = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSNumber *latestScheduleVersion = versionDirct[@"scheduleVersion"];
    NSNumber *latestSpeakerVersion = versionDirct[@"speakersVersion"];
    
    if (![currentScheduleVersion isEqualToString:[latestScheduleVersion stringValue]]) {
        // Update Schedule JSON
        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/2015/master/data/schedule.json"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:3.0];
        
        // Get the data
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (![data length]) return;
        [data writeToFile:_schedulePath atomically:YES];
        
        //Update Version
        [[NSUserDefaults standardUserDefaults] setValue:[latestScheduleVersion stringValue] forKey:SCHEDULE_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setupEventArray];
    }
    if (![currentSpeakersVersion isEqualToString:[latestSpeakerVersion stringValue]]) {
        // Update Speaker JSON
        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/RigaDevDay/2015/master/data/speakers.json"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:30.0];
        
        // Get the data
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (![data length]) return;
        [data writeToFile:_speakersPath atomically:YES];
        
        //Update Version
        [[NSUserDefaults standardUserDefaults] setValue:[latestSpeakerVersion stringValue] forKey:SPEAKERS_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setupSpeakers];
    }
}

@end
