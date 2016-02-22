//
//  PersistanceManager.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/22/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import "PersistanceService.h"

@interface PersistanceService () {
    dispatch_queue_t pDefaultQueue;
}

@end

static NSString *const kImagesFolder = @"/Images";

@implementation PersistanceService

- (id)init {
    self = [super init];
    if (self) {
        pDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (BOOL)imageExistsWithPath:(NSString *)imagePath {
    NSString *dataPath = [[[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:kImagesFolder] stringByAppendingPathComponent:imagePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        return YES;
    }
    return NO;
}


- (NSString*)saveDataToFileWithRandomName:(NSData*)data andExtension:(NSString*)extension {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString], extension];
    NSString *filePath = [[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

- (BOOL)removeFileAtPath:(NSString*)filePath {
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    return success && !error;
}

- (void)saveDataToFileWithUniqueName:(NSData*)data onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock {
    dispatch_async(pDefaultQueue, ^{
        NSError *error;
        NSString *fileName = [NSString stringWithFormat:@"%@.data",[[NSUUID UUID] UUIDString]];
        NSString *filePath = [[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:fileName];
        [self p_writeData:data toFile:fileName error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            error ? eblock(error) : cblock(filePath);
        });
    });
}

- (void)removeFile:(NSString*)filePath onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock {
    dispatch_async(pDefaultQueue, ^{
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            error ? eblock(error) : cblock([NSNumber numberWithBool:success]);
        });
    });
}

- (void)saveImage:(UIImage*)image forUrl:(NSString*)url onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock {
    dispatch_async(pDefaultQueue, ^{
        NSError *error;
        NSString *dataPath = [[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:kImagesFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
//        NSString *fileName = [NSString stringWithFormat:@"%lu", (unsigned long)[url hash]];
        NSString *filePath = [dataPath stringByAppendingPathComponent:url];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            error ? eblock(error) : cblock(image);
        });
    });
    
}

- (void)loadImageForUrl:(NSString*)url onCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock {
    dispatch_async(pDefaultQueue, ^{
        NSError *error;
        NSString *dataPath = [[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:kImagesFolder];
//        NSString *fileName = [NSString stringWithFormat:@"%lu", (unsigned long)[url hash]];
        NSString *filePath = [dataPath stringByAppendingPathComponent:url];
        NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
//        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            error ? eblock(error) : cblock(data);
        });
    });
}

- (void)removeAllImagesOnCompletion:(CompletionBlock)cblock onError:(ErrorBlock)eblock {
    dispatch_async(pDefaultQueue, ^{
        NSString *dataPath = [[self p_getDocumentsDirectoryPath] stringByAppendingPathComponent:kImagesFolder];
        BOOL result = [self removeFileAtPath:dataPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            result ? cblock(nil) : eblock(nil);
        });
    });
}

#pragma mark - Private methods

- (void)p_writeData:(NSData*)data toFile:(NSString*)fileName {
    NSString *documentsDirectory = [self p_getDocumentsDirectoryPath];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:appFile atomically:YES];
}

- (void)p_writeData:(NSData*)data toFile:(NSString*)fileName error:(NSError **)errorPtr{
    NSString *documentsDirectory = [self p_getDocumentsDirectoryPath];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:appFile options:NSDataWritingAtomic error:errorPtr];
}

- (NSData*)p_readDataFromFile:(NSString*)fileName {
    NSString *documentsDirectory = [self p_getDocumentsDirectoryPath];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:appFile];
    return data;
}

- (NSData*)p_readDataFromFile:(NSString*)fileName error:(NSError **)errorPtr {
    NSString *documentsDirectory = [self p_getDocumentsDirectoryPath];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:appFile options:0 error:errorPtr];
    return data;
}

- (NSString*)p_getDocumentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
