//
//  Interval+CoreDataProperties.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Interval.h"

NS_ASSUME_NONNULL_BEGIN

@interface Interval (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *startTime;
@property (nullable, nonatomic, retain) NSString *endTime;
@property (nullable, nonatomic, retain) NSSet<Event *> *events;
@property (nullable, nonatomic, retain) Day *day;

@end

@interface Interval (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet<Event *> *)values;
- (void)removeEvents:(NSSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
