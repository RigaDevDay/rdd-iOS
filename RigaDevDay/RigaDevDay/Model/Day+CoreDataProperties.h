//
//  Day+CoreDataProperties.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Day.h"

NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<Interval *> *intervals;
@property (nullable, nonatomic, retain) NSSet<Room *> *rooms;

@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addIntervalsObject:(Interval *)value;
- (void)removeIntervalsObject:(Interval *)value;
- (void)addIntervals:(NSSet<Interval *> *)values;
- (void)removeIntervals:(NSSet<Interval *> *)values;

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet<Room *> *)values;
- (void)removeRooms:(NSSet<Room *> *)values;

@end

NS_ASSUME_NONNULL_END
