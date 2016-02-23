//
//  Sponsor+CoreDataProperties.h
//  RigaDevDay
//
//  Created by Ksenija Krilatiha on 2/23/16.
//  Copyright © 2016 Riga Dev Day. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Sponsor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Sponsor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *sponsorID;
@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *sponsorDesc;

@end

NS_ASSUME_NONNULL_END
