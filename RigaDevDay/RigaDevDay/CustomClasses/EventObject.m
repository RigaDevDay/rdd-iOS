//
//  EventObject.m
//  RigaDevDay
//
//  Created by Deniss Kaibagarovs on 12/8/14.
//  Copyright (c) 2014 Deniss Kaibagarovs. All rights reserved.
//

#import "EventObject.h"

@implementation EventObject

- (BOOL)isEqual:(id)object {
    EventObject *eventOjbect = object;
    if (![self.startTime isEqualToString:eventOjbect.startTime]) return NO;
    if (![self.eventDescription isEqualToString:eventOjbect.eventDescription]) return NO;
    if (![self.subTitle isEqualToString:eventOjbect.subTitle]) return NO;
    if (self.hallID != eventOjbect.hallID) return NO;
    return YES;
}

@end
