//
//  NSDictionary+LinqExtensions.h
//  LinqToObjectiveC
//
//  Created by Colin Eberhardt on 25/02/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//
/*
 Copyright 2013 Colin Eberhardt
 Linq to Objective-C
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import <Foundation/Foundation.h>

typedef id (^LINQKeyValueSelector)(id key, id value);

typedef BOOL (^LINQKeyValueCondition)(id key, id value);

/**
 Various NSDictionary extensions that provide a Linq-style query API
 */
@interface NSDictionary (QueryExtension)

/** Filters a dictionary based on a predicate.
 
 @param predicate The function to test each source key-value pair for a condition.
 @return A dictionary that contains key-value pairs from the input dictionary that satisfy the condition.
 */
- (NSDictionary*) linq_where:(LINQKeyValueCondition)predicate;

/** Projects each element of the dictionary into a new form.
 
 @param selector A transform function to apply to each element.
 @return A dicionary whose elements are the result of invoking the transform function on each key-value pair of source.
 */
- (NSDictionary*) linq_select:(LINQKeyValueSelector)selector;

/** Projects each element of the dictionary to a new form, which is used to populate the returned array.
 
 @param selector A transform function to apply to each element.
 @return An array whose elements are the result of invoking the transform function on each key-value pair of source.
 */
- (NSArray*) linq_toArray:(LINQKeyValueSelector)selector;

/** Determines whether all of the key-value pairs of the dictionary satisfies a condition.
 
 @param condition The condition to test key-value pairs against.
 @return Whether any of the element of the dictionary satisfies a condition.
 */
- (BOOL) linq_all:(LINQKeyValueCondition)condition;

/** Determines whether any of the key-value pairs of the dictionary satisfies a condition.
 
 @param condition The condition to test key-value pairs against.
 @return Whether any of the element of the dictionary satisfies a condition.
 */
- (BOOL) linq_any:(LINQKeyValueCondition)condition;

/** Counts the number of key-value pairs that satisfy the given condition.
 
 @param condition The condition to test key-value pairs against.
 @return The number of elements that satisfy the condition.
 */
- (NSUInteger) linq_count:(LINQKeyValueCondition)condition;

/** Merges the contents of this dictionary with the given dictionary. For any duplicates, the value from
 the source dictionary will be used.
 
 @param dic The dictionary to merge with.
 @return A dictionary which is the result of merging.
 */
- (NSDictionary*) linq_Merge:(NSDictionary*)dic;

@end
