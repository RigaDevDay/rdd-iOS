//
//  Speaker+CoreDataProperties.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Speaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface Speaker (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *speakerID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *jobTitle;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *imgPath;
@property (nullable, nonatomic, retain) NSString *twitterURL;
@property (nullable, nonatomic, retain) NSString *blogURL;
@property (nullable, nonatomic, retain) NSString *speakerDesc;
@property (nullable, nonatomic, retain) NSString *linkedInURL;
@property (nullable, nonatomic, retain) NSSet<Event *> *events;

@end

@interface Speaker (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet<Event *> *)values;
- (void)removeEvents:(NSSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
