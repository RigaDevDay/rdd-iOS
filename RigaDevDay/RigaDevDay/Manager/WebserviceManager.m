//
//  WebserviceManager.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/22/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "WebserviceManager.h"
#import "PersistanceService.h"

@interface WebserviceManager ()
@property (nonatomic, strong) PersistanceService *pPersistanceService;
@property (nonatomic) NSInteger pTaskCount;

@end

NSString *const kWebServiceBaseURL = @"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io";
NSString *const kScheduleURL = @"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/master/assets/data/main.json";
NSString *const kSpeakerImageURL = @"https://raw.githubusercontent.com/RigaDevDay/RigaDevDay.github.io/source/src/%@";


@implementation WebserviceManager



+ (WebserviceManager *)sharedInstance {
    static WebserviceManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WebserviceManager alloc] init];
        
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _pPersistanceService = [[PersistanceService alloc] init];
        _pTaskCount = 0;
    }
    return self;
}

#pragma mark - Public methods

- (void)loadScheduleWithCompletionBlock:(CompletionBlock)cblock andErrorBlock:(ErrorBlock)eblock {
    [self p_incrementTaskCount];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kScheduleURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                [self p_decrementTaskCount];
                if (error) {
                    NSLog(@"Error loading schedule %@", error.localizedDescription);
                    eblock(error);
                }
                if (data) {
                    NSLog(@"Schedule loaded");
                    cblock(data);
                }
                
            }] resume];
}

- (void)loadImage:(NSString*)imageUrl withCompletionBlock:(CompletionBlock)cblock andErrorBlock:(ErrorBlock)eblock {
    NSString *lastPath = [[NSURL URLWithString:imageUrl] lastPathComponent];
    if ([self.pPersistanceService imageExistsWithPath:lastPath]) {
        // Load from cache
        [self.pPersistanceService loadImageForUrl:lastPath onCompletion:^(id data) {
            NSLog(@"Image %@ loaded from cache", lastPath);
            cblock(data);
        } onError:^(NSError *error) {
            eblock(error);
        }];
    } else {
        // Load from webservice
        [self p_incrementTaskCount];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kSpeakerImageURL, imageUrl]];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                 [self p_decrementTaskCount];
                                                                 
                                                                 if (error) {
                                                                     eblock(error);
                                                                 }
                                                                 if (data) {
                                                                     UIImage *image = [UIImage imageWithData:data];
                                                                     if (image) {
                                                                         [self.pPersistanceService saveImage:image forUrl:lastPath onCompletion:^(id data) {
                                                                             NSLog(@"Image with name %@ saved to cache", lastPath);
                                                                         } onError:^(NSError *error) {
                                                                             NSLog(@"Error %@ saving image with name %@ to cache", error.localizedDescription, lastPath);
                                                                         }];
                                                                        cblock(data);

                                                                     }
                                                                 }
                                                             }];
        [task resume];
    }
}

#pragma mark - Private methods

- (void)p_incrementTaskCount {
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        return;
    }
    
    if (![UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.pTaskCount = 0;
    }
    self.pTaskCount++;
}

- (void)p_decrementTaskCount {
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        return;
    }
    self.pTaskCount--;
    if (self.pTaskCount <= 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.pTaskCount = 0;
    }
}

- (void)p_setAllTasksComplete {
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.pTaskCount = 0;
}

@end
