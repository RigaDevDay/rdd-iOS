//
//  Event.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interval, Room, Speaker, Tag;

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Event+CoreDataProperties.h"
