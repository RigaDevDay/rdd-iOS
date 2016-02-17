//
//  Event+CoreDataProperties.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

@dynamic title;
@dynamic subtitle;
@dynamic eventDesc;
@dynamic isFavorite;
@dynamic speakers;
@dynamic tags;
@dynamic room;
@dynamic interval;

@end
