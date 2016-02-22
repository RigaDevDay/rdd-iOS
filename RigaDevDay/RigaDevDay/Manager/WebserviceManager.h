//
//  WebserviceManager.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/22/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(id data);
typedef void (^ErrorBlock)(NSError *error);


@interface WebserviceManager : NSObject

+ (WebserviceManager *)sharedInstance;

@property (nonatomic) BOOL isScheduleLoading;

- (void)loadScheduleWithCompletionBlock:(CompletionBlock)cblock andErrorBlock:(ErrorBlock)eblock;
- (void)loadImage:(NSString*)imageUrl withCompletionBlock:(CompletionBlock)cblock andErrorBlock:(ErrorBlock)eblock;

@end
