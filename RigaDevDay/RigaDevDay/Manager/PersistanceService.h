//
//  PersistanceManager.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/22/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebserviceManager.h"

@interface PersistanceService : NSObject

- (BOOL)imageExistsWithPath:(NSString *)imagePath;
- (BOOL)removeFileAtPath:(NSString*)filePath;
- (NSString*)saveDataToFileWithRandomName:(NSData*)data andExtension:(NSString*)extension;
- (void)saveDataToFileWithUniqueName:(NSData*)data onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock;
- (void)removeFile:(NSString*)filePath onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock;


- (void)saveImage:(UIImage*)data forUrl:(NSString*)url onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock;
- (void)loadImageForUrl:(NSString*)url onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock;
- (void)removeAllImagesOnCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock;

@end
