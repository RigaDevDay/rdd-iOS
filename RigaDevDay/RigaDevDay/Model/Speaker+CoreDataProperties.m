//
//  Speaker+CoreDataProperties.m
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/17/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Speaker+CoreDataProperties.h"

@implementation Speaker (CoreDataProperties)

@dynamic speakerID;
@dynamic name;
@dynamic company;
@dynamic jobTitle;
@dynamic country;
@dynamic imgPath;
@dynamic twitterURL;
@dynamic blogURL;
@dynamic speakerDesc;
@dynamic events;

@end
