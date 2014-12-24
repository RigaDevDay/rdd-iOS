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
        [_speakersArray addObject:newSpeaker];
    }
}

- (NSArray *)getAllSpeakers {
    return _speakersArray;
}

@end
